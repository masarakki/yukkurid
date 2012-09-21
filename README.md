# yukkurid

daemonized bowyomi chan.

*Yukkuri shite itte ne!*

## Require
- ALSA (aplay command)
- mecab
- ruby
- AquesTalk2.so

## Setup

    hub clone masarakki/yukkurid
    cd yukkurid
    bundle install
    rackup -p #{port_num}


## Usage

    curl -d "message=ゆっくりして行ってね!" http://localhost:#{port_num}/

棒読みちゃんがしゃべるよ!

## 使用ライブラリ
[AquasTalk2](http://www.a-quest.com/index.html)試用版

## 問題点
- 試用版ライセンスなので「ま」行が「ぬ」になります
