require_relative 'deck'
require_relative 'game'
require_relative 'user'
require_relative 'dealer'

# greet user
puts 'Welcome to Black Jack game!'
# ask user's name
puts  'Enter your name, please:'
username = gets.chomp

# create player for user
user = User.new(100, username)
# create dealer
dealer = Dealer.new(100)
# create deck
deck = Deck.new
game = Game.new(deck, user, dealer)

# loop while true
while true
#   shuffle deck
  game.deck.shuffle!
#   deal cards
  game.deal_cards(2)
#   show cards
  game.show_cards

#   make stakes
#   loop until both players have 3 cards
#     user choose his move (exit loop if user wish to open cards)
#     dealer choose his move
  game.play_round

#   show result
#   game bank goes to winner
  game.finish_round

#   ask if user wish to play another game if players still have at least 10$
  if game.players_have_enough_money?
    puts 'Do you want to play another round? Enter "yes" to continue the game.'
    break unless gets.chomp == 'yes'
  else
    break
  end
end

# end game
puts 'Game finished! Results:'
[user, dealer].each { |player| puts "#{player}'s balance: #{player.balance}" }
