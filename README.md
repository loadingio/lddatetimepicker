# lddatetimepicker

Vanilla Date/Time picker.


## Usage

install via npm, along with required libraries:

    npm install --save lddatetimepicker @loadingio/debounce.js dayjs


include required js / css:

    <link rel="stylesheet" type="text/css" href="dist/index.min.css">
    <script type="text/javascript" src="path-to/debounce.js"></script>
    <script type="text/javascript" src="path-to-day.js"></script>
    <script type="text/javascript" src="dist/index.min.js"></script>


initialize:

    lddtp = new lddatetimepicker({host: "input"})
    lddtp.value("2021/01/23"); // set value
    lddtp.value(); // get value


Constructor options:

 - `host`: host element ( should be an input element, if provided )
 - `time`: default true. hide and disable time picker if false.
 - `fixed`: (deprecated) default false. true to enabled fixed mode.
 - `mode`: either `in-place`, `out-place` or `fixed`.
   - `fixed`:
     - when toggled, the datetime widget pops up in screen center, and covers the whole screen.
     - will be forced to true if `host` and `container` are not provided.
   - `out-place`: widget is inserted under body.
   - `in-place`: widget is inserted after `host`.
 - `container`: optional. if provided, `lddatetimepicker` are rendered barely in this container.
   - this should be an object with following fields:
     - `node`: required. container element.
     - `toggle(v)`: required. function for toggling container on / off.
     - `isOn()`: required. return true if a container is toggled on, otherwise false.
     - `position({x,y,ix,iy})`: optional. use this function to correctly position container.
       - `x`: suggested x position
       - `y`: suggested y position
       - `ix`: suggested x position if mode is `in-place`.
       - `iy`: suggested y position if mode is `in-place`.
   - by default, mode will be `out-place` with `container` option set.
     - Set `mode` to `fixed` if the container is a fixed element (such as dialog)
 - `zmgr`: optional. if provided, widget will be auto z-indexing based on this zmgr.


## API

 - `isOn()`: return true if lddatetimepicker dialog is on, otherwise return false
 - `fire(n, ...args)`
 - `on(n, cb)`
 - `update()`
 - `value()`


## License

MIT
