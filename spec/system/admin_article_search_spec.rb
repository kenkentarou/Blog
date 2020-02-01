require 'rails_helper'

RSpec.describe '管理画面', type: :system do
  let(:admin) { create(:user) }
  let(:article_with_author) { create(:article, :with_author, author_name: 'あああああ') }
  let(:article_with_another_author) { create(:article, :with_author, author_name: 'いいいいい') }
  let(:article_with_tag) { create(:article, :with_tag, tag_name: 'aaaaa') }
  let(:article_with_another_tag) { create(:article, :with_tag, tag_name: 'bbbbb') }
  let(:article_with_sentence) { create(:article, :with_sentence, sentence_body: 'ううううう') }
  let(:article_with_another_sentence) { create(:article, :with_sentence, sentence_body: 'えええええ')}
  before do
    login_as(admin)
  end
  describe '記事一覧' do
    context '記事一覧から様々なパターンで記事検索' do
      it '著者名で絞り込みができること' do
        article_with_author
        article_with_another_author
        visit admin_articles_path
        within 'select[name="q[author_id]"]' do
          select 'あああああ'
        end
        click_button '検索'
        expect(find('.box-body')).to have_content(article_with_author.title)
        expect(find('.box-body')).not_to have_content(article_with_another_author.title)
      end

      it 'タグで絞り込みができること' do
        article_with_tag
        article_with_another_tag
        visit admin_articles_path
        within 'select[name="q[tag_id]"]' do
          select 'aaaaa'
        end
        click_button '検索'
        expect(find('.box-body')).to have_content(article_with_tag.title)
        expect(find('.box-body')).not_to have_content(article_with_another_tag.title)
      end

      it '記事内容で絞り込みができること' do
        article_with_sentence
        article_with_another_sentence
        visit admin_articles_path
        fill_in 'q[body]', with: 'ううううう'
        click_button '検索'
        expect(find('.box-body')).to have_content(article_with_sentence.title)
        expect(find('.box-body')).not_to have_content(article_with_another_sentence.title)
      end
    end
  end
end
