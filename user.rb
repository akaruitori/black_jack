class User < Player
  def initialize(balance, name)
    super(balance)
    @name = name
  end

  def to_s
    @name
  end
end
