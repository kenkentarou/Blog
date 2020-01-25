require 'rails_helper'

RSpec.describe '管理画面', type: :system do
  describe 'タグ' do
    let(:admin) { create(:user) }
    let!(:tag) { create(:taxonomy) }
    context 'パンくず表示' do
      it 'タグ一覧画面でパンくず表示' do
        login_as(admin)
        visit admin_tags_path
        expect(page).to have_css '.breadcrumb'
        expect(page).to have_link 'Home', href: '/admin/dashboard'
      end
      it 'タグ編集画面でパンくず表示' do
        login_as(admin)
        visit edit_admin_tag_path(tag)
        expect(page).to have_css '.breadcrumb'
        expect(page).to have_link 'タグ', href: '/admin/tags'
      end
    end
  end
end
