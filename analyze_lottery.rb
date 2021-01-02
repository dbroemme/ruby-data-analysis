require_relative 'lib/helpers'
require_relative 'lib/counter'

# Step 1: Read the data file
# Step 2: For each line, split up the data into its parts
# Step 3: Keep track of the number of occurrences for each number
# Step 4: Display a list of the results
#
# The data file comes from https://www.valottery.com/data/draw-games/pick4
# The format of this file is as follows:
#
# Results for Pick 4
# 12/20/2020; Day: 7,1,5,9; Night: 3,5,9,2
# 12/19/2020; Day: 7,7,9,8; Night: 2,9,4,1
# 12/18/2020; Day: 8,6,9,7; Night: 9,1,2,6
# ...
# 10/1/1991; Night: 5,1,5,3
# 9/30/1991; Night: 3,3,4,5
#
# All information is entered manually, and is subject to human error.
# Therefore, we can not guarantee the accuracy of this information.

DATA_FILE = "./data/Pick4_12_21_2020.txt"
counter = Counter.new("Lottery Numbers")

puts "Read the data file #{DATA_FILE}"
File.readlines(DATA_FILE).each do |line|
    line = line.chomp  # remove the carriage return

    if line.length > 0 and line[0].match(/[0-9]/)
        # A data line looks like this
        # 12/20/2020; Day: 7,1,5,9; Night: 3,5,9,2
        sections = line.split(";")
        # The sections are [0] date
        #                  [1] drawing1
        #                  [2] drawing2
        # There could be either two or three sections
        # as older lottery drawings only occurred at night
        (1..sections.size-1).each do |section_index|
            counter.increment("total")
            section = sections[section_index]
            # A section has the format:  Day: 7,1,5,9
            # Extract just the number portion and then
            # split by comma to get the individual numbers
            str_numbers = section.partition(":")[2].strip
            numbers = str_numbers.split(",")
            numbers.each do |str_number|
                counter.increment(str_number.to_i)
            end
        end
    end
end

total = counter.count("total")
newline
puts "#{pad('Number', 10)}  #{pad('Count', 10)}  #{pad('Percent', 10)}"
puts "#{'-' * 10}  #{'-' * 10}  #{'-' * 10}"
counter.get_sorted_array.each do |number_and_count_array|
    # The sorted array elements are [number, count]
    number = number_and_count_array[0]
    occurrences = number_and_count_array[1]
    percent = (occurrences.to_f / total.to_f).round(5)
    puts "#{pad(number,10)}  #{pad(occurrences,10)}  #{pad(percent,10)}"
end
newline

