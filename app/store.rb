class Store
  include Inesita::Store

  # attr_accessor :loaded
  attr_accessor :previous_hash

  def initialize
    # @loaded = false
    @previous_hash = ""
    @store = {
      "batt-type-lipo"         => 1,
      "batt-cells"             => 10,
      "motor-kv"               => 200,
      "system-efficiency"      => 80,
      "out-battery-volts"      => 0,
      "out-motor-rpm"          => 0,
      "out-motor-rpm-weighted" => 0,
      "out-motor-erpm"         => 0,
      "motor-pulley-teeth"     => 15,
      "wheel-pulley-teeth"     => 36,
      "wheel-size"             => 83,
      "out-gear-ratio"         => "x",
      "out-top-speed"          => 0,
      "out-top-speed-weighted" => 0,
    }
    store = @store.to_n
    # localStorage_load!
  end

  def set(key, value)
    @store[key] = value
  end

  def get(key)
    @store[key]
  end

  def store_data
    data = {}
    @store.each do |key, val|
      data[key] = val unless key =~ /^out-/
    end
    data
  end

  def to_json
    JSON = Native `JSON`
    JSON.stringify store_data.to_n
  end

  # def merge!(values)
  #   @store.merge! values
  # end

  def save!
    @store.each do |key, val|
      `localStorage["esk8_calc_"+key] = val`
    end
    `localStorage.esk8_calc = true`
  end

  def localStorage_load!
    if `localStorage.esk8_calc` && location_hash_blank?
      #   @store = Hash.new `localStorage.esk8_calc_store`
      @store.each do |key, _|
        val = `localStorage["esk8_calc_"+key]`
        unless key == "batt-cells"
          set key, val.to_i
        else
          set key, val.to_f
        end
      end
    end
  end

  private

  def location_hash_blank?
    hash = $$.location.hash
    hash = hash[1..-1]
    !hash || hash == ""
  end
end
