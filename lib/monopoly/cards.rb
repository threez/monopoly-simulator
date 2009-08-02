module Monopoly
  class Card
    attr_reader :description
    
    def initialize(description, &block)
      @description = description
      @block = block
    end
    
    def use(card_stack, player, other_players, playing_field)
      if @block # if card implemented
        playing_field.notify_observers :use_card, :player => player, :card => self,
          :card_stack => card_stack
        @block.call(self, card_stack, player, other_players, playing_field)
      end
    end
  end
  
  class CardStack
    attr_reader :name
    
    def initialize(name, cards)
      @name = name
      @cards = cards
      @iteration = 0
      shuffle_cards!
    end
    
    def next_card
      card = @cards[@iteration]
      
      # select next card
      if @iteration == @cards.size - 1
        @iteration = 0
      else
        @iteration += 1
      end  
    
      return card
    end
    
    def remove_card(card)
      @cards.delete(card)
    end
          
    def add_card(card)
      @cards << card
    end
    
    def shuffle_cards!
      (rand(10) + 5).times do
        (rand(@cards.size / 2) + 3).times { @cards << @cards.shift }
      end
    end
  end
end
