module Monopoly
  class Player
    attr_reader :name, :money
    attr_accessor :rolled_a_double, :current_field, :in_jail
    
    def initialize(name)
      @name = name
      @streets = []
      @money = 30000
      @jail_cards = []
      @rolled_a_double = 0
      @in_jail = false
    end
    
    def value
      money + streets.inject(0) { |sum, street| sum += street.value }
    end
    
    def do_actions(other_players, type = :normal)
      if type == :normal and current_field.buyable?
        current_field.buy(self) if current_field.price < money
      end
    end
    
    def do_auction(field, highest_offer)
      rand(500) + rand(500) # default
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
    
    def can_build_house?
      find_buildable_streets().size > 0
    end
    
    def find_buildable_streets()
      buildable_streets = []
      streets.each do |street|
        if street.class == Fields::Street and street.house_buyable?
          buildable_streets << street
        end
      end
      buildable_streets.sort { |y, x| x.color.to_s <=> y.color.to_s }
    end
    
    def houses
      find_streets(Fields::Street).inject(0) do |sum, street| 
        sum += 1 if street.houses > 0 and street.houses < Fields::Constructible::HOTEL
      end.to_i
    end
    
    def hotels
      find_streets(Fields::Street).inject(0) do |sum, street|
        sum += 1 if street.houses == Fields::Constructible::HOTEL
      end.to_i
    end
    
    def decrease_money(amount)
      while @money - amount < 0
        do_pay_sum(@money - amount)
      end
      @money -= amount
      logger.player_info(self, "payed #{amount} (#{@money})")
    end
    
    def raise_money(amount)
      @money += amount
      logger.player_info(self, "raised #{amount} (#{@money})")
    end
    
    def add_jail_card(card, card_stack)
      @jail_cards << [card, card_stack]
    end
    
    def has_jail_card?
      @jail_cards.size > 0
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
