FactoryGirl.define do
  factory :user do
    name     'steven'
    email    'user@example.com'
    password 'password'
    password_confirmation 'password'
  end
end
