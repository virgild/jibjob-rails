require 'rails_helper'

RSpec.describe PublicationsController, type: :controller do
  fixtures :all

  let(:resume) { resumes(:appleseed_resume) }

  example "Load resume page successfully" do
    get :show, slug: resume.slug
    assert_response :success
  end

  example "Recording page views" do
    expect(resume.publication_views.count).to eq 0

    assert_enqueued_with(job: PageViewRecorderJob) do
      get :show, slug: resume.slug
    end
  end

  example "Loading non-existent resume" do
    get :show, slug: "nonexistent-resume"
    assert_response :not_found
  end
end
