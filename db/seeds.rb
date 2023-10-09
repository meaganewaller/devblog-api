# frozen_string_literal: true
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
Project.delete_all
Post.delete_all

batch = GoodJob::Batch.new
batch.add do
  CategoryFetcherJob.perform_later
  ProjectFetcherJob.perform_later
end
batch.enqueue(on_finish: PostFetcherJob)
