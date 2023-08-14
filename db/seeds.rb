# This file should contain all the record creation needed to seed the database with its default values.
#
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

Category.delete_all
Post.delete_all

# Create some categories
["Ruby", "Rails", "HTML", "CSS", "JavaScript", "React", "Vue"].each do |category|
  Category.create!(
    title: category,
    slug: category.downcase,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    notion_id: "notion-id_#{category}"
  )
end

# Create some posts
Category.all.each do |category|
  5.times do |i|
    created_date = Faker::Date.between(from: 2.months.ago, to: Date.today)
    Post.create!(
      title: Faker::Lorem.sentence(word_count: 3),
      slug: Faker::Internet.slug(words: "notion post #{i} #{category.title}", glue: "-"),
      description: Faker::Lorem.paragraph(sentence_count: 2),
      notion_id: "notion-id_post-#{i}-#{category.title}",
      notion_created_at: created_date,
      notion_updated_at: Faker::Date.between(from: created_date, to: Date.today),
      notion_slug: Faker::Internet.slug(words: "notion post #{i} #{category.title}", glue: "-"),
      published: true,
      published_date: Faker::Date.between(from: created_date, to: Date.today),
      category: category
    )
  end
end
