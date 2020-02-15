class ArticleMailer < ApplicationMailer
  def published_email
    @article_count = Article.count
    @articles_published_at_yesterday = Article.where(published_at: Time.current.yesterday)
    mail(to: 'admin@example.com', subject: '公開済記事の集計結果')
  end
end
