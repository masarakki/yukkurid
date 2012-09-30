# -*- coding: utf-8 -*-
require 'csv'

module Yukkuri
  class Message

    HINSHI = 1
    YOMI = 10
    ACCENT = 23
    CONBINATION_TYPE = 24

    def initialize(str)
      @message = str
    end

    def mecab
      @mecab ||= CSV.parse(`echo "#{@message}" | mecab -d ~/unidic/dic/unidic-mecab --eos-format=\n`.gsub(/\t/, ','))
    end

    def yomi
      @yomi ||= mecab.map{|x| x[YOMI]}.join
    end

    def accent
      @accent ||= mecab.map{|x| [x[0], x[HINSHI], x[CONBINATION_TYPE], x[ACCENT]]}
    end

    NEW_ACCENT = 100

    def aqtalk
      result = []
      before_accent = 0

      mecab.each_with_index do |word, index|
        yomi = word[YOMI]
        accent = word[ACCENT] == "*" || word[ACCENT].nil? ? 0 : word[ACCENT].split(",").first.to_i
        before_hinshi = index > 0 ? mecab[index-1][HINSHI] : ""
        case word[CONBINATION_TYPE]
        when /C/
          if mecab[index-1][HINSHI] == "名詞"
            case word[CONBINATION_TYPE]
            when "C1"
              result[index - 1] = 0 if index > 0
              result[index] = accent
            when "C2"
              result[index - 1] = 0 if index > 0
              result[index] = 1
            when "C3"
              result[index - 1] = mecab[index - 1][YOMI].length if index > 0
              result[index] = 0
            when "C4"
              result[index - 1] = 0 if index > 0
              result[index] = 0
            when "C5"
              result[index] = 0
            end
          else
            result[index] = accent
          end
        when /F/
          regex = Regexp.new("#{before_hinshi}%(F\\d)(@(\\d)(,(\\d))?)?")
          matches = word[CONBINATION_TYPE].match(regex)
          if matches
            type = matches[1]
            case type
            when "F1"
              result[index] = 0
            when "F2"
              m = matches[3].to_i
              if result[index - 1] == 0
                result[index] = m
              else
                result[index] = 0
              end
            when "F3"
              m = matches[3].to_i
              if result[index - 1] == 0
                result[index] = 0
              else
                result[index - 1] = 0
                result[index] = m
              end
            when "F4"
              m = matches[3].to_i
              result[index - 1] = 0
              result[index] = m
            when "F5"
              result[index] = 0
              result[index-1] = 0
            when "F6"
              m = matches[3].to_i
              l = matches[5].to_i
              if result[index - 1] == 0
                result[index] = m
              else
                result[index - 1] = 0
                result[index] = l
              end
            end
          else
            result[index] = 0
          end
        else
          result[index] = accent
        end
      end
      before_accent = false

      mecab.each_with_index.map do |word, index|
        yomi = word[YOMI] || word[0]
        yomi.insert(result[index], "'") if result[index] != 0
        yomi << "/" if ["助詞", "副詞", "助動詞"].include?(word[HINSHI]) && index < mecab.length - 1 && !["助詞", "副詞", "助動詞", "補助記号"].include?(mecab[index + 1][HINSHI])
        yomi
      end.join
    end

    def play
      `echo #{aqtalk} | /home/masaki/workspace/yukkurid/bin/yukkuri | aplay -q`
    end
  end
end
