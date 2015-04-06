class Resume::PDFStatusSerializer < ResumeSerializer

  def filter(keys)
    [:id, :pdf_file_synced, :thumbnail]
  end
end