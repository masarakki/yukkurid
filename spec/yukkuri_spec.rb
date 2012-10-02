require 'spec_helper'

describe Yukkuri do
  subject {Yukkuri }
  its(:config) { should be_a Yukkuri::Config }
  describe :config do
    before do
      Yukkuri.setup do |yukkuri|
        yukkuri.unidic = :unidic_path
      end
    end
    subject { Yukkuri.config }
    its(:unidic) { should == :unidic_path }
  end
end
