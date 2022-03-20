class TeamRanking
  def initialize(teams)
    @teams = teams.sort_by(&:points).reverse
  end
  
  attr_reader :teams
  
  def best(n = 10)
    teams.first(n)
  end

  def rank(team)
    teams.index(team)
  end
end