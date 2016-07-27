class Calc
  LIPO_VOLTS = 3.7

  R = 0.00003728226

  def self.calc!(store)
    cell_volts = LIPO_VOLTS
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
    gear_ratio_out = (wheel_teeth / motor_teeth).round(1)
    store.set "out-gear-ratio", gear_ratio_out

    wheel_size = store.get "wheel-size"
    top_speed_mph   = motor_rpm * wheel_size * Math::PI * R * gear_ratio
    top_speed_kmh   = top_speed_mph * 1.609344
    top_speed_mph_w = top_speed_mph * efficiency
    top_speed_kmh_w = top_speed_kmh * efficiency
    store.set "out-top-speed", top_speed_mph
    store.set "out-top-speed-weighted", top_speed_mph_w
  end
end

class Home
  include Inesita::Component

  def change(e)
    key = e.target.name
    val = e.target.value
    @store.set key, val.to_i
    Calc.calc! @store
    render!
  end

  def label_speed(weighted: false)
    speed = @store.get "out-top-speed#{"-weighted" if weighted}"
    "#{speed.round 2} km/h - x mph"
  end

  def label_gear_ratio
    "#{@store.get("out-gear-ratio")}:1"
  end

  def render
    div class: 'jumbotron text-center' do
      h1 do
        text "ESK8 Calc"
      end
      p do
        text "Electric Skateboard Calculator"
      end

      div(class: "s10")

      section(class: "calc-form") {
        form {

          div(class: "row") {
            h1 { text "Battery and Motor" }
            div(class: "s10")

            div(class: "col-xs-6") {

              div(class: "form-group") {
                label(for: "batt-type") {
                  text "Battery type"
                }
                select(name: "batt-type", id: "batt-type", class: "form-control") {
                  option { text "Lipo" }
                  option { text "Li-ion" }
                }
              }

              div(class: "form-group") {
                label(for: "batt-cells") {
                  text "Number of Cells (6S-12S)"
                }
                input(name: 'batt-cells', value: @store.get("batt-cells"), onchange: method(:change), type: "text", id: "batt-cells", class: "form-control")
              }

              div(class: "form-group") {
                label(for: "motor-kv") {
                  text "Motor KV"
                }
                input(name: 'motor-kv', value: @store.get("motor-kv"), onchange: method(:change), type: "text", id: "motor-kv", class: "form-control")
              }

              div(class: "form-group") {
                label(for: "system-efficiency") {
                  text "Efficiency  (60-90%)"
                }
                input(name: 'system-efficiency', value: @store.get("system-efficiency"), onchange: method(:change), type: "text", id: "system-efficiency", class: "form-control")
              }
            }

            div(class: "col-xs-6") {
              div(class: "s30")

              div(class: "form-group") {
                label(class: "control-label") { text "Battery volts" }
                p(class: "form-control-static") {
                  text "#{@store.get "out-battery-volts"} V"
                }
              }

              div(class: "form-group") {
                label(class: "control-label") { text "Motor RPM" }
                p(class: "form-control-static") {
                  text "#{@store.get "out-motor-rpm"} RPM"
                }
              }

              div(class: "form-group") {
                label(class: "control-label") { text "Motor RPM (weighted)" }
                p(class: "form-control-static") {
                  text "#{@store.get "out-motor-rpm-weighted"} RPM"
                }
              }

            }
          }

          h1 { text "Gearing" }
          div(class: "s10")

          div(class: "wrap-60") {
            div(class: "form-group") {
              label(for: "motor-pulley-teeth") {
                text "Motor Pulley Teeth"
              }
              input(name: 'motor-pulley-teeth', type: "text", id: "motor-pulley-teeth", class: "form-control", value: @store.get("motor-pulley-teeth"), onchange: method(:change))
            }

            div(class: "form-group") {
              label(for: "wheel-pulley-teeth") {
                text "Wheel Pulley Teeth"
              }
              input(name: 'wheel-pulley-teeth', type: "text", id: "wheel-pulley-teeth", class: "form-control", value: @store.get("wheel-pulley-teeth"), onchange: method(:change))
            }

            div(class: "form-group") {
              label(for: "wheel-size") {
                text "Wheel size (mm)"
              }
              input(name: 'wheel-size', type: "text", id: "wheel-size", class: "form-control", value: @store.get("wheel-size"), onchange: method(:change))
            }
          }

          div(class: "form-group") {
            label(class: "control-label") { text "Gear ratio" }
            p(class: "form-control-static") {
              text label_gear_ratio
            }
          }

          h1 { text "Top Speed Results" }
          div(class: "s10")

          div(class: "form-group") {
            label(class: "control-label") { text "Top Speed" }
            p(class: "form-control-static") {
              text label_speed
            }
          }

          div(class: "form-group") {
            label(class: "control-label") { text "Top Speed (weighted)" }
            p(class: "form-control-static") {
              text  label_speed(weighted: true)
            }
          }

        }
      }

      div(class: "s40")
    end

  end
end
