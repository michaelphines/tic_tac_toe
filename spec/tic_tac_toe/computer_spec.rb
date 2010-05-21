require File.join(File.dirname(__FILE__), "/../spec_helper")

describe TicTacToe::Computer do
  
  describe "#get_move" do
    it "should prioritize moves correctly" do
      board = mock()
      computer = TicTacToe::Computer.new(board, :x)
      computer.should_receive(:win).ordered
      computer.should_receive(:block).ordered
      computer.should_receive(:fork).ordered
      computer.should_receive(:center).ordered
      computer.should_receive(:block_fork).ordered
      computer.should_receive(:corner).ordered
      computer.should_receive(:side).ordered
      computer.get_move
    end
    
    it "should use the first non-nil result" do
      board = mock()
      computer = TicTacToe::Computer.new(board, :x)
      computer.stub(:win).and_return(nil)
      computer.stub(:block).and_return(nil)
      computer.stub(:fork).and_return([0,1])
      computer.stub(:center).and_return(nil)
      computer.stub(:block_fork).and_return(nil)
      computer.stub(:corner).and_return([1,2])
      computer.stub(:side).and_return([2,1])
      computer.get_move.should == [0,1]
    end
  end
  
  describe "#win" do
    it "should find a win in one move" do
      board = mock(:lines => [ [ [[0,0], :o], [[0,1], :o], [[0,2], nil] ] ])
      computer = TicTacToe::Computer.new(board, :o)
      computer.win.should == [0,2]      
    end

    it "should return nil if no immediate win" do
      board = mock(:lines => [ [ [[0,0], :o], [[0,1], :x], [[0,2], nil] ] ])
      computer = TicTacToe::Computer.new(board, :x)
      computer.win.should be_nil
    end
  end
  
  describe "#block" do
    it "should find a block if the position requires" do
      board = mock(:lines => [ [ [[0,0], :o], [[0,1], :o], [[0,2], nil] ] ])
      computer = TicTacToe::Computer.new(board, :x)
      computer.block.should == [0,2]
    end

    it "should return nil if no block is needed" do
      board = mock(:lines => [ [ [[0,0], :o], [[0,1], :x], [[0,2], nil] ] ])
      computer = TicTacToe::Computer.new(board, :x)
      computer.block.should be_nil     
    end
  end
  
  describe "#fork" do
    it "should find a fork to play" do
      board = mock(:lines => [ [ [[0,0], nil], [[0,1], :o], [[0,2], nil] ],
                               [ [[0,0], nil], [[1,0], :o], [[2,0], nil] ]])
      computer = TicTacToe::Computer.new(board, :o)
      computer.fork.should == [0,0]      
    end

    it "should return nil if no fork" do
      board = mock(:lines => [ [ [[0,0], nil], [[0,1], :o], [[0,2], nil] ],
                               [ [[0,0], nil], [[1,0], :o], [[2,0], :x] ]])
      computer = TicTacToe::Computer.new(board, :o)
      computer.fork.should be_nil
    end
  end
  
  describe "#center" do
    it "should capture the center if it can" do
      board = mock()
      board.stub(:square).with(1,1).and_return(nil)
      computer = TicTacToe::Computer.new(board, :x)
      computer.center.should == [1,1]
    end

    it "should return nil if center is taken" do
      board = mock()
      board.stub(:square).with(1,1).and_return(:x)
      computer = TicTacToe::Computer.new(board, :x)
      computer.center.should be_nil
    end
  end  
  
  describe "#block_fork" do
    it "should block a one-way fork" do
      board = mock(:lines => [ [ [[0,0], nil], [[0,1], :o], [[0,2], nil] ],
                               [ [[0,0], nil], [[1,0], :o], [[2,0], nil] ]])
      computer = TicTacToe::Computer.new(board, :x)
      computer.block_fork.should == [0,0]      
    end

    it "should block a multi-fork when in the center" do
      board = mock(:lines => [ [ [[0,0], :x], [[0,1], nil], [[0,2], nil] ],
                               [ [[0,0], :x], [[1,0], nil], [[2,0], nil] ],
                               [ [[2,0], nil], [[2,1], nil], [[2,2], :x] ],
                               [ [[0,2], nil], [[1,2], nil], [[2,2], :x] ]])
      board.stub(:square).with(1,1).and_return(:o)
      computer = TicTacToe::Computer.new(board, :o)
      computer.should_receive :side
      computer.block_fork
    end

    it "should block a multi-fork when not in the center" do
      board = mock(:lines => [ [ [[2,0], nil], [[2,1], nil], [[2,2], :x]  ],
                               [ [[0,1], nil], [[1,1], :x],  [[2,1], nil] ],
                               [ [[1,0], nil], [[1,1], :x],  [[1,2], nil] ],
                               [ [[0,2], nil], [[1,2], nil], [[2,2], :x]  ]])
      board.stub(:square).with(1,1).and_return(:x)
      computer = TicTacToe::Computer.new(board, :o)
      computer.should_receive :corner
      computer.block_fork
    end

    it "should return nil if no block necessary" do
      board = mock(:lines => [ [ [[0,0], nil], [[0,1], :o], [[0,2], nil] ],
                               [ [[0,0], nil], [[1,0], :o], [[2,0], :x] ]])
      computer = TicTacToe::Computer.new(board, :x)
      computer.fork.should be_nil
    end
  end
  
  describe "#corner" do
    it "should choose a corner if one is available" do
      board = mock()
      board.stub(:square).with(0,0).and_return(nil)
      board.stub(:square).with(0,2).and_return(:x)
      board.stub(:square).with(2,0).and_return(:o)
      board.stub(:square).with(2,2).and_return(:o)
      computer = TicTacToe::Computer.new(board, :x)
      computer.corner.should == [0,0]
    end

    it "should choose the corner opposite the opponent" do
      board = mock()
      board.stub(:square).with(0,0).and_return(nil)
      board.stub(:square).with(0,2).and_return(nil)
      board.stub(:square).with(2,0).and_return(:o)
      board.stub(:square).with(2,2).and_return(nil)
      computer = TicTacToe::Computer.new(board, :x)
      computer.corner.should == [0,2]
    end

    it "should return nil if no corners are available" do
      board = mock()
      board.stub(:square).with(0,0).and_return(:x)
      board.stub(:square).with(0,2).and_return(:o)
      board.stub(:square).with(2,0).and_return(:o)
      board.stub(:square).with(2,2).and_return(:o)
      computer = TicTacToe::Computer.new(board, :x)
      computer.corner.should be_nil
    end
  end
  
  describe "#side" do
    it "should capture the center if it can" do
      board = mock()
      board.stub(:square).with(0,1).and_return(:x)
      board.stub(:square).with(1,0).and_return(nil)
      board.stub(:square).with(1,2).and_return(:o)
      board.stub(:square).with(2,1).and_return(:o)
      computer = TicTacToe::Computer.new(board, :x)
      computer.side.should == [1,0]
    end

    it "should return nil if sides are all gone" do
      board = mock()
      board.stub(:square).with(0,1).and_return(:x)
      board.stub(:square).with(1,0).and_return(:o)
      board.stub(:square).with(1,2).and_return(:o)
      board.stub(:square).with(2,1).and_return(:o)
      computer = TicTacToe::Computer.new(board, :x)
      computer.side.should be_nil
    end
  end  
end
