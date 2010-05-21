require File.join(File.dirname(__FILE__), "/../spec_helper")

describe TicTacToe::Game do
  before(:each) do
    @board = mock()
    @game = TicTacToe::Game.new(@board)
  end

  describe "#make_move" do
    it "should not change the move if Board#make_move fails" do
      @board.stub(:make_move).and_return(false)
      @game.should_not_receive(:next_turn)
      @game.make_move(0,0)
    end
    
    it "should change the move if make_move passes" do
      @board.stub(:make_move).and_return(true)
      @game.should_receive(:next_turn)
      @game.make_move(0,0)
    end
  end
  
  describe "#result" do
    it "should return :x for an X win" do
      @board.stub(:squares).and_return([:x, :x, :x])
      @board.stub(:lines).and_return([ [ [[0,0], :x], [[0,1],:x], [[0,2],:x] ] ])
      @game.result.should == :x
    end

    it "should return :o for an O win" do
      @board.stub(:squares).and_return([:o, :o, :o])
      @board.stub(:lines).and_return([ [ [[0,0], :o], [[0,1],:o], [[0,2],:o] ] ])
      @game.result.should == :o
    end

    it "should return :draw for a draw" do
      @board.stub(:squares).and_return([:o, :x, :x])
      @board.stub(:lines).and_return([ [ [[0,0], :o], [[0,1],:x], [[0,2],:x] ] ])
      @game.result.should == :draw
    end
    
    it "should return nil if the game isn't over yet" do
      @board.stub(:squares).and_return([:x, nil, :x])
      @board.stub(:lines).and_return([ [ [[0,0], :x], [[0,1],nil], [[0,2],:x] ] ])
      @game.result.should == nil
    end
    
  end
end
