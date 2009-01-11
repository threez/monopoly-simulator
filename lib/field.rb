require File.dirname(__FILE__) + "/cards"

module Monopoly
  module Fields
    module Buyable
      def mortgage
        @owner.raise_money(price / 2)
        @mortgage = true
        @interest = 1.10  # 10% interest
      end

      def amortize_the_mortgage()
        @owner.decrease_money(price / 2 * @interest)
        @mortgage = false
      end

      def mortgage?
        @mortgage
      end

      def buyable?
        @owner.nil?
      end

      def player_has_to_pay?
        !buyable? and !@owner.in_jail
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
            true
          else
            false
          end
        else
          false
        end
      end

      def sell

      end

      def sell_to_player(player)

      end

      def fields_of_same_kind()
        @owner.find_streets(self.class)
      end

      def enter_field(player, playing_field)
        if player_has_to_pay?
          player.decrease_money(self.charge)
        end
      end
    end

    module Constructible
      include Buyable
      NO_HOUSE = 0
      HOUSE_1 = 1
      HOUSE_2 = 2
      HOUSE_3 = 3
      HOUSE_4 = 4
      HOTEL = 5

      def mortgage
        unless houses?
          super.mortgage
        end
      end

      def houses?
        @houses != NO_HOUSE
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
        no_mortgage = true
        fields_of_kind.each { |field| no_mortgage &= false if field.mortgage? }
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
          if other_fields_houses >= @houses * 2
            true
          else
            false
          end
        else
          false
        end
      end

      def house_sellable
        if @houses > 0
          if other_fields_houses <= @houses * 2
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

      def charge
        case @houses
          when NO_HOUSE
            if all_streets_of_a_kind?
              @charge[0] * 2
            else
              @charge[0]
            end
          when HOUSE_1
            @charge[1]
          when HOUSE_2
            @charge[2]
          when HOUSE_3
            @charge[3]
          when HOUSE_4
            @charge[4]
          when HOTEL
            @charge[5]
        end
      end
    end

    module NotBuyable
      def buyable?
        false
      end
    end

    class Go
      include NotBuyable

      def enter_field(player, playing_field)
        player.raise_money 8000
      end

      def pass_field(player, playing_field)
        player.raise_money 4000
      end
    end

    class Street
      include Constructible

      attr_accessor :color, :name, :count_of_kind

      def initialize(color, name, price, charge, charge_house)
        @color = color
        @name = name
        @price = price

        # for constructible
        @charge = charge
        @charge_house = charge_house
        @houses = 0
      end

      def price
        @price
      end
    end

    class Station
      include Buyable

      def price
        4000
      end

      attr_accessor :name

      def initialize(name)
        @name = name
      end

      def charge
        case fields_of_same_kind.size
          when 1
            500
          when 2
            1000
          when 3
            2000
          when 4
            4000 
        end 
      end
    end

    class Plant
      include Buyable

      attr_accessor :name

      def initialize(name)
        @name = name
      end

      def price 
        3000
      end

      def enter_field(player, playing_field)
        if player_has_to_pay?
          charge = if fields_of_same_kind.size == 1
                     80 * playing_field.dices_value
                   else
                     200 * playing_field.dices_value
                   end

          player.decrease_money charge
        end
      end
    end

    class Community
      include NotBuyable

      def enter_field(player, playing_field)
        card = CommunityCards.next_card
        card.use(CommunityCards, player, playing_field.other_players(player), playing_field)
      end
    end

    class Event
      include NotBuyable

      def enter_field(player, playing_field)
        card = EventCards.next_card
        card.use(EventCards, player, playing_field.other_players(player), playing_field)
      end
    end

    class Tax
      include NotBuyable
      attr_accessor :name, :price

      def initialize(name, price)
        @name = name
        @price = price
      end

      def enter_field(player, playing_field)
        player.decrease_money @price
      end
    end

    class Jail
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
        @field_jail.delete prisoner
      end
    
      def is_prisoner?(prisoner)
        @prisoners.include? prisoner
      end

      def enter_field(player, playing_field)
        # visiting the prisoners
      end
    end

    class Parking
      include NotBuyable

      def enter_field(player, playing_field)
        # do nothing
      end
    end

    class GoJail
      include NotBuyable

      def enter_field(player, playing_field)
        playing_field.go_to_jail player
      end
    end
  end
end