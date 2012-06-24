require 'spec_helper'

describe 'IPAddr patches' do
  describe '.valid?' do
    it 'should not be valid with non IP strings' do
      IPAddr.valid?("").should be_false
      IPAddr.valid?("abc").should be_false
      IPAddr.valid?("1.2.3.4a").should be_false
    end

    it 'should be valid with with IP strings' do
      IPAddr.valid?("1.2.3.4").should be_true
      IPAddr.valid?("255.255.255.255").should be_true
      IPAddr.valid?("255.255.255.256").should be_false
    end

    it 'should be valid with integers in a certain limit' do
      IPAddr.valid?(0).should be_true
      IPAddr.valid?(123450).should be_true
      IPAddr.valid?(12345123451234512345).should be_false
    end
  end

  describe '.new_from_int' do
    #def self.new_from_int(addr)
    #  unless addr.blank?
    #    new(Integer(addr), Socket::AF_INET).to_s rescue nil
    #  end
    #end
  end
end
