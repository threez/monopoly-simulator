require "../lib/playing_field"
require "../lib/human_player"
require "pp"
include Monopoly

if false
  vincent = HumanPlayer.new("Vincent")
  lisa = HumanPlayer.new("Lisa")
else
  vincent = Player.new("Vincent")
  lisa = Player.new("Lisa")
end

players = [vincent, lisa]
pf = PlayingField.new(players)

# play 1000 turns
1000.times { players.each { |player| pf.play_turn player } }

def print_player(player)
  puts "## #{player.name} " + "#" * 50
  puts "Values: #{player.value}"
  puts " Streets:"
  player.streets.each do |street|
    if street.class != Fields::Street
      puts "  - #{street.name}: value => #{street.value} "
    else
      puts "  - #{street.name}:[#{street.color}] houses => #{street.houses} value => #{street.value} "
    end
  end
  puts " Can build on:"
  player.find_buildable_streets.each do |street|
    puts "  - #{street.name}:[#{street.color}] houses => #{street.houses} value => #{street.value} "
  end
end

print_player vincent
print_player lisa
