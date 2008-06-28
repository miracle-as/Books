AMAZON_CONF = YAML.load(File.open("#{RAILS_ROOT}/config/amazon.yml"))
puts AMAZON_CONF.inspect