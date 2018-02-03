require_relative 'player'

class Dealer < Player
  def show_cards(hide_values = true)
    if hide_values
      '░░ ' * @cards.size
    else
      super
    end
  end

  def to_s
    'Dealer'
  end
end
