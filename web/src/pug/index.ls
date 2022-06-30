view = new ldview root: document.body
lddtp1 = new lddatetimepicker host: view.get(\lddtp1), time: true
lddtp2 = new lddatetimepicker host: view.get(\lddtp2), time: false
lddtp3 = new lddatetimepicker host: view.get(\lddtp3), time: false, mode: \out-place
lddtp6 = new lddatetimepicker host: view.get(\lddtp6), time: false, mode: \fixed

ldcv-lddtp4 = new ldcover root: view.get(\ldcv-lddtp4)
ldcv-lddtp5 = new ldcover root: view.get(\ldcv-lddtp5)

lddtp4 = new lddatetimepicker do
  host: view.get(\lddtp4), time: false
  container:
    node: view.get(\container-lddtp4)
    toggle: -> ldcv-lddtp4.toggle it
    is-on: -> ldcv-lddtp4.is-on!
    position: ({x, y}) ->
      view.get(\ldcv-lddtp4).style <<< left: "#{x}px", top: "#{y}px"

lddtp5 = new lddatetimepicker do
  host: view.get(\lddtp5), time: false
  mode: \fixed
  container:
    node: view.get(\container-lddtp5)
    toggle: -> ldcv-lddtp5.toggle it
    is-on: -> ldcv-lddtp5.is-on!


