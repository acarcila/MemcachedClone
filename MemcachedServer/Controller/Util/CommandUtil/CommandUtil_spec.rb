require_relative "CommandUtil"

RSpec.describe CommandUtil do
  it "translates de SET command" do
    commandString = "set key 0 3600 2"
    command = CommandUtil.translateCommand(commandString)

    expect(command["command"]).to eq("set")
    expect(command["keys"][0]).to eq("key")
    expect(command["flags"]).to eq(0)
    expect(command["ttl"]).to eq(3600)
    expect(command["whitespace"]).to eq(2)
  end

  it "translates de Add command" do
    commandString = "add key 0 3600 2"
    command = CommandUtil.translateCommand(commandString)

    expect(command["command"]).to eq("add")
    expect(command["keys"][0]).to eq("key")
    expect(command["flags"]).to eq(0)
    expect(command["ttl"]).to eq(3600)
    expect(command["whitespace"]).to eq(2)
  end

  it "translates de Replace command" do
    commandString = "replace key 0 3600 2"
    command = CommandUtil.translateCommand(commandString)

    expect(command["command"]).to eq("replace")
    expect(command["keys"][0]).to eq("key")
    expect(command["flags"]).to eq(0)
    expect(command["ttl"]).to eq(3600)
    expect(command["whitespace"]).to eq(2)
  end

  it "translates de Append command" do
    commandString = "append key 0 3600 2"
    command = CommandUtil.translateCommand(commandString)

    expect(command["command"]).to eq("append")
    expect(command["keys"][0]).to eq("key")
    expect(command["flags"]).to eq(0)
    expect(command["ttl"]).to eq(3600)
    expect(command["whitespace"]).to eq(2)
  end

  it "translates de Prepend command" do
    commandString = "prepend key 0 3600 2"
    command = CommandUtil.translateCommand(commandString)

    expect(command["command"]).to eq("prepend")
    expect(command["keys"][0]).to eq("key")
    expect(command["flags"]).to eq(0)
    expect(command["ttl"]).to eq(3600)
    expect(command["whitespace"]).to eq(2)
  end

  it "translates de Get command" do
    commandString = "get key"
    command = CommandUtil.translateCommand(commandString)

    expect(command["command"]).to eq("get")
    expect(command["keys"][0]).to eq("key")

    commandString = "get key1 key2 key3"
    command = CommandUtil.translateCommand(commandString)

    expect(command["command"]).to eq("get")
    expect(command["keys"]).to eq(["key1", "key2", "key3"])
  end

  it "translates de Gets command" do
    commandString = "gets key"
    command = CommandUtil.translateCommand(commandString)

    expect(command["command"]).to eq("gets")
    expect(command["keys"][0]).to eq("key")

    commandString = "gets key1 key2 key3"
    command = CommandUtil.translateCommand(commandString)

    expect(command["command"]).to eq("gets")
    expect(command["keys"]).to eq(["key1", "key2", "key3"])
  end

  it "outputs ERROR" do
    commandString = "set 0 3600 2"
    command = CommandUtil.translateCommand(commandString)

    expect(command["output"]).to eq("ERROR")

    commandString = "set key key2 0 3600 2"
    command = CommandUtil.translateCommand(commandString)

    expect(command["output"]).to eq("CLIENT_ERROR bad command line format")
  end
end
