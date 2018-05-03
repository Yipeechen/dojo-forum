namespace :dev do
  task fake_posts: :environment do
    Post.destroy_all

    20.times do |i|
      number = rand(1..9)
      file = File.open("#{Rails.root}/public/image/image#{number}.jpg")

      Post.create!(
        title: FFaker::Book.title,
        description: FFaker::Lorem.paragraph,
        image: file,
        category_ids: [rand(1..3), rand(4..7)],
        user: User.all.sample
      )
    end
    puts "have created fake Posts"
    puts "now you have #{Post.count} posts data"
  end

  task fake_users: :environment do
    30.times do |i|
      user_name = FFaker::Name.first_name
      number = rand(1..10)
      file = File.open("#{Rails.root}/public/avatar/user#{number}.jpg")

      User.create!(
        name: user_name,
        email: "#{user_name}@example.com",
        password: "12345678",
        avatar: file,
        introduction: FFaker::Lorem::sentence(30)
      )
    end
    puts "have created fake users"
    puts "now you have #{User.count} users data"
  end

  task fake_replies: :environment do
    Post.all.each do |post|
      3.times do |i|
        post.replies.create!(
          content: FFaker::Lorem.sentence,
          user: User.all.sample
        )
      end
    end
    puts "have created fake replies"
    puts "now you have #{Reply.count} replies data"
  end

  task fake_all: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
    Rake::Task['dev:fake_users'].execute
    Rake::Task['dev:fake_posts'].execute
    Rake::Task['dev:fake_replies'].execute
  end
end