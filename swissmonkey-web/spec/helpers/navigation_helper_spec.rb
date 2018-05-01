require 'rails_helper'

RSpec.describe NavigationHelper, type: :helper do
  describe 'super_admin_menu_items' do
    before :each do
      @result = helper.super_admin_menu_items
      @instance = spy('instance')
      @sub_instance = spy('sub_instance')
      @result.call(@instance)
    end

    it 'should return a proc' do
      expect(@result.class).to be(Proc)
    end

    it 'should have a parent item with sub items and a dom class' do
      expect(@instance).to have_received('item') { |&block| block.call(@sub_instance) }
      expect(@sub_instance).to have_received('item').at_least(1).times
      expect(@sub_instance).to have_received('dom_class=')
    end

    it 'should have a dom_class of "nav"' do
      instance = spy('instance')
      @result.call(instance)
      expect(instance).to have_received('dom_class=').with('nav')
    end
  end
end
