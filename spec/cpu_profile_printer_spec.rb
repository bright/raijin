require 'spec_helper'

describe Raijin::CpuProfilePrinter do
  class SlowChild
    def run_child
      sum = 0
      (1..10).each do |v|
        sum += run_child_nested
        sleep 0.001
      end
      sum
    end

    def run_child_nested
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
    subject {
      result = RubyProf.profile do
        parent = FastParent.new
        parent.run_parent
      end
      printer(result).print
    }

    it 'is not nil' do
      expect(subject).to_not be nil
    end
  end

end