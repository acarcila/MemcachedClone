class StringUtil
  def StringUtil.cleanString(string)
    string = (string).gsub(/\r/, "")
    (string).gsub(/\n/, "")
  end
end
