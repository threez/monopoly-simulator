module Monopoly
  module Fields
    class Station < Field
      include Buyable
      
      attr_reader :gained_charges
      CHARGE = { 1 => 500, 2 => 1000, 3 => 2000, 4 => 4000 }

      def initialize(name)
        super(name)
        @gained_charges = 0
        @price = 4000
      end

      def charge
        CHARGE[fields_of_same_kind.size]
      end
    end
  end
end
