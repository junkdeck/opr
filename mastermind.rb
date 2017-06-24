require_relative "tagline"

class WelcomeScreenError < ArgumentError
end
class MMInputError < ArgumentError
end

class Game
  # include Tagline

  def initialize
    @first_play = true    # used to display "Hello!" when starting the game
    @game_running = false # keeps track of game state
    @tag = Tagline::tagline_generator
    @msg = ""
    @combo = Combination.new
    @remaining_turns = 12
    @history = Hash.new(0)
  end

  def main_loop
    loop do
      begin
        render_screen
        unless @game_running
          get_choice_input
          next
        end
        if @remaining_turns <= 0
          @msg = "You lose! Correct code was: #{@combo.code.join('')}. Try again? (Y/n)"
          render_screen
          print "\t>"
          input = gets.chomp.downcase
          case input
          when "y"
            new_game
          else
            break_game
          end
          next
        end
        print "\t>" # screen prompt
        input = @player.get_input
      rescue MMInputError
        @msg = "Input must be 4 digits between 1 and 6!"
      rescue WelcomeScreenError
        @msg = "1 or 2 only!"
      rescue Interrupt
        break_game
      else
        @history[@history.length] = {guess: input, feedback: @combo.try_guess(input)}
        @remaining_turns -= 1

        if @combo.feedback.all?{|x| x == "O"} && @combo.feedback.length >= 4
          @msg = "You win! Correct code was #{@combo.code.join('')}. Play again? (Y/n)"
          render_screen
          input = gets.chomp
          case input
          when "y"
            new_game
            next
          else
            break_game
          end
        end
      end
    end
  end

  def render_screen
    # renders the changed game state to screen
    system("clear")   # flush display before amending new data for a clean pro look
    puts "    junkdeck's #{@tag}
    • ▌ ▄ ·.  ▄▄▄· .▄▄ · ▄▄▄▄▄▄▄▄ .▄▄▄  • ▌ ▄ ·. ▪   ▐ ▄ ·▄▄▄▄
    ·██ ▐███▪▐█ ▀█ ▐█ ▀. •██  ▀▄.▀·▀▄ █··██ ▐███▪██ •█▌▐███▪ ██
    ▐█ ▌▐▌▐█·▄█▀▀█ ▄▀▀▀█▄ ▐█.▪▐▀▀▪▄▐▀▀▄ ▐█ ▌▐▌▐█·▐█·▐█▐▐▌▐█· ▐█▌
    ██ ██▌▐█▌▐█ ▪▐▌▐█▄▪▐█ ▐█▌·▐█▄▄▌▐█•█▌██ ██▌▐█▌▐█▌██▐█▌██. ██
    ▀▀  █▪▀▀▀ ▀  ▀  ▀▀▀▀  ▀▀▀  ▀▀▀ .▀  ▀▀▀  █▪▀▀▀▀▀▀▀▀ █▪▀▀▀▀▀•
    = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    #{@game_running ? "4 digits, 1-6 //remaining turns : #{@remaining_turns}" : "#{"Hello!" if @first_play} Select a code generation mode." }"
    print "\t#{@msg}\n"
    puts @combo.code.inspect
    unless @msg.empty?
      @msg = ""
    end
    if @history.empty?
      print "\t╔════════════════╗\n"
      unless @game_running
        print "\t║ 1: VS CPU      ║\n"
        print "\t║ 2: VS PLAYER   ║\n"
      end
      print "\t╚════════════════╝\n"
    end

    # shows past guesses and feedback on those guesses. history object is sorted as following:  n => {:guess, :feedback}
    @history.each do |index,log|
      print "\t╔════════════════╗\n" if index == 0
      #| 1 2 3 4 | oooo
      print "\t║"
      log[:guess].each do |x|
        print " #{x}"
      end
      print ' | '
      i = 4   # keeps track of how many characters was printed
      log[:feedback].each do |x|
        print "#{x}"
        i -= 1
      end
      print " "*i
      print " ║\n"
      print "\t╚════════════════╝\n" if index == (@history.length-1)
      # keeps the prompt down as many turns are left to keep its position the same
    end
    @remaining_turns = 0 if @remaining_turns < 0
    print @game_running ? "\n"*@remaining_turns : "\n"*(@remaining_turns-2)
  end

  def new_game
    @combo = Combination.new    # generate new code
    @remaining_turns = 12       # reset amount of turns
    @history = Hash.new(0)      # reset guess history
    @game_running = false
    @first_play = false
  end

  def break_game
    system('clear')
    puts "Thanks for playing!"
    exit
  end

  def get_choice_input
    print "\t>"
    choice_input = gets.chomp.to_i
    case choice_input
    when 1
      @player = Player.new("P1")
    when 2
      @player = Player.new("CPU")
    else
      raise WelcomeScreenError
    end
    @game_running = true
  end

  class Player
    def initialize(mode)
      @mode = mode
    end

    def get_input
      input = gets.strip.chomp.scan(/\d/).map(&:to_i) # strips out all non-letters
      unless input.length == 4 && input.all?{|x| x.between?(1,6)}
        # checks for bogus input and sets error message accordingly
        raise MMInputError
      else
        return input
      end
    end

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

    def try_guess(input)
      guess = input.slice(0..-1)  # copies the input
      @feedback = []    # empty feedback from previous guess
      code = @code.slice(0..-1) # copies the instance variable

      code.each_with_index do |x,i|
        if guess[i] == x
          @feedback << "O"
          guess[i] = 0
        elsif guess.count(x) == code.count(x)
          @feedback << "o"
        elsif guess.include?(x)
          @feedback << "o"
          guess.map!{|n| x == n ? 0 : n}
        end
      end
      return @feedback.sort
    end
  end
end

    mm = Game.new
    mm.main_loop
