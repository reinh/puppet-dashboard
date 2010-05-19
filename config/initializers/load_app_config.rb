require 'ostruct'

app_config_file = File.join(RAILS_ROOT, *%w{ config app_config.yml })
app_config = (YAML.load_file(app_config_file)[RAILS_ENV] || {}).symbolize_keys

App = OpenStruct.new(app_config)

class << App
  # Add query methods for all attributes
  def method_missing(mid, *args)
    mname = mid.id2name
    mname =~ /\?$/ ? send(mname[0..-2]) : super
  end
end
