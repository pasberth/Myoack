module Myoack

MYOACK_HOME = File.join(ENV["HOME"], '.myoack')

class ConfigManager

  def initialize home=MYOACK_HOME
    @home = home
    @init_file_path = File.join(@home, 'init.rb')
    @keys_file_path = File.join(@home, 'keys.yml')
    @configs = {}
    @config_types = {}
    @config_classes = {}
  end
  
  def main *argv
    if File.exist? @init_file_path
      load @init_file_path
    end
    if File.exist? argv[0]
      load argv[0]
    end
  end
  
  def << cfgclass
    cfg = cfgclass.new(self)
    add_config(cfgclass.id, cfg) if cfgclass.id
    add_config_type(cfgclass.type, cfgclass) if cfgclass.type
    configure cfgclass.id
  end
  
  attr_reader :init_file_path
  attr_reader :keys_file_path
  attr_reader :configs
  attr_reader :config_types
  attr_reader :config_classes
  
  def load_keys_file
    YAML.load_file @keys_file_path
  end
  
  def dump_config_file cfg
    open @keys_file_path, 'w' do |f|
      f.write YAML.dump(cfg)
    end
  end
  
  def configure_all
    cfg = load_keys_file
    cfg.each do |id, sitecfg|
      configure(id, sitecfg) if configs.key? id or sitecfg["site"] && sitecfg["type"]
    end
    true
  end
  
  def configure id, sitecfg=nil, cfg=nil
    return nil unless id
    sitecfg ||= load_keys_file[id.to_s] or return nil
    cfg ||= configs[id.to_s] ||
            ( cfgclass = config_types[sitecfg["type"]];
              cfgclass and cfgclass.new(self)) or return nil
    sitecfg.each { |k,v| cfg.send(:"#{k}=", v) }
    add_config id, cfg
    cfg
  end
  
  def add_config id, cfg
    configs[id.to_s] = cfg
  end

  def add_config_type type, cfgclass
    config_types[type.to_s] = cfgclass
  end
  
  def require_config id
    configs[id.to_s] or (configure id; configs[id.to_s]) or raise "Myoack don't know '#{id}'."
  end
end

Config = ConfigManager.new(MYOACK_HOME)
end