require 'spec_helper'

describe MenuKind do
  before do
    @menu_kind = MenuKind.new(name: "Обеденное")
  end

  subject { @menu_kind }

  it { should respond_to(:name) }
  it { should respond_to(:menus) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }

  it { should be_valid }

  describe "validation" do

    describe "with blank name" do
      before {@menu_kind.name = ' '}
      it { should_not be_valid }
    end

    describe "with name that is too long" do
      before {@menu_kind.name = 'a'*51}
      it { should_not be_valid }
    end
  end


  describe "order" do

    let!(:mk3) { FactoryGirl.create(:menu_kind, name: 'Утреннее') }
    let!(:mk2) { FactoryGirl.create(:menu_kind, name: 'Обеденное') }
    let!(:mk1) { FactoryGirl.create(:menu_kind, name: 'Вечернее') }

    it "should have rights menu_kinds in right order" do
      expect(MenuKind.all.to_a).to eq [mk1, mk2, mk3]
    end
  end

=begin

  describe "menu_kinds for menus" do

    let!(:mk1) { FactoryGirl.create(:menu_kind, name: 'Овощи') }
    let!(:mk2) { FactoryGirl.create(:menu_kind, name: 'Мясные') }
    before do
      @menu = Product.new(name: "Картошка")
      @menu.menu_kind = mk1
      @menu.save
    end
    it "should include menu kind" do
      expect(MenuKind.kinds_for_menus(Product.all)).to include(mk1)
    end

    it "should not include other kinds" do
      expect(MenuKind.kinds_for_menus(Product.all)).to_not include(mk2)
    end
  end
=end
end

