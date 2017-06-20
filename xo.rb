
# cli tic tac toe, oop style
class Game
  attr_reader :board
  @@game_running = true

  def initialize
    @current_player = 0
    @board = Board.new
    hello_message # displays the fancy logo and instructions on how to play
  end

  def hello_message
    message =
    "
    junkdeck's
    ██╗  ██╗ ██████╗       ██████╗ ██╗   ██╗██████╗ ██╗   ██╗
    ╚██╗██╔╝██╔═══██╗      ██╔══██╗██║   ██║██╔══██╗╚██╗ ██╔╝
    ╚███╔╝ ██║   ██║█████╗██████╔╝██║   ██║██████╔╝ ╚████╔╝
    ██╔██╗ ██║   ██║╚════╝██╔══██╗██║   ██║██╔══██╗  ╚██╔╝
    ██╔╝ ██╗╚██████╔╝      ██║  ██║╚██████╔╝██████╔╝   ██║
    ╚═╝  ╚═╝ ╚═════╝       ╚═╝  ╚═╝ ╚═════╝ ╚═════╝    ╚═╝
    ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
    supply coordinates as XY, where X is A-C and Y is 1-3
    "
    puts message
  end

  def main_loop
    while @@game_running
      # updates the game board to reflect changes brought by inputting coordinates
      puts "Player #{@current_player + 1}, you're up!"
      if @error_message
        puts @error_message
        @error_message = nil
      end
      @board.draw_board

      # error handling block
      begin
        input = get_input
        print "\n"  # lil linebreak

        fill_square(input)
      rescue ArgumentError
        @error_message = "Hey! That square's already occupied!"
      rescue IOError
        @error_message = "Invalid coordinate!"
      else
        # switches between player 1 and 2
        toggle_player
        # nothing left to do! next round, please!
      end
    end
  end

  def get_input
    # returns a sanitized input, recognizes only 'exit' and a-c // 1-3
    input = gets.chomp
    coords = input.scan(/^([a-cA-C][1-3])/).join('')

    unless coords.length > 0
      raise IOError
    end

    return coords
  end

  def toggle_player
    # XOR operator
    @current_player ^= 1
  end

  def fill_square(input)
    case @current_player
    when 0
      mark = 'X'
    when 1
      mark = 'O'
    else
      mark = '$'
    end

    # finds the square corresponding to the user's input coordinates.
    # input downcased and symbolized for case insensitivity
    square_index = @board.coords[input.to_sym]

    if @board.squares[square_index] == " "
      # sets the current players mark in the specified square if the current square isn't occupied
      @board.squares[square_index] = mark
    else
      raise ArgumentError
    end
  end

  class Board
    attr_accessor :squares
    attr_reader :coords

    def initialize
      @squares = Hash.new(" ")
      # coords to square index
      @coords = {
        a1: 0,
        a2: 3,
        a3: 6,
        b1: 1,
        b2: 4,
        b3: 7,
        c1: 2,
        c2: 5,
        c3: 8
      }
    end
    def draw_board
      message =
      "    A   B   C  \n"\
      "  ╔═══╦═══╦═══╗\n"\
      "1 ║ #{@squares[0]} ║ #{@squares[1]} ║ #{@squares[2]} ║\n"\
      "  ╠═══╬═══╬═══╣\n"\
      "2 ║ #{@squares[3]} ║ #{@squares[4]} ║ #{@squares[5]} ║\n"\
      "  ╠═══╬═══╬═══╣\n"\
      "3 ║ #{@squares[6]} ║ #{@squares[7]} ║ #{@squares[8]} ║\n"\
      "  ╚═══╩═══╩═══╝\n"
      puts message
    end

    def check_for_winner
      winning_combo = [
        [0,1,2],
        [3,4,5],
        [6,7,8],
        [0,3,6],
        [1,4,7],
        [2,5,8],
        [0,4,7],
        [2,4,6]
      ]
    end
  end
end

xo = Game.new
xo.main_loop
