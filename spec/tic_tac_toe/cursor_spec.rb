require File.join(File.dirname(__FILE__), "/../spec_helper")

describe TicTacToe::Cursor do
  describe "#<=>" do
    before(:each) do
      @cursor = TicTacToe::Cursor.new
      @cursor.set(1,1)
    end
    
    it "should be < a row above" do
      @cursor.should be < [2,0]
    end

    it "should be > a row below" do
      @cursor.should be > [0,2]
    end
    
    it "should be < one step to the right on the same row" do
      @cursor.should be < [1,2]
    end
    
    it "should be > for one step to the left on the same row" do
      @cursor.should be > [1,0]        
    end

    it "should be == to the same row and column" do
      @cursor.should be == [1,1]      
    end
  end
end