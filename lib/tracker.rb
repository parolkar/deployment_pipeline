
class Tracker
  STORY_TAG_PATTERN ||=/\[\w*\s*\#(\d*)\]/  #Default example  [fixes #30922794]  or [#30972795]
  attr_reader :stories

  def initialize(tracker_ids,api_key)
    raise("Missing tracker information") if (@api_key.empty? ||  @tracker_ids.empty?)
    @tag_pattern = STORY_TAG_PATTERN
    @stories = []
    @story_ids = []
  end
  def extract_story_ids(commits_list)
    raise("Must implement #extract_story_ids in #{self.class.to_s}")
  end
  def load_stories(story_id_list = nil)
    raise("Must implement #load_stories in #{self.class.to_s}")
  end
  def story_obj(story_id)
    raise("Must implement #story_obj in #{self.class.to_s}")
  end
end

class PivotalTracker < Tracker
  def initialize(tracker_ids = PIVOTAL_TRACKER_PROJECT_IDS,api_key = PIVOTAL_TRACKER_TOKEN)
     @tracker_ids = tracker_ids
     @api_key = api_key
     super(@tracker_ids,@api_key)
  end

  def extract_story_ids(commits_list)
    stories = {}
    untagged_commits = []
    commits_list.each { |c|
      stories_related_to_commit =  c.message.scan(@tag_pattern)
      if  stories_related_to_commit.empty?
        untagged_commits << c
      else

        stories_related_to_commit.flatten.each {|s|
          @story_ids << s
          stories[s] ||= []
          stories[s] << c.oid.to_s
        }
      end
    }
    return stories,untagged_commits
  end

  def load_stories(story_id_list = nil,show_progress = false)
    unless story_id_list.nil?
      @story_ids = story_id_list
    end
    @stories = []
    if show_progress
      progressbar = ProgressBar.new("Fetching...", @story_ids.length * @tracker_ids.length)
      progressbar.bar_mark = '='
    end
    @story_ids.each do |story_id|
      story = story_obj(story_id,progressbar)
      if story
         @stories << story
      else
        puts "WARNING: Story(#{story_id}) not found in any tracker(#{@tracker_ids.inspect})"
      end
    end
    progressbar.finish if show_progress
    @stories
  end

  def story_obj(story_id,progress_bar = nil)
    @tracker_ids.each { |tracker_id|
      obj = fetch_story_data("/projects/#{tracker_id}/stories/#{story_id}",@api_key)
      story_obj = obj.at('story')
      unless story_obj.nil?
        story = {
            :id               => story_id,
            :name             => story_obj.at('name').innerHTML,
            :type             => story_obj.at('story_type').innerHTML,
            :requested_by     => story_obj.at('requested_by').innerHTML,
            :url              => story_obj.at('url').innerHTML,
            :status           => story_obj.at('current_state').innerHTML
        }
        return story
      end
      progress_bar.inc if progress_bar
    }
    return nil
  end

  def fetch_story_data(obj_path,token)
    url =  "http://www.pivotaltracker.com/services/v3/#{obj_path}"
    resource_uri = URI.parse(url)
    response = Net::HTTP.start(resource_uri.host, resource_uri.port) do |http|
      http.get(resource_uri.path, {'X-TrackerToken' => "#{token}"})
    end
    doc = Hpricot(response.body)
  rescue
    doc = Hpricot("<xml></xml>")
  end

end

