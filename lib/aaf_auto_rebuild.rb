module AAFAutoRebuild
  
  def self.get_field_definitions_from_path
    @models = {}
    Dir.glob(File.join(RAILS_ROOT, "app/models/*.rb")).each do |model_file|
      model_class = File.basename(model_file, ".rb").classify.constantize
      if field_definition = self.aaf_field_definition(model_class)
        @models[model_class.to_s] = Marshal.dump(field_definition)
      end
    end
    @models
  end

  def self.application_name
    (defined?(APPLICATION_NAME)) ? APPLICATION_NAME : RAILS_ROOT
  end

  def self.aaf_field_definition(model)
    return nil unless model.respond_to?(:aaf_configuration)
    model.aaf_configuration[:ferret_fields]
  end

  def self.field_definition_has_changed?
    return :all unless File.exist?(STORE) && stored_definitions = YAML.load_file(STORE)
    return :all unless stored_definitions[application_name]
    @to_reindex = []
    @models.each do |model, m_dump|
      m_dump = Marshal.load(m_dump)
      unless stored_definitions[application_name][model] && m_dump == Marshal.load(stored_definitions[application_name][model])
        @to_reindex << model
      end
    end
    (@to_reindex.empty?) ? :none : @to_reindex
  end

  def self.write_new_field_definitions
    stored_definitions = (File.exist?(STORE)) ? YAML.load_file(STORE) : {}
    stored_definitions[application_name] = @models
    File.open(STORE, "w") { |f| YAML.dump(stored_definitions, f)}
  end

  def self.reindex_models
    what_to_reindex = (@to_reindex) ? @to_reindex : @models
    what_to_reindex.each do |model, hash|
      puts " => Indexing #{model}..\n"
      model.classify.constantize.rebuild_index
    end
  end
  
end