require 'spec_helper'

describe CourseKind do
  before do
    @course_kind = CourseKind.new(name: "Суп")
  end

  subject { @course_kind }

  it { should respond_to(:name) }
  it { should respond_to(:courses) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }

  it { should be_valid }

  describe "validation" do

    describe "with blank name" do
      before {@course_kind.name = ' '}
      it { should_not be_valid }
    end

    describe "with name that is too long" do
      before {@course_kind.name = 'a'*51}
      it { should_not be_valid }
    end
  end

  describe "order" do

    let!(:ck3) { FactoryGirl.create(:course_kind, name: 'Супы') }
    let!(:ck2) { FactoryGirl.create(:course_kind, name: 'Гарниры') }
    let!(:ck1) { FactoryGirl.create(:course_kind, name: 'Вторые блюда') }

    it "should have rights course_kinds in right order" do
      expect(CourseKind.all.to_a).to eq [ck1, ck2, ck3]
    end
  end

  describe "course_kinds for courses" do

    let!(:ck1) { FactoryGirl.create(:course_kind, name: 'Супы') }
    let!(:ck2) { FactoryGirl.create(:course_kind, name: 'Гарниры') }
    before do
      @course = Course.new(name: "Картошка")
      @course.course_kind = ck1
      @course.save
    end
    it "should include course kind" do
      expect(CourseKind.kinds_for_courses(@course)).to include(ck1)
    end

    it "should not include other kinds" do
      expect(CourseKind.kinds_for_courses(@course)).to_not include(ck2)
    end
  end
end
