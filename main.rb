require_relative 'deck'
require_relative 'game'
require_relative 'user'
require_relative 'dealer'

puts 'Welcome to Black Jack game!'
puts  'Enter your name, please:'
username = gets.chomp

user = User.new(100, username)
dealer = Dealer.new(100)
deck = Deck.new
game = Game.new(deck, user, dealer)


while true
  game.deck.shuffle!
  game.deal_cards(2)
  game.show_cards

  game.play_round
  game.finish_round

  if game.players_have_enough_money?
    puts 'Do you want to play another round? Enter "yes" to continue the game.'
    break unless gets.chomp == 'yes'
  else
    break
  end
end

puts 'Game finished! Results:'
[user, dealer].each { |player| puts "#{player}'s balance: #{player.balance}" }
