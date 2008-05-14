module Assert
  class AssertionError < RuntimeError; end

  PERFORMANCE_OVER_STABILITY = false

  def assert(err_msg=nil, &block)
    unless PERFORMANCE_OVER_STABILITY
      err_msg ||= "assertion failed"
      raise AssertionError, err_msg if not block.call
    end
  end
  module_function :assert
end
