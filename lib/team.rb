Team = Struct.new(:drivers, :constructor, :turbo, :mega) do
  def points
    @points ||= begin
      sum = drivers.sum(&:points) + constructor.points
      sum += turbo.points
      sum += (mega.points * 2) if mega
      sum
    end
  end

  def cost
    @cost ||= drivers.sum(&:cost) + constructor.cost
  end

  def ideal_turbo_driver
    drivers.select do |driver|
      driver.cost <= 20
    end.max_by(&:points)
  end

  def ideal_mega_driver
    drivers.max_by(&:points)
  end

  def to_s
    "Constructor: #{constructor.name} Drivers: #{drivers.map(&:name).join(", ")} Turbo: #{turbo.name} #{mega ? "Mega: #{mega.name} " : ""}Pts: #{points.to_s("F")} Budget: $#{cost.to_s("F")}M"
  end
end