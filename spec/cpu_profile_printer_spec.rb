require 'spec_helper'
require 'json'

describe Raijin::CpuProfilePrinter do
  class SlowChild
    def run_child
      sum = 0
      (1..10).each do |v|
        sum += run_child_nested
      end
      sum
    end

    def run_child_nested
      sleep 0.001
      3
    end
  end
  class FastParent
    def initialize(slow_child = SlowChild.new)
      @slow_child = slow_child
    end

    def run_parent
      parent_sum = 0
      parent_sum += @slow_child.run_child
      parent_sum
    end
  end

  def printer(result)
    Raijin::CpuProfilePrinter.new(result)
  end

  context 'with no recursion' do
    let(:output) { StringIO.new }
    let(:output_parsed) { JSON.parse(output.string) }
    before do
      result = RubyProf.profile do
        parent = FastParent.new
        parent.run_parent
      end
      printer(result).print(output)
    end

    it 'produces some output' do
      expect(output.size).to be > 0
    end

    it 'builds valid json' do
      expect(output_parsed).to_not be nil
    end

    it 'fills timestamps' do
      expect(output_parsed['timestamps'].size).to be > 0
    end

    it 'fills samples' do
      expect(output_parsed['samples'].size).to be > 0
    end
  end

end