require 'spec_helper'

feature 'Seed Data' do
  
  scenario 'the basics' do
    #load "#{Rails.root}/db/seeds.rb"
    Rails.application.load_seed
    user = User.where( email: 'admin@example.com' ).first!
    project = Project.where( name: 'Ticketee Beta' ).first!
  end

end
