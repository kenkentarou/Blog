require 'rails_helper'

RSpec.describe '管理画面', type: :system do
  describe '投稿' do
    let(:admin) { create(:user) }
    context '画像を挿入せずに投稿' do
      it '投稿が成功する' do
        login_as(admin)
        visit admin_dashboard_path
        click_link '記事'
        click_link '新規作成'
        fill_in 'タイトル', with: 'テストテスト'
        fill_in 'スラッグ', with: 'aaaa'
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
