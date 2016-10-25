require 'spec_helper'
require "rails"

describe ApplicationController do
  it "should be able to tag framgents" do
    Cashier.should_receive(:store_fragment).with('views/key', 'tag')
    controller.write_fragment('key', 'content', :tag => 'tag')
  end

  it "should be able to tag fragments multiple times" do
    Cashier.should_receive(:store_fragment).with('views/key', 'tag').twice
    controller.write_fragment('key', 'content', :tag => Proc.new() { |c| 'tag' })
    controller.write_fragment('key', 'content', :tag => Proc.new() { |c| 'tag' })
  end

  it "should be able write a fragment with multiple tags" do
    Cashier.should_receive(:store_fragment).with('views/key', ['tag1', 'tag2'])
    controller.write_fragment('key', 'content', :tag => %w(tag1 tag2))
  end

  it "should able to create a tag with a proc" do
    Cashier.should_receive(:store_fragment).with('views/key', 'tag')
    controller.write_fragment('key', 'content', :tag => proc { |c| 'tag' })
  end

  it "should able to create a tag with a lambda" do
    Cashier.should_receive(:store_fragment).with('views/key', 'tag')
    controller.write_fragment('key', 'content', :tag => lambda { |c| 'tag' })
  end

  it "should downcase incoming tags" do
    controller.write_fragment('key', 'content', :tag => 'NEWTAG')
    expect(Cashier.tags).to include('newtag')
  end

  it "should gradually downcase tags" do
    Cashier.adapter.store_fragment_in_tag('foo', 'THETAG')
    Cashier.adapter.store_tags(['THETAG'])
    Cashier.keys_for('THETAG')
    expect(Cashier.tags).to_not include('THETAG')
    expect(Cashier.tags).to include('thetag')
  end

end