class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.new
    @game.generate_map


    if @game.save
      @player1 = Player.new
      @player2 = Player.new
      @player1.game = @game
      @player2.game = @game
      @player1.host = true
      @player2.host = false
      @player1.save!
      @player2.save!

      redirect_to edit_player_path(@player1)
    end


  end

  def show
    @game = Game.find(params['format'])
    @player = Player.find(params['player'])
  end

  def join

  end

  def confirm_join
    game_id = params['join-id']
    @player = Player.find(game_id)
    if @player.nil?
      redirect_to join_games_path
    end
    redirect_to games_path(@player.game, player: @player)
  end

  def play

  end
end