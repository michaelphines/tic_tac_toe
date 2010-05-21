require 'curses'

module TicTacToe
  # Acts as the controller for the application, receiving input and passing it to the
  # view and models.
  class GameController
    include Curses::Key # include some handy key constants
    
    # Starts up a game in a curses window, defaults to the full terminal
    def initialize(window = Curses::stdscr)
      Curses::cbreak #Capture raw keys, but pass control keys to system
      Curses::noecho #Don't echo key presses

      @window = window
      @window.keypad(true) #Enable arrow keys and enter, etc.
      @cursor = Cursor.new
      start_new_game
    end
    
    def start_new_game(computer_mark = :o)
      @board = TicTacToe::Board.new
      @game = TicTacToe::Game.new(@board)
      @computer = TicTacToe::Computer.new(@board, computer_mark)
      @display = TicTacToe::Display.new(@window, @board, @cursor) 
    end
    
    def listen
      loop do
        key = @window.getch
        break if [?Q, ?q].include?(key)
        parse(key)
      end
      confirm_quit
    end
    
    def parse(key)
      case key
        when ?\t      : move_next
        when UP       : @cursor.move(-1,0)
        when DOWN     : @cursor.move(1,0)
        when LEFT     : @cursor.move(0,-1)
        when RIGHT    : @cursor.move(0,1)
        when ?\s, ?\n : make_move
        else            Curses::beep
      end      
      @display.update
    end
    
    def move_next
      squares = @board.empty_squares
      square = squares.select {|s| @cursor < s}.first || squares.first
      @cursor.set(*square)
    end
    
    def make_move
      moved = @game.make_move(*@cursor.location)
      if moved
        @display.update
        check_ending(:x) # Computer will be starting the game next round
        
        @game.make_move(*@computer.get_move)
        @display.update
        check_ending(:o) # Human will be starting the game next round
      end
    end
    
    
    # Check ending will ask if we want to start a new game,
    # if the game was drawn, then all the squares were used
    # and the opposite player will be starting, otherwise, 
    # we'll let the loser go first
    def check_ending(mark)
      return unless @game.result
      print_result
      key = @window.getch
      case key
      when ?Y,?y
        start_new_game(mark)
      when ?N,?n
        Kernel::exit
      else
        check_ending(mark)
      end
      @display.clear_status    
    end
    
    def print_result
      case @game.result
        when :draw: message = "The game is a draw."
        when :x   : message = "X wins the game!"
        when :o   : message = "O wins the game!"
      end
      @display.status("#{message}  Would you like to play another game? (y/n)")
    end
    
    def confirm_quit
      @display.status("Are you sure you want to quit? (y/n)")
      key = @window.getch
      case key
      when ?Y,?y
        Kernel::exit
      when ?N,?n
        @display.clear_status
        listen
      else
        confirm_quit
      end
    end
  end
end