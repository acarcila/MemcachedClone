require_relative "CommandTranslateUtil"
require_relative "../Constants/CommandPartsConstants"

RSpec.describe CommandTranslateUtil do
  it "translates the SET command" do
    commandString = "set key 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command[CommandPartsConstants::COMMAND]).to eq("set")
    expect(command[CommandPartsConstants::KEYS][0]).to eq("key")
    expect(command[CommandPartsConstants::FLAGS]).to eq(0)
    expect(command[CommandPartsConstants::TTL]).to eq(3600)
    expect(command[CommandPartsConstants::WHITESPACE]).to eq(2)
  end

  it "translates the Add command" do
    commandString = "add key 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command[CommandPartsConstants::COMMAND]).to eq("add")
    expect(command[CommandPartsConstants::KEYS][0]).to eq("key")
    expect(command[CommandPartsConstants::FLAGS]).to eq(0)
    expect(command[CommandPartsConstants::TTL]).to eq(3600)
    expect(command[CommandPartsConstants::WHITESPACE]).to eq(2)
  end

  it "translates the Replace command" do
    commandString = "replace key 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command[CommandPartsConstants::COMMAND]).to eq("replace")
    expect(command[CommandPartsConstants::KEYS][0]).to eq("key")
    expect(command[CommandPartsConstants::FLAGS]).to eq(0)
    expect(command[CommandPartsConstants::TTL]).to eq(3600)
    expect(command[CommandPartsConstants::WHITESPACE]).to eq(2)
  end

  it "translates the Append command" do
    commandString = "append key 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command[CommandPartsConstants::COMMAND]).to eq("append")
    expect(command[CommandPartsConstants::KEYS][0]).to eq("key")
    expect(command[CommandPartsConstants::FLAGS]).to eq(0)
    expect(command[CommandPartsConstants::TTL]).to eq(3600)
    expect(command[CommandPartsConstants::WHITESPACE]).to eq(2)
  end

  it "translates the Prepend command" do
    commandString = "prepend key 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command[CommandPartsConstants::COMMAND]).to eq("prepend")
    expect(command[CommandPartsConstants::KEYS][0]).to eq("key")
    expect(command[CommandPartsConstants::FLAGS]).to eq(0)
    expect(command[CommandPartsConstants::TTL]).to eq(3600)
    expect(command[CommandPartsConstants::WHITESPACE]).to eq(2)
  end

  it "translates the Get command" do
    commandString = "get key"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command[CommandPartsConstants::COMMAND]).to eq("get")
    expect(command[CommandPartsConstants::KEYS][0]).to eq("key")

    # multiple key
    commandString = "get key1 key2 key3"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command[CommandPartsConstants::COMMAND]).to eq("get")
    expect(command[CommandPartsConstants::KEYS]).to eq(["key1", "key2", "key3"])
  end

  it "translates the Gets command" do
    commandString = "gets key"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command[CommandPartsConstants::COMMAND]).to eq("gets")
    expect(command[CommandPartsConstants::KEYS][0]).to eq("key")

    # multiple key
    commandString = "gets key1 key2 key3"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command[CommandPartsConstants::COMMAND]).to eq("gets")
    expect(command[CommandPartsConstants::KEYS]).to eq(["key1", "key2", "key3"])
  end

  it "updates status of error" do
    commandString = "set 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command[CommandPartsConstants::STATUS]).to eq(ResponseConstants::ERROR)

    commandString = "set key key2 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command[CommandPartsConstants::STATUS]).to eq(ResponseConstants::CLIENT_ERROR)
    expect(command[CommandPartsConstants::ERROR]).to eq(ResponseConstants::LINE_FORMAT_ERROR)
  end
end
