class ResumeStats
  def self.hourly_times_between(start_date, end_date, &blk)
    date1 = start_date.in_time_zone('UTC')
    date2 = end_date.in_time_zone('UTC')
    if blk
      (date1.to_i .. date2.to_i).step(1.hour).each { |t| yield Time.at(t).at_beginning_of_hour.in_time_zone('UTC') }
      nil
    else
      (date1.to_i .. date2.to_i).step(1.hour).map { |t| Time.at(t).at_beginning_of_hour.in_time_zone('UTC') }
    end
  end

  def self.hourly_stats_keys_for(start_date, end_date)
    self.hourly_times_between(start_date, end_date).map do |time|
      time.strftime("day-%Y-%j-%H")
    end
  end
end