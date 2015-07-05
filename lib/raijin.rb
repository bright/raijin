require 'raijin/version'

module Raijin
  require 'raijin/cpu_profile_printer'
end

module RubyProf
  CpuProfilePrinter = Raijin::CpuProfilePrinter
end
