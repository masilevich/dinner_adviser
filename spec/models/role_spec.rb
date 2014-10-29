require 'spec_helper'

describe Role do

  before do
    @role = Role.new(name: "admin")
  end

  subject { @role }

  it { should respond_to(:name) }
  it { should respond_to(:users) }

  it { should be_valid }


  describe "validation" do
    describe "when role name is not present" do
      before { @role.name = " " }
      it { should_not be_valid }
    end

    describe "when role name is too long" do
      before { @role.name = "a" * 21 }
      it { should_not be_valid }
    end

    describe "when role name is already taken" do
      before do
        role_with_same_name = @role.dup
        role_with_same_name.save
      end

      it { should_not be_valid }
    end
  end

end
