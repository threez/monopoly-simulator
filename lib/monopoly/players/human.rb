module Monopoly
  class HumanPlayer < Player
    def read(msg = nil)
      print("#{msg}: ") if msg
      STDIN.readline.chomp!
    end
    
    def header
      puts "*" * 60
      puts "** #{name} money: #{money} current_field: #{current_field.name}"
      streets.size.times do |index|
        street = streets[index]
        
        if street.class == Fields::Street
          puts " - [Nb. #{index}] #{street.name} (price:#{street.price}, houses:#{street.houses}, charge:#{street.charge})"
        else
          puts " - [Nb. #{index}] #{street.name} (price:#{street.price})"
        end
      end
      puts "*" * 60
    end
    
    def clear  
      system 'clear'  
    end
    
    def select_street_helper
      begin
        street_nb = read("Enter Number of street (or [c] to cancel)")
        
        if street_nb == 'c'
          return nil
        else
          street = @streets[street_nb.to_i]
        end
      end while street == nil
      
      return street
    end
    
    def do_actions(other_players, type = :normal)
      if type == :normal
        header
        puts " press [b] to buy street" if current_street.buyable?
        puts " press [s] to sell street" if streets.size > 0
        puts " press [h] to build house" if can_build_house?
        puts " press [d] to destroy house" if houses > 0 or hotels > 0
        puts " press any key to continue"
      
        case read
          when 'b'
            current_field.buy(self)
          when 's'
            street = select_street_helper
            street.sell
          when 'h'
            puts " press [b] to build house" if houses > 0 or hotels > 0
            puts " press any key to cancel"
            begin
              street = select_street_helper
              if street.house_buyable?
                street.buy_house
              else
                logger.error "can't buy a house"
              end
              cancel = false if read == "b"
            end while !cancel and street.house_buyable?
          when 'd'
            puts " press [s] to sell house" if houses > 0 or hotels > 0
            puts " press any key to cancel"
            begin
              street = select_steet_helper
              if street.house_sellable? 
                street.sell_house
              else
                logger.error "can't sell house"
              end  
              cancel = false if read == "b"
            end while !cancel and street.house_sellable?
        end
        clear
      end
    end
    
    def do_auction(field, highest_offer)
      header
      read("enter your bid").to_i
    end
    
    def do_jail(other_players)
      header
      puts " How to leave jail?"
      puts " press [p] to pay 1000"
      puts " press [c] to use a card" if self.has_jail_card?
      puts " press any key to dice"
      
      return case read
        when 'p'
          :pay
        when 'c'
          :use_card
        else
          :dice
      end
    end
    
    def do_pay_sum(sum_left)
      @streets.first.mortgage # default
    end
    
    alias current_street current_field
  end
end