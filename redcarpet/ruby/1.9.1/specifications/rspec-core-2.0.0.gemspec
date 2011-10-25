# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-core}
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Chad Humphries}, %q{David Chelimsky}]
  s.date = %q{2010-10-10}
  s.description = %q{RSpec runner and example groups}
  s.email = %q{dchelimsky@gmail.com;chad.humphries@gmail.com}
  s.executables = [%q{rspec}]
  s.extra_rdoc_files = [%q{README.markdown}]
  s.files = [%q{bin/rspec}, %q{README.markdown}]
  s.homepage = %q{http://github.com/rspec/rspec-core}
  s.post_install_message = %q{**************************************************

  Thank you for installing rspec-core-2.0.0

  Please be sure to look at Upgrade.markdown to see what might have changed
  since the last release.

**************************************************
}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{rspec}
  s.rubygems_version = %q{1.8.8}
  s.summary = %q{rspec-core-2.0.0}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec-expectations>, [">= 2.0.0"])
      s.add_development_dependency(%q<rspec-mocks>, [">= 2.0.0"])
      s.add_development_dependency(%q<cucumber>, [">= 0.5.3"])
      s.add_development_dependency(%q<autotest>, [">= 4.2.9"])
      s.add_development_dependency(%q<syntax>, [">= 1.0.0"])
      s.add_development_dependency(%q<flexmock>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
    else
      s.add_dependency(%q<rspec-expectations>, [">= 2.0.0"])
      s.add_dependency(%q<rspec-mocks>, [">= 2.0.0"])
      s.add_dependency(%q<cucumber>, [">= 0.5.3"])
      s.add_dependency(%q<autotest>, [">= 4.2.9"])
      s.add_dependency(%q<syntax>, [">= 1.0.0"])
      s.add_dependency(%q<flexmock>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec-expectations>, [">= 2.0.0"])
    s.add_dependency(%q<rspec-mocks>, [">= 2.0.0"])
    s.add_dependency(%q<cucumber>, [">= 0.5.3"])
    s.add_dependency(%q<autotest>, [">= 4.2.9"])
    s.add_dependency(%q<syntax>, [">= 1.0.0"])
    s.add_dependency(%q<flexmock>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
  end
end
