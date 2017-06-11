class Calc
  LIPO_VOLTS = 3.7
  LIIO_VOLTS = 3.6
  LIFE_VOLTS = 3.2

  R = 0.00003728226

  def self.calc!(store)
    type_lipo  = store.get "batt-type-lipo"
    cell_volts = case type_lipo
      when 0 then LIIO_VOLTS
      when 1 then LIPO_VOLTS
      when 2 then LIFE_VOLTS
    end

    batt_cells = store.get "batt-cells"
    batt_volts = (batt_cells * cell_volts).round 1
    store.set "out-battery-volts", batt_volts

    motor_kv = store.get "motor-kv"
    raw_efficiency = store.get "system-efficiency"
    efficiency = raw_efficiency / 100

    motor_rpm = motor_kv * batt_volts
    motor_rpm_weighted = motor_rpm * efficiency
    store.set "out-motor-rpm", motor_rpm
    store.set "out-motor-rpm-weighted", motor_rpm_weighted

    motor_teeth    = store.get "motor-pulley-teeth"
    wheel_teeth    = store.get "wheel-pulley-teeth"
    gear_ratio     = motor_teeth / wheel_teeth
    gear_ratio_out = (wheel_teeth / motor_teeth).round(2)
    store.set "out-gear-ratio", gear_ratio_out

    wheel_size = store.get "wheel-size"
    top_speed_mph   = motor_rpm * wheel_size * Math::PI * R * gear_ratio
    top_speed_mph_w = top_speed_mph * efficiency
    store.set "out-top-speed", top_speed_mph
    store.set "out-top-speed-weighted", top_speed_mph_w

    erpm = batt_volts * motor_kv * 7
    store.set "out-motor-erpm", erpm
  end
end
