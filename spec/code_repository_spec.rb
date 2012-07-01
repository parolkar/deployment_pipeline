require "spec_helper"

describe CodeRepository do
  let(:repository_path) {"/some/repo/path"}
  let(:from_commit) {"shashashashashasahsahsah1"}
  let(:commit1) {
    commit = {}
    stub(commit).oid  {"shasha1"}
    stub(commit).message  {"[#1234] strory1"}
    stub(commit).author {{:name => "Tom Cruise & Rajinikanth"}}
    commit
  }
  before do
    mock.instance_of(CodeRepository).get_head_ish {"shashasha"}
    mock(Rugged::Repository).new(repository_path) {|repo|
      stub(repo).walk { [commit1] }
    }
  end

  it "should have commits" do
    cr =  CodeRepository.new(repository_path,from_commit)
    cr.commits.should include(commit1)
  end

  it "should provide list of all contributors" do
    cr =  CodeRepository.new(repository_path,from_commit)
    commiters = cr.contributors([commit1])
    commiters.should include("Rajinikanth")
  end
end
