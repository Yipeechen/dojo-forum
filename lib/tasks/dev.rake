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
        category_ids: [rand(1..3), rand(4..7)]
      )
    end
    puts "have created fake Posts"
    puts "now you have #{Post.count} posts data"
  end

  task fake_all: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
    Rake::Task['dev:fake_posts'].execute
  end
end