module Monopoly
  module Fields
    class Street < Field
      include Constructible
      
      attr_reader :gained_charges
      attr_accessor :color, :count_of_kind, :charge_house

      def initialize(color, name, price, charge, charge_house)
        super(name)
        @color = color
        @price = price

        # for constructible
        @charge = charge
        @charge_house = charge_house
        @houses = 0
        @gained_charges = 0
      end
    end
  end
end
