# -*- coding: utf-8 -*-
require 'sinatra'
require 'rqrcode_png'
require 'base64'
require 'digest/md5'
require 'digest/sha1'
require 'socket'
require 'json'
require 'cgi'

class String
	  def md5
	    Digest::MD5.digest self
	  end
	  def md5hex
	    Digest::MD5.hexdigest self
	  end
	  def sha1
	    Digest::SHA1.hexdigest self
	  end
	  def base64
	    Base64.encode64 self
	  end
	end
class App < Sinatra::Application
	get '/' do
	  erb :"index"
	end

	# http://localhost:4567/qrcode?url=http://baidu.com
	# 生成制定路径的二维码
	get '/qrcode' do
	  erb :'/qrcode/index'
	end
	post '/qrcode' do
	  @qrimg = qrcode(params[:url])
	  '<img src="data:image/png;base64,'+qrcode(params[:url])+'"/><a href="/">返回</a><form action="/qrcode" method="post"><textarea name="url"></textarea><input value="生成" type="submit" /></form>'
	end

	def qrcode(msg)
	  qr = RQRCode::QRCode.new( msg, :size => 19, :level => :h )
	  Base64.encode64( qr.to_img.resize(400,400).to_s )
	  #"hello"
	    #如果要保存的话，如下
	    #qr.to_img.resize(400, 400).save("my_qrcode.png")
	end

	
	get '/html' do
	  erb :'html/index'
	end

	get '/json' do
		erb :'json/index'
	end
	
	post '/json' do
		@json_s = params['json']
		@json = CGI.escape_html((JSON.pretty_generate(JSON.parse(params['json']))))
		
		erb :'json/index'
	end

	get '/hash' do
	  erb :'hash/index'
	end

	post '/hash' do
	  @md5 = params[:key].md5hex
	  @base64 = params[:key].base64
	  @sha1 = params[:key].sha1
	  erb :"hash/show"
	#  text = "MD5:&nbsp;" + params[:key].md5hex + "<br/>"
	#  text +="SHA1:&nbsp;" + params[:key].sha1 + "<br/>"
	#  text +="BASE64:&nbsp;" + params[:key].base64
	#    source = Base64.decode64(code)

	#  text
	end
end
