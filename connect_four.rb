class Game

  def initialize(num_of_players=1)
    @player1 = Player.new("X", "Player 1")
    @board = Board.new

    if num_of_players == 1
      @player2 = Computer.new("O", "The Computer")
    else
      @player2 = Player.new("O", "Player 2")
    end

    @current_player = @player1
  end

  def play
    loop do

      @board.render

      check_move(@current_player.get_move)

      break if check_win

      break if check_full_board

      switch_player

    end
  end

  def check_move(move)
    puts move
    if move > 7 || move < 1
      puts "Invalid move! It is out of bounds."
      check_move(@current_player.get_move)
    elsif @board.columns[move].length == 7
      puts "Invalid move! Column #{move} is full."
      check_move(@current_player.get_move)
    else
      @board.columns[move] << @current_player.piece
    end
  end

  def check_full_board
    @board.columns.each do |column, value|
      if @board.columns[column].count < 7
        return false
      end
    end
    @board.render
    puts "Game Over! No winners. The board is full!"
    return true
  end

  def check_win
    if horizontal_win?
      @board.render
      puts "#{@current_player.title} has won the game!"
      return true
    else
      return false
    end
  end

  def horizontal_win?
    (0..2).each do |offset|
      (0..6).each do |row|
        tile1 = @board.columns[1 + offset][row]
        tile2 = @board.columns[2 + offset][row]
        tile3 = @board.columns[3 + offset][row]
        tile4 = @board.columns[4 + offset][row]
        return true if [tile1, tile2, tile3, tile4].count(@current_player.piece) == 4
      end
    end
    return false
  end

  def switch_player
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end

  def over?
    if horizontal_win?
      return true
    else
      return false
    end
  end

end

class Player

  attr_reader :piece, :title

  def initialize(piece, title)
    @piece = piece
    @title = title
  end

  def get_move
    puts "Enter 1-6 to make a move."
    move = gets.chomp
    return move.to_i
  end

end

class Computer

  attr_reader :piece, :title

  def initialize(piece, title)
    @piece = piece
    @title = title
  end

end

class Board

  attr_reader :columns

  def initialize
    @columns = (1..6).each_with_object({}) { |num, col| col[num] = [] }
  end

  def render
    6.downto(0) do |num|
      print "|#{@columns[1][num]}\t|"
      print "#{@columns[2][num]}\t|"
      print "#{@columns[3][num]}\t|"
      print "#{@columns[4][num]}\t|"
      print "#{@columns[5][num]}\t|"
      print "#{@columns[6][num]}\t|\n"
    end
  end

end

puts "Welcome to Connect 4!\n1 or 2 Players?"
num_of_players = gets.chomp
game = Game.new(num_of_players.to_i)
game.play
