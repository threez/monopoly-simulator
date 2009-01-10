require "field"

module Monopoly
  class PlayingField
    attr_reader :dices_value, :dice_again
    
    def initialize(players)
      @players = players
      @player_positions = {}
      
      # placing all players on field go
      @players.each { |player| @player_positions[player] = 0 }
      
      @playing_field = [
        # site 1
        @field_go = FieldGo.new(),
        FieldStreet.new(:pink, "Badstraße", 1200, { 0 => 40, 1 => 200, 2 => 600, 3 => 1800, 4 => 3200, 5 => 5000 }, 1000),
        FieldCommunity.new(),
        FieldStreet.new(:pink, "Turmstraße", 1200, { 0 => 80, 1 => 400, 2 => 1200, 3 => 3600, 4 => 6400, 5 => 9000 }, 1000),
        FieldTax.new("Einkommenssteuer", 4000),
        FieldStation.new("Südbahnhof"),
        FieldStreet.new(:cyan, "Chausseestraße", 2000, { 0 => 120, 1 => 600, 2 => 1800, 3 => 5400, 4 => 8000, 5 => 11000 }, 1000),
        FieldEvent.new(),
        FieldStreet.new(:cyan, "Elisenstraße", 2000, { 0 => 120, 1 => 600, 2 => 1800, 3 => 5400, 4 => 8000 5 => 11000 }, 1000),
        FieldStreet.new(:cyan, "Poststraße", 2400 { 0 => 160, 1 => 800, 2 => 2000, 3 => 6000, 4 => 9000, 5 => 12000 }, 1000),

        # site 2
        @field_jail = FieldJail.new(),
        FieldStreet.new(:purple, "Seestraße", 2800, { 0 => 200, 1 => 1000, 2 => 3000, 3 => 9000, 4 => 12500, 5 => 15000 }, 2000),
        FieldPlant.new("Elektrizitäts-Werk"),
        FieldStreet.new(:purple, "Hafenstraße", 2800, { 0 => 200, 1 => 1000, 2 => 3000, 3 => 9000, 4 => 12500, 5 => 15000 }, 2000),
        FieldStreet.new(:purple, "Neue Straße", 3200, { 0 => 240, 1 => 1200, 2 => 3600, 3 => 10000, 4 => 14000, 5 => 18000 }, 2000),
        FieldStation.new("Westbahnhof"),
        FieldStreet.new(:orange, "Münchener Straße", 3600, { 0 => 280, 1 => 1400, 2 => 4000, 3 => 11000, 4 => 15000, 5 => 19000 }, 2000),
        FieldCommunity.new(),
        FieldStreet.new(:orange, "Wiener Straße", 3600, { 0 => 280, 1 => 1400, 2 => 4000, 3 => 11000, 4 => 15000, 5 => 19000 }, 2000),
        FieldStreet.new(:orange, "Berliner Straße", 4000, { 0 => 320, 1 => 1600, 2 => 4400, 3 => 12000, 4 => 16000, 5 => 20000 }, 2000),

        # site 3
        FieldParking.new(),
        FieldStreet.new(:red, "Theaterstraße", 4400, { 0 => 360, 1 => 1800, 2 => 5000, 3 => 14000, 4 => 17500, 5 => 21000 }, 3000),
        FieldEvent.new(),
        FieldStreet.new(:red, "Museumstraße", 4400, { 0 => 360, 1 => 1800, 2 => 5000, 3 => 14000, 4 => 17500, 5 => 21000 }, 3000),
        FieldStreet.new(:red, "Opernplatz", 4800, { 0 => 400, 1 => 2000, 2 => 6000, 3 => 15000, 4 => 18500, 5 => 23000 }, 3000),
        FieldStation.new("Nordbahnhof"),
        FieldStreet.new(:yellow, "Lessingstraße", 5200, { 0 => 440, 1 => 2200, 2 => 6600, 3 => 16000, 4 => 19500, 5 => 23000 }, 3000),
        FieldStreet.new(:yellow, "Schillerstraße", 5200, { 0 => 440, 1 => 2200, 2 => 6600, 3 => 16000, 4 => 19500, 5 => 23000 }, 3000),
        FieldPlant.new("Wasser-Werk"),
        FieldStreet.new(:yellow, "Goethestraße", 5600, { 0 => 480, 1 => 2400, 2 => 7200, 3 => 17000, 4 => 20500, 5 => 24000 }, 3000),

        # site 4
        FieldGoJail.new(),
        FieldStreet.new(:green, "Rathausplatz", 6000, { 0 => 520, 1 => 2600, 2 => 7800, 3 => 18000, 4 => 22000, 5 => 25500 }, 4000),
        FieldStreet.new(:green, "Hauptstraße", 6000, { 0 => 520, 1 => 2600, 2 => 7800, 3 => 18000, 4 => 22000, 5 => 25500 }, 4000),
        FieldCommunity.new(),
        FieldStreet.new(:green, "Bahnhofstraße", 6400, { 0 => 560, 1 => 3000, 2 => 9000, 3 => 20000, 4 => 24000, 5 => 28000 }, 4000),
        FieldStation.new("Hauptbahnhof"),
        FieldEvent.new(),
        FieldStreet.new(:blue, "Parkstraße", 7000, { 0 => 700, 1 => 3500, 2 => 10000, 3 => 22000, 4 => 26000, 5 => 30000 }, 4000),
        FieldTax.new("Zusatzsteuer", 2000),
        FieldStreet.new(:blue, "Schloßallee", 8000, { 0 => 1000, 1 => 4000, 2 => 12000, 3 => 28000, 4 => 34000, 5 => 40000 }, 4000)
      ]
    end
    
    def other_players(player)
      @players.select { |other_player| other_player != player }
    end
    
    def posiotion_of_field(field)
      @playing_field.index field
    end
    
    def go_to_jail(player)
      @field_jail.prisoners << player # add as prisoner
      player.in_jail = true
      move_to(player, @field_jail)
    end
    
    def is_in_jail?(player)
      @field_jail.prisoners.include? player 
    end
    
    def leave_jail(player)
      @field_jail.delete player # leave jail
    end
    
    def move_to(player, field)
      @player.current_field = field
      @player_position[player] = posiotion_of_field(field)
    end
    
    def enter_field(player, field)
      move_to(player, field)
      if @field.respond_to? :enter_field
        @field.enter_field(player, self)
      end
    end
    
    def pass_field(player, field)
      move_to(player, field)
      if @field.respond_to? :pass_field
        @field.pass_field(player, self)
      end
    end
    
    def next_field_for(player)
      @playing_field[@player_position[player] + 1] 
    end
    
    def pass_next_field(player)
      next_field = next_field_for(player)
    end
    
    def play_turn(player)
      hook_other_player_actions()
      if is_in_jail?(player)
        case player.do_jail(other_players(player)) 
          when :pay
            leave_jail(player) if player.decrease_money 1000
          when :use_card
            leave_jail(player) if player.has_jail_card?
          else
            # player has to dice
        end
      end
      
      # if in jail after a third double quit turn 
      if play_dices(player)
        # handle if player is in jail and dices
        break if is_in_jail?(player) and !dice_again
      
        # move the player
        (dice_value - 1).times do
          pass_field(player, next_field_for(player))
        end
        enter_field(next_field_for(player))
    
        # hook for player actions
        player.do_actions(other_players(player))
    
        play_turn(player) if dice_again
      end
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