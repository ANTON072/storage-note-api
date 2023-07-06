class AuthenticationError < StandardError; end
class ExpiredTokenError < AuthenticationError; end
