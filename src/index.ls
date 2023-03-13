html = '''
<div class="lddtp"><div>
  <div class="lddtp-h">
    <div class="lddtp-a" data-action="-"></div>
    <div class="lddtp-f"><select class="lddtp-month-sel"></select></div>
    <div class="lddtp-f"><input class="lddtp-year-sel" type="number"/></div>
    <div class="lddtp-a" data-action="+"></div>
  </div>
  <div class="lddtp-ds">
  </div>
  <div class="lddtp-t">
    <div class="lddtp-f"><select class="lddtp-hour-sel"></select></div>
    <div><b>:</b></div>
    <div class="lddtp-f"><select class="lddtp-minute-sel"></select></div>
  </div>
  <div class="lddtp-c"></div>
</div></div>
'''

lddatetimepicker = (opt = {})->
  @opt = opt
  @_enabled = time: !(opt.time?) or opt.time
  @_zmgr = opt.zmgr or null
  @_mode = if opt.mode in <[in-place out-place fixed]> => opt.mode
  else if opt.fixed => \fixed #legacy
  else if opt.container => \out-place
  else \in-place
  @evthdr = {}
  if (_c = opt.container) =>
    if !(typeof(_c) == \object and _c.is-on and _c.toggle and _c.node) =>
      throw new Error("[lddatetimepicker] `isOn`, `toggle` and `node` are all required within `container` option.")
    @ <<< {_toggle: _c.toggle, is-on: _c.is-on, _container: _c.node, _pos: _c.position}
  @hdr =
    mouseup: (evt) ~>
      if evt.target == @host => return
      @_toggle false
      document.removeEventListener \mouseup, @hdr.mouseup
      document.removeEventListener \keydown, @hdr.keydown
    keydown: (evt) ~>
      if !(@is-on!) => return
      c = evt.keyCode
      if !(c in [13 27 37 38 39 40]) => return
      if !@sel => return
      if c in [13 27] => return @toggle false
      evt.stopPropagation!
      evt.preventDefault!
      @sel = if c == 37 => @sel.subtract 1, \day
      else if c == 39 => @sel.add 1, \day
      else if c == 38 => @sel.subtract 7, \day
      else if c == 40 => @sel.add 7, \day
      @cur = @sel
      @update!

  div = document.createElement(\div)
  if opt.host =>
    @host = if typeof(opt.host) == \string => document.querySelector(opt.host) else opt.host
    @host.addEventListener \mouseup, (evt) ~> @toggle!
  div.innerHTML = html
  @root = r = div.querySelector '.lddtp'
  if @_container =>
    @_container.appendChild div
    @root.classList.add \static, \bare
  else if @_mode == \out-place =>
    document.body.appendChild div
  else if @_mode == \fixed or !@host =>
    document.body.appendChild div
    @root.classList.toggle \fixed
  else if @host => @host.parentNode.insertBefore div, opt.host.nextSibling

  @root.addEventListener \mouseup, (evt) -> evt.stopPropagation!
  @n =
    ds: r.querySelector '.lddtp-ds' # day cell container
    t: r.querySelector '.lddtp-t' # time selectors
    sel:
      year: r.querySelector('.lddtp-year-sel')
      month: r.querySelector('.lddtp-month-sel')
      hour: r.querySelector('.lddtp-hour-sel')
      minute: r.querySelector('.lddtp-minute-sel')

  @n.t.style.display = if @_enabled.time => '' else \none
  @months = <[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]>
  @wdays = <[SUN MON TUE WED THR FRI SAT]>

  @n.ds.innerHTML = (
    [0 til 7].map((w) ~> """<div class="lddtp-w">#{@wdays[w]}</div>""").join('') +
    [0 til 42].map((d) ~> """<div class="lddtp-d"></div>""").join('')
  )
  @n <<<
    dh: Array.from(r.querySelectorAll '.lddtp-w') # weakday header
    dc: Array.from(r.querySelectorAll '.lddtp-d') # day cell

  # cur: datetime for current viewport ( used to control when to show )
  # sel: selected datetime ( the actual picked value )
  [@cur, @today, @sel] = [0 to 2].map -> dayjs!

  @n.sel.month.innerHTML = @months.map((m) -> """<option value="#m">#m</option>""").join('')
  @n.sel.year
    ..setAttribute \min, 1900
    ..setAttribute \max, 2300
    ..setAttribute \value, @today.year!
  @n.sel.hour.innerHTML = [0 to 23].map((h) -> """<option value="#h">#{(''+h).padStart(2,"0")}</option>""").join('')
  @n.sel.minute.innerHTML = [0 to 59].map((m) -> """<option value="#m">#{(''+m).padStart(2,"0")}</option>""").join('')

  @root.addEventListener \click, (evt) ~>
    if @_mode == \fixed and evt.target.classList.contains(\fixed) => return @toggle false
    n = evt.target
    if n.classList.contains \lddtp-d =>
      @sel = dayjs new Date(n.date.year, n.date.month, n.date.date, @sel.hour!, @sel.minute!)
      @update @cur
    else if (n.getAttribute(\data-action) == \-) =>
      @cur = @cur.subtract 1, "month"
      @update @cur
    else if (n.getAttribute(\data-action) == \+) =>
      @cur = @cur.add 1, "month"
      @update @cur
    else if n.classList.contains \lddtp-c => @toggle false

  @n.sel.minute.addEventListener \change, (evt) ~>
    @sel = @sel.minute evt.target.value
    @update!
  @n.sel.hour.addEventListener \change, (evt) ~>
    @sel = @sel.hour evt.target.value
    @update!
  @n.sel.year.addEventListener \change, (evt) ~>
    @cur = dayjs new Date(@n.sel.year.value, @months.indexOf(@n.sel.month.value), 1)
    @update @cur
  @n.sel.month.addEventListener \change, (evt) ~>
    @cur = dayjs new Date(@n.sel.year.value, @months.indexOf(@n.sel.month.value), 1)
    @update @cur

  if @host =>
    _handler = debounce ~>
      try
        ret = dayjs(@host.value).format('YYYY-MM-DDTHH:mm:ssZ')
        @host.value = ret
        @value @host.value
      catch e
    @host.addEventListener \change, _handler
    @host.addEventListener \input, _handler
  if @host and @host.value =>
    try
      @host.value = dayjs(@host.value).format('YYYY-MM-DDTHH:mm:ssZ')
      @value @host.value
    catch e
  else @update!

  @

