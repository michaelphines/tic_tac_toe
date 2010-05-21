module TicTacToe
  # Represents a current game of tic-tac-toe.  Controls turns and knows the result
  # of the game
  class Game
    attr_reader :turn
    
    def initialize(board)
      @board = board
      @turn = :x
    end
    
    def make_move(y, x)
      success = @board.make_move(@turn, y, x)
      next_turn if success
    end
    
    def next_turn
      if @turn == :x
        @turn = :o
      else 
        @turn = :x
      end
    end
    
    def result
      squares_left = @board.squares.flatten.select { |s| s.nil? }
      won_lines = @board.lines.select do |line|
        moves = line.collect {|location, move| move}
        return moves.first if [[:x,:x,:x], [:o,:o,:o]].include?(moves)
      end
      return :draw if squares_left.empty?
    end
    
  end
end