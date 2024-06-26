# Change Logs

## v0.0.11

 - add `config` api
 - add `suppress` option


## v0.0.10

 - add a close button
 - upgrade dev dependencies


## v0.0.9

 - support zmgr for proper z-indexing


## v0.0.8

 - proper handle invalid input
 - add `mode` with following mode supported:
   - `in-place`: default value. widget is inserted after `host`.
   - `out-place`: widget is inserted under `document.body`. 
   - `fixed`: widget is inserted under `document.body`, with fixed position style.
 - support `container` option for customized modal window.


## v0.0.7

 - support `fixed` option for fixed mode. fixed mode is automatically enabled if no host provided.


## v0.0.6

 - even if `count-scroll = false` we should still consider scroll position to keep picker in viewport as possible.


## v0.0.5

 - support `change` event when value changed.


## v0.0.4

 - update widget based on initial value of host if available


## v0.0.3

 - add `isOn` API for checking if dialog is active or not
 - handle key event only if dialog is on
 - separate toggling code into standalone `toggle` api
 - show local timezone offset in host
 - update ui also when hour / minute change
 - fix bug: hour / minute don't work
 - support enter / escape to close
 - let dialog be mutual exclusive
 - fix bug: incorrect position when scrolling if scroll element is outside the absolute / relative positioned element.


## v0.0.2

 - tweak layout
 - add simple theme


## v0.0.1

 - init release
