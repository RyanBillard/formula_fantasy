require 'pry'
require 'bigdecimal'
require 'bigdecimal/util'

Driver = Struct.new(:name, :cost, :points)
Constructor = Struct.new(:name, :cost, :points)
Team = Struct.new(:drivers, :constructor, :points, :cost)

def load_drivers
    driver_file = "drivers.txt"
    IO.read(driver_file).split("\n").map do |driver_line|
        name, cost, points = driver_line.split(",")
        Driver.new(name, cost.to_d, points.to_d)
    end
end

def load_constructors
    constructor_file = "constructors.txt"
    IO.read(constructor_file).split("\n").map do |constructor_line|
        name, cost, points = constructor_line.split(",")
        Constructor.new(name, cost.to_d, points.to_d)
    end
end

max_budget = 100
drivers = load_drivers
constructors = load_constructors
cheapest_driver = drivers.min_by { |driver| driver.cost }

driver_combos = drivers.combination(5).select do |driver_combo|
    driver_combo.sum(&:cost) <= (max_budget - cheapest_driver.cost)
end

viable_teams = driver_combos.product(constructors).select do |team|
    team.flatten.sum(&:cost) <= max_budget
end.map do |team|
    Team.new(team.first, team.last, team.flatten.sum(&:points), team.flatten.sum(&:cost))
end

viable_teams.sort_by(&:points).reverse.first(10).each do |team|
    puts "Constructor: #{team.constructor.name} Drivers: #{team.drivers.map(&:name).join(", ")} Pts: #{team.points.to_s("F")} Budget: $#{team.cost.to_s("F")}M"
end


