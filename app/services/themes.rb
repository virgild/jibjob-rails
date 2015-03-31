module Themes

  def self.list
    if Rails.env.development?
      fetch_theme_names
    else
      @list ||= fetch_theme_names
    end
  end

  def self.fetch_theme_names
    files = Dir.glob("#{Rails.root.join('app', 'assets', 'stylesheets', 'themes')}/*.scss")
    files.map { |f| Pathname.new(f).basename.to_s.gsub(/\.scss$/, '') }
  end

end