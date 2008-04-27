require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Generate documentation for the aaf_auto_rebuild plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'AafAutoRebuild'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
