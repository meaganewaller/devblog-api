require "rails_helper"

RSpec.describe Api::V1::CreateContactEntry do
  describe ".call" do
    it "creates a Notion page" do
      params = {
        name: "John Doe",
        email: "john@example.com",
        subject: "Hello",
        message: "Hello, World!"
      }

      expect_any_instance_of(Notion::Client).to receive(:create_page).with(
        parent: {database_id: ENV["NOTION_CONTACT_FORM_DATABASE_ID"]},
        properties: {
          Name: {
            title: [
              {
                text: {
                  content: params[:name]
                }
              }
            ]
          },
          Email: {
            email: params[:email]
          },
          Subject: {
            rich_text: [
              {
                text: {
                  content: params[:subject]
                }
              }
            ]
          }
        },
        children: [
          {
            object: "block",
            type: "heading_1",
            heading_1: {
              rich_text: [{
                type: "text",
                text: {content: "Email from " + params[:name]}
              }]
            }
          },
          {
            object: "block",
            type: "paragraph",
            paragraph: {
              rich_text: [
                {
                  type: "text",
                  text: {
                    content: params[:message]
                  }
                }
              ]
            }
          }
        ]
      )

      described_class.call(params)
    end
  end
end
