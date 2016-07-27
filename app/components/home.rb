class Home
  include Inesita::Component

  def change(e)
    render!
  end

  def speed_label(weighted: false)
    speed = @store.get "top-speed#{"-weighted" if weighted}"
    "#{speed} km/h - x mph"
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
                text "Motor Pulley Teeth"
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

          div(class: "s10")
          h1 { text "Top Speed Results" }
          div(class: "s10")

          div(class: "form-group") {
            label(class: "control-label") { text "Top Speed" }
            p(class: "form-control-static") {
              text speed_label
            }
          }

          div(class: "form-group") {
            label(class: "control-label") { text "Top Speed (weighted)" }
            p(class: "form-control-static") {
              text  speed_label(weighted: true)
            }
          }

        }
      }

      div(class: "s40")
    end

  end
end
