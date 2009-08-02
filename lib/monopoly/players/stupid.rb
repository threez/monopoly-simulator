module Monopoly
  class StupidPlayer < Player
    def do_actions(other_players, type = :normal)
      if type == :normal and current_field.buyable?
        # simple buy field
        current_field.buy(self) if current_field.price < money
      
        # simple payback mortgage if any
        @streets.each do |street|
          if street.mortgage? and street.price / 2 < money / 2
            street.amortize_the_mortgage
          end
        end
      
        # simple build streets
        if can_build_house?
          find_buildable_streets.size.times do 
            find_buildable_streets.each do |street|
              if street.charge_house < money / 3
                street.buy_house
              end
            end
          end
        end  
      end
    end
    
    def do_auction(field, highest_offer)
      # simple bid
      rand(500)
    end
    
    def do_jail(other_players)
      # dice as default
    end
    
    def do_pay_sum(sum_left)
      # simple pay debt
      @streets.first.mortgage!
    end
  end
end
