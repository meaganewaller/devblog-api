# frozen_string_literal: true

module Api
  module V1
    class CreateContactEntry
      def self.call(params)
        puts "PARAMS ARE: #{params.inspect}"
        properties = {
          Name: {
            title: [
              {
                text: {
                  content: params['name']
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
        }
        children = [
          {
            object: 'block',
            type: 'heading_1',
            heading_1: {
              rich_text: [{
                type: 'text',
                text: { content: "Email from #{params[:name]}" }
              }]
            }
          },
          {
            object: 'block',
            type: 'paragraph',
            paragraph: {
              rich_text: [
                {
                  type: 'text',
                  text: {
                    content: params[:message]
                  }
                }
              ]
            }
          }
        ]
        client = Notion::Client.new
        client.create_page(
          parent: { database_id: ENV['NOTION_CONTACT_FORM_DATABASE_ID'] },
          properties:,
          children:
        )
      end
    end
  end
end
