require 'test_helper'


class ItemMasterTest < ActiveSupport::TestCase
  fixtures :item_masters

   test "should change the default status to Active with create" do
     ItemMaster.create(item: 'test_12345', client: 'C1')
     item = ItemMaster.find_by_item('test_12345')
     assert_equal(item.status, 'Active')
   end


  test "should change the default status to Active with save" do
    item = ItemMaster.new
    item.item = 'test_12346'
    item.save

    item = ItemMaster.find_by_item('test_12346')
    assert_equal(item.status, 'Active')
  end

  test "should override the default status to Active with save" do
    item = ItemMaster.new
    item.item = 'test_12347'
    item.status = 'InActive'
    item.save

    item = ItemMaster.find_by_item('test_12347')
    assert_equal(item.status, 'Active')
  end

  test "should not change the status for update" do
    item = ItemMaster.new
    item.item = 'test_12347'
    item.save

    item = ItemMaster.find_by_item('test_12347')
    item.status = 'InActive'

    assert_equal(item.status, 'InActive')
  end

end
