FactoryGirl.define do
  factory :user do
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
    factory :available_product do
      available true
    end

    factory :unavailable_product do
      available false
    end
  end

  factory :course do
    name "Рыба жареная"
    user

    factory :course_with_available_product do
      products {[FactoryGirl.create(:available_product, user: user, name: "available_product")]}
    end

    factory :course_with_unavailable_product do
      products {[FactoryGirl.create(:unavailable_product, user: user, name: "unavailable_product")]}
    end
  end

end