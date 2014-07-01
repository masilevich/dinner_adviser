require 'spec_helper'

describe ProductKind do
  before do
    @product_kind = ProductKind.new(name: "Овощи")
  end

  subject { @product_kind }

  it { should respond_to(:name) }
  it { should respond_to(:products) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }

  it { should be_valid }

  describe "validation" do

    describe "with blank name" do
      before {@product_kind.name = ' '}
      it { should_not be_valid }
    end

    describe "with name that is too long" do
      before {@product_kind.name = 'a'*51}
      it { should_not be_valid }
    end
  end

  describe "order" do

    let!(:pk3) { FactoryGirl.create(:product_kind, name: 'Овощи') }
    let!(:pk2) { FactoryGirl.create(:product_kind, name: 'Мясные') }
    let!(:pk1) { FactoryGirl.create(:product_kind, name: 'Крупы') }

    it "should have rights product_kinds in right order" do
      expect(ProductKind.all.to_a).to eq [pk1, pk2, pk3]
    end
  end

  describe "product_kinds for products" do

    let!(:pk1) { FactoryGirl.create(:product_kind, name: 'Овощи') }
    let!(:pk2) { FactoryGirl.create(:product_kind, name: 'Мясные') }
    before do
      @product = Product.new(name: "Картошка")
      @product.product_kind = pk1
      @product.save
    end
    it "should include product kind" do
      expect(ProductKind.kinds_for_products(Product.all)).to include(pk1)
    end

    it "should not include other kinds" do
      expect(ProductKind.kinds_for_products(Product.all)).to_not include(pk2)
    end
  end
end

