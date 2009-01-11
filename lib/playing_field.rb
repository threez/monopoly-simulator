require File.dirname(__FILE__) + "/field"
require File.dirname(__FILE__) + "/player"

module Monopoly
  class PlayingField
    include Fields
    attr_reader :dices_value, :dice_again
    
    def initialize(players)
      @players = players
      @player_positions = {}
      
      # placing all players on field go
      @players.each { |player| @player_positions[player] = 0 }
      
      @playing_field = [
        # site 1
        Go.new(),
        Street.new(:pink, "Badstra\xC3\x9f", 1200, { 0 => 40, 1 => 200, 2 => 600, 3 => 1800, 4 => 3200, 5 => 5000 }, 1000),
        Community.new(),
        Street.new(:pink, "Turmstra\xC3\x9f", 1200, { 0 => 80, 1 => 400, 2 => 1200, 3 => 3600, 4 => 6400, 5 => 9000 }, 1000),
        Tax.new("Einkommen\xC3\x9fteuer", 4000),
        Station.new("S\xC3\xBCdbahnhof"),
        Street.new(:cyan, "Chau\xC3\x9feestra\xC3\x9f", 2000, { 0 => 120, 1 => 600, 2 => 1800, 3 => 5400, 4 => 8000, 5 => 11000 }, 1000),
        Event.new(),
        Street.new(:cyan, "Elisenstra\xC3\x9f", 2000, { 0 => 120, 1 => 600, 2 => 1800, 3 => 5400, 4 => 8000, 5 => 11000 }, 1000),
        Street.new(:cyan, "Poststra\xC3\x9f", 2400, { 0 => 160, 1 => 800, 2 => 2000, 3 => 6000, 4 => 9000, 5 => 12000 }, 1000),

        # site 2
        Jail.new(),
        Street.new(:purple, "Seestra\xC3\x9f", 2800, { 0 => 200, 1 => 1000, 2 => 3000, 3 => 9000, 4 => 12500, 5 => 15000 }, 2000),
        Plant.new("Elektrizit\xC3\xA4ts-Werk"),
        Street.new(:purple, "Hafenstra\xC3\x9f", 2800, { 0 => 200, 1 => 1000, 2 => 3000, 3 => 9000, 4 => 12500, 5 => 15000 }, 2000),
        Street.new(:purple, "Neue Stra\xC3\x9f", 3200, { 0 => 240, 1 => 1200, 2 => 3600, 3 => 10000, 4 => 14000, 5 => 18000 }, 2000),
        Station.new("Westbahnhof"),
        Street.new(:orange, "M\xC3\xBCnchener Stra\xC3\x9f", 3600, { 0 => 280, 1 => 1400, 2 => 4000, 3 => 11000, 4 => 15000, 5 => 19000 }, 2000),
        Community.new(),
        Street.new(:orange, "Wiener Stra\xC3\x9f", 3600, { 0 => 280, 1 => 1400, 2 => 4000, 3 => 11000, 4 => 15000, 5 => 19000 }, 2000),
        Street.new(:orange, "Berliner Stra\xC3\x9f", 4000, { 0 => 320, 1 => 1600, 2 => 4400, 3 => 12000, 4 => 16000, 5 => 20000 }, 2000),

        # site 3
        Parking.new(),
        Street.new(:red, "Theaterstra\xC3\x9f", 4400, { 0 => 360, 1 => 1800, 2 => 5000, 3 => 14000, 4 => 17500, 5 => 21000 }, 3000),
        Event.new(),
        Street.new(:red, "Museumstra\xC3\x9f", 4400, { 0 => 360, 1 => 1800, 2 => 5000, 3 => 14000, 4 => 17500, 5 => 21000 }, 3000),
        Street.new(:red, "Opernplatz", 4800, { 0 => 400, 1 => 2000, 2 => 6000, 3 => 15000, 4 => 18500, 5 => 23000 }, 3000),
        Station.new("Nordbahnhof"),
        Street.new(:yellow, "Le\xC3\x9fingstra\xC3\x9f", 5200, { 0 => 440, 1 => 2200, 2 => 6600, 3 => 16000, 4 => 19500, 5 => 23000 }, 3000),
        Street.new(:yellow, "Schillerstra\xC3\x9f", 5200, { 0 => 440, 1 => 2200, 2 => 6600, 3 => 16000, 4 => 19500, 5 => 23000 }, 3000),
        Plant.new("Wa\xC3\x9fer-Werk"),
        Street.new(:yellow, "Goethestra\xC3\x9f", 5600, { 0 => 480, 1 => 2400, 2 => 7200, 3 => 17000, 4 => 20500, 5 => 24000 }, 3000),

        # site 4
        GoJail.new(),
        Street.new(:green, "Rathausplatz", 6000, { 0 => 520, 1 => 2600, 2 => 7800, 3 => 18000, 4 => 22000, 5 => 25500 }, 4000),
        Street.new(:green, "Hauptstra\xC3\x9f", 6000, { 0 => 520, 1 => 2600, 2 => 7800, 3 => 18000, 4 => 22000, 5 => 25500 }, 4000),
        Community.new(),
        Street.new(:green, "Bahnhofstra\xC3\x9f", 6400, { 0 => 560, 1 => 3000, 2 => 9000, 3 => 20000, 4 => 24000, 5 => 28000 }, 4000),
        Station.new("Hauptbahnhof"),
        Event.new(),
        Street.new(:blue, "Parkstra\xC3\x9f", 7000, { 0 => 700, 1 => 3500, 2 => 10000, 3 => 22000, 4 => 26000, 5 => 30000 }, 4000),
        Tax.new("Zusatzsteuer", 2000),
        Street.new(:blue, "Schlo\xC3\x9fllee", 8000, { 0 => 1000, 1 => 4000, 2 => 12000, 3 => 28000, 4 => 34000, 5 => 40000 }, 4000)
      ]
      
      @field_go = field 1
      @field_jail = field 11
    end
    
    # starting from 1 not from zero
    def field(index)
      @playing_field[index - 1]
    end
    
    def other_players(player)
      @players.select do |tmpplayer|
        player != tmpplayer
      end
    end
    
    def position_of(field)
      @playing_field.index field
    end
    
    def go_to_jail(player)
      @field_jail << player
      set_player_position(player, @field_jail)
    end
    
    def player_in_jail?(player)
      @field_jail.is_prisoner? player 
    end
    
    def leave_jail(player)
      @field_jail.leave player # leave jail
    end
    
    def set_player_position(player, field)
      player.current_field = field
      @player_positions[player] = position_of(field)
    end
    
    def enter_field(player, field)
      set_player_position(player, field)
      if field.respond_to? :enter_field
        field.enter_field(player, self)
      end
    end
    
    def pass_field(player, field)
      set_player_position(player, field)
      if field.respond_to? :pass_field
        field.pass_field(player, self)
      end
    end
    
    def next_field_of_type(player, field_class)
      current_position = @player_positions[player]
      begin
        if @playing_field.size == current_position + 1
          current_position = 0
        else
          current_position += 1
        end
      end while @playing_field[current_position].class != field_class
      return @playing_field[current_position]
    end
    
    # value can ether be a field or a dice value
    def player_move_to(player, field)
      next_field = next_field_for(player)
      if next_field == field
        enter_field(player, next_field)
      else
        pass_field(player, next_field)
        player_move_to(player, field)
      end
    end
    
    def player_move_dice_value(player, dice_value)
      if dice_value > 0 # move forward
        (dice_value - 1).times do
          pass_field(player, next_field_for(player))
        end
        enter_field(player, next_field_for(player))
      else # move backward
        (dice_value * -1 - 1).times do
          pass_field(player, prev_field_for(player))
        end
        enter_field(player, prev_field_for(player))
      end
    end
    
    def next_field_for(player)
      if @player_positions[player] < @playing_field.size - 1
        @playing_field[@player_positions[player] + 1]
      else
        @playing_field.first
      end
    end
    
    def prev_field_for(player)
      if @player_positions[player] - 1 >= 0
        @playing_field[@player_positions[player] - 1]
      else
        @playing_field.last
      end
    end

    def play_turn(player)
      # handle other player actions
      other_players(player).each do |tmpplayer| 
        tmpplayer.do_actions(other_players(tmpplayer))
      end
    
      if player_in_jail?(player)
        case player.do_jail(other_players(player)) 
          when :pay
            leave_jail(player) if player.decrease_money 1000
          when :use_card
            leave_jail(player) if player.has_jail_card?
          else
            # player has to dice
        end
      end
      
      # if in jail after a third rolled a double quit turn 
      if play_dices(player)
        # handle if player is in jail and dices
        return if player_in_jail?(player) and !dice_again
      
        # move the player
        player_move_dice_value(player, @dices_value)
    
        # hook for player actions
        player.do_actions(other_players(player))
        
        if player.current_field.respond_to? "buyable?" and player.current_field.buyable? 
          handle_auction_with(player.current_field, @players)
        end
        
        # play again if he has rolled a double
        play_turn(player) if dice_again
      end
    end
    
    def handle_auction_with(field, players)
      highest_offer = 0 # minimum price
      highest_tender = nil
      tenders = Array.new(players)
      
      begin
        tenders.each do |tender|
          new_offer = tender.do_auction(field, highest_offer)
          if new_offer > highest_offer
            highest_offer = new_offer
            highest_tender = tender
          else
            tenders.delete tender
          end
        end
      end while tenders.size > 1
      
      field.buy(highest_tender, highest_offer) if highest_offer > 0
    end
    
    def play_dices(player)
      dice1, dice2 = play_dice, play_dice
      @dices_value = dice1 + dice2
      @dice_again = false
    
      if dice1 == dice2
        player.rolled_a_double += 1
        if player.rolled_a_double == 3
          self.go_to_jail(player)
          player.reset_rolled_a_double
          return false
        else
          @dice_again = true
        end
      else
        player.reset_rolled_a_double
      end
      
      true
    end

    def play_dice()
      rand(6)
    end
  end
end
