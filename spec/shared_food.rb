shared_context "two products" do
	let!(:p1) { FactoryGirl.create(:product, user: user, available: true) }
	let!(:p2) { FactoryGirl.create(:product, user: user) }
end

shared_context "course and two products" do
	include_context "two products"
	let!(:course) {FactoryGirl.create(:course,user: user)}
end

shared_context "two courses" do
	let!(:c1) { FactoryGirl.create(:course, user: user) }
	let!(:c2) { FactoryGirl.create(:course, user: user) }
end

shared_context "menu and two courses" do
	include_context "two courses"
	let!(:menu) {FactoryGirl.create(:menu, user: user)}
end