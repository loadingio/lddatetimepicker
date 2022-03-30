# lddatetimepicker

Vanilla Date/Time picker.


## Usage

install via npm:

    npm install --save lddatetimepicker


include required js / css:

    <link rel="stylesheet" type="text/css" href="dist/index.min.css">
    <script type="text/javascript" src="dist/index.min.js"></script>


initialize:

    lddtp = new lddatetimepicker({host: "input"})
    lddtp.value("2021/01/23"); // set value
    lddtp.value(); // get value


Constructor options:

 - `host`: host element ( should be an input element, if provided )
 - `time`: default true. hide and disable time picker if false.


## License

MIT
