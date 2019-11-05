# frozen_string_literal: true
require 'open-uri'

class FinderService
  attr_reader :params

  def initialize(params, founder = FOUNDER)
    @params = require_params(params)
    @founder = founder
  end

  def call
    result = params.keys.each { |k| self.founder = send("find_by_#{k}") }
    result.blank? ? nil : founder
  end

  private

  attr_accessor :founder

  def find_by_name
    result = founder&.bsearch { |status| params[:name] <=> status['Name'] }
    [result] if result
  end

  def find_by_type
    search_match('Type', params[:type])
  end

  def find_by_designed
    search_match('Designed by', params[:designed])
  end

  def search_match(founder_key, param)
    result =
      founder&.select do |hash|
        attr = hash[founder_key].delete(' ').split(',')
        has_match?(attr, param.delete(' '))
      end

    self.founder = result if result.present?
  end

  def has_match?(array, param)
    has_match = false
    array.each { |item| break has_match = true if item =~ /#{param}/ }
    has_match
  end

  def require_params(params)
    JSON(params.permit(:name, :type, :designed).to_json, symbolize_names: true).select { |_k, v| v.present? }
  end
end
