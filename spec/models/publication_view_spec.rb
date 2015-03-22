# == Schema Information
#
# Table name: publication_views
#
#  id         :integer          not null, primary key
#  resume_id  :integer          not null
#  ip_addr    :inet             not null
#  url        :string           not null
#  referrer   :string
#  user_agent :string
#  created_at :datetime         not null
#  lat        :decimal(9, 6)
#  lng        :decimal(9, 6)
#  city       :string
#  state      :string
#  country    :string
#
# Indexes
#
#  index_publication_views_on_resume_id  (resume_id)
#

require 'rails_helper'

RSpec.describe PublicationView, type: :model do
  fixtures :all

  let(:resume) { resumes(:appleseed_resume) }

  context "attributes" do
    let(:pubview) { resume.publication_views.new }

    example "ip_addr" do
      expect(pubview.ip_addr).to be_nil
    end

    example "url" do
      expect(pubview.url).to be_nil
    end

    example "referrer" do
      expect(pubview.referrer).to be_nil
    end

    example "user_agent" do
      expect(pubview.user_agent).to be_nil
    end

    example "lat" do
      expect(pubview.lat).to be_nil
    end

    example "lng" do
      expect(pubview.lng).to be_nil
    end

    example "city" do
      expect(pubview.city).to be_nil
    end

    example "state" do
      expect(pubview.state).to be_nil
    end

    example "country" do
      expect(pubview.country).to be_nil
    end

    example "user" do
      expect(pubview.user).to eq resume.user
    end

    example "resume" do
      expect(pubview.resume).to eq resume
    end

    example "timezone" do
      expect(pubview.timezone).to eq pubview.user.timezone
    end
  end

  context "saving with valid attributes" do
    let(:pubview) { resume.publication_views.new }

    before(:each) do
      pubview.ip_addr = "24.55.66.77"
      pubview.url = "http://example.com/resume"
    end

    example "saved" do
      expect(pubview).to be_valid
      expect(pubview.save).to eq true
      expect(pubview.new_record?).to eq false
    end

    it "should increment counter on resume" do
      expect(resume.publication_views_count).to eq 0
      pubview.save
      resume.reload
      expect(resume.publication_views_count).to eq 1
    end
  end

  context "callbacks" do
    let(:pubview) { resume.publication_views.new }

    before(:each) do
      pubview.ip_addr = "24.55.66.77"
      pubview.url = "http://example.com/resume"
    end

    context "geocoding" do
      before(:each) do
        allow(Geokit::Geocoders::MultiGeocoder).to receive(:geocode).and_return(
          double("geocoder", {
            success?: true,
            city: "Toronto",
            country_code: "CA",
            state: "ON",
            lat: 0.0,
            lng: 0.0
          })
        )
      end

      example "sets location and coords" do
        expect(pubview.save).to eq true
        expect(pubview.city).to eq "Toronto"
        expect(pubview.country).to eq "CA"
        expect(pubview.state).to eq "ON"
        expect(pubview.lat).to eq 0.0
        expect(pubview.lng).to eq 0.0
      end
    end
  end
end
