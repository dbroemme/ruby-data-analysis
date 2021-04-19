SPACER = "  "
VALUE_WIDTH = 10

class Stats
    attr_accessor :name
    attr_accessor :data

    def initialize(name)
        @name = name
        @data = {}
    end
    
    def add(key, value)
        data_set = @data[key]
        if data_set
            data_set << value
        else
            data_set = []
            data_set << value
            @data[key] = data_set
        end     
    end
    
    def increment(key)
        add(key, 1)
    end
    
    def count(key)
        data_set = @data[key]
        if data_set
            return data_set.size
        else
            return 0
        end
    end

    def sum(key)
        data_set = @data[key]
        if data_set
            return data_set.inject(0.to_f){|sum,x| sum + x }
        else
            return 0
        end
    end
    
    def average(key)
        data_set = @data[key]
        if data_set
            return (sum(key) / count(key)).round(5)
        else
            return 0
        end
    end
    
    def min(key)
        data_set = @data[key]
        if data_set
            return data_set.min
        else
            return 0
        end
    end

    def max(key)
        data_set = @data[key]
        if data_set
            return data_set.max
        else
            return 0
        end
    end

    def sample_variance(key)
        data_set = @data[key]
        return 0 unless data_set
        m = average(key)
        s = data_set.inject(0.0){|accum, i| accum +(i-m)**2 }
        s/(data_set.length - 1).to_f
    end

    def std_dev(key)
        Math.sqrt(sample_variance(key))
    end

    def halfway(b, e)
        d = e - b
        m = b + (d / 2).to_i
        #puts "Calculated middle of #{b} and #{e} to be #{m}"
        m
    end 

    def percentile(key, pct)
        data_set = @data[key]
        if data_set
            sorted_data_set = data_set.sort
            pct_index = (data_set.length - 1).to_f * pct
            mod = pct_index.modulo(1.0)
            adj = pct_index
            if mod > 0.9
                adj = pct_index.ceil
            elsif mod < 0.1
                adj = pct_index.floor
            else
                # We want halfway between the two indices
                low = pct_index.floor
                high = pct_index.ceil
                if low < 0
                    low = 0
                end
                if high > data_set.size - 1
                    high = data_set.size - 1
                end
                result = halfway(sorted_data_set[low], sorted_data_set[high])
                return result
            end
            
            if adj < 0
                adj = 0
            elsif adj > data_set.size - 1
                adj = data_set.size - 1
            end
            result = sorted_data_set[adj]
            #puts "percentile pct_index: #{pct_index}; Mod #{mod}; Adj #{adj} of #{data_set.length}. Answer is #{result}"
            return result
        else
            return 0
        end
    end

    def most_common(key)
        value_counts = {}
        data_set = @data[key]
        data_set.each do |data|
            c = value_counts[data]
            if c.nil?
                value_counts[data] = 1
            else
                value_counts[data] = value_counts[data] + 1
            end
        end
        
        largest_count = 0
        largest_key = "none"
        value_counts.keys.each do |key|
            key_count = value_counts[key]
            if key_count > largest_count
                largest_count = key_count
                largest_key = key
            end
        end
        largest_key
    end

    def display_counts
        puts "#{pad(@name, 20)}   Value"
        puts "#{'-' * 20}   #{'-' * 10}"
        @data.keys.each do |key|
            #data_set = @data[key]
            puts "#{pad(key, 20)}   #{count(key)}"
        end
    end
    
    def report(report_keys = nil)
        puts "#{pad(@name, 10)}#{SPACER}#{pad('Count', 7)}#{SPACER}#{pad('Min', VALUE_WIDTH)}#{SPACER}#{pad('Avg', VALUE_WIDTH)}#{SPACER}#{pad('StdDev', VALUE_WIDTH)}#{SPACER}#{pad('Max', VALUE_WIDTH)}#{SPACER}| #{pad('p1', VALUE_WIDTH)}#{SPACER}#{pad('p10', VALUE_WIDTH)}#{SPACER}#{pad('p50', VALUE_WIDTH)}#{SPACER}#{pad('p90', VALUE_WIDTH)}#{SPACER}#{pad('p99', VALUE_WIDTH)}"
        puts "#{'-' * 10}#{SPACER}#{'-' * 7}#{SPACER}#{'-' * VALUE_WIDTH}#{SPACER}#{'-' * VALUE_WIDTH}#{SPACER}#{'-' * VALUE_WIDTH}#{SPACER}#{'-' * VALUE_WIDTH}#{SPACER}| #{'-' * VALUE_WIDTH}#{SPACER}#{'-' * VALUE_WIDTH}#{SPACER}#{'-' * VALUE_WIDTH}#{SPACER}#{'-' * VALUE_WIDTH}#{SPACER}#{'-' * VALUE_WIDTH}"
        if report_keys.nil?
            report_keys = @data.keys
        end
        report_keys.each do |key|
            data_set = @data[key]
            m1 = min(key).round(5)
            a = average(key).round(5)
            sd = std_dev(key).round(5)
            m2 = max(key).round(5)
            p1 = percentile(key, 0.01).round(5)
            p10 = percentile(key, 0.1).round(5)
            p50 = percentile(key, 0.5).round(5)
            p90 = percentile(key, 0.90).round(5)
            p99 = percentile(key, 0.99).round(5)
            puts "#{pad(key, 10)}#{SPACER}#{pad(count(key), 7)}#{SPACER}#{pad(m1, VALUE_WIDTH)}#{SPACER}#{pad(a, VALUE_WIDTH)}#{SPACER}#{pad(sd, VALUE_WIDTH)}#{SPACER}#{pad(m2, VALUE_WIDTH)}#{SPACER}| #{pad(p1, VALUE_WIDTH)}#{SPACER}#{pad(p10, VALUE_WIDTH)}#{SPACER}#{pad(p50, VALUE_WIDTH)}#{SPACER}#{pad(p90, VALUE_WIDTH)}#{SPACER}#{pad(p99, VALUE_WIDTH)}"
        end    
    end
end
