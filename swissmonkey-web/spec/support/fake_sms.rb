class FakeSMS
  Message = Struct.new(:from, :to, :body)

  cattr_accessor :messages
  self.messages = []

  def initialize(_account_sid, _auth_token); end

  def messages
    self
  end

  def create(from: nil, to: nil, body: nil)
    puts 'create'
    self.class.messages << Message.new(from: from, to: to, body: body)
  end
end
