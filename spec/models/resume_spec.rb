# == Schema Information
#
# Table name: resumes
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  name             :string           not null
#  content          :text             not null
#  guid             :string           not null
#  status           :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  pdf_file_name    :string
#  pdf_content_type :string
#  pdf_file_size    :integer
#  pdf_updated_at   :datetime
#  edition          :integer          default(0), not null
#  slug             :string           not null
#  is_published     :boolean          default(FALSE), not null
#  access_code      :string
#  pdf_edition      :integer          default(0), not null
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

  context "as a new instance" do
    let(:resume) { Resume.new }

    example "has nil user" do
      expect(resume.user).to be_nil
    end

    example "has blank name" do
      expect(resume.name).to be_blank
    end

    example "has blank content" do
      expect(resume.content).to be_blank
    end

    example "has blank slug" do
      expect(resume.slug).to be_blank
    end

    example "has blank guid" do
      expect(resume.guid).to be_blank
    end

    example "has 0 status" do
      expect(resume.status).to eq 0
    end

    example "has 0 edition" do
      expect(resume.edition).to eq 0
    end

    example "has 0 pdf_edition" do
      expect(resume.pdf_edition).to eq 0
    end

    example "has false is_published" do
      expect(resume.is_published).to eq false
    end

    example "has nil pdf" do
      expect(resume.pdf).to_not be_nil
    end

    example "has 0 publication_views" do
      expect(resume.publication_views.length).to eq 0
    end

    example "has blank access_code" do
      expect(resume.access_code).to be_blank
    end

    example "has false requires_access_code?" do
      expect(resume.requires_access_code?).to eq false
    end
  end

  context "after creation" do
    let(:resume) { user.resumes.create(name: "Test Resume 2", slug: "test-resume-2", content: sample_content) }

    it "has edition 1" do
      expect(resume.edition).to eq 1
    end

    it "has pdf_edition 1" do
      expect(resume.pdf_edition).to eq 1
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

    it "pdf_file_synced? is true" do
      expect(resume.pdf_file_synced?).to eq true
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
    let(:resume) { user.resumes.build(name: subject, slug: 'new-resume', content: "") }

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

  context "after content changes" do
    let(:resume) { user.resumes.first }

    example "edition increments from 1 to 2" do
      expect(resume.edition).to eq 1
      expect(resume.pdf_edition).to eq 1
      expect(resume.content).to match(/Thomas/)

      resume.content.gsub! /Thomas/, 'Gourdough'
      expect(resume.save).to eq true
      expect(resume.edition).to eq 2
      expect(resume.pdf_edition).to eq 1
      expect(resume.pdf_file_synced?).to eq false
    end

    example "pdf refresh job is queued" do
      expect(resume.pdf.path).to be_blank

      assert_enqueued_with(job: PdfRefreshJob) do
        resume.content.gsub! /Thomas/, 'Gourdough'
        expect(resume.save).to eq true
      end
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

    example "total_page_views" do
      expect(resume.total_page_views).to eq 0
    end
  end

  context "with present access_code" do
    it "makes requires_access_code? true" do
      resume = user.resumes.first
      expect(resume.access_code).to be_blank
      expect(resume.requires_access_code?).to eq false

      expect(resume.update(access_code: "ABCDEF")).to eq true
      expect(resume.requires_access_code?).to eq true
    end
  end

  context "saving" do
    context "on create" do
      it "ensures there is always a newline at the end of the content" do
        resume = user.resumes.create(name: "My Resume", slug: "my-resume", content: "")
        expect(resume.content.last).to eq "\n"
      end
    end

    context "on update" do
      it "ensures there is always a newline at the end of the content" do
        resume = resumes(:appleseed_resume)
        resume.content = "#N Terry Gourdough"
        resume.save!
        expect(resume.content).to eq("#N Terry Gourdough\n")
      end
    end
  end
end
