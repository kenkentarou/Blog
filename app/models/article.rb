# == Schema Information
#
# Table name: articles
#
#  id           :bigint           not null, primary key
#  category_id  :bigint
#  author_id    :bigint
#  uuid         :string(255)
#  slug         :string(255)
#  title        :string(255)
#  description  :text(65535)
#  body         :text(65535)
#  state        :integer          default("draft"), not null
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  deleted_at   :datetime
#
# Indexes
#
#  index_articles_on_author_id     (author_id)
#  index_articles_on_category_id   (category_id)
#  index_articles_on_deleted_at    (deleted_at)
#  index_articles_on_published_at  (published_at)
#  index_articles_on_slug          (slug)
#  index_articles_on_uuid          (uuid)
#

class Article < ApplicationRecord
  belongs_to :category
  belongs_to :author

  has_many :article_tags
  has_many :tags, through: :article_tags
  has_many :article_blocks, -> { order(:level) }, inverse_of: :article
  has_many :sentences, through: :article_blocks, source: :blockable, source_type: 'Sentence'
  has_many :media, through: :article_blocks, source: :blockable, source_type: 'Medium'
  has_many :embeds, through: :article_blocks, source: :blockable, source_type: 'Embed'

  has_one_attached :eye_cache

  enum state: %i[draft published publish_wait]

  validates :slug, slug_format: true, uniqueness: true, length: { maximum: 255 }, allow_blank: true
  validates :title, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :state, presence: true
  validates :eye_cache, attachment: { purge: true, content_type: %r{\Aimage/(png|jpeg)\Z}, maximum: 10485760 }

  with_options if: :published? do |v|
    v.validates :slug, slug_format: true, presence: true, length: { maximum: 255 }
    v.validates :published_at, presence: true
    v.validates :category_id, presence: true
  end

  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :slug, to: :category, prefix: true, allow_nil: true
  delegate :name, to: :author, prefix: true, allow_nil: true

  before_create -> { self.uuid = SecureRandom.uuid }

  scope :viewable, -> { published.where('published_at < ?', Time.current) }
  scope :new_arrivals, -> { viewable.order(published_at: :desc) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :title_contain, ->(word) { where('title LIKE ?', "%#{word}%") }
  scope :by_author, ->(author_id) { where(author_id: author_id) }
  scope :by_tag, ->(tag_id) { joins(:article_tags).where(article_tags: { tag_id: tag_id }) }
  scope :body_contain, ->(word) { joins(:sentences).where('sentences.body LIKE ?', "%#{word}%") }
  class << self
    def search(search_articles_form)
      relation = Article.distinct
      if search_articles_form.category_id?
        relation = relation.by_category(search_articles_form.category_id)
      end

      if search_articles_form.author_id?
        relation = relation.by_author(search_articles_form.author_id)
      end

      if search_articles_form.tag_id?
        relation = relation.by_tag(search_articles_form.tag_id)
      end

      search_articles_form.title_words.each do |word|
        relation = relation.title_contain(word)
      end

      search_articles_form.body_words.each do |word|
        relation = relation.body_contain(word)
      end

      relation
    end
  end

  def build_body(controller)
    result = ''

    article_blocks.each do |article_block|
      result << if article_block.sentence?
                  sentence = article_block.blockable
                  sentence.body ||= ''
                elsif article_block.medium?
                  medium = ActiveDecorator::Decorator.instance.decorate(article_block.blockable)
                  controller.render_to_string("shared/_media_#{medium.media_type}", locals: { medium: medium }, layout: false)
                elsif article_block.embed?
                  embed = ActiveDecorator::Decorator.instance.decorate(article_block.blockable)
                  controller.render_to_string("shared/_embed_#{embed.embed_type}", locals: { embed: embed }, layout: false)
                end
    end

    result
  end

  def next_article
    @next_article ||= Article.viewable.order(published_at: :asc).where('published_at > ?', published_at).first
  end

  def prev_article
    @prev_article ||= Article.viewable.order(published_at: :desc).where('published_at < ?', published_at).first
  end

  def assign_state
    self.state = if Time.current < published_at
                   :publish_wait
                 else
                   :published
                 end
  end
end
