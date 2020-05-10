class PlayersController < ApplicationController

  def show
    @player = Player.find(params[:format])
    Player.where(game_id: @player.game.id).each do |player|
      unless player.id == @player.id
        @other_player = player
      end
    end
  end
  def edit
    @player = Player.find(params[:format])
  end

  def update
    @player = Player.find(params[:format])
    if params['avatar'] == 'jemma'
      @player.avatar = 0
      Player.where(game_id: @player.game.id).each do |player|
        unless player.id == @player.id
          player.avatar = 1
          player.save!
        end
      end
      @player.save!
    else
      @player.avatar = 1
      Player.where(game_id: @player.game.id).each do |player|
        unless player.id == @player.id
          player.avatar = 0
          player.save!
        end
      end
      @player.save!
    end
    redirect_to player_path(@player)
  end
end