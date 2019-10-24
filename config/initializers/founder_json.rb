# frozen_string_literal: true
require 'open-uri'

URI_OF_JSON = 'https://gist.githubusercontent.com/g3d/d0b84a045dd6900ca4cb/raw/5189f24f375cb1bf2f1739866165d3fcc336564f/data.json'
FOUNDER = JSON.load(open(URI_OF_JSON)).freeze
