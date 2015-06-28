require 'ruby-prof'

module Raijin
  class CpuProfilePrinter < RubyProf::AbstractPrinter
    def print(output = STDOUT)
      @call_uid = -1
      @id = -1
      thread = @result.threads[0]
      call_infos = RubyProf::CallInfo.roots_of(thread.top_call_infos)
      output << '{
  "head": {
     "functionName": "(root)",
    "scriptId": "0",
    "url": "",
    "lineNumber": 0,
    "columnNumber": 0,
    "hitCount": 0,
    "callUID": 5,
    "children": ['
      print_call_infos(call_infos, output)
  output << "],
  \"startTime\": 0,
  \"endTime\": 643781.273678,
  \"samples\": #{@samples},
  \"timestamps\": #{@timestamps}
}"
    end
private
    def print_call_infos(call_infos, output)
      last_index = call_infos.size - 1
      call_infos.each_with_index do |call_info, index|
        target = call_info.target
        full_name = target.full_name
        id = next_id
        output << "{
  \"functionName\": \"#{full_name}\",
  \"scriptId\": 0,
  \"url\": \"file://#{target.source_file}\",
  \"lineNumber\": #{call_info.line},
  \"columnNumber\": 0,
  \"hitCount\": #{target.called},
  \"callUID\": #{next_call_uid},
  \"id\": #{id},
  \"children\": ["
        print_call_infos(call_info.children, output)
        output << ']
}'
        if index != last_index
          output << ', '
        end
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