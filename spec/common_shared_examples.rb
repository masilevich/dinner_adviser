shared_examples "common" do
it { should respond_to(:common) }
it { should respond_to(:exclude_by_name) }
it { should respond_to(:common_exclude_by_name) }
end
