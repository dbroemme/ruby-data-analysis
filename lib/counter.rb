class Counter
    attr_accessor :data

    def initialize(name)
        @data = {}
    end
    
    def increment(key)
        value = @data[key]
        if value
            @data[key] = value + 1
        else
            @data[key] = 1
        end     
    end
    
    def count(key)
        value = @data[key]
        if value
            return value
        else
            return 0
        end
    end

    # returns a sorted array of the form [ [key, count], [key, count], ...]
    def get_sorted_array
        @data.sort_by { |key, count| count }
    end
end
