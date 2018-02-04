class GameInterface
  def show_cards(player)
    puts "\n#{player}'s cards: #{player.show_cards}"
    puts "Current score: #{player.score}" unless player.is_a?(Dealer)
  end

  def show_round_result(winner, players)
    puts "\n***Round results:***"
    if winner == :no_one
      puts 'A tie!'
    else
      puts "#{winner} won!\n"
    end

    players.each do |player|
      puts "#{player}'s cards: #{player.show_cards(hide_values = false)}"
      puts "Score: #{player.score}\nBalance: #{player.balance}\n"
    end
  end

  def show_move(player, move)
    puts "\n#{player} chose to #{Game::MOVES[move]}\n"
  end

  def show(message)
    puts message
  end

  def ask_for_move(player, options)
    puts "\n#{player}, choose your move:"
    options.each_with_index { |move, i| puts "#{i + 1}: #{Game::MOVES[move]}" }
    choice = gets.to_i

    unless (1..options.size).cover?(choice)
      raise 'Please, enter one of the digits.'
    end
    choice
  end
end
