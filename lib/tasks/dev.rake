namespace :dev do
  task fake_posts: :environment do
    Post.destroy_all

    20.times do |i|
      number = rand(1..9)
      file = File.open("#{Rails.root}/public/image/image#{number}.jpg")

      Post.create!(
        title: FFaker::Book.title,
        description: FFaker::Lorem.paragraph,
        image: file
      )
    end
    puts "have created fake Posts"
    puts "now you have #{Post.count} posts data"
  end
end