class FinderController < ApplicationController
  def index; end

  def find_out
    render 'finder/finder', locals: { finder: FinderService.new(set_params, FOUNDER).call }
  end

  private

  def set_params
    params.permit(:name, :type, :designed).select { |_k, v| v.present? }
  end
end
