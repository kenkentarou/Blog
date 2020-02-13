require 'rails_helper'

RSpec.describe 'site設定', type: :system do
  let(:admin) { create(:admin_user) }
  before do
    login_as(admin)
  end
  describe 'siteの画像変更' do
    context 'faviconの投稿'do
      it '保存ができる'do
        visit edit_admin_site_path
        click_link '設定'
        attach_file 'favicon', Rails.root.join('spec', 'fixtures', 'images', 'fixture.png')
        click_button '保存'
        expect(page).to have_css('.img-responsive')
      end
      it '削除ができる'do
        visit edit_admin_site_path
        click_link '設定'
        attach_file 'favicon', Rails.root.join('spec', 'fixtures', 'images', 'fixture.png')
        click_button '保存'
        click_link '削除'
        expect(page).not_to have_css('.img-responsive')
      end
    end
    context 'og:imageの投稿'do
      it '保存ができる'do
        visit edit_admin_site_path
        click_link '設定'
        attach_file 'og:image', Rails.root.join('spec', 'fixtures', 'images', 'fixture.png')
        click_button '保存'
        expect(page).to have_css('.img-responsive')
      end
      it '削除ができる'do
        visit edit_admin_site_path
        click_link '設定'
        attach_file 'og:image', Rails.root.join('spec', 'fixtures', 'images', 'fixture.png')
        click_button '保存'
        click_link '削除'
        expect(page).not_to have_css('.img-responsive')
      end
    end
    context 'Main imagesの投稿'do
      it '保存ができる'do
        visit edit_admin_site_path
        click_link '設定'
        attach_file 'Main images', Rails.root.join('spec', 'fixtures', 'images', 'fixture.png')
        click_button '保存'
        expect(page).to have_css('.main_images')
      end
      it '削除ができる'do
        visit edit_admin_site_path
        click_link '設定'
        attach_file 'Main images', Rails.root.join('spec', 'fixtures', 'images', 'fixture.png')
        click_button '保存'
        click_link '削除'
        expect(page).not_to have_css('.main_images')
      end
    end
  end
end
