namespace :status_task do
  desc '公開状態にする'
  task :published do
    if @article.waiting_publish?
      @article.state = :published
    end
  end
end
