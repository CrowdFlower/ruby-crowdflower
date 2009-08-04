# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-crowdflower}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian P O'Rourke", "Chris Van Pelt"]
  s.date = %q{2009-07-31}
  s.description = %q{A toolkit for interacting with CrowdFlower via the REST API.

This is alpha software in its most nascent stages, and is not 
yet ready for use with the current version of CrowdFlower.

}
  s.email = %q{brian@doloreslabs.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/ruby-crowdflower.rb",
     "lib/ruby-crowdflower/crowdflower.rb",
     "lib/ruby-crowdflower/httparty.rb",
     "ruby-crowdflower.gemspec",
     "spec/ruby-crowdflower_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/dolores/ruby-crowdflower}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{a toolkit for the CrowdFlower API}
  s.test_files = [
    "spec/ruby-crowdflower_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0.4.3"])
    else
      s.add_dependency(%q<httparty>, [">= 0.4.3"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0.4.3"])
  end
end
