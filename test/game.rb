include Monopoly

log = HtmlLog.new("log.html")

player1 = StupidPlayer.new("John")
player2 = StupidPlayer.new("Marie")
field = PlayingField.new([player1, player2], Parker1996)
field.add_observer(log)
field.play_game(10)

log.save
system "open log.html"
