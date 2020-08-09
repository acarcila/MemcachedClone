class Item
  attr_reader :value, :ttl, :createdAt, :casToken, :whitespace, :flags     # getters
  attr_writer :value, :ttl, :createdAt, :casToken, :whitespace, :flags     # setters

  def initialize(value: nil, casToken: @casToken, ttl: 0, whitespace: 0, flags: 0)
    @value = value
    @ttl = ttl
    @casToken = casToken
    @whitespace = whitespace
    @flags = flags
    @createdAt = Time.now.getutc
  end

  # Concats a value to the end of the current value
  def append(value: nil, casToken: @casToken, ttl: nil, whitespace: 0, flags: 0)
    ttl ||= @ttl
    @whitespace += whitespace
    @casToken = casToken
    @ttl = ttl
    @flags = flags
    @value = "#{@value}#{value}"
  end

  # Concats a value to the start of the current value
  def prepend(value: nil, casToken: @casToken, ttl: nil, whitespace: 0, flags: 0)
    ttl ||= @ttl
    @whitespace += whitespace
    @casToken = casToken
    @ttl = ttl
    @flags = flags
    @value = "#{value}#{@value}"
  end

  # Returns the time at wich the item is suposed to expire
  def diesAt()
    @createdAt + @ttl
  end

  def to_s()
    "value=#{@value}, ttl=#{ttl}, casToken=#{@casToken}, whitespace=#{@whitespace}, flags=#{@flags}, createdAt=#{@createdAt}"
  end
end
