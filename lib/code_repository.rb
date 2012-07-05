require 'rugged'

class CodeRepository
  attr_reader :commits
  def initialize(repository_path,from_commit,to_commit = nil)
    @commits  = []
    @repo = Rugged::Repository.new(repository_path)

    to_commit ||= get_head_ish
    walker = @repo.walk(to_commit)

    walker.each { |c|
      @commits << c
      break if c.oid == from_commit
    }
  end

  def contributors(commit_list)

    return [] if commit_list.empty?
    author_names = []
    commit_list.each do |oid|
      c = @repo.lookup(oid)
      next unless @commits.map(&:oid).include?(c.oid)
      author = c.author
      names = author[:name]
      names = names.split("&")
      names.each{|n|
         n =n.strip
         author_names << n unless author_names.include?(n)
      }
    end
    author_names
  end

  def get_head_ish
    @repo.head.target
  end

  def lookup(oid)
    @repo.lookup(oid)
  end
end



