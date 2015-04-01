desc "Install fonts (Linux only)"
task :install_fonts do
  `/bin/cp -R #{Rails.root}/app/assets/fonts/print/* #{ENV['FONTS_INSTALL_DIR']}`
  `fc-cache -f`
end