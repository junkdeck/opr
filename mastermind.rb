require_relative "tagline"

class Game
  # include Tagline

  def initialize
    @tag = Tagline::tagline_generator
    @msg = ""
    @combo = Combination.new
    @remaining_turns = 12
    @history = Hash.new(0)
  end

  def main_loop
    loop do
      render_screen
      if @remaining_turns <= 0
        @msg = "You lose! Correct code was: #{@combo.code}. Try again? (Y/n)"
        render_screen
        print "\t>"
        input = gets.chomp.downcase
        case input
        when "y"
          new_game
        else
          raise Interrupt
        end
        next
      end
      print "\t>" # screen prompt
      begin
        input = get_input
      rescue ArgumentError
        @msg = "Input must be 4 digits between 1 and 6!"
      rescue Interrupt
        break_game
      else
        @history[@history.length] = {guess: input, feedback: @combo.try_guess(input)}
        @remaining_turns -= 1
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
    puts "    junkdeck's #{@tag}
    • ▌ ▄ ·.  ▄▄▄· .▄▄ · ▄▄▄▄▄▄▄▄ .▄▄▄  • ▌ ▄ ·. ▪   ▐ ▄ ·▄▄▄▄
    ·██ ▐███▪▐█ ▀█ ▐█ ▀. •██  ▀▄.▀·▀▄ █··██ ▐███▪██ •█▌▐███▪ ██
    ▐█ ▌▐▌▐█·▄█▀▀█ ▄▀▀▀█▄ ▐█.▪▐▀▀▪▄▐▀▀▄ ▐█ ▌▐▌▐█·▐█·▐█▐▐▌▐█· ▐█▌
    ██ ██▌▐█▌▐█ ▪▐▌▐█▄▪▐█ ▐█▌·▐█▄▄▌▐█•█▌██ ██▌▐█▌▐█▌██▐█▌██. ██
    ▀▀  █▪▀▀▀ ▀  ▀  ▀▀▀▀  ▀▀▀  ▀▀▀ .▀  ▀▀▀  █▪▀▀▀▀▀▀▀▀ █▪▀▀▀▀▀•
    = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
                4 digits, 1-6 // remaining turns : #{@remaining_turns}"
    print "\t#{@msg}\n"
    unless @msg.empty?
      @msg = ""
    end

    if @history.empty?
      print "\t╔════════════════╗\n"
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
    # cheat mode display of correct code, remove later
    # puts @combo.code.join("")
    @remaining_turns = 0 if @remaining_turns < 0
    print "\n"*@remaining_turns

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
      code = @code.slice(0..-1) # copies the instance variable

      # scans for correct placement, then correct number, resetting every occurence to 0 to avoid false repeats
      guess.each_with_index do |x,i|
        if code[i] == x   # if the current index of the code is the same number, we've got a correct placement
          @feedback << 'O'
          code[i] = 0
          # guess[i] = 0
        end
      end
      guess.each_with_index do |x,i|
        if code.include?(x)
          @feedback << 'o'
          code[code.find_index(x)] = 0
        end
      end
      return @feedback
    end
  end
end

mm = Game.new
puts "hey there! what'd you like to do?"
input = gets.chomp
case input
when 'exit'
  exit
else
  mm.main_loop
end
