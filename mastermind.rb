require_relative "tagline"

class Game
  # include Tagline

  def initialize
    @tag = Tagline::tagline_generator
    @err_msg = ""
    @combo = Combination.new
    @remaining_turns = 12
    @history = Hash.new(0)
  end

  def main_loop
    loop do
      render_screen
      print ">" # screen prompt
      begin
        input = get_input
      rescue ArgumentError
        @err_msg = "Input must be 4 digits between 1 and 6!"
      rescue Interrupt
        break_game
      else
        @history[@history.length] = {guess: input, feedback: @combo.try_guess(input)}
      end
    end
  end

  def get_input
    input = gets.strip.chomp.scan(/\d/).map(&:to_i) # strips out all non-letters
    unless input.length == 4 && input.all?{|x| x.between?(1,6)}
      # checks for bogus input and sets error message accordingly
      raise ArgumentError
    else
      return input
    end
  end

  def render_screen
    # renders the changed game state to screen
    system("clear")   # flush display before amending new data for a clean pro look

    puts "
    junkdeck's #{@tag}

    • ▌ ▄ ·.  ▄▄▄· .▄▄ · ▄▄▄▄▄▄▄▄ .▄▄▄  • ▌ ▄ ·. ▪   ▐ ▄ ·▄▄▄▄
    ·██ ▐███▪▐█ ▀█ ▐█ ▀. •██  ▀▄.▀·▀▄ █··██ ▐███▪██ •█▌▐███▪ ██
    ▐█ ▌▐▌▐█·▄█▀▀█ ▄▀▀▀█▄ ▐█.▪▐▀▀▪▄▐▀▀▄ ▐█ ▌▐▌▐█·▐█·▐█▐▐▌▐█· ▐█▌
    ██ ██▌▐█▌▐█ ▪▐▌▐█▄▪▐█ ▐█▌·▐█▄▄▌▐█•█▌██ ██▌▐█▌▐█▌██▐█▌██. ██
    ▀▀  █▪▀▀▀ ▀  ▀  ▀▀▀▀  ▀▀▀  ▀▀▀ .▀  ▀▀▀  █▪▀▀▀▀▀▀▀▀ █▪▀▀▀▀▀•
    = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    guess the code! input accepts 4 digits between 1-6"
    print "\t#{@err_msg}\n"
    unless @err_msg.empty?
      @err_msg = ""
    end

    # puts "HISTORY: #{@history}"

    @history.each do |index,log|
      puts "#{log[:guess]}, #{log[:feedback]}"
      # puts "#{x[:guess]} | #{x[:feedback]}"
    end
    # board = "#{@combo.code[0]} #{@combo.code[1]} #{@combo.code[2]} #{@combo.code[3]} "\
    # "| #{@combo.feedback[0]} #{@combo.feedback[1]} #{@combo.feedback[2]} #{@combo.feedback[3]}" if @history
    # user guess > feedback
    # puts board

  end

  def new_game
    @combo = Combination.new    # generate new code
    @remaining_turns = 12       # reset amount of turns
    @history = Hash.new(0)      # reset guess history
  end

  def break_game
    system('clear')
    puts "Thanks for playing!"
    exit
  end

  class Player
  end
  class Combination
    attr_reader :code, :feedback

    def initialize
      # if player chooses
      # combination = Game::get_input
      @code = []
      @feedback = []
      4.times do
        @code << rand(1..6)
      end
    end

    def try_guess(guess)
      @feedback = []    # empty feedback from previous guess
      # compares the guess with the randomly generated code - o is correct number, O is correct number & position
      guess.each_with_index do |x,i|
        if @code.include?(x)
          if @code[i] == x
            @feedback << 'O'
          else
            @feedback << 'o'
          end
        end
      end
      return @feedback
    end
  end
end

mm = Game.new
mm.main_loop
