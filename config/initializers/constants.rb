module ValidationConstants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_URL_REGEX   = /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
end
