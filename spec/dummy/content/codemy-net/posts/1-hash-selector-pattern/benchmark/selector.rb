require 'benchmark'

class Selector


  def initialize(key)
    @key = key
  end

  def selector_if
    if @key == :success
      'alert-success'
    elsif @key == :error
      'alert-danger'
    elsif @key == :warn
      'alert-warning'
    elsif @key == :info
      'alert-info'
    end
  end

  def selector_case
    case @key
      when :success then 'alert-success'
      when :error   then 'alert-danger'
      when :warn    then 'alert-warning'
      when :info    then 'alert-info'
    end
  end

  ALERT_TYPES = { success: 'alert-success',
                  error:   'alert-danger',
                  notice:  'alert-info',
                  warn:    'alert-warning' }

  def selector_hash_cached
    ALERT_TYPES[@key]
  end

  def selector_hash
    { success: 'alert-success',
      error:   'alert-danger',
      notice:  'alert-info',
      warn:    'alert-warning' }[@key]
  end
end

Benchmark.bm(25) do |x|
  x.report("if") { 
    1.times do 
      selector = Selector.new([:success, :error, :notice, :warn].sample)
      selector.selector_if
    end
  }

  x.report("case") { 
    1.times do 
      selector = Selector.new([:success, :error, :notice, :warn].sample)
      selector.selector_case
    end
  }
 
  x.report("hash_select_cached") { 
    1.times do 
      selector = Selector.new([:success, :error, :notice, :warn].sample)
      selector.selector_hash_cached
    end
  }

  x.report("hash_select") { 
    1.times do 
      selector = Selector.new([:success, :error, :notice, :warn].sample)
      selector.selector_hash
    end
  }
end

