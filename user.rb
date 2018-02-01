class User < Player
  attr_reader :name

  def initialize(balance, name)
    super(balance)
    @name = name
  end
end
