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

  def append(value: nil, casToken: @casToken, ttl: nil, whitespace: 0, flags: 0)
    ttl ||= @ttl
    @whitespace += whitespace
    @casToken = casToken
    @ttl = ttl
    @flags = flags
    @value = "#{@value}#{value}"
  end

  def prepend(value: nil, casToken: @casToken, ttl: nil, whitespace: 0, flags: 0)
    ttl ||= @ttl
    @whitespace += whitespace
    @casToken = casToken
    @ttl = ttl
    @flags = flags
    @value = "#{value}#{@value}"
  end

  def diesAt()
    @createdAt + @ttl
  end

  def to_s()
    "value=#{@value}, ttl=#{ttl}, casToken=#{@casToken}, whitespace=#{@whitespace}, flags=#{@flags}, createdAt=#{@createdAt}"
  end
end
