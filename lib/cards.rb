module Monopoly
  
  class Card
    def initialize(description, &block)
      @description = description
      @block = block
    end
    
    def use(card_stack, player, other_players, playing_field)
      if @block # if card implemented
        @block.call(self, card_stack, player, other_players, playing_field)
      end
    end
  end
  
  class CardStack
    def initialize(cards)
      @cards = cards
      @iteration = 0
      shuffle_cards!
    end
    
    def next_card
      card = @card[@iteration]
      
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
  
  CommunityCards = CardStack.new([
    Card.new("Es ist dein Geburtstag. Ziehe von jedem Spieler DM 1000,- ein.") do |card, card_stack, player, other_players, playing_field|  
      other_players.transfer_money_to(player, 1000)
    end,
    Card.new("Gehe in das Gefängnis! Begib Dich direkt dorthin. Gehe nicht über LOS. Ziehe nicht DM 4000,- ein.") do |card, card_stack, player, other_players, playing_field|
      playing_field.go_to_jail(player)
    end,
    Card.new("Zahle Schulgeld: DM 3000,-") do |card, card_stack, player, other_players, playing_field|
      player.decrease_money(3000)
    end,
    Card.new("Die Jahresrente wird fällig. Ziehe DM 2000,- ein.") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(2000)
    end,
    Card.new("Du hast den 2. Preis in einer Schönheitskonkurrenz gewonnen. Ziehe DM 200,- ein.") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(200)
    end,
    Card.new("Bank-Irrtum zu Deinen Gunsten. Ziehe DM 4000,- ein.") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(4000)
    end,
    Card.new("Du wirst zu Straßenausbesserungsarbeiten herangezogen. Zahle für Deine Häuser und Hotels DM 800,- je Haus DM 2300,- je Hotel an die Bank.") do |card, card_stack, player, other_players, playing_field|
      player.decrease_money(player.houses * 800 + player.hotels * 2300)
    end,
    Card.new("Arzt-Kosten. Zahle: DM 1000.-") do |card, card_stack, player, other_players, playing_field|
      player.decrease_money(1000)
    end,
    Card.new("Du kommst aus dem Gefängnis frei. Diese Karte musst Du behalten, bis Du sie benötigst oder verkaufst.") do |card, card_stack, player, other_players, playing_field|
      player.add_jail_card(card, card_stack)
    end,
    Card.new("Aus Lagerverkäufen erhälst Du: DM 500,-") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(500)
    end,
    Card.new("Du erbst: DM 2000,-") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(2000)
    end,
    Card.new("Einkommensteuer-Rückzahlung. Ziehe DM 400,- ein.") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(400)
    end,
    Card.new("Du erhälst auf Vorzugs-Aktien 7% Dividende: DM 900,-") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(900)
    end,
    Card.new("Rücke vor bis auf LOS.") do |card, card_stack, player, other_players, playing_field|
      # goto field
    end,
    Card.new("Du hast in einem Kreuzworträtsel-Wettbewerb gewonnen. Ziehe DM 2000,- ein.") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(2000)
    end,
    Card.new("Zahle an das Krankenhaus: DM 2000,-") do |card, card_stack, player, other_players, playing_field|
      player.decrease_money(2000)
    end
  ])
  
  EventCards = CardStack.new([
    Card.new("Rücke vor bis zur Schloßallee.") do |card, card_stack, player, other_players, playing_field|
      # goto field
    end,
    Card.new("Strafe für zu schnelles Fahren: DM 300,-") do |card, card_stack, player, other_players, playing_field|
      player.decrease_money(300)
    end,
    Card.new("Rücke vor bis zum nächsten Bahnhof. Der Eigentümer erhält das Doppelte der normalen Miete. Hat noch kein Spieler einen Besitzanspruch auf diesen Bahnhof, so kannst Du ihn von der Bank kaufen.") do |card, card_stack, player, other_players, playing_field|
      # goto field
    end,
    Card.new("Gehe zurück zu Badstraße") do |card, card_stack, player, other_players, playing_field|
      # goto field
    end,
    Card.new("Miete und Anleihezinsen werden fällig. Die Bank zahlt Dir DM 3000,-") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(3000)
    end,
    Card.new("Mache einen Ausflug zum Südbahnhof. Wenn du über LOS kommst, ziehe DM 4000,- ein.") do |card, card_stack, player, other_players, playing_field|
      # goto field
    end,
    Card.new("Lasse alle Deine Häuser renovieren! Zahle an die Bank: Für jedes Haus DM 500,- Für jedes Hotel DM 2000,-") do |card, card_stack, player, other_players, playing_field|
      player.decrease_money(player.houses * 500 + player.hotels * 2000)
    end,
    Card.new("Gehe in das Gefängnis! Begib dich direkt dorthin. Gehe nicht über LOS. Ziehe nicht DM 4000,- ein.") do |card, card_stack, player, other_players, playing_field|
      player.add_jail_card(card, card_stack)
    end,
    Card.new("Rücke vor bis zum Opernplatz. Wenn du über LOS kommst, ziehe DM 4000,- ein.") do |card, card_stack, player, other_players, playing_field|
      # goto field
    end,
    Card.new("Rücke vor bis zur Seestraße. Wenn du über LOS kommst, ziehe DM 4000,- ein.") do |card, card_stack, player, other_players, playing_field|
      # goto field
    end,
    Card.new("Gehe 3 Felder zurück.") do |card, card_stack, player, other_players, playing_field|
      # goto field
    end,
    Card.new("Die Bank Zahlt Dir eine Dividende: DM 1000,-") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(1000)
    end,
    Card.new("Du bist zum Vorstand gewählt worden. Zahle jedem Spieler DM 1000,-") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(1000)
    end,
    Card.new("Rücke vor bis auf LOS.") do |card, card_stack, player, other_players, playing_field|
      # goto field
    end,
    Card.new("Zahle eine Strafe von DM 200,- oder nimm eine Gemeinschaftskarte.") do |card, card_stack, player, other_players, playing_field|
      player.decrease_money(300)
      # FIXME choise
    end,
    Card.new("Du kommst aus dem Gefängnis frei. Diese Karte musst Du behalten, bis Du sie benötigst oder verkaufst.") do |card, card_stack, player, other_players, playing_field|
      player.add_jail_card(card, card_stack)
    end
  ])
end