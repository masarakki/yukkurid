# yukkurid

daemonized bowyomi chan.

*Yukkuri shite itte ne!*

## Require
- ALSA (aplay command)
- mecab
- [unidic](http://www.tokuteicorpus.jp/dist/)
- ruby
- AquesTalk2.so

## Install

    hub clone masarakki/yukkurid
    cd yukkurid
    bundle install

## Setup

- Rakefile portを変更可能
- config.ru Yukkuri.setup の中を変更可能

## Start

    rake server:start

## Usage

    curl -d "message=ゆっくりして行ってね" http://localhost:9999/

棒読みちゃんがしゃべるよ!

## 使用ライブラリ
[AquasTalk2](http://www.a-quest.com/index.html)試用版

## 問題点
- 試用版ライセンスなので「ま」行が「ぬ」になります
