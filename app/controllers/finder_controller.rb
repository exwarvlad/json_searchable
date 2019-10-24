class FinderController < ApplicationController
  def index; end

  def find_out
    render 'finder/finder', locals: { finder: FinderService.new(params).call }
  end
end
