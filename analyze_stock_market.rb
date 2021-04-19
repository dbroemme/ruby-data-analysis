require_relative 'lib/helpers'
require_relative 'lib/stats'

TOTAL_COUNT = "total"

# The data file comes from https://finance.yahoo.com
# The format of this file is as follows:
#
# Date,Open,High,Low,Close,Adj Close,Volume
# 1971-02-05,100.000000,100.000000,100.000000,100.000000,100.000000,0
# 1971-02-08,100.839996,100.839996,100.839996,100.839996,100.839996,0
# ...
# 2020-12-30,12906.509766,12924.929688,12857.759766,12870.000000,12870.000000,5292210000
# 2020-12-31,12877.089844,12902.070313,12821.230469,12888.280273,12888.280273,4771390000

def display_row(n, c, p)
    puts "#{pad(n, 10)}  #{pad(c, 10)}  #{pad(p, 10)}"
end

DATA_FILE = "./data/NASDAQ.csv"
stats = Stats.new("NASDAQ")
previous_close = nil

puts "Read the data file #{DATA_FILE}"
File.readlines(DATA_FILE).each do |line|
    line = line.chomp  # remove the carriage return

    if line.length > 0 and line[0].match(/[0-9]/)
        # A line from the file has comma-separated values
        # Date,Open,High,Low,Close,Adj Close,Volume
        values = line.split(",")
        date = Date.strptime(values[0], "%Y-%m-%d")
        weekday = Date::DAYNAMES[date.wday]

        open_value = values[1].to_f
        close_value = values[4].to_f

        if previous_close.nil?
            # Just use the first day to set the baseline
            previous_close = close_value
        else 
            change_from_previous_close = close_value - previous_close
            change_intraday = close_value - open_value
            change_overnight = open_value - previous_close
            
            change_percent = change_from_previous_close / previous_close

            stats.add(weekday, change_percent)
            stats.add("#{weekday} prev close", change_from_previous_close)
            stats.add("#{weekday} intraday", change_intraday)
            stats.add("#{weekday} overnight", change_overnight)

            previous_close = close_value
        end
    end
end

#puts "Number of weeks: #{stats.count('Monday')}"
#stats.display_counts

puts "Mon: #{stats.sum('Monday')}"
puts "Tue: #{stats.sum('Tuesday')}"
puts "Wed: #{stats.sum('Wednesday')}"
puts "Thu: #{stats.sum('Thursday')}"
puts "Fri: #{stats.sum('Friday')}"

puts " "
stats.report(Date::DAYNAMES[1..5])
