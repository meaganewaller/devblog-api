# frozen_string_literal: true

# This class is responsible for transforming records from Notion.
class NotionTransformer
  attr_reader :client, :record, :properties

  PROPERTY_NAMES = {
    author: 'Author',
    cover_image: 'Cover Image',
    date: 'Date',
    last_edited_time: 'Last edited time',
    meta_description: 'Meta Description',
    published: 'Published',
    summary: 'Summary',
    title: 'Name'
  }.freeze

  def initialize(client, record)
    @client = client
    @record = record
    @properties = record.properties
  end

  def self.transform(client, record)
    new(client, record).transform
  end

  def transform
    # Implement in subclass
  end

  protected

  def from_rich_text(property)
    property&.rich_text&.reduce('') { |acc, curr| acc + curr.plain_text } || ''
  end

  def blocks_children(page_id)
    all_blocks = []
    client.block_children(block_id: page_id) do |page|
      all_blocks.concat(page.results)
    end

    all_blocks.reduce('') { |acc, curr| acc + to_md(curr) + "\n\n" }
  end

  def from_files(property)
    property&.files&.first || ''
  end

  def from_title(property)
    property&.title&.first&.plain_text || ''
  end

  def to_md(block)
    prefix = ''
    suffix = ''

    case block['type']
    when 'paragraph'
      # do nothing
    when /heading_(\d)/
      prefix = "#{"\n\n" + '#' * Regexp.last_match(1).to_i} "
      block[block['type'].to_s]['rich_text'].map { _1['annotations']['bold'] = false } # unbold headings
      suffix = "\n\n"
    when 'callout'
      # do nothing
    when 'quote'
      prefix = '> '
    when 'bulleted_list_item'
      prefix = '- '
    when 'numbered_list_item'
      prefix = '1. '
    when 'to_do'
      prefix = block.to_do['checked'] ? '- [x] ' : '- [ ] '
    when 'toggle'
      return "\n\n#{from_rich_text(block.toggle)}\n\n"
    when 'table'
      # do nothing
    when 'code'
      prefix = "\n```#{block['code']['language'].split.first}\n"
      suffix = "\n```\n"
    when 'image'
      return "![#{RichText.to_md(block.image['caption'])}](#{block.image[block.image['type']]['url']})"
    when 'equation'
      return "$$#{block.equation['expression']}$$"
    when 'divider'
      return '---'
    else
      raise 'Unable to convert the block'
    end

    prefix + RichText.to_md(block[block['type'].to_s]['rich_text']) + suffix
  rescue RuntimeError => e
    puts "#{e.message}: #{JSON.pretty_generate(to_h)}"
    "```json\n#{JSON.pretty_generate(to_h)}\n```"
  end

  class RichText
    ATTRIBUTES = %w[
      plain_text href annotations type text mention equation
    ].each { attr_reader _1 }

    def self.to_md(obj)
      return '' unless obj

      obj.is_a?(Array) ? obj.map { |item| new(item).to_md }.join : new(obj).to_md
    end

    def initialize(data)
      ATTRIBUTES.each { instance_variable_set("@#{_1}", data[_1]) }
    end

    def to_md
      md = plain_text

      # Shortcut for equation
      return " $#{md}$ " if type == 'equation'

      md = " <u>#{md}</u> " if annotations['underline']
      md = " `#{md}` " if annotations['code']
      md = " **#{md}** " if annotations['bold']
      md = " *#{md}* " if annotations['italic']
      md = " ~~#{md}~~ " if annotations['strikethrough']
      md = " [#{md}](#{href}) " if href
      md
    end
  end
end
