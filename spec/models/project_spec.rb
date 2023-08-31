# == Schema Information
#
# Table name: projects
#
#  id                   :uuid             not null, primary key
#  contributors         :text             default([]), is an Array
#  creation_date        :date
#  demo_screenshot_urls :string           default([]), is an Array
#  description          :text             not null
#  difficulty_level     :string
#  documentation_url    :string
#  featured             :boolean          default(FALSE)
#  framework            :string
#  homepage_url         :string
#  language             :string
#  last_update          :date
#  license              :string
#  open_issues          :integer          default(0)
#  pull_requests        :integer          default(0)
#  repository_url       :string
#  slug                 :string           not null
#  status               :integer          default("active")
#  tags                 :text             default([]), is an Array
#  title                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_projects_on_featured  (featured)
#  index_projects_on_language  (language)
#  index_projects_on_slug      (slug) UNIQUE
#  index_projects_on_tags      (tags) USING gin
#  index_projects_on_title     (title) UNIQUE
#
require 'rails_helper'

RSpec.describe Project, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
