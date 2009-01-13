module Monopoly
  module HasStreets
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
  end
  
  module HasStreetsWithHouses
    def can_build_house?
      find_buildable_streets().size > 0
    end
    
    def find_buildable_streets()
      buildable_streets = []
      streets.each do |street|
        if street.class == Fields::Street and street.all_streets_of_a_kind?
          buildable_streets << street
        end
      end
      buildable_streets.sort { |y, x| x.color.to_s <=> y.color.to_s }
    end
    
    def houses
      find_streets(Fields::Street).inject(0) do |sum, street| 
        (street.houses > 0 and street.houses < Fields::Constructible::HOTEL) ? sum + 1 : sum
      end
    end
    
    def hotels
      find_streets(Fields::Street).inject(0) do |sum, street|
        (street.houses == Fields::Constructible::HOTEL) ? sum + 1 : sum
      end
    end
  end
  
  module HasJailCards
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
  
  class Player
    include HasStreets
    include HasStreetsWithHouses
    include HasJailCards
    
    attr_reader :name, :money
    attr_accessor :current_field, :in_jail
    
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
    
    # DEFAULT IMPLEMENTATION: will be changed in later strategie implementations
    def do_actions(other_players, type = :normal)
      if type == :normal and current_field.buyable?
        # simple buy field
        current_field.buy(self) if current_field.price < money
      
        # simple payback mortgage if any
        @streets.each do |street|
          if street.mortgage? and street.price / 2 < money / 2
            street.amortize_the_mortgage
          end
        end
      
        # simple build streets
        if can_build_house?
          3.times do 
            find_buildable_streets.each do |street|
              street.buy_house if street.charge_house < money / 3
            end
          end
        end  
      end
    end
    
    # DEFAULT IMPLEMENTATION: will be changed in later strategie implementations
    def do_auction(field, highest_offer)
      # simple bid
      rand(500)
    end
    
    # DEFAULT IMPLEMENTATION: will be changed in later strategie implementations
    def do_jail(other_players)
      # dice as default
    end
    
    # DEFAULT IMPLEMENTATION: will be changed in later strategie implementations
    def do_pay_sum(sum_left)
      # simple pay debt
      @streets.first.mortgage!
    end
    
    def can_act?
      !@in_jail
    end
    
    def rolled_a_double
      @rolled_a_double += 1
      (@rolled_a_double == 3) ? true : false
    end
    
    def reset_rolled_a_double
      @rolled_a_double = 0
    end
    
    def transfer_money_to(receiver, amount)
      if receiver != :bank
        receiver.raise_money(amount)
        logger.player_info(self, "transfer #{amount} from [#{self.name}] to [#{receiver.name}]")
      else  
        logger.player_info(self, "transfer #{amount} from [#{self.name}] to [bank]")
      end
      decrease_money(amount)
    end

    def raise_money(amount)
      @money += amount
    end
    
  private 
    
    def decrease_money(amount)
      while @money - amount < 0
        do_pay_sum(@money - amount)
      end
      @money -= amount
    end
  end
end
