module Monopoly
  module Fields
    class Go < Field
      include NotBuyable

      def enter_field(player)
        playing_field.notify_observers :entered_go_field, :player => player
        player.raise_money 8000
      end

      def pass_field(player)
        playing_field.notify_observers :passed_go_field, :player => player
        player.raise_money 4000
      end
    end
  end
end
