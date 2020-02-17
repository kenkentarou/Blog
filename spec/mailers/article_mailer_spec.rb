require "rails_helper"

RSpec.describe ArticleMailer, type: :mailer do
  describe "公開済み記事の情報を管理者へ送信する" do
    let(:mail) { ArticleMailer.report_summary.deliver_now }
    let(:article_draft) { create(:article, :draft) }
    let(:article_published_at_yesterday) { create(:article, :publised_at_yesterday, title: '昨日の記事') }
    let(:article_published_at_3days_ago) { create(:article, :published_at_3days_ago, title: '１週間以内の記事') }
    context 'メールを管理者のメールアトレスに送信する' do
      it 'admin@example.comへ送信' do
        expect(mail.to).to eq ['admin@example.com']
      end
    end
    context '正しい件名で送信する' do
      it '件名に「公開済記事の集計結果」と表示' do
        expect(mail.subject).to eq '公開済記事の集計結果'
      end
    end
    context '公開済みの記事が存在しない場合' do
      it '「昨日公開された記事はありません」と表示' do
        expect(mail.body).to have_content '昨日公開された記事はありません'
      end
    end
    context '昨日公開済みの記事が存在する場合' do
      it '昨日公開済みの記事の情報を表示' do
        article_published_at_yesterday
        expect(mail.body).to have_content '公開済の記事数: 1件'
        expect(mail.body).to match('昨日公開された記事数: 1件')
        expect(mail.body).to have_content '昨日の記事'
        expect(mail.body).to have_content '公開日時'
      end
    end
    context '公開日が昨日と1週間以内の記事が両方存在する場合' do
      it '昨日公開済みの記事の情報のみを表示' do
        article_published_at_yesterday
        article_published_at_3days_ago
        expect(mail.body).to have_content '公開済の記事数: 2件'
        expect(mail.body).to match('昨日公開された記事数: 1件')
        expect(mail.body).to have_content '昨日の記事'
        expect(mail.body).not_to have_content '１週間以内の記事'
      end
    end
  end
end
