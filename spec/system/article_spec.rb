require 'rails_helper'

RSpec.describe '管理画面', type: :system do
  let(:admin) { create(:user) }
  let!(:category) { create :category }
  let(:article) { create :article, category: category }
  before do
    login_as(admin)
  end
  describe '投稿のステータス設定' do
    context '記事編集画面から「更新する」を押した際に、ステータスが「下書き状態以外かつ公開日時が未来の日付」に設定された場合' do
      it 'ステータスを「公開待ち」に変更して「更新しました」とフラッシュメッセージを表示' do
        article
        visit edit_admin_article_path(article.uuid)
        fill_in '公開日', with: Time.current.tomorrow
        click_button '更新する'
        expect(find('#article_state')).to have_content '公開待ち'
        expect(page).to have_content "更新しました"
      end
    end
    context '記事編集画面から「更新する」を押した際に、ステータスが「下書き状態以外かつ公開日時が過去の日付」に設定された場合' do
      it 'ステータスを「公開」に変更して「更新しました」とフラッシュメッセージを表示' do
        article
        visit edit_admin_article_path(article.uuid)
        fill_in '公開日', with: Time.current.yesterday
        click_button '更新する'
        expect(find('#article_state')).to have_content '公開'
        expect(page).to have_content "更新しました"
      end
    end
    context '記事編集画面から「更新する」を押した際に、ステータスが「下書き状態」の場合' do
      it 'ステータスは「下書き」のまま「更新しました」とフラッシュメッセージを表示' do
        article = create(:article, :draft)
        visit edit_admin_article_path(article.uuid)
        fill_in '公開日', with: Time.current
        click_button '更新する'
        expect(page).to have_content '下書き'
        expect(page).to have_content "更新しました"
      end
    end
    context '記事編集画面から「公開日時が未来の日付の記事」に「公開する」を押した場合' do
      it 'ステータスを「公開待ち」に変更して「記事を公開待ちにしました」とフラッシュメッセージを表示' do
        article = create(:article , published_at: Time.current.tomorrow)
        visit edit_admin_article_path(article.uuid)
        click_link '公開する'
        expect(find('#article_state')).to have_content '公開待ち'
        expect(page).to have_content "記事を公開待ちにしました"
      end
    end
    context '記事編集画面から「公開日時が過去の日付の記事」に「公開する」を押した場合' do
      it 'ステータスを「公開」に変更して「記事を公開しました」とフラッシュメッセージを表示' do
        article = create(:article , published_at: Time.current.yesterday)
        visit edit_admin_article_path(article.uuid)
        click_link '公開する'
        expect(find('#article_state')).to have_content '公開'
        expect(page).to have_content "記事を公開しました"
      end
    end
  end
end
