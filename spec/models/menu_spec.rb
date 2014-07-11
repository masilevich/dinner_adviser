require 'spec_helper'

describe Menu do
	let(:user) { FactoryGirl.create(:user) }
	before do
		@menu = user.menus.build(date: Time.now())
	end

	subject { @menu }

	it { should respond_to(:date) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	it { should respond_to(:menu_kind) }
	it { should respond_to(:courses) }

	its(:user) { should eq user }

	it { should be_valid }

	describe "validation" do

		describe "with blank name" do
			before {@menu.date = nil}
			it { should_not be_valid }
		end

	end

	describe "order" do

		let!(:m3) { FactoryGirl.create(:menu, date: (Time.now-2.days)) }
		let!(:m2) { FactoryGirl.create(:menu, date: (Time.now-1.days)) }
		let!(:m1) { FactoryGirl.create(:menu, date: Time.now) }

		it "should have rights menus in right order" do
			expect(Menu.all.to_a).to eq [m1, m2, m3]
		end
	end

=begin
	describe "without_kind" do
		
	  it "scope should include menu without kind" do
	  	@menu.save
			expect(Menu.without_kind).to include(@menu)
		end

		describe "scope should not include menu with kind" do
			let(:menu_kind) { FactoryGirl.create(:menu_kind) }
			before do
			  @menu.menu_kind = menu_kind
			  @menu.save
			end 
			specify { expect(Course.without_kind).to_not include(@menu) }
		end

	end
=end
end
