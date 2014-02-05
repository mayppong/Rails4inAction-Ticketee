module AuthenticationHelpers

  def sign_in_as!( user )
    visit '/signin'
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button 'Sign in'
    expect( page ).to have_content( 'Signed in successfully.' )
  end
  def sign_in( user )
    session[:user_id] = user.id
  end

end

RSpec.configure do |c|
  c.include( AuthenticationHelpers, type: :controller )
  c.include( AuthenticationHelpers, type: :feature )
end
