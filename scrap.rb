require 'curb'
require 'nokogiri'
require 'csv'
def poisk(url12,filename)
  html= Curl::Easy.perform(url12)
names=[]
stroka_name=[]
doc = Nokogiri::HTML.parse(html)
doc.xpath('//*[@class = "attribute_list"]' ).each do |row|
  tempRadio =Array(doc.xpath('//span[@class="radio_label"]').map{|radio_label| radio_label.text})
  tempPrice =Array( doc.xpath('//span[@class="price_comb"]').map{|price_comb| price_comb.text})
 tempName = doc.xpath('//h1[@class="product_main_name"]').text.strip
  tempImg =doc.xpath('//span/img[@id="bigpic"]/@src').to_s
  for i in 0..tempRadio.length()-1
    stroka_name=tempName + "-" + tempRadio[i]
    stroka_price=tempPrice[i]
names.push(
      name:stroka_name,
   price:stroka_price,
    img:tempImg
    )
  end
  CSV.open(filename,'a',write_headers: true,headers: names.first.keys) do |csv|
     names.each do |wr|
     csv << wr.values
          end
        end
  end
  end
puts "Enter url:"
url= gets.chomp
c = Curl::Easy.perform(url)
puts "Enter name of file(without .csv):"
fname = gets.chomp + '.csv'
docx=Nokogiri::HTML.parse(c)
docx.xpath('//*[@id= "product_list"]').each do |prod|
  tempUrl=Array(prod.xpath('//a[@class="product_img_link product-list-category-img"]/@href').map{ |href| href.text})
for x in 0..tempUrl.length()-1
url2=tempUrl[x]
puts "product" + " " + (x+1).to_s + " " + "is written in file"
poisk(url2,fname)
end
puts "End"
end
