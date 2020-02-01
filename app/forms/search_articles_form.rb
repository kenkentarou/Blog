class SearchArticlesForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attribute :category_id, Integer
  attribute :author_id, Integer
  attribute :tag_id, Integer
  attribute :title, String
  attribute :body, String

  def category_id?
    category_id.present?
  end

  def title?
    title.present?
  end

  def title_words
    title? ? title.split(nil) : []
  end

  def author_id?
    author_id.present?
  end

  def tag_id?
    tag_id.present?
  end

  def body?
    body.present?
  end

  def body_words
    body? ? body.split(nil) : []
  end
end
