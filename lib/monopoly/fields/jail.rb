module Monopoly
  module Fields
    class Jail < Field
      include NotBuyable

      attr_accessor :prisoners

      def initialize(name)
        super(name)
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

      def enter_field(player)
        # visiting the prisoners
      end
    end
  end
end
