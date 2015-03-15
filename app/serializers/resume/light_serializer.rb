class Resume::LightSerializer < ResumeSerializer

  def filter(keys)
    keys - [:content, :structure, :errors]
  end
end