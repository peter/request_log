# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rake}
  s.version = "0.8.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jim Weirich}]
  s.date = %q{2009-05-15}
  s.description = %q{Rake is a Make-like program implemented in Ruby. Tasks and dependencies are specified in standard Ruby syntax.}
  s.email = %q{jim@weirichhouse.org}
  s.executables = [%q{rake}]
  s.extra_rdoc_files = [%q{README}, %q{MIT-LICENSE}, %q{TODO}, %q{CHANGES}, %q{doc/command_line_usage.rdoc}, %q{doc/glossary.rdoc}, %q{doc/proto_rake.rdoc}, %q{doc/rakefile.rdoc}, %q{doc/rational.rdoc}, %q{doc/release_notes/rake-0.4.14.rdoc}, %q{doc/release_notes/rake-0.4.15.rdoc}, %q{doc/release_notes/rake-0.5.0.rdoc}, %q{doc/release_notes/rake-0.5.3.rdoc}, %q{doc/release_notes/rake-0.5.4.rdoc}, %q{doc/release_notes/rake-0.6.0.rdoc}, %q{doc/release_notes/rake-0.7.0.rdoc}, %q{doc/release_notes/rake-0.7.1.rdoc}, %q{doc/release_notes/rake-0.7.2.rdoc}, %q{doc/release_notes/rake-0.7.3.rdoc}, %q{doc/release_notes/rake-0.8.0.rdoc}, %q{doc/release_notes/rake-0.8.2.rdoc}, %q{doc/release_notes/rake-0.8.3.rdoc}, %q{doc/release_notes/rake-0.8.4.rdoc}, %q{doc/release_notes/rake-0.8.5.rdoc}, %q{doc/release_notes/rake-0.8.6.rdoc}, %q{doc/release_notes/rake-0.8.7.rdoc}]
  s.files = [%q{bin/rake}, %q{README}, %q{MIT-LICENSE}, %q{TODO}, %q{CHANGES}, %q{doc/command_line_usage.rdoc}, %q{doc/glossary.rdoc}, %q{doc/proto_rake.rdoc}, %q{doc/rakefile.rdoc}, %q{doc/rational.rdoc}, %q{doc/release_notes/rake-0.4.14.rdoc}, %q{doc/release_notes/rake-0.4.15.rdoc}, %q{doc/release_notes/rake-0.5.0.rdoc}, %q{doc/release_notes/rake-0.5.3.rdoc}, %q{doc/release_notes/rake-0.5.4.rdoc}, %q{doc/release_notes/rake-0.6.0.rdoc}, %q{doc/release_notes/rake-0.7.0.rdoc}, %q{doc/release_notes/rake-0.7.1.rdoc}, %q{doc/release_notes/rake-0.7.2.rdoc}, %q{doc/release_notes/rake-0.7.3.rdoc}, %q{doc/release_notes/rake-0.8.0.rdoc}, %q{doc/release_notes/rake-0.8.2.rdoc}, %q{doc/release_notes/rake-0.8.3.rdoc}, %q{doc/release_notes/rake-0.8.4.rdoc}, %q{doc/release_notes/rake-0.8.5.rdoc}, %q{doc/release_notes/rake-0.8.6.rdoc}, %q{doc/release_notes/rake-0.8.7.rdoc}]
  s.homepage = %q{http://rake.rubyforge.org}
  s.rdoc_options = [%q{--line-numbers}, %q{--main}, %q{README}, %q{--title}, %q{Rake -- Ruby Make}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{rake}
  s.rubygems_version = %q{1.8.8}
  s.summary = %q{Ruby based make-like utility.}

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
