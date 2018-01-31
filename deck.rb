require_relative "card"

class Deck
  SUITS = %w[♢ ♡   ♣ ♠]
  VALUES = %w[2 3 4 5 6 7 8 9 10 J Q K A]

  def shuffle!
    @cards = SUITS.product(VALUES).map { |suit, value| Card.new(suit, value) }
    @cards.shuffle!
  end

  def deal_cards(number)
    @cards.shift(number)
  end
end
