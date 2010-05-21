module TicTacToe
  # Acts as a game computer playing an ideal game.  Is associated with a board
  # on init so get_move doesn't take any arguments.
  class Computer
    def initialize(board, mark)
      @board = board
      @computer_mark = mark
      @opponent_mark = (mark == :x ? :o : :x)
    end
    
    def get_move
      win || block || fork ||
      center || block_fork || 
      corner || side
    end
  
    # Win the game in one move if possible
    def win
      winning_move(@computer_mark)
    end
    
    # Block the opponent from winning in the next move
    def block
      winning_move(@opponent_mark)      
    end

    # If two of the player's squares are in a line 
    # and there's an open space, it's winning
    def winning_move(player)
      count_squares_and_moves(player) do |squares, moves| 
        return moves.first if squares == 2 and !moves.empty? 
      end
      nil
    end
    
    # Play a move that forces a win next move
    def fork
      find_forks(@computer_mark).first
    end
    
    # Just block if there's one fork, the only preventable
    # double forks involve an opponent in the center and corner, 
    # or in opposite corners with the computer in the center.
    def block_fork
      forks = find_forks(@opponent_mark)
      if forks.length == 1
        forks.first
      elsif forks.length > 1
        # We look at the center to determine which case this is
        if @board.square(1,1) == @computer_mark
          side
        else
          corner
        end
      else
        nil
      end
    end
    
    # If an open space appears in more than one line that
    # has only one of our marks, it's a fork
    def find_forks(player)
      forks = []
      open_spaces = {}
      count_squares_and_moves(player) do |squares, moves|
        if squares == 1 && moves.length == 2
          moves.each do |move|
            forks << move if open_spaces[move]
            open_spaces[move] = true
          end
        end
      end
      forks
    end
    
    
    # Count the squares in the lines and yield the number
    # of squares and the possible moves
    def count_squares_and_moves(player)
      @board.lines.each do |line|
        squares = 0
        open_spaces = []
        line.each do |move, mark|
          case mark
            when player: squares += 1
            when nil   : open_spaces << move
          end
        end
        yield(squares, open_spaces)
      end
    end
    
    # Grab the center.  This also blocks all
    # possible forks if available.
    def center
      if @board.square(1,1).nil?
        [1,1]
      else
        nil
      end
    end

    # Take the opposite corner if you can to
    # maximize possible lines, sometimes this
    # is the difference between getting a fork or not
    def corner
      corners = [ [0, 0], [0, 2], [2, 0], [2, 2] ]
      opponent_corner = corners.select { |l| @board.square(*l) == @opponent_mark }.first
      opposite = if opponent_corner
        pick_empty([[2-opponent_corner[0], 2-opponent_corner[1]]] | corners)
      else
        pick_empty(corners)
      end
    end
    
    # Grab a side, this is usually a last resort, but
    # not always
    def side
      pick_empty([ [0, 1], [1, 0], [1, 2], [2, 1] ])
    end
    
    # Find the first legal move in a list
    def pick_empty(locations)
      locations.each do |location|
        return location if @board.square(*location).nil?
      end
      nil
    end
  end
end