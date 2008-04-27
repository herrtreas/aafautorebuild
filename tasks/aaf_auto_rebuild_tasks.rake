require 'digest/md5'
require File.join(File.dirname(__FILE__), '../lib/aaf_auto_rebuild')

STORE = ENV['HOME'] + "/.ferret_auto_build_field_definitions"

namespace :ferret do
  namespace :index do
    desc 'Rebuild ferret index if necessary'
    task :auto_rebuild => :environment do
      AAFAutoRebuild.get_field_definitions_from_path
      if (what_to_reindex = AAFAutoRebuild.field_definition_has_changed?) != :none
        puts " * AAF field definitions have changed:\n"
        puts " * Need to reindex: #{what_to_reindex.inspect.to_s}"
       AAFAutoRebuild.reindex_models
       AAFAutoRebuild.write_new_field_definitions
      else
        puts " * No need to rebuild ferret index"
      end      
    end    
  end
end