class StringUtil
  def StringUtil.cleanString(string)
    (string).gsub(/\r\n/, "")
  end
end
