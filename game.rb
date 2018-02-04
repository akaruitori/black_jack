require_relative 'game_interface'

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
    @interface = GameInterface.new
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
    @players.each { |player| @interface.show_cards(player) }
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
    @interface.show_round_result(winner, @players)
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

  def calculate_score(cards)
    score = cards.map { |card| card.points }.sum
    score -= 10 if score > 21 && cards.map(&:value).include?('A')
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
      choice = @interface.ask_for_move(player, available_moves) - 1
    rescue RuntimeError => error_message
      @interface.show(error_message)
      retry
    end

    available_moves.at(choice)
  end

  def make_dealer_move(player)
    move = if player.score >= 17
             :pass
           else
             :add_card
           end
    @interface.show_move(player, move)
    move
  end

  def define_winner
    players = @players.sort_by { |player| player.score }
    if players.first.score > 21 || players.first.score == players.last.score
      :no_one
    elsif players.last.score <= 21
      players.last
    else
      players.first
    end
  end
end
