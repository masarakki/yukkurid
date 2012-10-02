require 'spec_helper'

describe Yukkuri::Config do
  subject { described_class.new }
  its(:unidic) { should be_nil }

  describe :unidic= do
    before { subject.unidic = :unidic_path }
    its(:unidic) { should == :unidic_path }
  end
end
