class PdfRefreshJob < BaseJob
  queue_as :default

  def perform(*args)
    resume = args[0]
    if resume
      resume.update_pdf_attachment
      resume.save!
    end
  end
end
