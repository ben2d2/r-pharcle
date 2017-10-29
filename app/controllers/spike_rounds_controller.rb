class SpikeRoundsController < ApplicationController
  def index
    @roll_em = Round.new.turn
  end
end
