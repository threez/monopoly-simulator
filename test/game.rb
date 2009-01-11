require "../lib/playing_field"
require "../lib/human_player"
require "pp"
include Monopoly
vincent = HumanPlayer.new("Vincent")
lisa = HumanPlayer.new("Lisa")
players = [vincent, lisa]
pf = PlayingField.new(players)
1000.times { [vincent, lisa].each { |player| pf.play_turn player } }
puts "#" * 50
p vincent.money
puts "#" * 50
p lisa.money