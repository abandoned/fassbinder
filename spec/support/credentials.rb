def credentials
  @credentials ||= YAML::load_file(File.dirname(__FILE__) + '/amazon.yml')
end
