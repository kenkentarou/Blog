require 'rails_helper'

RSpec.describe '管理画面', type: :system do
  let(:write) { create(:write_user) }
  let(:article) { create :article }
  before do
    login_as(write)
  end
  describe '権限管理' do
    context 'writeの権限を持つユーザーで記事一覧ページにアクセス' do
      it 'カテゴリー・タグ・著者へのリンクが表示されていない' do
        visit admin_articles_path
        expect(page).not_to have_selector('.fa fa-folder-open')
        expect(page).not_to have_selector('.fa.fa-tag')
        expect(page).not_to have_selector('.fa.fa-pencil')
      end
      context '権限のないページへのアクセスで403エラー画面を返す' do
        it 'カテゴリー' do
          visit admin_categories_path
          expect(page).to have_http_status(403)
        end
        it 'タグ' do
          visit admin_tags_path
          expect(page).to have_http_status(403)
        end
        it '著者' do
          visit admin_authors_path
          expect(page).to have_http_status(403)
        end
      end
    end
  end
end
