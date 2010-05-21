module TicTacToe
  # Represents a tic-tac-toe game board.  :x, :o, and nil are stored in the 
  # @squares ivar to represent moves on the board.  Supports access by
  # continuous lines and also individual squares by address
  class Board
    BOARD_LOCATIONS = [ [0,0], [0,1], [0,2] ],
                      [ [1,0], [1,1], [1,2] ],
                      [ [2,0], [2,1], [2,2] ]
    
    def initialize
      @squares = Array.new(3) { Array.new(3, nil) }
    end
    
    def square(y,x)
      @squares[y][x]
    end
    
    def squares
      @squares.dup.freeze
    end
    
    def empty_squares
      moves = []
      (0..2).each do |y|
        (0..2).each do |x|
          moves << [y, x] if square(y, x).nil?
        end
      end
      moves
    end
    
    # Place a square on the board and return whether successful
    def make_move(square, y, x)
      if square(y,x)
        false
      else
        @squares[y][x] = square 
        true
      end
    end

    def lines
      rows + columns + diagonals
    end

    def rows
      BOARD_LOCATIONS.collect { |row| find_group(row) }
    end
    
    def columns
      BOARD_LOCATIONS.transpose.collect { |column| find_group(column) }
    end
    
    def diagonals
      locations = [ [0,0], [1,1], [2,2] ],
                  [ [0,2], [1,1], [2,0] ]
      locations.collect { |l| find_group(l) }
    end
    
  private
    
    def find_group(locations)
      locations.collect do |location| 
        [location, square(*location)]
      end
    end

  end
end