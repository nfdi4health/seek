require 'test_helper'

class SamplesHelperTest < ActionView::TestCase
  test 'seek sample attribute display' do
    sample = Factory(:sample, policy: Factory(:public_policy))
    assert sample.can_view?
    value = { id: sample.id, title: sample.title, type: 'Sample' }.with_indifferent_access
    display = seek_sample_attribute_display(value)
    tag = Nokogiri::HTML::DocumentFragment.parse(display).children.first
    assert_equal 'a', tag.name
    assert_equal "/samples/#{sample.id}", tag['href']
    assert_equal sample.title, tag.children.first.content

    # private sample
    sample = Factory(:sample, policy: Factory(:private_policy))
    refute sample.can_view?
    value = { id: sample.id, title: sample.title, type: 'Sample' }.with_indifferent_access
    display = seek_sample_attribute_display(value)
    tag = Nokogiri::HTML::DocumentFragment.parse(display).children.first
    assert_equal 'span', tag.name
    assert_equal 'none_text', tag['class']
    assert_equal 'Hidden', tag.children.first.content

    # doesn't exist
    value = { id: (Sample.maximum(:id)+1), title: 'Blah', type: 'Sample' }.with_indifferent_access
    display = seek_sample_attribute_display(value)
    tag = Nokogiri::HTML::DocumentFragment.parse(display).children.first
    assert_equal 'span', tag.name
    assert_equal 'none_text', tag['class']
    assert_equal 'Blah', tag.children.first.content
  end

  test 'sample_attribute_display_title' do
    # simple
    attribute = Factory(:sample_sample_attribute, title:'The title',sample_type: Factory(:simple_sample_type))
    assert_equal 'The title',sample_attribute_display_title(attribute)

    #unit
    attribute = Factory(:sample_sample_attribute, title:'The title',unit:Factory(:unit),sample_type: Factory(:simple_sample_type))
    assert_equal 'The title ( g )',sample_attribute_display_title(attribute)

    #pid
    attribute = Factory(:sample_sample_attribute, title:'The title',pid:'http://pid.org/attr#title',sample_type: Factory(:simple_sample_type))
    assert_equal "The title<small data-tooltip=\"http://pid.org/attr#title\"> [ title ]</small>",sample_attribute_display_title(attribute)
  end
end
