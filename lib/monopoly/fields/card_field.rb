module Monopoly
  module Fields
    class CardField < Field
      include NotBuyable
      
      def initialize(card_stack)
        super(card_stack.name)
        @card_stack = card_stack
      end
      
      def enter_field(player)
        card = CommunityCards.next_card
        card.use(@card_stack, player, playing_field.other_players(player), playing_field)
      end
    end
  end
end
