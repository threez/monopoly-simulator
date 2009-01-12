require File.dirname(__FILE__) + "/cards"

module Monopoly
  module Fields
    module Buyable
      def mortgage
        @owner.raise_money(price / 2)
        @mortgage = true
        @interest = 1.10  # 10% interest
      end
      
      def price
        @price
      end

      def amortize_the_mortgage()
        @owner.decrease_money(price / 2 * @interest)
        @mortgage = false
      end

      def mortgage?
        @mortgage
      end
      
      def value
        price
      end

      def buyable?
        @owner.nil?
      end

      def player_has_to_pay?(player)
        !buyable? and !@owner.in_jail and player != @owner and !@owner.in_jail
      end

      def owner=(player)
        # just set the owner if there is no other owner
        @owner = player if @owner.nil?
      end

      def owner
        @owner
      end

      def buy(player, auction_price = 0)
        price_of_field = (auction_price == 0) ? price : auction_price

        if buyable?
          if player.money >= price_of_field
            player.decrease_money price_of_field
            player.add_street(self)
            self.owner = player
            logger.player_info(player, "buyed #{name} for #{price_of_field} (normal price: #{price})")
            true
          else
            false
          end
        else
          false
        end
      end
      
      def sellable?
        true
      end

      def sell
        if sellable?
          @owner.streets.remove_street(self)
          @woner.raise_money(price)
          @owner = nil
        end
      end

      def sell_to_player(player)
        # FIXME
      end

      def fields_of_same_kind()
        @owner.find_streets(self.class)
      end

      def enter_field(player, playing_field)
        if player_has_to_pay?(player)
          player.transfer_money_to(@owner, self.charge)
          logger.player_info(player, "pay charge to #{@owner.name} (#{self.charge})")
        end
      end
    end

    module Constructible
      include Buyable
      NO_HOUSE = 0
      HOTEL = 5

      def mortgage
        unless houses?
          super
        end
      end

      def houses?
        @houses != NO_HOUSE
      end
      
      def houses
        @houses ||= 0
      end

      def fields_of_kind
        @owner.find_streets(self.class).select do |field|
          field.color == @color
        end
      end

      def all_streets_of_a_kind?
        @count_of_kind == fields_of_kind.size
      end

      def all_streets_of_a_kind_without_mortgage?
        return false unless all_streets_of_a_kind?
        fields_of_kind.each do |field| 
          return false if field.mortgage? 
        end
        true
      end

      def other_fields_houses
        other_fields = fields_of_kind.select { |field| field != self }
        other_fields.inject(0) { |sum, field| sum += field.houses }
      end

      def more_houses_possible?
        @houses < HOTEL
      end

      def house_buyable?
        if all_streets_of_a_kind_without_mortgage? and more_houses_possible?
          if other_fields_houses >= @houses * (@count_of_kind.size - 1)
            true
          else
            false
          end
        else
          false
        end
      end
      
      def sellable?
        !house_sellable?
      end

      def house_sellable?
        if @houses > 0
          if other_fields_houses <= @houses * (@count_of_kind.size - 1)
            true
          else
            false
          end
        else
          false
        end
      end

      def buy_house
        if house_buyable?
          @owner.decrease_money @charge_house
          @houses += 1
          true
        else
          false
        end
      end

      def sell_house
        if house_sellable?
          @owner.increase_money @charge_house
          @houses -= 1
          true
        else
          false
        end
      end
      
      def value
        price + houses * @charge_house
      end

      def charge
        case @houses
          when NO_HOUSE
            if all_streets_of_a_kind?
              @charge[0] * 2
            else
              @charge[0]
            end
          else
            @charge[@houses]
        end
      end
    end

    module NotBuyable
      def buyable?
        false
      end
    end
    
    class Field
      def name
        if @name
          @name
        else
          self.class
        end
      end
    end

    class Go < Field
      include NotBuyable

      def enter_field(player, playing_field)
        logger.player_info(player, "entered go field, raised 8000 (#{player.money})")
        player.raise_money 8000
      end

      def pass_field(player, playing_field)
        logger.player_info(player, "passed go field, raised 4000 (#{player.money})")
        player.raise_money 4000
      end
    end

    class Street < Field
      include Constructible

      attr_accessor :color, :count_of_kind

      def initialize(color, name, price, charge, charge_house)
        @color = color
        @name = name
        @price = price

        # for constructible
        @charge = charge
        @charge_house = charge_house
        @houses = 0
      end
    end

    class Station < Field
      include Buyable
      CHARGE = { 1 => 500, 2 => 1000, 3 => 2000, 4 => 4000}

      def initialize(name)
        @name = name
        @price = 4000
      end

      def charge
        CHARGE[fields_of_same_kind.size]
      end
    end

    class Plant < Field
      include Buyable

      def initialize(name)
        @name = name
        @price = 3000
      end

      def enter_field(player, playing_field)
        if player_has_to_pay?(player)
          multiplyer = (fields_of_same_kind.size == 1) ? 80 : 200
          charge = multiplyer * playing_field.dices_value
          player.transfer_money_to(@owner, charge)
        end
      end
    end

    class Community < Field
      include NotBuyable

      def enter_field(player, playing_field)
        card = CommunityCards.next_card
        card.use(CommunityCards, player, playing_field.other_players(player), playing_field)
      end
    end

    class Event < Field
      include NotBuyable

      def enter_field(player, playing_field)
        card = EventCards.next_card
        card.use(EventCards, player, playing_field.other_players(player), playing_field)
      end
    end

    class Tax < Field
      include NotBuyable

      def initialize(name, price)
        @name = name
        @price = price
      end

      def enter_field(player, playing_field)
        player.decrease_money @price
      end
    end

    class Jail < Field
      include NotBuyable

      attr_accessor :prisoners

      def initialize()
        @prisoners = []
      end
    
      def <<(prisoner)
        @prisoners << prisoner
        prisoner.in_jail = true
      end
    
      def leave(prisoner)
        @prisoners.delete prisoner
        prisoner.in_jail = false
      end
    
      def is_prisoner?(prisoner)
        @prisoners.include? prisoner
      end

      def enter_field(player, playing_field)
        # visiting the prisoners
      end
    end

    class Parking < Field
      include NotBuyable
    end

    class GoJail < Field
      include NotBuyable

      def enter_field(player, playing_field)
        playing_field.go_to_jail player
      end
    end
  end
end
