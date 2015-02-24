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
#  access_code      :string
#
# Indexes
#
#  index_resumes_on_slug  (slug) UNIQUE
#

require 'rails_helper'

RSpec.describe Resume, type: :model do
  fixtures :all

  let(:user) { users(:appleseed) }
  let(:sample_content) { resumes(:appleseed_resume).content }

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

    example "publication_views" do
      expect(resume.publication_views).to_not be_nil
      expect(resume.publication_views.length).to eq 0
    end

    example "access_code" do
      expect(resume.access_code).to be_blank
    end

    example "requires_access_code?" do
      expect(resume.requires_access_code?).to eq false
    end
  end

  context "after creation" do
    let(:resume) { user.resumes.create(name: "Test Resume 2", slug: "test-resume-2", content: sample_content) }

    it "has edition 1" do
      expect(resume.edition).to eq 1
    end

    it "generates guid" do
      expect(resume.guid).to_not be_blank
    end

    it "belongs to user" do
      expect(resume.user).to eq(user)
    end

    it "creates pdf file" do
      expect(File.exists?(resume.pdf.path)).to eq true
    end

    it "is not published" do
      expect(resume.is_published).to eq false
    end

    it "has status 0" do
      expect(resume.status).to eq 0
    end
  end

  context "names are unique within user scope" do
    let(:user) { users(:appleseed) }

    example "another resume with the same name is invalid" do
      expect(user.resumes.first.name).to eq 'Test Resume'

      resume = user.resumes.build(name: 'Test Resume', slug: 'test-resume-2', content: "\n")
      expect(resume).to_not be_valid
      expect(resume.errors[:name]).to_not be_empty
    end
  end

  context "slugs are unique globally" do
    let(:user1) { users(:appleseed) }
    let(:user2) { users(:gourdough) }

    example "another resume with the same slug is invalid" do
      expect(user1.resumes.first.slug).to eq 'test-resume'

      resume = user2.resumes.build(name: 'Test Resume', slug: 'test-resume', content: "\n")
      expect(resume).to_not be_valid
      expect(resume.errors[:slug]).to_not be_empty
    end
  end

  context "name format" do
    let(:user) { users(:appleseed) }
    subject do |example|
      example.description
    end
    let(:resume) { user.resumes.build(name: subject, slug: 'new-resume', content: "\n") }

    context "invalid format" do
      after(:each) do
        expect(resume).to_not be_valid
        expect(resume.errors[:name]).to_not be_empty
      end

      example "my-resume" do
      end

      example "my.resume" do
      end
    end

    context "valid format" do
      after(:each) do
        expect(resume).to be_valid
      end

      example "my resume" do
      end

      example "1st Resume" do
      end
    end
  end

  context "slug format" do
    let(:user) { users(:appleseed) }
    subject do |example|
      example.description
    end
    let(:resume) { user.resumes.build(name: "New Resume", slug: subject, content: "\n") }

    context "invalid format" do
      after(:each) do
        expect(resume).to_not be_valid
        expect(resume.errors[:slug]).to_not be_empty
      end

      example "my resume" do
      end

      example "my.resume" do
      end

      example "my@resume" do
      end

      example "new-resume!" do
      end

      example "(new-resume)" do
      end

      example "new_resume" do
      end

      example "x" do
      end
    end

    context "valid format" do
      after(:each) do
        expect(resume).to be_valid
      end

      example "my-resume" do
      end

      example "my-new-resume" do
      end

      example "My-New-Resume" do
      end
    end
  end

  context "incrementing edition when content changes" do
    let(:resume) { user.resumes.first }

    example "updating content increments edition 1 to 2" do
      expect(resume.edition).to eq 1
      expect(resume.content).to match(/Thomas/)

      resume.content.gsub! /Thomas/, 'Gourdough'
      expect(resume.save).to eq true
      expect(resume.edition).to eq 2
    end
  end

  context "pdf file gets recreated when content changes" do
    let(:resume) { user.resumes.first }

    example "updating content regenerates the pdf file" do
      expect(resume.pdf.path).to be_blank

      resume.content.gsub! /Thomas/, 'Gourdough'
      expect(resume.save).to eq true
      expect(resume.pdf.path).to_not be_blank
      expect(File.exists?(resume.pdf.path)).to eq true
    end
  end

  context "exporting to other formats and other attributes" do
    let(:resume) { user.resumes.first }

    example "generate_pdf_data" do
      expect(resume.generate_pdf_data).to_not be_blank
    end

    example "generate_plain_text" do
      expect(resume.generate_plain_text).to_not be_blank
    end

    example "generate_json_text" do
      expect(resume.generate_json_text).to_not be_blank
    end

    example "structure" do
      expect(resume.structure).to_not be_blank
    end

    example "descriptor" do
      expect(resume.descriptor).to_not be_blank
    end

    example "total_page_views" do
      expect(resume.total_page_views).to eq 0
    end
  end

  example "ensure the content has a newline at the end" do
    resume = user.resumes.create(name: "New Test Resume", slug: "new-test-resume", content: "")
    expect(resume.content.last).to eq "\n"
  end

  example "presence of access_code makes requires_access_code? true" do
    resume = user.resumes.first
    expect(resume.access_code).to be_blank
    expect(resume.requires_access_code?).to eq false

    expect(resume.update(access_code: "ABCDEF")).to eq true
    expect(resume.requires_access_code?).to eq true
  end
end
