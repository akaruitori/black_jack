class Player
  attr_accessor :balance, :cards, :score

  def initialize(balance)
    @balance = balance
    @cards = []
    @score = 0
  end

  def show_cards(*)
    @cards.join(' ')
  end

  def to_s; end
end
