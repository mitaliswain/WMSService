class PutawayController < ApplicationController

  protect_from_forgery except: :index

  def validate
    putaway = Putaway::CasePutaway.new(params[:putaway])
    putaway.is_valid_putaway?(params[:to_validate])
    render json: putaway.message.to_json, status: putaway.message[:status]

  end

  def putaway
    putaway = Putaway::CasePutaway.new(params[:putaway])
    putaway.case_putaway
    render json: putaway.message.to_json, status: putaway.message[:status]
  end

end