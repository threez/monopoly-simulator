module Monopoly
  module Fields
    class Parking < Field
      include NotBuyable
    end
  end
end
