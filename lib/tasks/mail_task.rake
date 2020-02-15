namespace :mail_task do
  desc '毎日am9:00に管理者に公開記事の情報をmailerで送信'
  task mail: :environment do
    ArticleMailer.published_email.deliver_now
  end
end
