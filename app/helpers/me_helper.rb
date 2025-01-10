module MeHelper
  def self.build_time_format time
    return "" unless time
    day = time.day.to_s.rjust 2, " "
    month = time.month.to_s.rjust 2, " "
    "#{day}/#{month}/%y %H:%M"
  end

  def format_time time, format = MeHelper.build_time_format(time)
    if time
      time.strftime format
    else
      ""
    end
  end
end
