require 'rubygems'
require 'mechanize'

namespace :db do
  desc "clone pronunciation from brish disctionary"

  task clone_pronunciation: :environment do
    @agent = Mechanize.new
    @agent.user_agent = 'Mozilla'

    f = File.open(Rails.root.join('db/data/word.txt'), "r")
    f.each_line do |line|
      word = line.chomp
      search_and_insert_word_into_db(word)
    end
    f.close
  end

  def search_and_insert_word_into_db(word)
    begin
      page = @agent.get("http://dictionary.cambridge.org/dictionary/english-vietnamese/#{word}")
      Word.new.tap do |word|
        word.name = page.search(".di-title.cdo-section-title-hw").children.text
        word.pronunciation = page.search("span.ipa").children.first.text
        word.categorie = page.search("span.di-info").search("span.pos").text
        word.eng_define = page.search("span.def").first.text
        word.vi_define = page.search("span.trans").children.first.text.chomp.strip
        examples = []
        page.search("span.def-body").first.search("span.examp").each do |exam|
          examples << exam.text
        end
        word.examples = examples
        word.save
      end
    rescue Mechanize::ResponseCodeError => e
      p "errors at: #{word}"
    end
  end

end