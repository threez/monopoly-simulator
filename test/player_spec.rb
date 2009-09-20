require File.dirname(__FILE__) + '/spec_helper'

shared_examples_for "all players" do
  it "should have starting conditions according to the rules" do
    name = "John Doe"
    player = Monopoly::StupidPlayer.new(name)
    player.name.should == name
    player.money.should == 30000
    player.value.should == 30000 # because no houses or streets ar buyed
    player.streets.should == []
    player.can_act?.should == true
    
    # has no streets with houses
    player.can_build_house?.should == false
    player.find_buildable_streets.should  == []
    player.houses.should == 0
    player.hotels.should == 0
    
    # has no jail cards
    player.has_jail_card?.should == false
    
    # should have hooks methods defined
    player.should.respond_to? :do_actions
    player.should.respond_to? :do_auction
    player.should.respond_to? :do_jail
    player.should.respond_to? :do_pay_sum
  end
end

describe Monopoly::StupidPlayer do
  it_should_behave_like "all players"
end

describe Monopoly::HumanPlayer do
  it_should_behave_like "all players"
end
