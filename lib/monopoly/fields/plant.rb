module Monopoly
  module Fields
    class Plant < Field
      include Buyable
      
      attr_reader :gained_charges

      def initialize(name)
        super(name)
        @gained_charges = 0
        @price = 3000
      end

      def enter_field(player)
        if player_has_to_pay?(player)
          multiplyer = (fields_of_same_kind.size == 1) ? 80 : 200
          charge = multiplyer * playing_field.dices_value
          player.transfer_money_to(@owner, charge)
          @gained_charges += charge
        end
      end
    end
  end
end
