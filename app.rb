require 'sinatra'
require 'trello'

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end


get '/cards' do
  board = Trello::Board.find(ENV['BOARD_ID'])
  cards = board.cards.reject { |card| !card.member_ids.include?(ENV['USER_ID']) }
  cards.to_json
end

get '/log' do
  halt 400 unles params[:card_id].present?
  card = Trello::Card.find(params[:card_id])
  halt 403 unless card.member_ids.include?(ENV['USER_ID'])
  card.add_comment('holis')
  'ok'
end
