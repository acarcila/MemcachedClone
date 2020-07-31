require_relative "Item"

describe Item do
  it "appends a string to a string" do
    expect(Item.new("string").append("append")).to eq("stringappend")
    expect(Item.new("string").append(10)).to eq("string10")
  end

  it "appends a string to a number" do
    expect(Item.new(10).append("append")).to eq("10append")
    expect(Item.new(10).append(20)).to eq("1020")
  end

  it "prepends a string to a string" do
    expect(Item.new("string").prepend("prepend")).to eq("prependstring")
    expect(Item.new("string").prepend(10)).to eq("10string")
  end

  it "prepends a string to a number" do
    expect(Item.new(10).prepend("prepend")).to eq("prepend10")
    expect(Item.new(10).prepend(20)).to eq("2010")
  end

  it "initialize a default ttl of 0" do
    expect(Item.new(10).ttl).to eq(Item.new(10, 0).ttl)
  end

  it "calculates the timestamp the item should die" do
    item = Item.new(10, 3600)
    time = item.createdAt + 3600
    puts item.diesAt
    expect(item.diesAt).to eq(time)
  end
end
