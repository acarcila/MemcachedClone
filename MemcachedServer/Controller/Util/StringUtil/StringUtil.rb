class StringUtil
  # Cleans a given string of Carriage Return (\r) and Line Feed (\n)
  def StringUtil.cleanString(string)
    string = (string).gsub(/\r/, "")
    (string).gsub(/\n/, "")
  end
end
