class Game
  attr_reader :bank
  attr_accessor :deck

  MAX_CARDS_NUMBER = 3
  MOVES = {add_card: 'add a card', open_cards: 'open cards', pass: 'pass'}
  STAKE = 10

  def initialize(deck, user, dealer)
    @deck = deck
    @players = [user, dealer]
    @bank = 0
  end

  def deal_cards(number)
    @players.each do |player|
      player.cards = @deck.deal_cards(number)
      player.score = calculate_score(player.cards)
    end
  end

  def make_stakes(amount)
    @players.each { |player| player.balance -= amount }
    @bank += 2 * amount
  end

  def show_cards
    @players.each do |player|
      puts "#{player}'s cards: #{player.show_cards}"
      puts "Corrent score: #{player.score}" unless player.is_a?(Dealer)
      puts
    end
  end

  def play_round
    make_stakes(STAKE)
    catch :user_opens_cards do
      until max_card_number_reached?
        make_moves
        show_cards
      end
    end 
  end

  def finish_round
    winner = define_winner

    if winner == :no_one
      make_stakes(-STAKE)
    else
      winner.balance += @bank
      @bank = 0
    end
    show_round_result(winner)
  end

  def players_have_enough_money?
    @players.select { |player| player.balance < STAKE }.none?
  end

  private

  def make_moves
    @players.each do |player|
      move = choose_a_move(player)
      case move
      when :open_cards
        throw :user_opens_cards
      when :add_card
        player.cards += @deck.deal_cards(1)
        player.score = calculate_score(player.cards)
      end
    end
  end


  def show_round_result(winner)
    puts "***Round results:***"
    if winner == :no_one
      puts 'A tie!'
    else
      puts "#{winner} won!"
    end

    @players.each do |player|
      puts "#{player}'s cards: #{player.show_cards(hide_values = false)}"
      puts "Score: #{player.score}\nBalance: #{player.balance}"
    end
  end
 
  def calculate_score(cards)
    score = cards.map { |card| card.points }.sum
    score - 10 if score > 21 && cards.map(&:value).include?('A')
    score
  end

  def max_card_number_reached?
    @players.sum { |player| player.cards.size } == MAX_CARDS_NUMBER * 2
  end

  def choose_a_move(player)
    if player.is_a? User
      user_move(player)
    else
      make_dealer_move(player)
    end
  end

  def user_move(player)
    available_moves = MOVES.keys
    available_moves.delete(:add_card) if player.cards.size == MAX_CARDS_NUMBER

    begin
      choice = ask_for_user_move(player, available_moves) - 1
    rescue RuntimeError => error_message
      puts error_message
      retry
    end

    available_moves.at(choice)
  end

  def ask_for_user_move(player, available_moves)
    puts "#{player}, choose your move:"
    available_moves.each_with_index { |move, i| puts "#{i + 1}: #{MOVES[move]}" }
    choice = gets.to_i

    unless (1..available_moves.size).cover?(choice)
      raise 'Please, enter one of the digits.'
    end
    choice
  end

  def make_dealer_move(player)
    move = if player.score >= 17
             :pass
           else
             :add_card
           end

    puts "Dealer chose to #{MOVES[move]}"
    move
  end

  def define_winner
    player, dealer = @players

    if player.score > 21 && dealer.score > 21
      :no_one
    elsif player.score <= 21 && dealer.score > 21
      player
    elsif dealer.score <= 21 && player.score > 21
      dealer
    else
      case player.score <=> dealer.score
      when 1 then player
      when 0 then :no_one
      when -1 then dealer
      end
    end
  end
end
