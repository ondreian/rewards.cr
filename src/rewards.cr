require "./eaccess"

module Rewards
  VERSION = "0.3.0"
  def self.account()
    ENV["GS_ACCOUNT"]
  end

  def self.password()
    ENV["GS_PASSWORD"]
  end

  def self.claim!(account = self.account, password = self.password)
    EAccess.fetch_characters(account: account, password: password).each {|character|
      _0, _1, otp = EAccess.auth(account: account, password: password, character: character)
      self.login(character, otp)
    }
  end

  def self.login(character, otp)
    game = otp.use()
    game.read_timeout = 3
    server = TCPServer.new("localhost", 0)
    while from_game = game.gets
      break if game.closed?
      next if from_game.nil? || from_game.strip.empty?
      break if from_game =~ /Thank you for logging into GemStone IV!/
      break if from_game =~ /^<prompt/
    end
    server.close
    puts "%s> logged in" % [character.ljust(15)]
  end
end
