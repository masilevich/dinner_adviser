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
    sequence(:name) { |n| "Продукт #{n}" }
    user
    factory :available_product do
      available true
    end

    factory :unavailable_product do
      available false
    end
  end

  factory :course do
    sequence(:name) { |n| "Блюдо #{n}" }
    user

    factory :course_with_available_product do
      products {[FactoryGirl.create(:available_product, user: user)]}
    end

    factory :course_with_unavailable_product do
      products {[FactoryGirl.create(:unavailable_product, user: user)]}
    end

    factory :course_with_products do
      ignore do
        products_count 2
      end
      after(:create) do |course, evaluator|
        create_list(:product, evaluator.products_count, courses: [course])
      end
      #using create(:course_with_products, products_count: 15).products.length # 15
    end
  end


  factory :course_kind do
    sequence(:name) { |n| "Вид блюда #{n}" }
    user
  end

  factory :product_kind do
    sequence(:name) { |n| "Вид продукта #{n}" }
    user
  end

  factory :menu do
    date Time.now
    user

    factory :menu_with_courses do
      ignore do
        courses_count 2
      end
      after(:create) do |menu, evaluator|
        create_list(:course, evaluator.courses_count, menus: [menu])
      end
      #using create(:course_with_products, products_count: 15).products.length # 15
    end
  end

  factory :menu_kind do
    sequence(:name) { |n| "Вид меню #{n}" }
    user
  end

end