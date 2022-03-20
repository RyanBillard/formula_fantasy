class Parser
  Options = Struct.new(:max_budget, :my_drivers, :my_constructor, :turbo_driver, :mega_driver)
  
  def self.parse(options, drivers, constructors)
    args = Options.new(nil, nil, nil)
    
    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: main.rb [options]"
      
      opts.on("-b", "--budget MAX_BUDGET", "Max budget for a team") do |budget|
        args.max_budget = budget.to_d
      end
      opts.on("-d", "--drivers DRIVERS_LIST", "Comma-separated list of drivers currently on your team") do |drivers_list|
        args.my_drivers = drivers_list.split(",").map { |name| drivers.find { |driver| driver.name == name } }.sort_by(&:name)
      end
      opts.on("-c", "--constructor CONSTRUCTOR_NAME", "Name of the constructor currently on your team") do |constructor_name|
        args.my_constructor = constructors.find { |constructor| constructor.name == constructor_name }
      end
      opts.on("-t", "--turbo-driver DRIVER_NAME", "Name of the turbo driver") do |driver_name|
        args.turbo_driver = drivers.find { |driver| driver.name == driver_name }
      end
      opts.on("-m", "--mega-driver DRIVER_NAME", "Name of the mega driver") do |driver_name|
        args.mega_driver = drivers.find { |driver| driver.name == driver_name }
      end
      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end
    
    opt_parser.parse!(options)
    return args
  end
end

