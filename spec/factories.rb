FactoryGirl.define do
  factory :user, :aliases => [:sender, :recipient] do
    sequence(:username)  { |n| "person_#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end

    factory :confirmed_user do
      confirmed_at Time.now
    end
  end

  factory :product do
    name "Огурец"
    user
  end

  factory :course do
    name "Рыба жареная"
    user
  end
end