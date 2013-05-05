# -*- coding: utf-8 -*-
require 'csv'
require 'nkf'

module Yukkuri
  class Message

    HINSHI = 1
    YOMI = 10
    ACCENT = 23
    CONBINATION_TYPE = 24


    def initialize(str)
      @message = NKF.nkf('-w -Z1', str)
    end

    def mecab
      @mecab ||= CSV.parse(`echo "#{@message}" | mecab -d ~/unidic/dic/unidic-mecab --eos-format=\n`.gsub(/\t/, ','))
    end

    def mora
      @mora ||= mecab.map do |word|
        (word[YOMI] || word[0]).each_char.inject [] do |res, char|
          if %{ャ ュ ョ ァ ィ ゥ ェ ォ}.include? char
            before = res.pop
            res.push before + char
          else
            res << char
          end
        end
      end
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
        accent = word[ACCENT] == "*" || word[ACCENT].nil? ? [0] : word[ACCENT].split(",").map(&:to_i)
        before_hinshi = index > 0 ? mecab[index-1][HINSHI] : ""
        case word[CONBINATION_TYPE]
        when /C/
          if index > 0 && mecab[index-1][HINSHI] == "名詞"
            case word[CONBINATION_TYPE]
            when "C1"
              result[index - 1] = [0] if index > 0
              result[index] = accent
            when "C2"
              result[index - 1] = [0] if index > 0
              result[index] = [1]
            when "C3"
              result[index - 1] = [mora[index - 1].length] if index > 0
              result[index] = [0]
            when "C4"
              result[index - 1] = [0] if index > 0
              result[index] = [0]
            when "C5"
              result[index] = [0]
            end
          else
            result[index] = accent
          end
        when /F/
          regex = Regexp.new("#{before_hinshi}%(F\\d)(@(-?\\d)(,(-?\\d))?)?")
          matches = word[CONBINATION_TYPE].match(regex)
          if matches
            type = matches[1]
            case type
            when "F1"
              result[index] = [0]
            when "F2"
              m = matches[3].to_i
              if result[index - 1] == 0
                if m < 0
                  result[index-1] = [mora[index-1] + m]
                  result[index] = [0]
                else
                  result[index] = [m]
                end
              else
                result[index] = [0]
              end
            when "F3"
              m = matches[3].to_i
              if result[index - 1] == [0]
                result[index] = [0]
              else
                result[index - 1] = [0]
                result[index] = [m]
              end
            when "F4"
              m = matches[3].to_i
              result[index - 1] = [0]
              result[index] = [m]
            when "F5"
              result[index] = [0]
              result[index-1] = [0]
            when "F6"
              m = matches[3].to_i
              l = matches[5].to_i
              if result[index - 1] == [0]
                result[index] = [m]
              else
                result[index - 1] = [0]
                result[index] = [l]
              end
            end
          else
            result[index] = [0]
          end
        when /P/
          next_mora = mora[index+1].length
          _x = mecab[index+1][ACCENT]
          next_accent_type = _x == "*" || _x.nil? ? [0] : _x.split(",").map(&:to_i)
          case word[CONBINATION_TYPE]
          when "P2"
            if next_accent_type.include?(next_mora) || next_accent_type.include?(0)
              result[index] = [0]
              result[index+1] = [1]
              mecab[index+1][ACCENT] = "1"
            else
              result[index] = [0]
              result[index+1] = next_accent_type
            end
          else
            result[index] = [0]
          end
        else
          result[index] = accent
        end
      end
      before_accent = false

      blocks = []
      current_block = {words: [], accents: [], mora: []}

      mecab.each_with_index do |word, index|
        current_block[:words] << word
        current_block[:accents] << result[index]
        current_block[:mora] << mora[index]

        if ["助詞", "副詞", "助動詞"].include?(word[HINSHI]) && index < mecab.length - 1 && !["助詞", "副詞", "助動詞", "補助記号"].include?(mecab[index + 1][HINSHI])
          blocks << current_block
          current_block = {words: [], accents: [], mora: []}
        end
      end

      blocks << current_block

      blocks.map do |block|
        block[:words].each_with_index.map do |word, index|
          yomi = block[:mora][index].dup
          if block[:accents][index].count > 1 && block[:accents][index].first == 0
            unless block[:accents].each_with_index.any? do |other_accents, check_index|
                check_index != index && other_accents.any?{ |x| x != 0 }
              end
              yomi.insert(block[:accents][index][1], "'")
            end
          elsif block[:accents][index].first != 0
            yomi.insert(block[:accents][index].first, "'")
          end
          yomi.join
        end.join
      end.join("/")
    end

    def play
      `echo "#{aqtalk}" | /home/masaki/workspace/yukkurid/bin/yukkuri | aplay -q`
    end
  end
end
