module Monopoly
  CommunityCards = CardStack.new("Gemeinschaftskarte", [
    Card.new("Es ist dein Geburtstag. Ziehe von jedem Spieler DM 1000,- ein.") do |card, card_stack, player, other_players, playing_field|  
      other_players.each { |tmpplayer| tmpplayer.transfer_money_to(player, 1000) }
    end,
    Card.new("Gehe in das Gef\xC3\xA4ngnis! Begib Dich direkt dorthin. Gehe nicht \xC3\xBCber LOS. Ziehe nicht DM 4000,- ein.") do |card, card_stack, player, other_players, playing_field|
      playing_field.go_to_jail(player)
    end,
    Card.new("Zahle Schulgeld: DM 3000,-") do |card, card_stack, player, other_players, playing_field|
      player.transfer_money_to(:bank, 3000)
    end,
    Card.new("Die Jahresrente wird f\xC3\xA4llig. Ziehe DM 2000,- ein.") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(2000)
    end,
    Card.new("Du hast den 2. Preis in einer Sch\xC3\xB6nheitskonkurrenz gewonnen. Ziehe DM 200,- ein.") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(200)
    end,
    Card.new("Bank-Irrtum zu Deinen Gunsten. Ziehe DM 4000,- ein.") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(4000)
    end,
    Card.new("Du wirst zu Stra\xC3\x9fenausbesserungsarbeiten herangezogen. Zahle f\xC3\xBCr Deine H\xC3\xA4user und Hotels DM 800,- je Haus DM 2300,- je Hotel an die Bank.") do |card, card_stack, player, other_players, playing_field|
      player.transfer_money_to(:bank, 800 * player.houses + 2300 * player.hotels)
    end,
    Card.new("Arzt-Kosten. Zahle: DM 1000.-") do |card, card_stack, player, other_players, playing_field|
      player.transfer_money_to(:bank, 1000)
    end,
    Card.new("Du kommst aus dem Gef\xC3\xA4ngnis frei. Diese Karte musst Du behalten, bis Du sie ben\xC3\xB6tigst oder verkaufst.") do |card, card_stack, player, other_players, playing_field|
      player.add_jail_card(card, card_stack)
    end,
    Card.new("Aus Lagerverk\xC3\xA4ufen erh\xC3\xA4lst Du: DM 500,-") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(500)
    end,
    Card.new("Du erbst: DM 2000,-") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(2000)
    end,
    Card.new("Einkommensteuer-R\xC3\xBCckzahlung. Ziehe DM 400,- ein.") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(400)
    end,
    Card.new("Du erh\xC3\xA4lst auf Vorzugs-Aktien 7% Dividende: DM 900,-") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(900)
    end,
    Card.new("R\xC3\xBCcke vor bis auf LOS.") do |card, card_stack, player, other_players, playing_field|
      playing_field.player_move_to(player, playing_field.field(1))
    end,
    Card.new("Du hast in einem Kreuzwortr\xC3\xA4tsel-Wettbewerb gewonnen. Ziehe DM 2000,- ein.") do |card, card_stack, player, other_players, playing_field|
      player.raise_money(2000)
    end,
    Card.new("Zahle an das Krankenhaus: DM 2000,-") do |card, card_stack, player, other_players, playing_field|
      player.transfer_money_to(:bank, 2000)
    end
  ])
end
