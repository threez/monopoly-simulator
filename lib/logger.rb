require "logger"

module Monopoly
  class Logger < ::Logger
    def initialize()
      super(STDOUT)
      self.datetime_format = "%H:%M:%S"
    end
    
    def player_info(player, msg)
      info("[#{player.name}] #{msg}")
    end
  end
  
  LOGGER = Logger.new()
  LOGGER.level = Logger::DEBUG
  
  def logger
    LOGGER
  end
end