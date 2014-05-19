namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users  
    make_products
    make_courses
  end
end

def make_users
  User.create!(username: "jorik",
    email: "l.masilevich@gmail.com",
    password: "foobar",
    password_confirmation: "foobar",
    confirmed_at: "21.04.2014" 
    )
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

  def make_products
    users = User.all
    users.each { |user| user.products.create!(name: "Капуста для #{user.username}") }
    users.each { |user| user.products.create!(name: "Картошка для #{user.username}") }
  end

  def make_courses
    users = User.all
    users.each { |user| user.courses.create!(name: "Пюре для #{user.username}") }
    users.each { |user| user.courses.create!(name: "Курица для #{user.username}") }
  end
  
end
