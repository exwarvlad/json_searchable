class FinderController < ApplicationController
  def index; end

  def find_out
    render 'finder/finder'
  end
end