lddatetimepicker.prototype = Object.create(Object.prototype) <<< do
  on: (n, cb) -> (if Array.isArray(n) => n else [n]).map (n) ~> @evthdr.[][n].push cb
  fire: (n, ...v) -> for cb in (@evthdr[n] or []) => cb.apply @, v
  is-on: -> @root.classList.contains \active
  _toggle: (v) ->
    set-on = v or (!(v?) and !@is-on!)
    if @_zmgr =>
      if set-on => @root.style.zIndex = @_zmgr.add!
      else @_zmgr.remove @root.style.zIndex
    @root.classList.toggle \active, set-on
  toggle: (v) ->
    if arguments.length == 0 => v = !@is-on!
    if !v =>
      @_toggle false
      document.removeEventListener \mouseup, @hdr.mouseup
      document.removeEventListener \keydown, @hdr.keydown
      return
    if !@is-on! =>
      document.addEventListener \mouseup, @hdr.mouseup
      document.addEventListener \keydown, @hdr.keydown
    @_toggle true
    # in fixed mode, caller should position container.
    if @_mode == \fixed => return

    c = @root
    h = @host
    n = h.parentNode
    hb = h.getBoundingClientRect!
    cb = c.getBoundingClientRect!
    [x,y] = [0,0]
    [nscroll, nstack] = [null, null]
    # should we adjust picker position based on scroll element?
    count-scroll = true

    while n and n.getAttribute
      s = getComputedStyle(n)
      if n.nodeName == \BODY =>
        if !nscroll => nscroll = document.scrollingElement
      if <[overflow overflow-y overflow-x]>.filter(-> s[it] != \visible).length =>
        if !nscroll => nscroll = n
      # TODO (should we consider opacity, transform and filter? )
      if n.nodeName == \BODY or s.position != \static =>
        if !nstack =>
          nstack = n
          # no scroll element within stacking context.
          # thus, scroll left/top should not be used when calculating position
          if !nscroll => count-scroll = false
      if nscroll and nstack => break
      n = n.parentNode
    stackb = nstack.getBoundingClientRect!
    scrollb = nscroll.getBoundingClientRect!
    scroll = {left: nscroll.scrollLeft, top: nscroll.scrollTop}
    # root scrolling. we dont have to consider it in fixed mode
    rscroll = if @_mode == \fixed => {left: 0, top: 0}
    else {left: document.scrollingElement.scrollLeft, top: document.scrollingElement.scrollTop}

    _cb = if @_container => @_container.getBoundingClientRect! else cb
    # vx / vy: viewport x and y. for fixed element to correctly position
    if hb.y + hb.height + _cb.height > window.innerHeight + rscroll.top =>
      vy = hb.y - _cb.height + rscroll.top - 2
    else vy = hb.y + hb.height + rscroll.top + 2
    if hb.x + _cb.width > window.innerWidth + rscroll.left =>
      vx = hb.x + hb.width - + rscroll.left + _cb.width
    else vx = hb.x + rscroll.left

    # ix / iy: inside stacking context x and y.
    if hb.y + hb.height + cb.height > scrollb.y + scrollb.height + scroll.top =>
      iy = hb.y - stackb.y - cb.height + (if count-scroll => scroll.top else 0) - 2
    else
      iy = hb.y - stackb.y + hb.height + (if count-scroll => scroll.top else 0) + 2
    if hb.x + cb.width > scrollb.x + scrollb.width + scroll.left =>
      ix = hb.x - stackb.x + hb.width - cb.width + (if count-scroll => scroll.left else 0)
    else
      ix = hb.x - stackb.x + (if count-scroll => scroll.left else 0)
    # _pos usually are for fixed element, so we by default use `x` and `y` for viewport x and y.
    if @_pos => return @_pos {x: vx, y: vy, vx, vy, ix, iy}
    [x, y] = if @_mode == \out-place => [x, y] = [vx, vy]
    else [ix, iy]
    c.style.transform = "translate(#{x}px, #{y}px)"
    c.style <<< top: 0, left: 0

  update: (now) ->
    now = now or @cur
    [y,m] = [now.year!, now.month!]
    now = dayjs new Date(now.year!, now.month!, 1)
    start = now.subtract now.day!, 'day'
    [ny,nm,nd] = [now.year!, now.month!, now.date!]
    [ty,tm,td] = [@today.year!, @today.month!, @today.date!]
    [sy,sm,sd] = if !@sel => [null,null,null] else [@sel.year!, @sel.month!, @sel.date!]
    @n.sel.month.value = @months[nm]
    @n.sel.year.value = ny
    @n.sel.minute.value = @sel.minute!
    @n.sel.hour.value = @sel.hour!
    @n.dc.map (n,i) ~>
      d = start.add i, \day
      [dy,dm,dd] = [d.year!, d.month!, d.date!]
      n.date = {year: dy, month: dm, date: dd}
      n.innerText = d.date!
      n.classList.toggle \dim, (d.month! != m)
      n.classList.toggle \today, (ty == dy and tm == dm and td == dd)
      n.classList.toggle \selected, (sy == dy and sm == dm and sd == dd)
    if @host =>
      ov = @host.value
      nv = @value!
      @host.value = nv
      if ov != nv => @fire \change, nv
  value: (v) ->
    if !arguments.length =>
      if @_enabled.time =>
        ret = dayjs new Date( @sel.year!, @sel.month!, @sel.date!, @sel.hour!, @sel.minute! )
        return ret.format('YYYY-MM-DDTHH:mm:ssZ')
      else return dayjs(new Date( @sel.year!, @sel.month!, @sel.date!)).format('YYYY-MM-DD')
    v = dayjs v
    if !v.isValid! => v = @_last or dayjs!
    @_last = @cur
    @sel = @cur = v
    @update!

if module? => module.exports = lddatetimepicker
else if window? => window.lddatetimepicker = lddatetimepicker
