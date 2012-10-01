# -*- coding: utf-8 -*-
require 'spec_helper'

describe Yukkuri::Message do
  subject { described_class.new self.class.ancestors[1].description }

  context "解析結果を表示します" do
    its(:aqtalk) { should == "カイセキケ'ッカオ/ヒョージシマ'ス" }
  end

  context "生活" do
    its(:aqtalk) { should == "セ'ーカツ" }
  end

  context "社会生活" do
    its(:aqtalk) { should == "シャカイセ'ーカツ" }
  end

  context "これは、合成音声です。" do
    its(:aqtalk) { should == "コレワ、ゴーセーオ'ンセーデス。" }
  end

  context "これは、音声記号です。" do
    its(:aqtalk) { should == "コレワ、オンセーキ'ゴーデス。" }
  end

  context "今度は、もう少し複雑な音声記号です。" do
    before { p subject.accent }
    its(:aqtalk) { should == "コ'ンドワ、モースコ'シ/フクザツナ/オンセーキ'ゴーデス。" }
  end

  context "それは難しいな" do
    before { p subject.accent }
    its(:aqtalk) { should == "ソレワ/ムズカシ'ーナ" }
  end
end

