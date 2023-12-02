class BlogPostAdapter < CmsAdapter
  def initialize(cms_adapter)
    @cms_adapter = cms_adapter
  end

  def fetch_blog_posts
    @cms_adapter.fetch_data(:blog_post)
  end
end
