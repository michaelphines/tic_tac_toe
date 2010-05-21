module TicTacToe
  # Acts as the view for the application.  Is associated with models, but
  # requires a manual update() call from the controller to refresh the
  # screen.  Also implements a status method for simple messages.
  class Display

    def initialize(window, board, cursor)
      @window = window
      @board = board
      @cursor = cursor
      update
    end
    
    def update
      draw_board
      draw_squares
      move_cursor
      @window.refresh
    end
          
    def status(str)
      @window.setpos(STATUS_LINE, 0)
      @window.deleteln
      @window.addstr(str)
      move_cursor
      @window.refresh
    end
    
    def clear_status
      @window.setpos(STATUS_LINE, 0)
      @window.deleteln
      move_cursor
      @window.refresh
    end

    def move_cursor
      @window.setpos(*position(@cursor.y, @cursor.x))
    end
    
    def draw_board
      @window.setpos(0, 0)
      @window.addstr(BOARD)
    end
    
    # Get the squares from the board and print them on the screen
    def draw_squares
      squares = @board.squares
      squares.each_with_index do |row, y|
        row.each_with_index do |mark, x|
          @window.setpos(*position(y, x))
          @window.addstr(mark.to_s.upcase) if mark
        end
      end
    end

    # Find the screen location of a board square
    def position(y, x)
      [START[0] + (y * SPACING[0]),
       START[1] + (x * SPACING[1])]
    end
  end
end

TicTacToe::Display::STATUS_LINE = 6
TicTacToe::Display::SPACING = [2, 4]
TicTacToe::Display::START = [0, 1]
TicTacToe::Display::BOARD = <<-END
   |   |   
---+---+--- Move with [Tab] or [Up] [Down] [Left] [Right] 
   |   |    Press [Space] or [Enter] to make your move
---+---+--- Tap [Q] to quit
   |   |   
END

