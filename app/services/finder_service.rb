# frozen_string_literal: true
require 'open-uri'

class FinderService
  attr_reader :params

  def initialize(params, founder = FOUNDER)
    @params = params
    @founder = founder
  end

  def call
    return if params.to_h.empty?

    params.keys.each { |k| self.founder = send("slice_by_#{k}", founder) }
    self.founder = nil if founder == []
    founder
  end

  private

  attr_accessor :founder

  def slice_by_name(founder)
    result = founder&.bsearch { |status| params[:name] <=> status['Name'] }
    [result] if result
  end

  def slice_by_type(founder)
    search_match(founder: founder, json_key: 'Type', param: params[:type])
  end

  def slice_by_designed(founder)
    search_match(founder: founder, json_key: 'Designed by', param: params[:designed])
  end

  def search_match(founder:, json_key:, param:)
    founder&.select do |hash|
      attr = hash[json_key].delete(' ').split(',')
      (attr & param.delete(' ').split(',')).any?
    end
  end
end
