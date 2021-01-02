require 'net/http'
require 'json'
require 'date'

def get_data_from_website(url)
    Net::HTTP.get(URI(url))
end

def get_price_in_usd(data)
    parsed_data = JSON.parse(data)
    price_in_usd = parsed_data["USD"]["15m"]
    return price_in_usd
end

def create_personal_greeting(name)
    "Hello #{name}"
end

def calculate_days_until(birthday)
    # The birthday is a string with the format MM/DD
    month = birthday[0..1]
    day = birthday[3..4]
    now = Time.now
    bday = Time.new(now.year, month.to_i, day.to_i)
    if bday < now
        # We need to set the year to next year
        bday = Time.new(now.year + 1, month.to_i, day.to_i)
    end
    # Now get the difference in days between the two
    ((bday - now).to_i / (24 * 60 * 60)) + 1
end

def newline
    puts " "
end

def pad(str, size, left_align = false)
    str = str.to_s
    if left_align
        str[0, size].ljust(size, ' ')
    else
        str[0, size].rjust(size, ' ')
    end
end
