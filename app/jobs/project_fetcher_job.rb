# frozen_string_literal: true

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
    found_project.update!(
      title: project[:title],
      description: project[:description],
      notion_created_at: project[:notion_created_at],
      notion_updated_at: project[:notion_updated_at],
      notion_id: project[:notion_id],
      tags: project[:tags],
      status: get_status(project[:status])
      # content: project[:content],
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end

  def create_project(project)
    Project.create!(
      notion_id: project[:notion_id],
      title: project[:title],
      description: project[:description],
      notion_created_at: project[:notion_created_at],
      notion_updated_at: project[:notion_updated_at],
      tags: project[:tags],
      status: get_status(project[:status])
      # content: project[:content],
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end

  def get_status(status)
    {
      "Inbox" => "inbox",
      "Needs Refinement" => "needs_refinement",
      "Ready for Work" => "ready_for_work",
      "Outlining" => "outlining",
      "Drafting" => "drafting",
      "Editing" => "editing",
      "Published" => "published"
    }[status]
  end

  def get_category_id(category_notion_id)
    return unless category_notion_id

    Category.find_by(notion_id: category_notion_id)&.id
  end

  def get_cover_image(cover_image)
    return unless cover_image
    return cover_image["file"]["url"] if cover_image.key?("file")

    cover_image["external"]["url"]
  end
end
