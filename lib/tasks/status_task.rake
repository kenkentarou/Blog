#require Rails.root.join(“app/models/article.rb”)

namespace :status_task do
  desc '公開状態にする'
  task published: :environment do
    Article.publish_wait.each do |article|
      article.published!
    end
  end
end
