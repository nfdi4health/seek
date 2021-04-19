require 'test_helper'


class StudyhubResourceRelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = StudyhubResourceRelationship.new(parent_id: 1, child_id: 2)
  end

  test 'should be valid' do
    assert @relationship.valid?
  end

  test 'should require a parent_id' do
    @relationship.parent_id = nil
    assert_not @relationship.valid?
  end

  test 'should require a child_id' do
    @relationship.child_id = nil
    assert_not @relationship.valid?
  end

  test 'should add and remove a child' do
    shr1 = Factory(:min_studyhub_study)
    shr2 = Factory(:max_studyhub_study)

    assert_not shr1.is_parent?(shr2)
    assert_not shr2.is_child? (shr1)

    shr1.add_child(shr2)
    assert shr1.is_parent?(shr2)
    assert shr2.is_child? (shr1)

    shr1.remove_child(shr2)
    assert_not shr1.is_parent?(shr2)
    assert_not shr2.is_child? (shr1)

    shr2.add_parent(shr1)
    assert shr1.is_parent?(shr2)
    assert shr2.is_child? (shr1)

  end

end