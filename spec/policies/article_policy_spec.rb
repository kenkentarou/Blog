require 'rails_helper'

RSpec.describe '管理画面', type: :system do
  describe '投稿' do
    let(:user) { create(:user, name: 'admin' ) }
    let(:site) { create(:site) }
    before do
      user
      site
      visit admin_login_identifier_path
      fill_in 'user_name' ,with: 'admin'
      click_button '次へ'
      fill_in 'user_password', with: 'password'
      click_button 'ログイン'
    end
    context '画像を挿入せずに投稿' do
      it '投稿が成功する' do
        visit admin_dashboard_path
        click_link '記事'
        click_link '新規作成'
        fill_in 'タイトル', with: Faker::Name.name
        fill_in 'スラッグ', with: 'abc'
        click_button '登録する'
        click_link 'ブロックを追加する'
        click_link '画像'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_selector('.media-image', visible: false)
      end
    end
  end
end
