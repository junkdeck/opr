
# cli tic tac toe, oop style
class Game
  @@game_running = true

  def initialize
    @current_player = rand(0..1)
    @board = Board.new
    @tagline = tagline_generator
    @won = false
  end

  def tagline_generator
    tags = [
      "raw and rowdy",
      "family style",
      "oldschool",
      "roguelite puzzler",
      "desperate scramble for a portfolio piece",
      "Y2K compliant",
      "never-seen-before",
      "illustrious career all started with",
      "diet contains natural sources of",
      "chopped & screwed",
      "proud to present",
      "sick and tired of",
      "original recipe",
      "visually impressive",
      "dangerously spicy",
      "hot and heavy",
      "interdimensional nosedive",
      "curio of the millenium",
      "straight out the oven",
      "sparkly and clean",
      "drinking that sweet, sweet",
      "homemade",
      "jerry-rigged",
      "barely functional",
      "multi-player only",
      "early access",
      "crowdfunded",
      "carrot-top of cli entertainment",
      "enterprise-level server infrastructure framework",
      "Brand New",
      "dynamic tagline generated",
      "personal warning: do not operate heavy machinery after using",
      "ruby implementation of tic-tac-toe",
      "journey to the planet named",
    ]
    tag = rand(0..tags.length+1)
    return tags[tag]
  end

  def hello_message
    system("clear")
    message =
    "
    junkdeck's #{@tagline}
    ██╗  ██╗ ██████╗       ██████╗ ██╗   ██╗██████╗ ██╗   ██╗
    ╚██╗██╔╝██╔═══██╗      ██╔══██╗██║   ██║██╔══██╗╚██╗ ██╔╝
     ╚███╔╝ ██║   ██║█████╗██████╔╝██║   ██║██████╔╝ ╚████╔╝
     ██╔██╗ ██║   ██║╚════╝██╔══██╗██║   ██║██╔══██╗  ╚██╔╝
    ██╔╝ ██╗╚██████╔╝      ██║  ██║╚██████╔╝██████╔╝   ██║
    ╚═╝  ╚═╝ ╚═════╝       ╚═╝  ╚═╝ ╚═════╝ ╚═════╝    ╚═╝
    ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
    enter coordinates in this format : letter, number
    "
    puts message
  end

  def main_loop
    while @@game_running
      hello_message # displays the fancy logo and instructions on how to play

      puts "Player #{@current_player + 1}, you're up!" unless @won
      if @error_message
        puts "\t#{@error_message}"
        @error_message = nil
      else
        print "\n"
      end

      @board.draw_board
      # error handling block
      begin
        input = get_input
        print "\n"  # lil linebreak

        if @won
          new_game
          next
        else
          fill_square(input)
        end

      rescue ArgumentError
        @error_message = "Hey! That square's already occupied!"
      rescue IOError
        @error_message = "Invalid coordinate!"
      rescue Interrupt
        system("clear")
        puts "Thanks for playing!"
        exit
      else
        # switches between player 1 and 2
        if check_for_winner
          @error_message = "Player #{@current_player + 1} wins!"
          @won = true
        else
          toggle_player
        end
        system("clear")
        # nothing left to do! next round, please!
      end
    end
  end

  def new_game
    # sets the current player, assigns a board instance variable, a random tagline and resets the win state
    @current_player ^= 1
    @board = Board.new
    @won = false
  end

  def get_input
    # returns a sanitized input, recognizes only a-c // 1-3
    input = gets.chomp.downcase
    coords = input.scan(/^([a-cA-C][1-3])/).join('')

    unless coords.length > 0
      raise IOError unless @won
    end
    return coords
  end

  def toggle_player
    # XOR operator
    @current_player ^= 1
  end

  def check_for_winner
    winner = false
    winning_combo = [
      [0,1,2],
      [3,4,5],
      [6,7,8],
      [0,3,6],
      [1,4,7],
      [2,5,8],
      [0,4,8],
      [2,4,6]
    ]

    ["X","O"].each do |mark|
      winning_combo.each do |x,y,z|
        if @board.squares[x] == mark && @board.squares[y] == mark && @board.squares[z] == mark
          # @@game_running = false
          winner = @current_player
        end
      end
    end
    return winner
  end

  def fill_square(input)
    case @current_player    # determines what mark to use
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
      "\t    A   B   C  \n"\
      "\t  ╔═══╦═══╦═══╗\n"\
      "\t1 ║ #{@squares[0]} ║ #{@squares[1]} ║ #{@squares[2]} ║\n"\
      "\t  ╠═══╬═══╬═══╣\n"\
      "\t2 ║ #{@squares[3]} ║ #{@squares[4]} ║ #{@squares[5]} ║\n"\
      "\t  ╠═══╬═══╬═══╣\n"\
      "\t3 ║ #{@squares[6]} ║ #{@squares[7]} ║ #{@squares[8]} ║\n"\
      "\t  ╚═══╩═══╩═══╝\n\n\n"
      puts message
    end
  end

  class Player
    def initialize(name)
      @name = name
      @wins = 0
    end
  end

end

xo = Game.new
xo.main_loop
