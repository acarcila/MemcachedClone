class Item
  attr_reader :value, :ttl     # getters
  attr_writer :value, :ttl     # setters

  def initialize(value, ttl = 0)
    @value = value
    @ttl = ttl
  end

  def append(value)
    @value = "#{@value}#{value}"
  end

  def prepend(value)
    @value = "#{value}#{@value}"
  end

  def to_s()
    "Value: #{@value}, will die in #{@ttl}"
  end
end
