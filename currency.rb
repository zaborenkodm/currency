# encoding: utf-8
# Курс валют
# Данные берем с сайта Центробанка http://www.cbr.ru/scripts/XML_daily.asp
require 'net/http'
require 'uri'
require 'rexml/document'
require 'date'

# XXX/ Этот код необходим только при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
# /XXX

# сформировали адрес запроса
uri = URI.parse("http://www.cbr.ru/scripts/XML_daily.asp")

# отправили запрос и получили ответ
response = Net::HTTP.get_response(uri)

# из тела ответа сформировали XML документ с помощью REXML парсера
doc = REXML::Document.new(response.body)

# Для того, чтобы найти курс валюты, необходимо знать её ID в XML-файле
# R01235 — Доллар США
# R01239 — Евро

# Найдём в документе соответствующие элементы
doc.each_element('//Valute[@ID="R01235" or  @ID="R01239"]') do |currency_tag|
  # Достаём название валюты и курс
  name = currency_tag.get_text('Name')
  value = currency_tag.get_text('Value')

  # выводим пользователю
  puts "#{name}: #{value} руб."
end
