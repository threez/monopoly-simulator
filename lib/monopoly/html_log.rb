module HtmlHelper
  def html(title)
    write "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"
      \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">

    <html xmlns=\"http://www.w3.org/1999/xhtml\">
    	<head>
    		<title>#{title}</title>

    		<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\" />

    		<meta name=\"robots\" content=\"index,follow\" />
    		<meta name=\"author\" content=\"monopoly-simulator\" />
    		<meta http-equiv=\"Content-language\" content=\"en\" />

    		<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />
    	</head>
    	<body>

    	</body>
    </html>
    "
    yield
    write "</body></html>"
  end
  
  def graph(value)
    "<div style=\"display: block; height: 10px; width: #{value*2}px; " \
    "border: 1px solid #ccc; background-color: #efefef\"></div>"
  end
  
  def title(str)
    write "<h1>#{str}</h1>\n"
  end
  
  def subtitle(str)
    write "<h2>#{str}</h2>\n"
  end
  
  def tr
    write "<tr>\n"
    yield
    write "</tr>\n"
  end

  def td(str)
    write "<td>#{str}</td>\n"
  end

  def th(str)
    write "<th>#{str}</th>\n"
  end

  def td_r(str)
    write "<td align=\"right\">#{str}</td>\n"
  end

  def th_r(str)
    write "<th align=\"right\">#{str}</th>\n"
  end
  
  def table()
    write "<table>"
    yield
    write "</table>\n"
  end
end

module Monopoly
  class HtmlLog
    include HtmlHelper
    
    def initialize(path)
      @path = path
      @player_cards_history = []
      @field_statistics = {}
      @rolled_a_double = {}
    end
    
    def playing_field=(new_playing_field)
      @playing_field = new_playing_field
      @playing_field.playing_field.each do |field|
        @field_statistics[field] = 0
      end
    end
    
    def players=(new_players)
      @players = new_players
      @players.each do |player|
        @rolled_a_double[player] = 0
      end
    end
    
    def entering_field(env)
      @field_statistics[env[:field]] += 1
    end
    
    def use_card(env)
      @player_cards_history << [
        env[:player],
        env[:card_stack],
        env[:card]
      ]
    end
    
    def rolled_a_double(env)
      @rolled_a_double[env[:player]] += 1
    end
    
=begin
    def money_transfer(env)
      # ...
    end

    def buyed_street(env)
      #puts "buyed #{env.inspect}"
      # ...
    end

    def player_movement(env)
      # ...
    end

    def use_card(env)
      
    end

    #def entered_go_field(env)
      # ...
    #end

    def passing_field(env)
      # ...
    end

    def passed_go_field(env)
      p env
      # ...
    end

    def go_to_jail(env)
      # ...
    end

    def leave_jail(env)
      # ...
    end

    def buyed_house(env)
      # ...
    end
=end
    
    def save
      @file = File.open(@path, "w")
      
      html("Statistics of the MonopolySoimulator") do
        print_rolled_a_double
        print_cards_history
        print_field_statistics
      
        @players.each do |player|
          print_player player
        end
      end      
      
      @file.close
    end
    
  private  
  
    def write(str)
      @file.write(str + "\n")
    end
    
    def print_rolled_a_double
      title "Rolled a double"
      table do
        tr do
          th 'Player'
          th 'doubles'
        end
        @rolled_a_double.each_pair do |player, doubles|
          tr do
            td player.name
            td_r doubles
          end
        end
      end      
    end
    
    def print_cards_history
      title "Cards History"
      table do
        tr do
          th 'Player'
          th 'Stack'
          th 'Card'
        end
        @player_cards_history.each do |player, stack, card|
          tr do
            td player.name
            td stack.name
            td card.description
          end
        end
      end      
    end
    
    def print_field_statistics
      title "Field Statistics"
      sum = 0
      table do
        tr do
          th "Field"
          th "Times Entered"
          th "Graph"
        end
        @playing_field.playing_field.each do |field|
          value = @field_statistics[field]
          sum += value
          tr do
            td field.name
            td_r value
            td graph(value)
          end
        end
        tr do
          th 'Sum'
          th_r sum
        end
      end      
    end
    
    def print_player(player)
      title "Player %s" % player.name
      write "<label>Money:<label> %0.2f" % player.value

      plants = player.find_streets(Monopoly::Fields::Plant)
      unless plants.empty?
        subtitle "Plants"
        print_plants(sort_by_gained_charges(plants))
      end

      stations = player.find_streets(Monopoly::Fields::Station)
      unless stations.empty?
        subtitle "Stations"
        print_stations(sort_by_gained_charges(stations))
      end

      streets = player.find_streets(Monopoly::Fields::Street)
      unless streets.empty?
        subtitle "Streets"
        print_streets(sort_by_gained_charges(streets))
      end
    end
  
    def print_plants(plants)
      table do
        tr do
          th 'Name'
          th 'Price'
          th 'Income'
        end
        price, income = 0, 0
        plants.each do |plant|
          tr do
            td plant.name
            td_r "%.2f" % plant.value
            td_r "%.2f" % plant.gained_charges
          end
          price += plant.value
          income += plant.gained_charges
        end
        tr do
          th 'Sum'
          th_r "%.2f" % price
          th_r "%.2f" % income
        end
      end
    end

    def print_stations(stations)
      print_plants(stations)
    end

    def print_streets(streets)
      table do
        tr do
          th 'Name'
          th 'Price'
          th 'Income'
          th 'Houses'
          th 'Buildable'
        end
        price, income, houses = 0, 0, 0
        streets.each do |street|
          tr do
            td street.name
            td_r "%.2f" % street.value
            td_r "%.2f" % street.gained_charges
            td_r street.houses
            td (street.house_buyable? or street.houses > 0) ? "yes" : "no"
          end
          price += street.value
          income += street.gained_charges
          houses += street.houses
        end
        tr do
          th 'Sum'
          th_r "%.2f" % price
          th_r "%.2f" % income
          th_r houses
        end
      end
    end

    def sort_by_gained_charges(list)
      list.sort { |x, y| y.gained_charges <=> x.gained_charges }
    end
  end
end
