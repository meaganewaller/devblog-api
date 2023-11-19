# frozen_string_literal: true

require "faker"

Project.delete_all
Category.delete_all
Reaction.delete_all
View.delete_all
Post.delete_all

categories = ["Tutorials & Guides", "Toolbox", "How-to & Tips", "Deep Dives", "Best Practices", "News & Updates",
  "Profesional Development", "Coding Challenges", "Opinion & Analysis", "Case Studies",
  "Interviews & Profiles", "Opportunities & Events"]

categories.each do |category|
  Category.create!(
    cover_image: "http://placekitten.com/800/600",
    description: Faker::TvShows::BojackHorseman.quote,
    title: category,
    notion_id: Faker::Internet.uuid
  )
end

10.times do |project|
  date = Faker::Date.between(from: "2020-01-01", to: "2023-09-01")
  notion_created = Faker::Date.between(from: date, to: date + 10.days)
  Project.create!(
    contributors: [1, 2].map { |_| Faker::TvShows::Buffy.character },
    creation_date: date,
    demo_screenshot_urls: [1, 2, 3].map { |_| Faker::Placeholdit.image(size: "800x600") },
    description: Faker::TvShows::Buffy.quote,
    featured: [true, false, false, false, false, true, false, true].sample,
    framework: ["Next.js", "Rails", nil].sample,
    homepage_url: Faker::Internet.url(host: "example.com"),
    language: Faker::ProgrammingLanguage.name,
    last_update: Faker::Date.between(from: date, to: Time.zone.today),
    license: "MIT",
    notion_created_at: notion_created,
    notion_updated_at: Faker::Date.between(from: notion_created, to: Time.zone.today),
    repository_url: Faker::Internet.url(host: "github.com/meaganewaller"),
    tags: [1, 2, 3].map { |_| Faker::Hobby.activity },
    title: "#{Faker::App.name} - #{Faker::Lorem.words(number: project)}",
    notion_id: Faker::Internet.uuid
  )
end

30.times do
  date = Faker::Date.between(from: "2014-01-01", to: Time.zone.today)
  notion_created = Faker::Date.between(from: date, to: date + 10.days)

  Post.create!(
    content: Faker::Markdown.sandwich(sentences: 15, repeat: 2),
    cover_image: "http://placekitten.com/800/600",
    description: Faker::TvShows::Community.quotes,
    meta_description: Faker::TvShows::TwinPeaks.quote,
    meta_keywords: [1, 2, 3].map { |_| Faker::Hobby.activity },
    notion_created_at: notion_created,
    notion_updated_at: Faker::Date.between(from: notion_created, to: Time.zone.today),
    published: true,
    published_date: date,
    status: 6,
    tags: [1, 2, 3].map { |_| Faker::Hobby.activity },
    title: Faker::TvShows::Seinfeld.quote,
    category_id: Category.pluck(:id).sample,
    notion_id: Faker::Internet.uuid,
    notion_slug: Faker::Internet.slug
  )
end

Post.all.each do |post|
  view_count = rand(10..10_000)
  puts "Adding #{view_count} views to #{post.slug}"
  views = Array.new(view_count).map do
    {
      viewable_slug: post.slug,
      viewable_type: "Post",
      session_id: Faker::Internet.uuid
    }
  end
  View.insert_all(views)

  puts "Adding reactions to #{post.slug}"
  10.times do |_|
    post.reactions.create(kind: [0, 1, 2, 3, 4, 5].sample, session_id: Faker::Internet.uuid)
  end
end
