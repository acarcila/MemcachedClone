require_relative "Item"

describe Item do
  it "appends a string to a string" do
    expect(Item.new(value: "string").append(value: "append")).to eq("stringappend")
    expect(Item.new(value: "string").append(value: 10)).to eq("string10")
  end

  it "appends a string to a number" do
    expect(Item.new(value: 10).append(value: "append")).to eq("10append")
    expect(Item.new(value: 10).append(value: 20)).to eq("1020")
  end

  it "prepends a string to a string" do
    expect(Item.new(value: "string").prepend(value: "prepend")).to eq("prependstring")
    expect(Item.new(value: "string").prepend(value: 10)).to eq("10string")
  end

  it "prepends a string to a number" do
    expect(Item.new(value: 10).prepend(value: "prepend")).to eq("prepend10")
    expect(Item.new(value: 10).prepend(value: 20)).to eq("2010")
  end

  it "initialize a default ttl of 0" do
    expect(Item.new(value: 10).ttl).to eq(Item.new(value: 10, ttl: 0).ttl)
  end

  it "calculates the timestamp the item should die" do
    item = Item.new(value: 10, ttl: 3600)
    time = item.createdAt + 3600
    expect(item.diesAt).to eq(time)
  end
end
