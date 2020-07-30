class Item
  attr_reader :value, :ttl, :createdAt     # getters
  attr_writer :value, :ttl, :createdAt     # setters

  def initialize(value, ttl = 0)
    @value = value
    @ttl = ttl
    @createdAt = Time.now.getutc
  end

  def append(value)
    @value = "#{@value}#{value}"
  end

  def prepend(value)
    @value = "#{value}#{@value}"
  end

  def diesAt()
    @createdAt + @ttl
  end

  def to_s()
    "Value: #{@value}, will die in #{@ttl}"
  end
end
