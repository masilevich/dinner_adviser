require 'shared_stuff'

shared_examples "kinds" do |name, ru_name_plural, kind_class_object|
	include_context "shared stuff"
	describe "creation" do
		
		before {visit send(name +"_kinds_path")}

		describe "with invalid information" do

			it "should not create a #{kind_class_object.name}" do
				expect { click_button add_button }.not_to change(kind_class_ob, :count)
			end

			describe "error messages" do
				before { click_button add_button }
				it { should have_error_message("Вид #{ru_name_plural} не добавлен") }
			end
		end

		describe "with valid information" do
			before {fill_in "#{name}_kind_name", with: "#{ru_name_plural}" }
			it "should create a #{kind_class_object.name}" do
				expect { click_button add_button }.to change(kind_class_object, :count).by(1)
			end
		end
	end

	describe "destruction" do
		let!(kind) {FactoryGirl.create(name +"_kind", user: user)}
		describe "in #{kind_class_object.name} controller pages" do

			before { visit send(name +"_kinds_path") }
			it "should delete a #{kind_class_object.name}" do
				expect { click_link delete_link }.to change(kind_class_object, :count).by(-1)
			end
=begin
			describe "should have link to destroy" do
				specify {expect(page).to have_link(delete_link, _kind_path(course_kind))}
			end
=end
		end
	end
end
