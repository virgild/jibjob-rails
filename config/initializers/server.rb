unless Rails.env.test?
  hostname = `hostname`.strip!
  pid = $$

  Rails.configuration.action_dispatch.default_headers.merge!({
    'X-Worker-Pants': "#{hostname}-#{pid}"
  });
end
