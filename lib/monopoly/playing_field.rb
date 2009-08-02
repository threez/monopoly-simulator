module Monopoly
  class PlayingField
    attr_reader :dices_value, :dice_again, :turn, :playing_field
    
    def initialize(players, playing_field)
      @players = players
      @observers = []
      @player_positions = {}
      @playing_field = playing_field
      @playing_field.each do |field|
        field.playing_field = self
      end
      
      # placing all players on field go
      @players.each do |player| 
        set_player_position(player, field(1))
        player.playing_field = self
      end
      
      # initialize count of a kind
      @number_of_groups = Hash.new { |h, k| h[k] = 0 }
      @playing_field.each do |field| 
        if field.class == Fields::Street
          @number_of_groups[field.color] += 1
        end
      end
      @playing_field.each do |field| 
        if field.class == Fields::Street
          field.count_of_kind = @number_of_groups[field.color] 
        end
      end
      
      @field_go = field 1
      @field_jail = field 11
    end
    
    def notify_observers(event_name, env)
      @observers.each do |observer|
        if observer.respond_to? event_name
          observer.send(event_name, env)
        end
      end
    end

    def add_observer(observer)
      @observers << observer
      observer.players = @players
      observer.playing_field = self
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
      notify_observers :go_to_jail, :player => player
    end
    
    def player_in_jail?(player)
      @field_jail.is_prisoner? player 
    end
    
    def leave_jail(player)
      @field_jail.leave player # leave jail
      notify_observers :leave_jail, :player => player
    end
    
    def set_player_position(player, field)
      player.current_field = field
      @player_positions[player] = position_of(field)
    end
    
    def enter_field(player, field)
      set_player_position(player, field)
      if field.respond_to? :enter_field
        notify_observers :entering_field, :player => player, :field => field
        field.enter_field(player)
      end

      # hook for player actions
      player.do_actions(other_players(player))

      if player.current_field.buyable? 
        handle_auction_with(player.current_field, @players)
      end
    end
    
    def pass_field(player, field)
      set_player_position(player, field)
      if field.respond_to? :pass_field
        notify_observers :passing_field, :player => player, :field => field
        field.pass_field(player)
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
    def player_move_to(player, field, kind = :forward)
      next_field = (kind == :forward) ?
        next_field_for(player) :
        prev_field_for(player)
        
      if next_field == field
        enter_field(player, next_field)
      else
        pass_field(player, next_field)
        player_move_to(player, field, kind)
      end
    end
    
    def player_move_dice_value(player, dice_value)
      tmp_current_field = player.current_field
      
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
      
      notify_observers :player_movement, :current_field => tmp_current_field,
        :next_field => player.current_field, :player => player, 
        :dice_value => dice_value
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
        tmpplayer.do_actions(other_players(tmpplayer), :pre_move)
      end
    
      if player_in_jail?(player)
        case player.do_jail(other_players(player)) 
          when :pay
            leave_jail(player) if player.transfer_money_to(:bank, 1000)
          when :use_card
            leave_jail(player) if player.has_jail_card?
          else
            # player has to dice
        end
      end
      
      if play_dices(player)
        player_move_dice_value(player, dices_value)
        
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
          new_offer = tender.do_auction(field, highest_offer).to_i
          
          # if the tender is in jail he can't bid
          if new_offer > highest_offer and !tender.in_jail
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
    
      if dice1 == dice2 # double
        if player_in_jail?(player)
          leave_jail(player)
        elsif player.rolled_a_double
          go_to_jail(player)
          return false
        else
          @dice_again = true
          notify_observers :rolled_a_double, :dice => [dice1, dice2], :player => player
        end
      else  
        @dice_again = false
        player.reset_rolled_a_double
        return !player_in_jail?(player)
      end  
      
      return true
    end

    def play_dice()
      unless @seed
        @seed = File.open("/dev/urandom", "rb") { |f| f.read(4).unpack('I')[0] }
        srand(@seed)
      end
      rand(5) + 1
    end
    
    def play_game(turn_limit)
      turn_limit.times do |i|
        @players.each do |player|
          play_turn player
          @turn = i + 1
        end
      end
    end
  end
end
