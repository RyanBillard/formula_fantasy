require 'pry'
require 'bigdecimal'
require 'bigdecimal/util'
require 'optparse'
require_relative 'lib/team_generator'
require_relative 'lib/file_loader'
require_relative 'lib/team_ranking'
require_relative 'lib/parser'

drivers, constructors = FileLoader.call
options = Parser.parse(ARGV, drivers, constructors)
max_budget = options.max_budget || 100
include_mega = options.mega_driver ? true : false
generator = TeamGenerator.new(drivers, constructors, max_budget, include_mega)
ranking = TeamRanking.new(generator.viable_teams)

puts "Best 10 teams"
ranking.best(10).each do |team|
  puts team
end

if options.my_drivers && options.my_constructor
  my_team = Team.new(options.my_drivers, options.my_constructor, options.turbo_driver, options.mega_driver)
  puts "My team: #{my_team}"
  puts "My team's ranking: #{ranking.rank(my_team)}/#{ranking.teams.size}"
end

