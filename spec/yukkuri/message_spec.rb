# -*- coding: utf-8 -*-
require 'spec_helper'

describe Yukkuri::Message do
  subject { described_class.new self.class.ancestors[1].description }

  describe :mora do
    subject { described_class.new "カッパの好物はチョコレート" }
    its("mora.flatten") { should == %w{カ ッ パ ノ コ ー ブ ツ ワ チョ コ レ ー ト} }
  end


  describe "アクセント" do
    context "解析結果を表示します" do
      its(:aqtalk) { should == "カイセキケ'ッカオ/ヒョージシマ'ス" }
    end

    context "アクセント結合型 普通名詞・接尾辞" do
      context "C1" do
        context "大将" do
          its(:aqtalk) { should == "タ'イショー" }
        end
        context "大将手続き" do
          its(:aqtalk) { should == "タイショーテツ'ズキ" }
        end
      end

      context "C2" do
        context "生活" do
          its(:aqtalk) { should == "セーカツ" }
        end

        context "社会生活" do
          its(:aqtalk) { should == "シャカイセ'ーカツ" }
        end
      end

      context "C3" do
        context "経済" do
          its(:aqtalk) { should == "ケ'ーザイ" }
        end
        context "経済学" do
          its(:aqtalk) { should == "ケーザイ'ガク" }
        end
      end
      context "C4" do
        context "物理" do
          its(:aqtalk) { should == "ブ'ツリ" }
        end
        context "物理系" do
          its(:aqtalk) { should == "ブツリケー" }
        end
      end
    end

    context "これは、合成音声です。" do
      its(:aqtalk) { should == "コレワ、ゴーセーオ'ンセーデス。" }
    end

    context "これは、音声記号です。" do
      its(:aqtalk) { should == "コレワ、オンセーキ'ゴーデス。" }
    end

    context "今度は、もう少し複雑な音声記号です。" do
      its(:aqtalk) { should == "コ'ンドワ、モースコ'シ/フクザツナ/オンセーキ'ゴーデス。" }
    end

    context "それは難しいな" do
      before { p subject.accent }
      its(:aqtalk) { should == "ソレワ/ムズカシ'ーナ" }
    end

    context "ご想像にお任せします" do
      its(:aqtalk) { should == "ゴソーゾーニ/オマ'カセシマ'ス" }
    end

    context "任せてもいいですか?" do
      its(:aqtalk) { should == "マカセ'テモ/イ'ーデスカ\?" }
    end

    context "今日は非常に暑いので、夜はビールでも飲みに行きたいと思っています。" do
      its(:aqtalk) { should == "キョ'ーワ/ヒジョーニ/アツ'イノデ、ヨ'ルワ/ビ'ールデモ/ノ'ミニ/イキタ'イト/オモ'ッテ/イマ'ス。" }
    end

    context "両軍の総大将" do
      its(:aqtalk) { should == "リョーグンノ/ソータ'イショー" }
    end
  end
end


