require 'ruby-prof'

module Raijin
  # https://chromium.googlesource.com/chromium/blink/+/master/Source/devtools/protocol.json
  class CpuProfilePrinter < RubyProf::AbstractPrinter
    def print(output = STDOUT, options={})
      @call_uid = -1
      @id = -1
      @samples = []
      @timestamps = []
      @total = 0
      @min_ratio = (options[:min_percent] || 0) / 100
      thread = @result.threads[0]
      @thread_total_time = thread.total_time
      call_infos = RubyProf::CallInfo.roots_of(thread.top_call_infos)
      output << "
{
  \"head\": {
    \"functionName\": \"(root)\",
    \"scriptId\": \"0\",
    \"url\": \"\",
    \"lineNumber\": 0,
    \"columnNumber\": 0,
    \"hitCount\": 0,
    \"callUID\": #{next_call_uid},
    \"id\": #{next_id},
    \"children\": ["
      print_call_infos(call_infos, output)
    output << "]
  },
  \"startTime\": 0,
  \"endTime\": #{@thread_total_time},
  \"samples\": [#{@samples.join(', ')}],
  \"timestamps\": [#{@timestamps.join(', ')}]
}"
    end
private
    MICROSECONDS_IN_SECOND = 1_000_000
    def print_call_infos(call_infos, output)
      last_index = call_infos.size - 1
      outputed_nodes_count = 0
      call_infos.each_with_index do |call_info, index|
        total_time = call_info.total_time
        if total_time / @thread_total_time < @min_ratio
          next
        end
        self_time = call_info.self_time * MICROSECONDS_IN_SECOND
        target = call_info.target
        full_name = target.full_name
        id = next_id
        @samples << id
        @timestamps << @total + self_time
        if outputed_nodes_count > 0
          output << ','
        end
        output << "{
  \"functionName\": \"#{full_name}\",
  \"scriptId\": 0,
  \"url\": \"file://#{target.source_file}\",
  \"lineNumber\": #{call_info.line},
  \"columnNumber\": 0,
  \"hitCount\": #{target.called},
  \"callUID\": #{next_call_uid},
  \"positionTicks\": [{
      \"line\": #{call_info.line},
      \"ticks\": 1
  }],
  \"id\": #{id},
  \"children\": ["

        print_call_infos(call_info.children, output)

        output << ']
}'
        outputed_nodes_count += 1
      end
    end

    def next_call_uid
      @call_uid += 1
    end

    def next_id
      @id += 1
    end
  end
end