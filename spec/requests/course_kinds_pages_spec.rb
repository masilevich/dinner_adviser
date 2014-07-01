require 'spec_helper'

describe "course_kindsPages" do
	include Warden::Test::Helpers
	Warden.test_mode!

	subject { page }

	let(:user) { FactoryGirl.create(:confirmed_user) }
	before {login_as(user, :scope => :user)}

	describe "creation" do
		before {visit course_kinds_path}
		describe "with invalid information" do

			it "should not create a CourseKind" do
				expect { click_button "Добавить" }.not_to change(CourseKind, :count)
			end

			describe "error messages" do
				before { click_button "Добавить" }
				it { should have_error_message('Вид блюда не добавлен') }
			end
		end

		describe "with valid information" do
			before {fill_in 'course_kind_name', with: "Вторые блюда" }
			it "should create a CourseKind" do
				expect { click_button "Добавить" }.to change(CourseKind, :count).by(1)
			end
		end

	end

	describe "destruction" do
		let!(:course_kind) {FactoryGirl.create(:course_kind, user: user)}
		describe "in CourseKinds controller pages" do

			before { visit course_kinds_path }
			it "should delete a CourseKind" do
				expect { click_link "удалить" }.to change(CourseKind, :count).by(-1)
			end

			describe "should have link to destroy" do
				specify {expect(page).to have_link("удалить", course_kind_path(course_kind))}
			end
		end

		describe "link should be only on CourseKind contoller pages" do
			let!(:c1) { FactoryGirl.create(:course, user: user, name: 'Пюре') }
			before do
				c1.course_kind = course_kind
				visit course_path(c1)
			end	
			specify {expect(page).to_not have_link("удалить", href: course_kind_path(course_kind))}
		end
	end

	describe "edit" do
		let!(:course_kind) {FactoryGirl.create(:course_kind,user: user, name: "Вторые блюда")}
		before do
			visit edit_course_kind_path(course_kind)
			fill_in "course_kind_name", with: "Первые блюда"
			click_button "Сохранить"
		end 
		it "should update a course_kind" do
			expect(course_kind.reload.name).to eq "Первые блюда"
		end

		it { should have_content("Первые блюда") }

		it { should have_content("Вид блюда изменен") }

	end

	describe "index" do
		let!(:ck1) { FactoryGirl.create(:course_kind, user: user, name: 'Первые блюда') }
		let!(:ck2) { FactoryGirl.create(:course_kind, user: user, name: 'Вторые блюда') }
		before {visit course_kinds_path}

		it { should have_title(full_title('Виды блюд')) }

		it { should have_button('Добавить') }
		it { should have_link('удалить', href: course_kind_path(ck1)) }
		it { should have_link(ck1.name, href: edit_course_kind_path(ck1)) }
		it { should have_link(ck2.name, href: edit_course_kind_path(ck2)) }

		describe "on all course_kinds" do
			it { should have_content("Все (#{user.course_kinds.count})") }

			it "should list each course_kind" do
				user.course_kinds.each do |course_kind|
					expect(page).to have_selector('td', text: course_kind.name)
				end
			end
		end

	end

end

