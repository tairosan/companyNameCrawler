require 'rubygems'
require 'anemone'  #クローラー
require 'nokogiri' #エクストラクター
require 'csv'      #csv操作
require 'kconv'    #文字encoding

# 定数の設定
# non_key = ["株式会社", "(株)", "㈱", "有限会社", "合同会社", "合資会社"] # titleから除外する文字列の配列
csv_path = "/var/www/html/csv/kana_company_utf8.csv" # csv出力先

# Anemone オプション設定
opts = {
	:user_agent => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit(KHTML, like Gecko) Chrome/28.0.1500.52 Safari/537.36",
	#:skip_query_strings => true,
	:delay => 1.6,
	# :storage => Anemone::Storage.MongoDB,
	:depth_limit => 0,
 }

# 指定回数分、Anemoneクローリング開始
1.upto(422814) do |n|
	Anemone.crawl("http://jobtalk.jp/company/#{n}_info.html", opts) do |anemone|
		anemone.on_every_page do |page|
        		# title = page.doc.xpath("//head/title/text()")
			# NokogiriでExtract
        		doc = Nokogiri::HTML(open(page.url))
				doc.css("//h3/a").each do |company|
        			k = company.text
				puts k
  				# a = company[:href]
				puts n
  				# CSV形式でfile書き出し
        			CSV.open(csv_path, 'a', :encoding => "UTF-8") do |csv|
					csv << [s] 
				end
			end
        	end
        end
end
