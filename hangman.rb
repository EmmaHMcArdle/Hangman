require 'yaml'

class Board

  attr_accessor :used_letters, :current_board, :missed_count, :player_won, :iteration, :chosen_word

  def initialize(chosen_word)
    @iteration = 0
    @used_letters = Array.new
    @missed_count = 0
    @player_won = false
    @current_board = Array.new
    @chosen_word = chosen_word
  end

  def new_game()
    chosen_word.split('').each_with_index { |c, index|
    @current_board[index] = "_ "
    print @current_board[index]
    STDOUT.flush
  }
  print "\n"
  print "\n"
  end

  def save_game?()
    print "Are you sure you want to game and quit? (y/n) "
    answer = gets.chomp.strip
    if answer == "y"
      save_game()
      exit
    elsif answer == "n"
      return
    else
      put "Invalid answer."
      save_game?
    end
  end

  def save_game()
    Dir.mkdir("saves") unless Dir.exists? "saves"
    File.open("save_file", "w+") do |info|
    Marshal.dump(self, info)
    end
    exit
  end

  def load_game()
    object = nil
    File.open("save_file") do |info|
      object = Marshal.load(info)
      puts "Guess your next letter"
    end
    self.iteration = object.iteration
    self.used_letters = object.used_letters
    self.missed_count = object.missed_count
    self.player_won = object.player_won
    self.current_board = object.current_board
    self.chosen_word = object.chosen_word
    puts "The old word is " + self.chosen_word.to_s
    puts self.current_board.join(' ')
    STDOUT.flush
    print "\n"
  end

  def update_lines(guess, letter_used)
    guessed_right = false
    chosen_word.split('').each_with_index { |c, index|
    if guess.downcase() == c.downcase()
      guessed_right = true
      @current_board[index] = c
    end 
    }
    if guessed_right == false && letter_used == false
      add_body_part()
      @missed_count += 1
    end
    print @current_board.join(" ")
    STDOUT.flush
    print "\n"
    return @missed_count
  end

  def check_if_used(guess)
    letter_used = false
    if @used_letters.length == 0
      @used_letters[0] = guess
    else
      if @used_letters.include? guess
        puts "You already guessed that"
        letter_used = true
      else
        @used_letters.push(guess)
      end
    end
    print "\n"
    print "Used letters: "
    print @used_letters.sort
    print "\n"
    return letter_used
  end

   def add_body_part()
    if @iteration == 0
      puts " _________"
      puts "|         |"
      puts "|         |"
      puts "|         O"
      puts "|          "
      puts "|          "
      puts "|          "
      puts "|__________"

      puts "6 turns left"
      print "\n"
    elsif @iteration == 1
      puts " _________"
      puts "|         |"
      puts "|         |"
      puts "|         O"
      puts "|         |"
      puts "|          "
      puts "|          "
      puts "|__________"
      
      puts "5 turns left"

    elsif @iteration == 2
      puts " _________"
      puts "|         |"
      puts "|         |"
      puts "|         O"
      puts "|         |/"
      puts "|          "
      puts "|          "
      puts "|__________"

      puts "4 turns left"

    elsif @iteration == 3
      puts " _________"
      puts "|         |"
      puts "|         |"
      puts "|         O"
      puts '|        \|/'
      puts "|          "
      puts "|          "
      puts "|__________"

      puts "3 turns left"

    elsif @iteration == 4
      puts " _________"
      puts "|         |"
      puts "|         |"
      puts "|         O"
      puts '|        \|/'
      puts "|         | "
      puts "|          "
      puts "|__________"

      puts "2 turns left"
    elsif @iteration == 5
      puts " _________"
      puts "|         |"
      puts "|         |"
      puts "|         O"
      puts '|        \|/'
      puts "|         |"
      puts '|          \ '
      puts "|_________ "

      puts "1 try left"
    else
      puts " _________"
      puts "|         |"
      puts "|         |"
      puts "|         O"
      puts '|        \|/'
      puts "|         | "
      puts '|        / \ '
      puts "|__________"
   end
   @iteration += 1
  end

  def check_if_player_won()
    split_word = chosen_word.split('')
    if @current_board.eql?(split_word)
      @player_won = true
    end
    if @player_won == true
      puts "You won"
      exit
    end
    #puts "I am chosen word: #{split_word}"
    #puts "I am current board: #{@@current_board}"
  end


  def check_if_player_lost(missed_count)
  if missed_count == 7
      print "\n"
      puts "You lost"
      puts "The answer was: #{chosen_word}"
      print "\n"
      exit
    end
  end
end

class Computer

  def choose_word_from_dictionary()
    file = File.open("5desk.txt", "r")
    words = file.readlines()
    length = 0
    until length > 5 && length < 12
      chosen_word = words.sample.chop
      length = chosen_word.length()
    end
    puts chosen_word
    return chosen_word
  end

  
end


class Player
  def guess_letter()
    puts "Please guess a letter:"
    puts "(type 'sq' to quit & save)"
    guess = gets.chomp().strip()
    until guess == 'sq' || (guess.length == 1 && guess.count("a-zA-Z") == 1)
      guess = gets.chomp().strip
    end
    return guess
  end
end

class Game

  cmp1 = Computer.new
  chosen_word = cmp1.choose_word_from_dictionary()
  board1 = Board.new(chosen_word)
    print "\n"
    puts "   Welcome to Hangman"
    puts "(a violent spelling game)"

    puts " _________"
    puts "|         |"
    puts "|         |"
    puts "|          "
    puts "|          "
    puts "|          "
    puts "|          "
    puts "|__________"
    
  if File.exists? "save_file"
    start = 'nothing'
    while start == 'nothing'
      print "\n"
      puts "Would you like to a \"new\" game or \"load\" a game?"
      start = gets.chomp.strip
      if start.include? 'load'
        puts "Your last game was loaded"
        board1.load_game
      elsif start.include? 'new' 
        start = 'go'
        board1.new_game()
      else
       puts "Invalid entry"
       start = 'nothing'
      end
    end
  end
    player_won = board1.check_if_player_won()
    player1 = Player.new
    while player_won == nil
    guess = player1.guess_letter()
    if guess == "sq"
      board1.save_game?()
    else
    letter_used = board1.check_if_used(guess)
    missed_count = board1.update_lines(guess, letter_used)
    player_won = board1.check_if_player_won()
    board1.check_if_player_lost(missed_count)
    end
  end
end

game = Game.new