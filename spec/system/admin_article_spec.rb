require 'rails_helper'

RSpec.describe '管理画面', type: :system do
  let(:admin) { create(:admin_user) }
  let(:article) { create :article }
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
    context '記事編集画面から画像位置を指定して更新した場合' do
      it '右寄せで指定して更新するとプレビュー画面で右寄せに画像が表示' do
        article = create(:article , published_at: Time.current.tomorrow)
        visit edit_admin_article_path(article.uuid)
        attach_file 'アイキャッチ', Rails.root.join('spec', 'fixtures', 'images', 'fixture.png')
        choose '右寄せ'
        fill_in '横幅', with: '100'
        click_button '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_css('.text-right')
      end
      it '中央で指定して更新するとプレビュー画面で中央に画像が表示' do
        article = create(:article , published_at: Time.current.tomorrow)
        visit edit_admin_article_path(article.uuid)
        attach_file 'アイキャッチ', Rails.root.join('spec', 'fixtures', 'images', 'fixture.png')
        choose '右寄せ'
        fill_in '横幅', with: '100'
        click_button '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_css('.text-center')
      end
      it '左寄せで指定して更新するとプレビュー画面で左寄せに画像が表示' do
        article = create(:article , published_at: Time.current.tomorrow)
        visit edit_admin_article_path(article.uuid)
        attach_file 'アイキャッチ', Rails.root.join('spec', 'fixtures', 'images', 'fixture.png')
        choose '左寄せ'
        fill_in '横幅', with: '100'
        click_button '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_css('.text-left')
      end
    end
  end
end
