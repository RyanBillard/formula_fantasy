require_relative 'team'

class TeamGenerator
  def initialize(drivers, constructors, max_budget, include_mega)
    @drivers = drivers
    @constructors = constructors
    @max_budget = max_budget
    @include_mega = include_mega
    @cheapest_constructor = @constructors.min_by { |constructor| constructor.cost }
  end
  
  attr_reader :drivers, :constructors, :max_budget, :cheapest_constructor, :include_mega
  
  def viable_teams
    @viable_teams ||= build_viable_teams
  end
  
  private
  
  def build_viable_teams
    driver_combos = drivers.combination(5).select do |driver_combo|
      # find any driver combo that can be combined with the cheapest constructor while satisfying the budget
      driver_combo.sum(&:cost) <= (max_budget - cheapest_constructor.cost)
    end.map do |driver_combo|
      driver_combo.sort_by(&:name)
    end
    
    viable_teams = driver_combos.product(constructors).select do |team|
      # find any team within the budget
      team.flatten.sum(&:cost) <= max_budget
    end.map do |team|
      possible_turbo = team.first.select do |driver|
        driver.cost <= 20
      end
      ideal_mega = team.first.max_by(&:points)
      teams = possible_turbo.map do |turbo_driver|
        # build teams with a turbo driver
        Team.new(team.first, team.last, turbo_driver, nil)
      end
      if include_mega
        # build teams with a turbo and mega driver
        mega_teams = possible_turbo.map do |turbo_driver|
          Team.new(team.first, team.last, turbo_driver, ideal_mega)
        end
        teams = teams + mega_teams
      end
      teams
    end.flatten
  end
end