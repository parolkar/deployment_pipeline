# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name = "deployment_pipeline"
  gem.description = "Deployment Pipeline makes Continuous Deployment super easy."
  gem.homepage = "https://github.com/parolkar/deployment_pipeline"
  gem.summary = gem.description
  gem.version = "0.0.0"
  gem.authors = ["Abhishek Parolkar"]
  gem.email = "abhishek@parolkar.com"
  gem.has_rdoc = false
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ['lib']
  gem.add_dependency "rugged","0.16.0"
  gem.add_dependency "thor","0.14.6"
  gem.add_dependency "rdiscount"
  gem.add_dependency "progressbar","0.11.0"
  gem.add_dependency "hpricot"
end

