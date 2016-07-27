class Store
  include Inesita::Store

  def initialize
    @store = {
      "batt-cells"             => 10,
      "motor-kv"               => 200,
      "system-efficiency"      => 80,
      "out-battery-volts"      => 0,
      "out-motor-rpm"          => 0,
      "out-motor-rpm-weighted" => 0,
      "motor-pulley-teeth"     => 15,
      "wheel-pulley-teeth"     => 36,
      "wheel-size"             => 83,
      "out-gear-ratio"         => "x",
      "out-top-speed"          => 0,
      "out-top-speed-weighted" => 0,
    }
  end

  def set(key, value)
    @store[key] = value
  end

  def get(key)
    @store[key]
  end
end
