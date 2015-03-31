unless Rails.env.test?
  WickedPdf.config = {
    :exe_path => ENV['WKHTMLTOPDF_BIN']
  }
end