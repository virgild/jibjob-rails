require 'rails_helper'

RSpec.describe PdfRefreshJob, type: :job do
  fixtures :all

  context "after running" do
    let(:resume) { resumes(:unsynced_resume) }

    before(:each) do
      expect(resume.edition).to eq 2
      expect(resume.pdf_edition). to eq 1

      PdfRefreshJob.perform_now(resume)
    end

    it "updates the pdf file" do
      expect(File.exists?(resume.pdf.path)).to eq true
      expect(resume.pdf_file_size).to be > 0
    end

    it "increments the pdf_edition" do
      expect(resume.pdf_edition).to eq 2
    end

    it "makes pdf_file_synced? true" do
      expect(resume.pdf_file_synced?).to eq true
    end
  end
end
