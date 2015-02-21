# == Schema Information
#
# Table name: resumes
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  name             :string           not null
#  content          :text             not null
#  guid             :string           not null
#  status           :integer          default("0"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  pdf_file_name    :string
#  pdf_content_type :string
#  pdf_file_size    :integer
#  pdf_updated_at   :datetime
#  edition          :integer          default("1")
#  slug             :string           not null
#  is_published     :boolean          default("false"), not null
#
# Indexes
#
#  index_resumes_on_slug  (slug) UNIQUE
#

require 'rails_helper'

RSpec.describe Resume, type: :model do
  fixtures :all

  context "attributes" do
    let(:resume) { Resume.new }

    example "user" do
      expect(resume.user).to be_nil
    end

    example "name" do
      expect(resume.name).to be_blank
    end

    example "content" do
      expect(resume.content).to be_blank
    end

    example "slug" do
      expect(resume.slug).to be_blank
    end

    example "guid" do
      expect(resume.guid).to be_blank
    end

    example "status" do
      expect(resume.status).to eq 0
    end

    example "edition" do
      expect(resume.edition).to eq 1
    end

    example "is_published" do
      expect(resume.is_published).to eq false
    end

    example "pdf" do
      expect(resume.pdf).to_not be_nil
    end
  end
end
