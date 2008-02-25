require File.join(File.dirname(__FILE__), *%w[helper])
require 'stories/item_steps.rb'

with_steps_for :item_submit do
  run File.expand_path(__FILE__).gsub(".rb",""), :type => RailsStory
end
