class CommandConstants
  GET = "get"
  GETS = "gets"
  SET = "set"
  ADD = "add"
  REPLACE = "replace"
  APPEND = "append"
  PREPEND = "prepend"
  CAS = "cas"
  INTEGER_REGEX = /\d+\b/
  GET_GETS_REGEX = /#{GET}(s|)\b/
  NOT_GET_REGEX = /#{SET}|#{ADD}|#{REPLACE}|#{APPEND}|#{PREPEND}|#{CAS}\b/
  VALID_COMMAND_REGEX = /(#{SET}|#{ADD}|#{REPLACE}|#{APPEND}|#{PREPEND}|#{CAS}|(#{GET}(s|)))\b/
end
