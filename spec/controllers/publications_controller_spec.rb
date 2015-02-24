require 'rails_helper'

RSpec.describe PublicationsController, type: :controller do
  fixtures :all

  let(:resume) { resumes(:appleseed_resume) }

  example "Load resume page successfully" do
    get :show, slug: resume.slug
    expect(response).to be_success
  end

  example "Recording page views" do
    expect(resume.publication_views.count).to eq 0

    assert_enqueued_with(job: PageViewRecorderJob) do
      get :show, slug: resume.slug
    end
  end

  example "Loading non-existent resume" do
    expect {
      get :show, slug: "nonexistent-resume"
    }.to raise_error(ActionController::RoutingError)
  end

  context "Resume with access code" do
    before(:each) do
      expect(resume.update(access_code: "ABCDEF")).to eq true
    end

    example "Loading the page redirects to access code form" do
      get :show, slug: resume.slug
      expect(response).to be_redirect
      expect(response).to redirect_to(controller: :publications, action: :access_code, slug: resume.slug)
    end

    example "Submitting incorrect access code" do
      post :post_access_code, slug: resume.slug, access_code: 'INCORRECT'
      expect(response).to be_success
      expect(response).to render_template("access_code")
    end

    example "Submitting correct access code" do
      post :post_access_code, slug: resume.slug, access_code: 'ABCDEF'
      expect(response).to be_redirect
      expect(response).to redirect_to(controller: :publications, action: :show, slug: resume.slug)
    end
  end
end
