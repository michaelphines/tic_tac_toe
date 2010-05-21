require File.join(File.dirname(__FILE__), "/../spec_helper")

describe TicTacToe::GameController do
  before(:each) do
    # These first two lines are important so that we get test output
    Curses.stub(:cbreak)
    Curses.stub(:noecho)
    @computer = mock(:computer).as_null_object
    @display = mock(:display).as_null_object
    @cursor = mock(:cursor).as_null_object
    @window = mock(:window).as_null_object
    @board = mock(:board).as_null_object
    @game = mock(:game).as_null_object
    TicTacToe::Cursor.stub(:new).and_return(@cursor)
    TicTacToe::Display.stub(:new).and_return(@display)
    TicTacToe::Board.stub(:new).and_return(@board)
    TicTacToe::Game.stub(:new).and_return(@game)
    TicTacToe::Computer.stub(:new).and_return(@computer)
    @controller = TicTacToe::GameController.new(@window)
  end
  describe "#new" do
    it "should link all the models and views" do
      TicTacToe::Cursor.should_receive(:new).and_return(@cursor)
      TicTacToe::Board.should_receive(:new).and_return(@board)
      TicTacToe::Game.should_receive(:new).with(@board).and_return(@game)
      TicTacToe::Computer.should_receive(:new).with(@board, anything())
      TicTacToe::Display.should_receive(:new).with(anything(), @board, @cursor)
      controller = TicTacToe::GameController.new(@window)
    end
  end
  
  describe "#start_new_game" do
    it "should take an argument for the piece for the computer to override the default :o" do
      TicTacToe::Computer.should_receive(:new).with(anything(), :x)
      @controller.start_new_game(:x)
    end
  end
  
  describe "#listen" do
    before(:each) do
      @controller.stub(:parse)
      @controller.stub(:confirm_quit)
    end
    it "should keep getting new keys until it receives ?q" do
      @window.should_receive(:getch).exactly(4).times.and_return(?\t, ?\t, ?\t, ?Q)
      @controller.listen
    end
    
    it "should do something with the key" do
      @window.stub(:getch).and_return(?\t, ?\Q)
      @controller.should_receive(:parse).with(?\t)
      @controller.listen
    end
    
    it "should confirm that the user wants to quit after ?Q" do
      @window.stub(:getch).and_return(?\Q)
      @controller.should_receive(:confirm_quit)
      @controller.listen
    end
  end
  
  describe "#parse" do
    it "should respond to arrow keys" do
      @cursor.should_receive(:move).with(-1,0).ordered
      @cursor.should_receive(:move).with(1,0).ordered
      @cursor.should_receive(:move).with(0,-1).ordered
      @cursor.should_receive(:move).with(0,1).ordered
      @controller.parse(Curses::Key::UP)
      @controller.parse(Curses::Key::DOWN)
      @controller.parse(Curses::Key::LEFT)
      @controller.parse(Curses::Key::RIGHT)
    end
  
    it "should respond to [tab]" do
      @controller.should_receive(:move_next)
      @controller.parse(?\t)
    end
    
    it "should update the display" do
      @display.should_receive(:update)
      @controller.parse(?\t)
    end
    
    it "should make a move when [space] is pressed" do
      @controller.should_receive(:make_move)
      @controller.parse(?\s)      
    end
    
    it "should make a move when [enter] is pressed" do
      @controller.should_receive(:make_move)
      @controller.parse(?\n)      
    end
  end

  describe "#make_move" do
    it "should not let the computer play if the move was invalid" do
      @computer.should_not_receive(:get_move)
      @game.should_receive(:make_move).and_return(false)
      @controller.make_move
    end
    it "should check for an ending after each move" do
      @game.stub(:make_move).and_return(true)
      @controller.should_receive(:check_ending).twice
      @controller.make_move      
    end
    it "should let the computer start if the player won or played last, and the computer otherwise" do
      @controller.stub(:check_ending).with(:x).ordered
      @controller.stub(:check_ending).with(:o).ordered
      @controller.make_move      
    end
  end
  
  describe "#check_ending" do
    it "should start a new game when ?Y" do
      @window.stub(:getch).and_return(?Y)
      @controller.should_receive(:start_new_game)
      @controller.check_ending(:x)      
    end
    it "should exit when ?N" do
      @window.stub(:getch).and_return(?N)
      Kernel.should_receive(:exit)
      @controller.check_ending(:x)      
    end
    it "should return immediately if the game is not over" do
      @game.stub(:result).and_return(nil)
      @display.should_not_receive(:print_result)
      @controller.check_ending(:x)
    end
  end
  
  describe "#print_result" do
    it "should print a draw" do
      @game.stub(:result).and_return(:draw)
      @display.should_receive(:status).with("The game is a draw.  Would you like to play another game? (y/n)")
      @controller.print_result
    end
    
    it "should print a win for x" do
      @game.stub(:result).and_return(:x)
      @display.should_receive(:status).with("X wins the game!  Would you like to play another game? (y/n)")
      @controller.print_result
    end
    
    it "should print a win for y" do
      @game.stub(:result).and_return(:o)
      @display.should_receive(:status).with("O wins the game!  Would you like to play another game? (y/n)")
      @controller.print_result
    end
  end
  
  describe "#confirm_quit" do
    it "should go back to listening when ?N" do
      @window.stub(:getch).and_return(?N)
      @controller.should_receive(:listen)
      @controller.confirm_quit
    end
    it "should exit when ?Y" do
      @window.stub(:getch).and_return(?Y)
      Kernel.should_receive(:exit)
      @controller.confirm_quit
    end    
  end
  
end