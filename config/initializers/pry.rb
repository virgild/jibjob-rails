if Rails.env.development?
  Pry.config.pager = false

  AwesomePrint.pry!
end