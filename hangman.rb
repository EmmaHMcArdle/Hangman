
class Board

  def initialize(chosen_word)
    print "\n"
    puts "   Welcome to Hangman"
    puts "(a violent spelling game)"
    make_board()
    @@iteration = 0
    @@used_letters = Array.new
    @@missed_count = 0
    player_won = false
    print "\n"
    @@current_board = Array.new
    chosen_word.split('').each_with_index { |c, index|
    @@current_board[index] = "_ "
    print @@current_board[index]
    STDOUT.flush
  }
  print "\n"
  print "\n"
  puts "Please guess a letter?"
  end

  def make_board()
    puts " _________"
    puts "|         |"
    puts "|         |"
    puts "|          "
    puts "|          "
    puts "|          "
    puts "|          "
    puts "|__________"
  end

  def update_lines(chosen_word, guess, letter_used)
    guessed_right = false
    chosen_word.split('').each_with_index { |c, index|
    if guess.downcase() == c.downcase()
      guessed_right = true
      @@current_board[index] = c
    end 
    }
    if guessed_right == false && letter_used == false
      add_body_part()
      @@missed_count += 1
    end
    print @@current_board.join(" ")
    STDOUT.flush
    print "\n"
    return @@missed_count
  end

  def check_if_used(guess)
    letter_used = false
    if @@used_letters.length == 0
      @@used_letters[0] = guess
    else
      if @@used_letters.include? guess
        puts "You already guessed that"
        letter_used = true
      else
        @@used_letters.push(guess)
      end
    end
    print "\n"
    print "Used letters: "
    print @@used_letters.sort
    print "\n"
    return letter_used
  end

   def add_body_part()
    if @@iteration == 0
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
    elsif @@iteration == 1
      puts " _________"
      puts "|         |"
      puts "|         |"
      puts "|         O"
      puts "|         |"
      puts "|          "
      puts "|          "
      puts "|__________"
      
      puts "5 turns left"

    elsif @@iteration == 2
      puts " _________"
      puts "|         |"
      puts "|         |"
      puts "|         O"
      puts "|         |/"
      puts "|          "
      puts "|          "
      puts "|__________"

      puts "4 turns left"

    elsif @@iteration == 3
      puts " _________"
      puts "|         |"
      puts "|         |"
      puts "|         O"
      puts '|        \|/'
      puts "|          "
      puts "|          "
      puts "|__________"

      puts "3 turns left"

    elsif @@iteration == 4
      puts " _________"
      puts "|         |"
      puts "|         |"
      puts "|         O"
      puts '|        \|/'
      puts "|         | "
      puts "|          "
      puts "|__________"

      puts "2 turns left"
    elsif @@iteration == 5
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
   @@iteration += 1
  end

  def check_if_player_won(chosen_word)
    player_won = false
    split_word = chosen_word.split('')
    if @@current_board.eql?(split_word)
      player_won = true
    end
    if player_won == true
      puts "You won"
      exit
    end
    #puts "I am chosen word: #{split_word}"
    #puts "I am current board: #{@@current_board}"
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
    #puts chosen_word
    return chosen_word
  end
end

class Player
  def guess_letter()
    guess = gets.chomp()
    until guess.length == 1 || guess.count("a-zA-Z") == 1
      guess = gets.chomp()
    end
    return guess
  end
end




cmp1 = Computer.new
chosen_word = cmp1.choose_word_from_dictionary()
board1 = Board.new(chosen_word)
player1 = Player.new
player_won = board1.check_if_player_won(chosen_word)
while player_won == nil
  guess = player1.guess_letter()
  letter_used = board1.check_if_used(guess)
  missed_count = board1.update_lines(chosen_word, guess, letter_used)
  player_won = board1.check_if_player_won(chosen_word)
  if missed_count == 7
    print "\n"
    puts "You lost"
    puts "The answer was: #{chosen_word}"
    print "\n"
    exit
  end
end
puts "Got here "
