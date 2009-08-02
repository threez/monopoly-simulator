module Monopoly
  module Fields
    module Buyable
      def mortgage!
        @owner.raise_money(price / 2)
        @mortgage = true
        @interest = 1.10  # 10% interest
      end
      
      def price
        @price
      end

      def amortize_the_mortgage()
        @owner.transfer_money_to(:bank, price / 2 * @interest)
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
        !@owner.nil? and @owner.can_act? and player != @owner
      end

      def owner=(player)
        # only set the owner if there is no other owner
        @owner = player if @owner.nil?
      end

      def owner
        @owner
      end

      def buy(player, auction_price = nil)
        price_of_field = auction_price || price 

        if buyable?
          if player.money >= price_of_field
            player.transfer_money_to(:bank, price_of_field)
            player.add_street(self)
            self.owner = player
            playing_field.notify_observers :buyed_street, :player => player,
              :price_of_field => price, :paid => price_of_field, :field => self
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

      def enter_field(player)
        if player_has_to_pay?(player)
          player.transfer_money_to(@owner, charge)
          @gained_charges += charge if @gained_charges
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
        other_fields.inject(0) { |sum, field| sum + field.houses }
      end

      # FIXME: error in rule execution
      def more_houses_possible?
        #puts "other_fields_houses: %d, %d, %s" % [other_fields_houses, houses * (@count_of_kind.size - 1), (other_fields_houses >= houses * (@count_of_kind.size - 1)).to_s]
        #@houses < HOTEL and other_fields_houses >= houses * (@count_of_kind.size - 1)
        @houses < HOTEL
      end

      def house_buyable?
        all_streets_of_a_kind_without_mortgage? and more_houses_possible?
      end
      
      def sellable?
        !house_sellable?
      end

      def house_sellable?
        @houses > 0 and other_fields_houses <= houses * (@count_of_kind.size - 1)
      end

      def buy_house
        if house_buyable?
          @owner.transfer_money_to(:bank, @charge_house)
          @houses += 1
          playing_field.notify_observers :buyed_house, :player => @owner, 
            :street => self, :charge => @charge_house
          true
        else
          false
        end
      end

      def sell_house
        if house_sellable?
          @owner.raise_money @charge_house
          @houses -= 1
          true
        else
          false
        end
      end
      
      def value
        super + houses * @charge_house
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
      attr_accessor :playing_field
      
      def initialize(name)
        @name = name
      end
      
      def name
        if @name
          @name
        else
          self.class
        end
      end
    end
  end
end
