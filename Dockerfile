# version 0.0.2
#
## build
# docker build -t yonh/mytools .
#
## run
# docker run -it --rm -P yonh/mytools
# docker run -it --rm -p 4567:80 yonh/mytools
# docker run -it --rm -p 4567:80 -v $PWD/app:/app yonh/mytools
FROM ubuntu:16.04

#镜像作者和email
MAINTAINER yonh "azssjli@163.com"
# ENV REFERSHED_AT 2015-04-19
ENV REFERSHED_AT 2019-01-12

ADD app /app

#执行命令，docker会在每条run指令后创建一个新的镜像层
#使用官方源实在是太慢了，下载软件还会失败，更改阿里源作替换
#ADD sources.list /etc/apt/sources.list

RUN sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list &&\
    sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get -y install ruby ruby-dev make g++ &&\
#    gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ &&\
    gem install bundle &&\
    cd /app && bundle install

#gem install --no-rdoc --no-ri sinatra rqrcode_png thin
#RUN sed -i "s/:DoNotReverseLookup => nil/:DoNotReverseLookup=> true/g" /usr/lib/ruby/1.9.1/webrick/config.rb

#公开端口
EXPOSE 80

ADD run.sh /run.sh
RUN chmod +x /run.sh
CMD [ "/run.sh" ]