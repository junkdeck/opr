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
    @player = nil   # set later by get_choice_input
  end

  def main_loop
    loop do
      begin
        render_screen
        unless @game_running
          get_choice_input
          if @player.class == CPU
            @msg = "Input a code, 4 digits between 1-6."
            render_screen
            print "\t>"
            @combo.code = Player.get_input
          else
            @combo.code = CPU.cpu_random
          end
          next
        end
      rescue MMInputError
        @msg = "Input must be 4 digits between 1 and 6!"
      rescue WelcomeScreenError
        @msg = "1 or 2 only!"
      rescue Interrupt
        break_game
      else
        if @remaining_turns <= 0
          @msg = "You lose! Correct code was: #{@combo.code.join('')}. Try again? (Y/n)"
          render_screen
          print "\t>"
          input = gets.chomp.downcase
          input == 'y' || input == '' ? new_game : break_game
          next
        end
      end
      begin
        print "\t>" # screen prompt
        input = @player.class == CPU ? @player.cpu_algo(@combo.feedback) : @player.get_input
      rescue MMInputError
        @msg = "Input must be 4 digits between 1 and 6!"
      else
        @history[@history.length] = {guess: input, feedback: @combo.try_guess(input)}
        @remaining_turns -= 1
      end
      begin
        check_win
      rescue Interrupt
        break_game
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

  def check_win
    if @combo.feedback.all?{|x| x == "O"} && @combo.feedback.length >= 4
      @msg = "You win! Correct code was #{@combo.code.join('')}. Play again? (Y/n)"
      render_screen
      input = gets.chomp
      case input
      when "y"
        new_game
      else
        break_game
      end
    end
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
      @player = Player.new
    when 2
      @player = CPU.new
    else
      raise WelcomeScreenError
    end
    @game_running = true
  end

  class Player
    attr_reader :mode
    def initialize
    end

    def self.get_input
      input = []
      input = gets.strip.chomp.scan(/\d/).map(&:to_i) # strips out all non-letters
      unless input.length == 4 && input.all?{|x| x.between?(1,6)}
        # checks for bogus input and sets error message accordingly
        raise MMInputError
      end
      return input
    end

    def get_input
      self.class.get_input  # calls Player.get_input, all cool like
    end
  end

  class CPU < Player
    def self.cpu_random
      input = []
      4.times{ input << rand(1..6) }
      return input
    end

    def cpu_random
      self.class.cpu_random
    end

    def cpu_algo(feedback)
      unless feedback
        return cpu_random
      end
      return cpu_random
    end
  end

  class Combination
    attr_accessor :code
    attr_reader :feedback

    def initialize
      # if player chooses
      # combination = Game::get_input
      @code = []
      @feedback = []
    end

    def cpu_code
      4.times do
        @code << rand(1..6)
      end
    end

    def try_guess(input)
      guess = input.slice(0..-1)  # copies the input
      @feedback = []    # empty feedback from previous guess
      code = @code.slice(0..-1) # copies the instance variable

      code.each_with_index do |x,i|
        if guess[i] == x    # check for correct placements first
          @feedback << "O"
          guess[i] = 0
        elsif guess.count(x) == code.count(x)   # makes sure multiple digits in the guess don't all trigger if code only contains one
          @feedback << "o"
        elsif guess.include?(x)
          @feedback << "o"
          # removes the current code digit from guess to avoid one digit triggering as correct number for every occurence in the guess
          guess.map!{|n| x == n ? 0 : n}
        end
      end
      return @feedback.sort
    end
  end
end

mm = Game.new
mm.main_loop
