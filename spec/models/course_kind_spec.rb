require 'spec_helper'

describe CourseKind do
  before do
    @course_kind = CourseKind.new(name: "Суп")
  end

  subject { @course_kind }

  it { should respond_to(:name) }
  it { should respond_to(:courses) }

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
end
