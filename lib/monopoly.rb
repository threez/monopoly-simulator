# helper to load all files from the monopoly sub directory
def load_all(folder)
  Dir[File.join(File.dirname(__FILE__), "monopoly", folder, "*.rb")].each do |file|
    require file
  end
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "monopoly"))

require "html_log"

require "cards"
load_all "cards"

require "field"
load_all "fields"

require "player"
load_all "players"

require "playing_field"
load_all "playing_fields"
