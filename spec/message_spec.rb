# -*- coding: utf-8 -*-
require 'spec_helper'

describe Yukkuri::Message do
  subject { @message }
  context "multi sentence" do
    before { @message = Yukkuri::Message.new "ほげ? はげ?ひげ? ふが。ふげ、ふが。" }
    its(:yomi) { should == "ほげ?/はげ?/ひげ?/ふが。/ふげ、/ふが。" }
  end

end
