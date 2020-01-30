namespace :status_task do
  desc '公開状態にする'
  task published: :environment do
    Article.publish_wait.find_each do |article|
      if article.published_at < Time.current
      article&.published!
      end
    end
  end
end
