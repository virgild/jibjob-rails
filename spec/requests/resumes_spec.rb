# == Schema Information
#
# Table name: resumes
#
#  id                      :integer          not null, primary key
#  user_id                 :integer          not null
#  name                    :string           not null
#  content                 :text             not null
#  guid                    :string           not null
#  status                  :integer          default(0), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  pdf_file_name           :string
#  pdf_content_type        :string
#  pdf_file_size           :integer
#  pdf_updated_at          :datetime
#  edition                 :integer          default(0), not null
#  slug                    :string           not null
#  is_published            :boolean          default(FALSE), not null
#  access_code             :string
#  pdf_edition             :integer          default(0), not null
#  pdf_pages               :integer
#  publication_views_count :integer          default(0), not null
#  theme                   :string
#
# Indexes
#
#  index_resumes_on_slug  (slug) UNIQUE
#

require 'rails_helper'

RSpec.describe "Resumes", type: :request, js: true do
  fixtures :all

  let(:user) { users(:appleseed) }
  let(:sample) { resumes(:appleseed_resume) }

  before(:each) do
    visit "/app/login"
    fill_in "username", with: "appleseed"
    fill_in "password", with: "testpass"
    click_button "Submit"
  end

  example "creation" do
    click_on "create-button"

    fill_in "Resume Label", with: "A New Resume"

    expect(page).to have_field("Link Name", with: "a-new-resume")

    fill_in "Access Code", with: "SESAME"
    click_on "Load Example"
    wait_for_ajax

    click_button "Save"
    wait_for_ajax
    wait_for_selector(".details")

    expect(page).to have_content("A New Resume")

    within(".topnav") do
      click_on "My resumes"
    end
    within(".resume-list") do
      expect(page).to have_content("A New Resume")
    end
  end

  example "edit and update" do
    click_on "Test Resume"
    click_on "Edit"
    expect(page).to have_css(".resume-form")

    fill_in "Resume Label", with: "Modified Resume"
    expect(page).to have_field("Link Name", with: "modified-resume")

    fill_in "Link Name", with: "test-resume-2"
    check "Publish now"
    fill_in "Access Code", with: "DOODLES"

    click_on "Save"
    wait_for_ajax
    # TODO: Do not sleep
    sleep 1

    click_on "Test Resume"

    within(".details") do
      expect(page).to have_text("Modified Resume")
      expect(page).to have_text("PUBLISHED")
      expect(page).to have_text("DOODLES")
      expect(page).to have_text("test-resume-2")
    end
  end

  example "delete" do
    click_on "Test Resume"
    click_on "Delete"
    expect(page).to have_text("delete this resume")
    click_button "Yes - Delete it"

    within(".resume-list") do
      expect(page).to_not have_content("Test Resume")
    end
  end

  example "published with no access code" do
    publication_window = window_opened_by do
      click_on "Test Resume"
      click_on "Publish URL"
    end

    within_window(publication_window) do
      expect(page).to have_text "Thomas B. Seeker"
    end
  end

  example "published with access code" do
    click_on "Test Resume"
    click_on "Edit"
    fill_in "Access Code", with: "secret"
    click_button "Save"
    wait_for_ajax
    # TODO: Do not sleep
    sleep 1
    click_on "Test Resume"

    publication_window = window_opened_by do
      click_on "Publish URL"
    end

    within_window(publication_window) do
      expect(page).to have_content("Enter Access Code")
      fill_in "access_code", with: "guesswork"
      click_on "Submit"
      expect(page).to have_content("Incorrect access code")

      fill_in "access_code", with: "secret"
      click_on "Submit"
      expect(page).to_not have_content("Enter Access Code")
    end
  end
end
