# encoding: utf-8
require 'rubygems'
require 'anemone'  #クローラー
require 'nokogiri' #エクストラクター
require 'csv'      #csv操作
require 'kconv'    #文字encoding

# 定数の設定
# non_key = ["株式会社", "(株)", "㈱", "有限会社", "合同会社", "合資会社"] # titleから除外する文字列の配列
csv_path = "./csv/company_sjis_split.csv" # csv出力先

# Anemone オプション設定
opts = {
	:user_agent => "Mozilla/6.0 Safari/537.36",
	#:skip_query_strings => true,
	:delay => 1.2,
	# :storage => Anemone::Storage.MongoDB,
	:depth_limit => 0,
 }

# 指定回数分、Anemoneクローリング開始
1.upto(19654) do |n|
	Anemone.crawl("http://jobtalk.jp/company/index_#{n}.html", opts) do |anemone|
		anemone.on_every_page do |page|
      # NokogiriでExtract
      doc = Nokogiri::HTML(open(page.url))
			doc.css("//h3/a").each do |company|
        s = company.text
        puts s
  			# puts company[:href]
  			# CSV形式でfile書き出し
  			if company.text=="株式会社HI−LINE" then
					enc = "UTF-8"
				else
					enc = "sjis"
				end
        	CSV.open(csv_path, 'a', :encoding => enc ) do |csv|
					csv << [s]
				end
			end
    end
  end
end
