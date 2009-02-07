require File.dirname(__FILE__) + '/test_helper'

class DominoTest < Test::Unit::TestCase
  should "generate a basic open/close tag string" do
    assert_equal "<p></p>", Domino::Element.new(:p).to_s
  end
  
  should "generate open/close string with attribute" do
    assert_equal '<p class="copy"></p>', Domino::Element.new(:p, :class => 'copy').to_s
  end
  
  should "generate open/close string with self-referential attribute" do
    assert_equal '<p enabled="enabled"></p>', Domino::Element.new(:p, :enabled => true).to_s
  end
  
  should "generate singleton string" do
    assert_equal '<img />', Domino::Element.new(:img, {}, true).to_s
  end
  
  should "generate singleton string with attributes" do
    assert_equal '<img src="photo.jpg" />', Domino::Element.new(:img, { :src => 'photo.jpg' }, true).to_s
  end
  
  should "generate open/close tag with some text content" do
    assert_equal '<p>Hello world.</p>', Domino::Element.new(:p){'Hello world.'}.to_s
  end
  
  should "generate open/close tag with attributes and some text content" do
    assert_equal '<p class="copy">Hello world.</p>', Domino::Element.new(:p, :class => 'copy'){'Hello world.'}.to_s
  end
  
  should "generate tag with an Domino::Element as content" do
    assert_equal '<p><img src="photo.jpg" /></p>', Domino::Element.new(:p){Domino::Element.new(:img, { :src => 'photo.jpg' }, true )}.to_s
  end
  
  should "generate nested tags from injected Elements" do
    table = Domino::Element.new(:table, :class => 'calendar')
    tr = Domino::Element.new(:tr).inject_into(table)
    th = Domino::Element.new(:th){'Monday'}.inject_into(tr)
    assert_equal '<table class="calendar"><tr><th>Monday</th></tr></table>', table.to_s
  end
end