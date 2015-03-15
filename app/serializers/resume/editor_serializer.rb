class Resume::EditorSerializer < ResumeSerializer

  def filter(keys)
    keys - [:structure]
  end

end