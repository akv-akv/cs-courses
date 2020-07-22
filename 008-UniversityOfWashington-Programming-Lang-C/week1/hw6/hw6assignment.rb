# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.


class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  # class array holding all the pieces and their rotations
  All_My_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
               rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
               [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
               [[0, 0], [0, -1], [0, 1], [0, 2]]],
               rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
               rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
               rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
               rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
               rotations([[0, 0], [1, 0], [0, 1], [1, 1], [2, 1]]), #Problem 2 fig 1
               [[[0, 0],[-2,0], [-1, 0], [1, 0], [2, 0]],
               [[0, 0], [0, -2],[0, -1] , [0, 1], [0, 2]]], #Problem 2 fig. 2
               rotations([[0, 0], [-1, 0], [0, -1]])] #Problem 2 fig. 3
  

  # your enhancements here
  # class method to choose the next piece
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  
end

class MyBoard < Board
# your enhancements here
def initialize (game)
  @grid = Array.new(num_rows) {Array.new(num_columns)}
  @current_block = MyPiece.next_piece(self)
  @score = 0
  @cheat = 0
  @game = game
  @delay = 500
end

def rotate_180
  if !game_over? and @game.is_running?
    @current_block.move(0, 0, 2)
  end
  draw
end


# gets the next piece
def next_piece
  if @cheat <= 0
    @current_block = MyPiece.next_piece(self) #piece creation from My_All_Pieces
    @cheat = 0
  else
    @current_block = MyPiece.new([[[1,1]]],self) # square 1x1
    @cheat = @cheat - 1
  end
  @current_pos = nil
end

# gets the information from the current piece about where it is and uses this
# to store the piece on the board itself.  Then calls remove_filled.
def store_current
  locations = @current_block.current_rotation
  displacement = @current_block.position
  (0..(locations.size-1)).each{|index| 
    current = locations[index];
    @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
    @current_pos[index]
  }
  remove_filled
  @delay = [@delay - 2, 80].max
end

#if cheat key pressed then checks score>100, reduces score by 100 and sets cheat variable true
  def set_cheat
    if @game.is_running?
      if @score >= 100
        @score -= 100
        @cheat += 1;
      end
    end
  end

end

class MyTetris < Tetris
  # your enhancements here
  # # creates a canvas and the board that interacts with it
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
   super()
   @root.bind('u' , proc {@board.rotate_180}) #rotate piece 180 deg
   @root.bind('c' , proc {@board.set_cheat})  #cheat
  end 

  
end


