require_relative "tagline"

class Game
  # include Tagline

  def initialize
    @tag = Tagline::tagline_generator
    @err_msg = ""
  end

  def main_loop
    loop do
      render_screen
      print ">" # screen prompt
      begin
        input = get_input
      rescue Interrupt
        break_game
      end
    end
  end

  def get_input
    input = gets.chomp.scan(/\d/).map(&:to_i) # strips out all non-letters
    unless input.length == 4 && input.all?{|x| x.between?(0,6)}
      # checks for bogus input and sets error message accordingly
      @err_msg = "Input must be 4 digits between 0 and 6!"
    end
  end

  def render_screen
    # renders the changed game state to screen
    system("clear")   # flush display before amending new data for a clean pro look

    title = "
    junkdeck's #{@tag}

    • ▌ ▄ ·.  ▄▄▄· .▄▄ · ▄▄▄▄▄▄▄▄ .▄▄▄  • ▌ ▄ ·. ▪   ▐ ▄ ·▄▄▄▄
    ·██ ▐███▪▐█ ▀█ ▐█ ▀. •██  ▀▄.▀·▀▄ █··██ ▐███▪██ •█▌▐███▪ ██
    ▐█ ▌▐▌▐█·▄█▀▀█ ▄▀▀▀█▄ ▐█.▪▐▀▀▪▄▐▀▀▄ ▐█ ▌▐▌▐█·▐█·▐█▐▐▌▐█· ▐█▌
    ██ ██▌▐█▌▐█ ▪▐▌▐█▄▪▐█ ▐█▌·▐█▄▄▌▐█•█▌██ ██▌▐█▌▐█▌██▐█▌██. ██
    ▀▀  █▪▀▀▀ ▀  ▀  ▀▀▀▀  ▀▀▀  ▀▀▀ .▀  ▀▀▀  █▪▀▀▀▀▀▀▀▀ █▪▀▀▀▀▀•
    = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
               guess the code! 4 digits between 0-6
"
  puts title
  print "#{@err_msg}\n"
  unless @err_msg.empty?
    @err_msg = ""
  end
  end

  def break_game
    system('clear')
    puts "Thanks for playing!"
    exit
  end

  class Player
  end
  class Combination
  end
end

mm = Game.new
mm.main_loop
