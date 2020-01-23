require 'rails_helper'

RSpec.describe '管理画面', type: :system do
  describe 'タグ' do
    let(:admin) { create(:user) }
    context 'パンくず表示' do
      it 'タグ一覧画面でパンくず表示' do
        login_as(admin)
        visit admin_tags_path
        expect(page).to have_css '.breadcrumb'
      end
      it 'タグ編集画面でパンくず表示' do
        login_as(admin)
        visit admin_tags_path
        fill_in 'タグ名', with: 'あいうえお'
        fill_in 'スラッグ', with: 'vvvv'
        click_button '登録する'
        click_link '編集'
        expect(page).to have_css '.breadcrumb'
      end
    end
  end
end
