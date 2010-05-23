require 'rake'
require 'spec/rake/spectask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "zomgrss"
    gem.summary = "Create RSS feeds from Ruby collections."
    gem.description = "Create RSS feeds from Ruby collections."
    gem.email = "federico@mheroin.com"
    gem.homepage = "http://github.com/febuiles/zomgrss"
    gem.authors = ["Federico Builes"]
    gem.add_development_dependency "builder"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/*_spec.rb']
end

desc 'Default: run specs.'
task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "zomgrss #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
