# Version 0.0.1
# build
# sudo docker build -t yonh/sinatra:mytools
# run
# sudo docker run -it --rm -p 4567:4567 yonh/sinatra:mytools
# sudo docker run -it --rm -p 4567:4567 -v ~/git/mytools/app:/opt/webapp yonh/sinatra:mytools

FROM ubuntu:14.04

#镜像作者和email
MAINTAINER yonh "azssjli@163.com"
ENV REFERSHED_AT 2015-04-01

#执行命令，docker会在每条run指令后创建一个新的镜像层
#使用官方源实在是太慢了，下载软件还会失败，更改阿里源作替换
ADD sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install ruby ruby-dev
#移除官方源
#RUN gem sources --remove https://rubygems.org/
#增加http://ruby.taobao.org/源
#RUN gem sources -a https://ruby.taobao.org/
RUN gem install --no-rdoc --no-ri sinatra rqrcode_png
RUN sed -i "s/:DoNotReverseLookup => nil/:DoNotReverseLookup=> true/g" /usr/lib/ruby/1.9.1/webrick/config.rb
ADD app /opt/webapp/
RUN mkdir -p /opt/webapp

#公开端口
EXPOSE 80

ADD run.sh /run.sh
RUN chmod +x /run.sh
CMD [ "/run.sh" ]
