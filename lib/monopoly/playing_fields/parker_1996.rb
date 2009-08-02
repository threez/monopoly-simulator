module Monopoly
  
  Parker1996 = [
    # site 1
    Fields::Go.new("LOS"),
    Fields::Street.new(:pink, "Badstra\xC3\x9fe", 1200, { 0 => 40, 1 => 200, 2 => 600, 3 => 1800, 4 => 3200, 5 => 5000 }, 1000),
    Fields::CardField.new(CommunityCards),
    Fields::Street.new(:pink, "Turmstra\xC3\x9fe", 1200, { 0 => 80, 1 => 400, 2 => 1200, 3 => 3600, 4 => 6400, 5 => 9000 }, 1000),
    Fields::Tax.new("Einkommensteuer", 4000),
    Fields::Station.new("S\xC3\xBCdbahnhof"),
    Fields::Street.new(:cyan, "Chausseestra\xC3\x9fe", 2000, { 0 => 120, 1 => 600, 2 => 1800, 3 => 5400, 4 => 8000, 5 => 11000 }, 1000),
    Fields::CardField.new(EventCards),
    Fields::Street.new(:cyan, "Elisenstra\xC3\x9fe", 2000, { 0 => 120, 1 => 600, 2 => 1800, 3 => 5400, 4 => 8000, 5 => 11000 }, 1000),
    Fields::Street.new(:cyan, "Poststra\xC3\x9fe", 2400, { 0 => 160, 1 => 800, 2 => 2000, 3 => 6000, 4 => 9000, 5 => 12000 }, 1000),

    # site 2
    Fields::Jail.new("Gef\xC3\xA4ngnis"),
    Fields::Street.new(:purple, "Seestra\xC3\x9fe", 2800, { 0 => 200, 1 => 1000, 2 => 3000, 3 => 9000, 4 => 12500, 5 => 15000 }, 2000),
    Fields::Plant.new("Elektrizit\xC3\xA4ts-Werk"),
    Fields::Street.new(:purple, "Hafenstra\xC3\x9fe", 2800, { 0 => 200, 1 => 1000, 2 => 3000, 3 => 9000, 4 => 12500, 5 => 15000 }, 2000),
    Fields::Street.new(:purple, "Neue Stra\xC3\x9fe", 3200, { 0 => 240, 1 => 1200, 2 => 3600, 3 => 10000, 4 => 14000, 5 => 18000 }, 2000),
    Fields::Station.new("Westbahnhof"),
    Fields::Street.new(:orange, "M\xC3\xBCnchener Stra\xC3\x9fe", 3600, { 0 => 280, 1 => 1400, 2 => 4000, 3 => 11000, 4 => 15000, 5 => 19000 }, 2000),
    Fields::CardField.new(CommunityCards),
    Fields::Street.new(:orange, "Wiener Stra\xC3\x9fe", 3600, { 0 => 280, 1 => 1400, 2 => 4000, 3 => 11000, 4 => 15000, 5 => 19000 }, 2000),
    Fields::Street.new(:orange, "Berliner Stra\xC3\x9fe", 4000, { 0 => 320, 1 => 1600, 2 => 4400, 3 => 12000, 4 => 16000, 5 => 20000 }, 2000),

    # site 3
    Fields::Parking.new("Frei Parken"),
    Fields::Street.new(:red, "Theaterstra\xC3\x9fe", 4400, { 0 => 360, 1 => 1800, 2 => 5000, 3 => 14000, 4 => 17500, 5 => 21000 }, 3000),
    Fields::CardField.new(EventCards),
    Fields::Street.new(:red, "Museumstra\xC3\x9fe", 4400, { 0 => 360, 1 => 1800, 2 => 5000, 3 => 14000, 4 => 17500, 5 => 21000 }, 3000),
    Fields::Street.new(:red, "Opernplatz", 4800, { 0 => 400, 1 => 2000, 2 => 6000, 3 => 15000, 4 => 18500, 5 => 23000 }, 3000),
    Fields::Station.new("Nordbahnhof"),
    Fields::Street.new(:yellow, "Lessingstra\xC3\x9fe", 5200, { 0 => 440, 1 => 2200, 2 => 6600, 3 => 16000, 4 => 19500, 5 => 23000 }, 3000),
    Fields::Street.new(:yellow, "Schillerstra\xC3\x9fe", 5200, { 0 => 440, 1 => 2200, 2 => 6600, 3 => 16000, 4 => 19500, 5 => 23000 }, 3000),
    Fields::Plant.new("Wasser-Werk"),
    Fields::Street.new(:yellow, "Goethestra\xC3\x9fe", 5600, { 0 => 480, 1 => 2400, 2 => 7200, 3 => 17000, 4 => 20500, 5 => 24000 }, 3000),

    # site 4
    Fields::GoJail.new("Gehe ins Gef\xC3\xA4ngnis"),
    Fields::Street.new(:green, "Rathausplatz", 6000, { 0 => 520, 1 => 2600, 2 => 7800, 3 => 18000, 4 => 22000, 5 => 25500 }, 4000),
    Fields::Street.new(:green, "Hauptstra\xC3\x9fe", 6000, { 0 => 520, 1 => 2600, 2 => 7800, 3 => 18000, 4 => 22000, 5 => 25500 }, 4000),
    Fields::CardField.new(CommunityCards),
    Fields::Street.new(:green, "Bahnhofstra\xC3\x9fe", 6400, { 0 => 560, 1 => 3000, 2 => 9000, 3 => 20000, 4 => 24000, 5 => 28000 }, 4000),
    Fields::Station.new("Hauptbahnhof"),
    Fields::CardField.new(EventCards),
    Fields::Street.new(:blue, "Parkstra\xC3\x9fe", 7000, { 0 => 700, 1 => 3500, 2 => 10000, 3 => 22000, 4 => 26000, 5 => 30000 }, 4000),
    Fields::Tax.new("Zusatzsteuer", 2000),
    Fields::Street.new(:blue, "Schlo\xC3\x9fallee", 8000, { 0 => 1000, 1 => 4000, 2 => 12000, 3 => 28000, 4 => 34000, 5 => 40000 }, 4000)
  ]
end