module Monopoly
  class Player
    attr_reader :name, :money
    attr_accessor :rolled_a_double, :current_field, :in_jail
    
    def initialize(name, &actions)
      @name = name
      @actions = actions
      @streets = []
      @money = 30000
      @jail_cards = []
      @rolled_a_double = 0
      @in_jail = false
    end
    
    def do_actions(other_players)
      if @actions 
        @actions.call(self, other_players)
      end
    end
    
    def do_auction(field, highest_offer)
      500 # rand(500) # default
    end
    
    def do_jail(other_players)
      # nothing to do
      nil # default to dice
    end
    
    def do_pay_sum(sum_left)
      @streets.first.mortgage # default
    end
    
    def reset_rolled_a_double
      @rolled_a_double = 0
    end
    
    def streets
      @streets
    end
    
    def add_street(street)
      @streets << street
    end
    
    def remove_street(street)
      @streets.delete street
    end
    
    def sell_street(player, street, price)
      # transfer money
      player.transfer_money_to(self, price)
      
      # transfer street
      player.add_street(street)
      self.remove_street(street)
    end
    
    def find_streets(street_class)
      @streets.select { |field| field.class == street_class }
    end
    
    def houses
      find_streets(Fields::Street).inject(0) { |sum, field| sum += 1 if field.houses < Fields::Constructible::HOTEL }
    end
    
    def hotels
      find_streets(Fields::Street).inject(0) { |sum, field| sum += 1 if field.houses == Fields::Constructible::HOTEL }
    end
    
    def decrease_money(amount)
      while @money - amount < 0
        do_pay_sum(@money - amount)
      end
      @money -= amount
    end
    
    def raise_money(amount)
      @money += amount
    end
    
    def add_jail_card(card, card_stack)
      @jail_cards << [card, card_stack]
    end
    
    def has_jail_card?
      @jail_cards > @jail_cards.size
    end
    
    def use_jail_card
      if has_jail_card?
        card, card_stack = @jail_cards.shift
        card_stack.add_card(card)
        true
      else
        false
      end
    end
    
    def transfer_money_to(player, amount)
      player.raise_money(amount)
      self.decrease_money(amount)
    end
    
    def sell_jail_card(player, price)
      if has_jail_card?
        # transfer money
        player.transfer_money_to(self, amount)
        
        # transfer card
        card, card_stack = @jail_cards.shift
        player.add_jail_card(card, card_stack)
      end
    end
  end
end
