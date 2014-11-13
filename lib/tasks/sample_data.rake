namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users  
    make_products
    make_courses
    make_menus
    make_categories
  end
end

def make_users
  @admin = User.create!(username: "jorik",
    email: "l.masilevich@gmail.com",
    password: "foobar",
    password_confirmation: "foobar",
    confirmed_at: "21.04.2014" 
    )
  @admin.admin!
  10.times do |n|
    full_name  = Faker::Name.name
    username  = full_name.split.join('_').downcase
    username.gsub!("'","")
    username.gsub!(".","")
    if username.size > 15
      username = username.slice(0,15)
    end
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(
      username: username,
      email: email,
      password: password,
      password_confirmation: password,
      confirmed_at: "21.04.2014")
  end

end

def make_products
  users = User.all
  users.each { |user| user.products.create!(name: "Капуста для #{user.username}") }
  users.each { |user| user.products.create!(name: "Картошка для #{user.username}") }
  Product.create!(name: "Общий продукт1", common: true)
  Product.create!(name: "Общий продукт2", common: true)
end

def make_courses
  users = User.all
  users.each { |user| user.courses.create!(name: "Пюре для #{user.username}") }
  users.each { |user| user.courses.create!(name: "Курица для #{user.username}") }
end

def make_menus
  user = User.first
  user.menus.create!(date: Time.now()) 
  user.menus.create!(date: (Time.now() - 1.day))
end

def make_categories
  user = User.first
  user.categories.product_categories.create!(name: "Овощи") 
  user.categories.product_categories.create!(name: "Фрукты") 
  user.categories.menu_categories.create!(name: "Обеденное") 
  user.categories.menu_categories.create!(name: "Вечернее") 
  user.categories.course_categories.create!(name: "Первые") 
  user.categories.course_categories.create!(name: "Гарниры")
end
