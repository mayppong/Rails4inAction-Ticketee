FactoryGirl.define do

  # increment the email handler by 1 each time we create a new user
  sequence( :email ) { |n|
    "user#{n}@example.con"
  }

  factory :user do
    name     'steven'
    email    { generate( :email ) }
    password 'password'
    password_confirmation 'password'

    factory :admin_user do
      admin true
    end

  end
end
