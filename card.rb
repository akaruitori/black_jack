class Card
  attr_reader :suit, :value, :points

  def initialize(suit, value)
    @suit = suit
    @value = value
    @points = define_points
  end

  def to_s
    "#{@value}#{@suit}"
  end

  private

  def define_points
    value = @value.to_i
    if (2..10).cover?(value)
      value
    elsif @value == 'A'
      11
    else
      10
    end
  end
end
