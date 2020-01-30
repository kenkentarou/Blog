class Admin::Articles::PublishesController < ApplicationController
  layout 'admin'

  before_action :set_article

  def update
    @article.published_at = Time.current unless @article.published_at?
    @article.state = :published

    if @article.valid?
      Article.transaction do
        @article.body = @article.build_body(self)
      end
        @article.assign_state
        @article.save
      flash[:notice] = flash_message(@article)
      redirect_to edit_admin_article_path(@article.uuid)
    else
      flash.now[:alert] = 'エラーがあります。確認してください。'

      @article.state = @article.state_was if @article.state_changed?
      render 'admin/articles/edit'
    end
  end

  private

  def set_article
    @article = Article.find_by!(uuid: params[:article_uuid])
  end

  def flash_message(article)
    if article.published?
      '記事を公開しました'
    elsif article.publish_wait?
      '記事を公開待ちにしました'
    end
  end
end
