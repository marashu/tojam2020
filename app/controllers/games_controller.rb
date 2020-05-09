class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.new
    @game.generate_map
    if @game.save
      redirect_to games_url(@game)
    end


  end

  def show
    @game = Game.find(params['format'])
  end

  def join

  end

  def play

  end
end