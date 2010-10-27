require 'bundler'
Bundler::GemHelper.install_tasks

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |t|
  puts Dir.glob('spec/**/*_spec.rb').inspect
  t.spec_files = Dir.glob('spec/**/*_spec.rb')
end
