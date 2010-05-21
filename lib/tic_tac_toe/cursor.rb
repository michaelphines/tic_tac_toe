module TicTacToe
  # Represents a cursor state on the screen that the user controls
  class Cursor
    include Comparable
    
    attr_reader :y, :x
    
    def initialize
      set(0, 0)
    end
    
    def move(dy, dx)
      @y = (@y + dy) % 3
      @x = (@x + dx) % 3
    end
    
    def set(y, x)
      @y, @x = y, x
    end
    
    def location
      [y, x]
    end
    
    # For comparing with arrays
    def first; y; end
    def last; x; end
    def <=>(other)
      if other.first == first 
        last <=> other.last
      else
        first <=> other.first
      end
    end
  end
end  
    