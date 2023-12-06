# frozen_string_literal: true

require 'open-uri'

class ProjectFetcherJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    projects = NotionAdapter.fetch_projects

    return if projects.empty?

    existing_projects = Project.where(notion_id: projects.map { |project| project[:notion_id] }).index_by(&:notion_id)

    projects.each do |project|
      found_project = existing_projects[project[:notion_id]]
      if skip?(found_project, project)
        Rails.logger.info("Skipping #{project[:title]} because it's already up to date")
        next
      end

      update_project(found_project, project) if found_project
      create_project(project)
    end
  end

  private

  def skip?(found_project, project)
    found_project && found_project.notion_updated_at >= project[:notion_updated_at].to_date
  end

  def update_project(found_project, project)
    image = project[:cover_image]
    image_url = image.dig("file", "url") || image.dig("external", "url")
    if image_url.present?
      puts "Downloading #{image_url}"
      file = URI.open(image_url)
      found_project.cover_image.attach(io: file, filename: "#{project.title.downcase.gsub(' ','_')}_cover_image.png")
    end

    found_project.update!(
      content: project[:content],
      description: project[:description],
      link: project[:link],
      notion_created_at: project[:notion_created_at],
      notion_id: project[:notion_id],
      notion_updated_at: project[:notion_updated_at],
      repository_links: project[:repository_links],
      tags: project[:tags],
      title: project[:title],
      cover_image: image_url,
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end

  def create_project(project)
    image = project[:cover_image]
    image_url = image.dig("file", "url") || image.dig("external", "url")

    Project.create!(
      content: project[:content],
      description: project[:description],
      link: project[:link],
      notion_created_at: project[:notion_created_at],
      notion_id: project[:notion_id],
      notion_updated_at: project[:notion_updated_at],
      repository_links: project[:repository_links],
      tags: project[:tags],
      title: project[:title],
      cover_image: image_url,
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end
end
