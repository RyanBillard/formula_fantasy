require_relative 'driver'
require_relative 'constructor'

class FileLoader
  class << self
    def call(driver_file = "drivers.txt", constructor_file = "constructors.txt")
      drivers = load_drivers(driver_file)
      constructors = load_constructors(constructor_file)
      [drivers, constructors]
    end
    
    private
    
    def file_lines(file_name)
      IO.read(file_name).split("\n")
    end
    
    def load_drivers(file_name)
      file_lines(file_name).map do |driver_line|
        name, cost, points = driver_line.split(",")
        Driver.new(name, cost.to_d, points.to_d)
      end
    end
    
    def load_constructors(file_name)
      file_lines(file_name).map do |constructor_line|
        name, cost, points = constructor_line.split(",")
        Constructor.new(name, cost.to_d, points.to_d)
      end
    end
  end
end