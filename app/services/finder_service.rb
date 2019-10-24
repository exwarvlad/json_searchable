# frozen_string_literal: true
require 'open-uri'

class FinderService
  attr_reader :params

  def initialize(params)
    @params = JSON(params.permit(:name, :type, :designed).to_json, symbolize_names: true).delete_if { |_k, v| v.blank? }
    @founder = FOUNDER
  end

  def call
    result = params.each_key {|k| @founder = send("find_by_#{k}")}

    if result.blank? || @founder.blank?
      nil
    else
      @founder
    end
  end

  private

  def find_by_name
    result = @founder&.bsearch { |status| params[:name] <=> status['Name'] }
    [result] if result
  end

  def find_by_type
    search_match('Type', params[:type])
  end

  def find_by_designed
    search_match('Designed by', params[:designed])
  end

  def search_match(founder_key, param)
    @founder&.select do |hash|
      attr = hash[founder_key].delete(' ').split(',')
      has_match?(attr, param.delete(' '))
    end
  end

  def has_match?(array, param)
    has_match = false
    array.each { |item| break has_match = true if item =~ /#{param}/  }
    has_match
  end
end
