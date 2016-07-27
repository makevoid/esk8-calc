require 'calc'

class Home
  include Inesita::Component

  def initialize
    block = lambda do
      Calc.calc! @store
      render!
    end

    `window.setTimeout(#{block.to_n}, 1000)`
  end

  def change(e)
    key = e.target.name
    val = e.target.value
    `console.log(key, val)`
    @store.set key, val.to_i
    Calc.calc! @store
    render!
  end

  def save(e)
    @store.save!
  end

  def label_speed(weighted: false)
    speed = @store.get "out-top-speed#{"-weighted" if weighted}"
    speed_kmh = speed * 1.609344
    "#{speed.round 2} mph - #{speed_kmh.round 2} km/h"
  end

  def label_gear_ratio
    "#{@store.get("out-gear-ratio")}:1"
  end

  def render
    div class: 'jumbotron text-center' do
      h1 do
        text "ESK8 Calc"
      end
      p(class: "tagline") do
        text "Electric Skateboard Calculator"
      end
      div(class: "s20")

      section(class: "calc-form") {
        form {
          div(class: "row") {
            div(class: "col-xs-12 col-md-8") {
              h1 { text "Battery and Motor" }
              div(class: "s10")
            }

            div(class: "col-xs-12 col-md-4 heading-gearing") {
              h1 { text "Gearing" }
            }
          }

          div(class: "row") {
            div(class: "col-md-4 col-xs-12") {

              div(class: "form-group") {
                label(for: "batt-type") {
                  text "Battery type"
                }

                lipo = @store.get("batt-type-lipo") == 1

                select(name: "batt-type-lipo", id: "batt-type", class: "form-control", onchange: method(:change)) {
                  option(value: 1, selected: lipo) { text "Lipo" }
                  option(value: 0, selected: !lipo) { text "Li-ion" }
                }
              }

              div(class: "form-group") {
                label(for: "batt-cells") {
                  text "Number of Cells (6S-12S)"
                }
                input(name: 'batt-cells', value: @store.get("batt-cells"), onkeyup: method(:change), type: "text", id: "batt-cells", class: "form-control")
              }

              div(class: "form-group") {
                label(for: "motor-kv") {
                  text "Motor KV"
                }
                input(name: 'motor-kv', value: @store.get("motor-kv"), onkeyup: method(:change), type: "text", id: "motor-kv", class: "form-control")
              }

              div(class: "form-group") {
                label(for: "system-efficiency") {
                  text "Efficiency  (60-90%)"
                }
                input(name: 'system-efficiency', value: @store.get("system-efficiency"), onkeyup: method(:change), type: "text", id: "system-efficiency", class: "form-control")
              }
            }

            div(class: "col-xs-12 col-md-4") {
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
                  text "#{(@store.get "out-motor-rpm").round} RPM"
                }
              }

              div(class: "form-group") {
                label(class: "control-label") { text "Motor RPM (weighted)" }
                p(class: "form-control-static") {
                  text "#{(@store.get "out-motor-rpm-weighted").round} RPM"
                }
              }

            }

            div(class: "col-xs-12 col-md-4") {

              div(class: "heading-gearing-sm") {
                h1 { text "Gearing" }
              }

              div(class: "s5")

              div(class: "") {
                div(class: "form-group") {
                  label(for: "motor-pulley-teeth") {
                    text "Motor Pulley Teeth"
                  }
                  input(name: 'motor-pulley-teeth', type: "text", id: "motor-pulley-teeth", class: "form-control", value: @store.get("motor-pulley-teeth"), onkeyup: method(:change))
                }

                div(class: "form-group") {
                  label(for: "wheel-pulley-teeth") {
                    text "Wheel Pulley Teeth"
                  }
                  input(name: 'wheel-pulley-teeth', type: "text", id: "wheel-pulley-teeth", class: "form-control", value: @store.get("wheel-pulley-teeth"), onkeyup: method(:change))
                }

                div(class: "form-group") {
                  label(for: "wheel-size") {
                    text "Wheel size (mm)"
                  }
                  input(name: 'wheel-size', type: "text", id: "wheel-size", class: "form-control", value: @store.get("wheel-size"), onkeyup: method(:change))
                }
              }

              div(class: "form-group") {
                label(class: "control-label") { text "Gear ratio" }
                p(class: "form-control-static") {
                  text label_gear_ratio
                }
              }
            }
          }

          h1 { text "Top Speed" }
          div(class: "s5")

          div(class: "form-group") {
            p(class: "form-control-static") {
              text "#{label_speed}"
            }
          }

          div(class: "form-group") {
            p {
              text  label_speed(weighted: true)
            }
            label(class: "control-label up-10") { text "(weighted)" }
          }
        }
      }
      div(class: "s20")

      button(onclick: method(:save)) {
        text "Save"
      }

      div(class: "s30")
    end

  end
end
