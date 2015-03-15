class Resume::ShowSerializer < ResumeSerializer
  def filter(keys)
    keys - [:errors]
  end
end