class ResponseConstants
  STORED = "STORED"
  NOT_STORED = "NOT_STORED"
  EXISTS = "EXISTS"
  NOT_FOUND = "NOT_FOUND"
  ERROR = "ERROR"
  CLIENT_ERROR = "CLIENT_ERROR"
  SERVER_ERROR = "SERVER_ERROR"
  LINE_FORMAT_ERROR = "bad command line format"
  BAD_DATA_ERROR = "bad data chunk"
  SERVER_CONNECTED_TEMPLATE = "Server started in port: %d"
  ITEM_TEMPLATE = "VALUE %s %d %d"
  ITEM_CAS_TEMPLATE = "VALUE %s %d %d %d"
  VALUE_TEMPLATE = "%s"
  ERROR_TEMPLATE = "%s %s"
  END_ = "END"
  ERROR_REGEX = /ERROR/
end
