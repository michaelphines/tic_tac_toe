require File.join(File.dirname(__FILE__), "/../spec_helper")

def board_stub(board, pieces)
  (0..2).each do |y|
    (0..2).each do |x|
      board.make_move(pieces[y][x],y,x)
    end
  end
end

describe TicTacToe::Board do
  before(:each) do
    @board = TicTacToe::Board.new
  end
  
  describe "#empty_squares" do
    it "should return the empty squares" do
      board_stub(@board, [[:x,  :x, :o],
                          [nil, :o, :o],
                          [:x,  :o, :x]])
      @board.empty_squares.should == [[1,0]]
    end
  end
  
  describe "#make_move" do
    it "should set the square to belong to the piece if empty" do
      board_stub(@board, [[:x,  :x, :o],
                          [nil, :o, :o],
                          [:x,  :o, :x]])
      @board.make_move(:x, 1,0)
      @board.square(1,0).should == :x
    end
    
    it "should return true if empty" do
      board_stub(@board, [[:x,  :x, :o],
                          [nil, :o, :o],
                          [:x,  :o, :x]])
      @board.make_move(:x, 1,0).should == true
    end
    
    it "should not set the square to belong to the piece if filled" do
      board_stub(@board, [[:x,  :x, :o],
                          [nil, :o, :o],
                          [:x,  :o, :x]])
      @board.make_move(:x, 1,1)
      @board.square(1,1).should == :o
    end
    
    it "should return false if filled" do
      board_stub(@board, [[:x,  :x, :o],
                          [nil, :o, :o],
                          [:x,  :o, :x]])
      @board.make_move(:x, 1,1).should == false
    end
  end

  describe "#lines" do
    it "should join rows columns and diagonals" do
      @board.should_receive(:rows).and_return([])
      @board.should_receive(:columns).and_return([])
      @board.should_receive(:diagonals).and_return([])
      @board.lines
    end
    
    it "should join rows columns and diagonals" do
      @board.stub(:rows).and_return([[[1,2],:x]])
      @board.stub(:columns).and_return([[[2,1],:x]])
      @board.stub(:diagonals).and_return([[[2,2],:o]])
      @board.lines.should == [[[1,2], :x],[[2,1], :x],[[2,2], :o]]
    end
  end
  
  describe "#rows" do
    it "should return the rows with locations" do
      board_stub(@board, [[:x,  :x, :o],
                          [nil, :o, :o],
                          [:x,  :o, :x]])
      @board.rows.should == [ [ [[0,0],:x],  [[0,1],:x], [[0,2],:o] ],
                              [ [[1,0],nil], [[1,1],:o], [[1,2],:o] ],
                              [ [[2,0],:x],  [[2,1],:o], [[2,2],:x] ] ]
    end
  end
  
  describe "#columns" do
    it "should return the columns with locations" do
      board_stub(@board, [[:x, nil, :x],
                          [:x, :o,  :o],
                          [:o, :o,  :x]])
      @board.columns.should == [ [ [[0,0],:x],  [[1,0],:x], [[2,0],:o] ],
                                 [ [[0,1],nil], [[1,1],:o], [[2,1],:o] ],
                                 [ [[0,2],:x],  [[1,2],:o], [[2,2],:x] ] ]
    end
  end
  
  describe "#diagonals" do
    it "should return the diagonals with locations" do
      board_stub(@board, [[:x, nil, :x],
                          [:x, :o,  :o],
                          [:o, :o,  :x]])
      @board.diagonals.should == [ [ [[0,0],:x], [[1,1],:o], [[2,2],:x] ],
                                   [ [[0,2],:x], [[1,1],:o], [[2,0],:o] ] ]
    end
  end
  
end