(function(){
  var html, lddatetimepicker;
  html = '<div class="lddtp">\n  <div class="lddtp-h">\n    <div class="lddtp-a" data-action="-"></div>\n    <div class="lddtp-f"><select class="lddtp-month-sel"></select></div>\n    <div class="lddtp-f"><input class="lddtp-year-sel" type="number"/></div>\n    <div class="lddtp-a" data-action="+"></div>\n  </div>\n  <div class="lddtp-ds">\n  </div>\n  <div class="lddtp-t">\n    <div class="lddtp-f"><select class="lddtp-hour-sel"></select></div>\n    <div><b>:</b></div>\n    <div class="lddtp-f"><select class="lddtp-minute-sel"></select></div>\n  </div>\n</div>';
  lddatetimepicker = function(opt){
    var div, r, ref$, x$, _handler, this$ = this;
    opt == null && (opt = {});
    this.opt = opt;
    this._enabled = {
      time: !(opt.time != null) || opt.time
    };
    this.evthdr = {};
    this.hdr = {
      mouseup: function(){
        this$.root.classList.toggle('active', false);
        document.removeEventListener('mouseup', this$.hdr.mouseup);
        return document.removeEventListener('keydown', this$.hdr.keydown);
      },
      keydown: function(evt){
        var c;
        if (!this$.isOn()) {
          return;
        }
        c = evt.keyCode;
        if (!(c === 37 || c === 38 || c === 39 || c === 40)) {
          return;
        }
        if (!this$.sel) {
          return;
        }
        evt.stopPropagation();
        evt.preventDefault();
        this$.sel = c === 37
          ? this$.sel.subtract(1, 'day')
          : c === 39
            ? this$.sel.add(1, 'day')
            : c === 38
              ? this$.sel.subtract(7, 'day')
              : c === 40 ? this$.sel.add(7, 'day') : void 8;
        this$.cur = this$.sel;
        return this$.update();
      }
    };
    div = document.createElement('div');
    if (opt.host) {
      this.host = typeof opt.host === 'string'
        ? document.querySelector(opt.host)
        : opt.host;
      this.host.parentNode.insertBefore(div, opt.host.nextSibling);
      this.host.addEventListener('mouseup', function(evt){
        evt.stopPropagation();
        return this$.toggle();
      });
    } else {
      document.body.appendChild(div);
    }
    div.innerHTML = html;
    this.root = r = div.querySelector('.lddtp');
    this.root.addEventListener('mouseup', function(evt){
      return evt.stopPropagation();
    });
    this.n = {
      ds: r.querySelector('.lddtp-ds'),
      t: r.querySelector('.lddtp-t'),
      sel: {
        year: r.querySelector('.lddtp-year-sel'),
        month: r.querySelector('.lddtp-month-sel'),
        hour: r.querySelector('.lddtp-hour-sel'),
        minute: r.querySelector('.lddtp-minute-sel')
      }
    };
    this.n.t.style.display = this._enabled.time ? '' : 'none';
    this.months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    this.wdays = ['SUN', 'MON', 'TUE', 'WED', 'THR', 'FRI', 'SAT'];
    this.n.ds.innerHTML = [0, 1, 2, 3, 4, 5, 6].map(function(w){
      return "<div class=\"lddtp-w\">" + this$.wdays[w] + "</div>";
    }).join('') + [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41].map(function(d){
      return "<div class=\"lddtp-d\"></div>";
    }).join('');
    ref$ = this.n;
    ref$.dh = Array.from(r.querySelectorAll('.lddtp-w'));
    ref$.dc = Array.from(r.querySelectorAll('.lddtp-d'));
    ref$ = [0, 1, 2].map(function(){
      return dayjs();
    }), this.cur = ref$[0], this.today = ref$[1], this.sel = ref$[2];
    this.time = {
      hour: 0,
      minute: 0
    };
    this.n.sel.month.innerHTML = this.months.map(function(m){
      return "<option value=\"" + m + "\">" + m + "</option>";
    }).join('');
    x$ = this.n.sel.year;
    x$.setAttribute('min', 1900);
    x$.setAttribute('max', 2300);
    x$.setAttribute('value', this.today.year());
    this.n.sel.hour.innerHTML = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23].map(function(h){
      return "<option value=\"" + h + "\">" + ('' + h).padStart(2, "0") + "</option>";
    }).join('');
    this.n.sel.minute.innerHTML = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59].map(function(m){
      return "<option value=\"" + m + "\">" + ('' + m).padStart(2, "0") + "</option>";
    }).join('');
    this.root.addEventListener('click', function(evt){
      var n;
      n = evt.target;
      if (n.classList.contains('lddtp-d')) {
        this$.sel = dayjs(new Date(n.date.year, n.date.month, n.date.date));
        return this$.update(this$.cur);
      } else if (n.getAttribute('data-action') === '-') {
        this$.cur = this$.cur.subtract(1, "month");
        return this$.update(this$.cur);
      } else if (n.getAttribute('data-action') === '+') {
        this$.cur = this$.cur.add(1, "month");
        return this$.update(this$.cur);
      }
    });
    this.n.sel.minute.addEventListener('change', function(evt){
      this$.time.minute = evt.target.value;
      this$.cur.minute(this$.time.minute);
      return this$.update(this$.ucr);
    });
    this.n.sel.hour.addEventListener('change', function(evt){
      this$.time.hour = evt.target.value;
      this$.cur.hour(this$.time.hour);
      return this$.update(this$.ucr);
    });
    this.n.sel.year.addEventListener('change', function(evt){
      this$.cur = dayjs(new Date(this$.n.sel.year.value, this$.months.indexOf(this$.n.sel.month.value), 1));
      return this$.update(this$.cur);
    });
    this.n.sel.month.addEventListener('change', function(evt){
      this$.cur = dayjs(new Date(this$.n.sel.year.value, this$.months.indexOf(this$.n.sel.month.value), 1));
      return this$.update(this$.cur);
    });
    if (this.host) {
      _handler = debounce(function(){
        var ret, e;
        try {
          ret = dayjs(this$.host.value).toISOString();
          this$.host.value = ret;
          return this$.value(this$.host.value);
        } catch (e$) {
          return e = e$;
        }
      });
      this.host.addEventListener('change', _handler);
      this.host.addEventListener('input', _handler);
    }
    if (this.host && this.host.value) {
      this.value(this.host.value);
    } else {
      this.update();
    }
    return this;
  };
  lddatetimepicker.prototype = import$(Object.create(Object.prototype), {
    on: function(n, cb){
      var this$ = this;
      return (Array.isArray(n)
        ? n
        : [n]).map(function(n){
        var ref$;
        return ((ref$ = this$.evthdr)[n] || (ref$[n] = [])).push(cb);
      });
    },
    fire: function(n){
      var v, res$, i$, to$, ref$, len$, cb, results$ = [];
      res$ = [];
      for (i$ = 1, to$ = arguments.length; i$ < to$; ++i$) {
        res$.push(arguments[i$]);
      }
      v = res$;
      for (i$ = 0, len$ = (ref$ = this.evthdr[n] || []).length; i$ < len$; ++i$) {
        cb = ref$[i$];
        results$.push(cb.apply(this, v));
      }
      return results$;
    },
    isOn: function(){
      return this.root.classList.contains('active');
    },
    toggle: function(v){
      var c, h, n, hb, cb, ref$, x, y, nscroll, nstack, s, stackb, scrollb;
      if (arguments.length === 0) {
        v = !this.root.classList.contains('active');
      }
      if (!v) {
        this.root.classList.toggle('active', false);
        document.removeEventListener('mouseup', this.hdr.mouseup);
        document.removeEventListener('keydown', this.hdr.keydown);
        return;
      }
      if (!this.isOn()) {
        document.addEventListener('mouseup', this.hdr.mouseup);
        document.addEventListener('keydown', this.hdr.keydown);
      }
      this.root.classList.toggle('active', true);
      c = this.root;
      h = this.host;
      n = h.parentNode;
      hb = h.getBoundingClientRect();
      cb = c.getBoundingClientRect();
      ref$ = [0, 0], x = ref$[0], y = ref$[1];
      ref$ = [null, null], nscroll = ref$[0], nstack = ref$[1];
      while (n && n.getAttribute) {
        s = getComputedStyle(n);
        if (n.nodeName === 'BODY' || ['overflow', 'overflow-y', 'overflow-x'].filter(fn$).length) {
          if (!nscroll) {
            nscroll = n;
          }
        }
        if (n.nodeName === 'BODY' || s.position !== 'static') {
          if (!nstack) {
            nstack = n;
          }
        }
        if (nscroll && nstack) {
          break;
        }
        n = n.parentNode;
      }
      stackb = nstack.getBoundingClientRect();
      scrollb = nscroll.getBoundingClientRect();
      if (hb.y + hb.height + cb.height > scrollb.y + scrollb.height) {
        y = hb.y - stackb.y - cb.height + nscroll.scrollTop - 2;
      } else {
        y = hb.y - stackb.y + hb.height + nscroll.scrollTop + 2;
      }
      if (hb.x + cb.width > scrollb.x + scrollb.width) {
        x = hb.x - stackb.x + hb.width - cb.width + nscroll.scrollLeft;
      } else {
        x = hb.x - stackb.x + nscroll.scrollLeft;
      }
      c.style.transform = "translate(" + x + "px, " + y + "px)";
      return ref$ = c.style, ref$.top = 0, ref$.left = 0, ref$;
      function fn$(it){
        return s[it] !== 'visible';
      }
    },
    update: function(now){
      var ref$, y, m, start, ny, nm, nd, ty, tm, td, sy, sm, sd;
      now = now || this.cur;
      ref$ = [now.year(), now.month()], y = ref$[0], m = ref$[1];
      now = dayjs(new Date(now.year(), now.month(), 1));
      start = now.subtract(now.day(), 'day');
      ref$ = [now.year(), now.month(), now.date()], ny = ref$[0], nm = ref$[1], nd = ref$[2];
      ref$ = [this.today.year(), this.today.month(), this.today.date()], ty = ref$[0], tm = ref$[1], td = ref$[2];
      ref$ = !this.sel
        ? [null, null, null]
        : [this.sel.year(), this.sel.month(), this.sel.date()], sy = ref$[0], sm = ref$[1], sd = ref$[2];
      this.n.sel.month.value = this.months[nm];
      this.n.sel.year.value = ny;
      this.n.dc.map(function(n, i){
        var d, ref$, dy, dm, dd;
        d = start.add(i, 'day');
        ref$ = [d.year(), d.month(), d.date()], dy = ref$[0], dm = ref$[1], dd = ref$[2];
        n.date = {
          year: dy,
          month: dm,
          date: dd
        };
        n.innerText = d.date();
        n.classList.toggle('dim', d.month() !== m);
        n.classList.toggle('today', ty === dy && tm === dm && td === dd);
        return n.classList.toggle('selected', sy === dy && sm === dm && sd === dd);
      });
      if (this.host) {
        return this.host.value = this.value();
      }
    },
    value: function(v){
      var ret;
      if (!arguments.length) {
        if (this._enabled.time) {
          ret = dayjs(new Date(this.sel.year(), this.sel.month(), this.sel.date(), this.time.hour, this.time.minute));
          return ret.format('YYYY-MM-DDTHH:mm:ssZ');
        } else {
          return dayjs(new Date(this.sel.year(), this.sel.month(), this.sel.date())).format('YYYY-MM-DD');
        }
      }
      this.sel = dayjs(v);
      this.cur = dayjs(v);
      return this.update();
    }
  });
  if (typeof module != 'undefined' && module !== null) {
    module.exports = lddatetimepicker;
  } else if (typeof window != 'undefined' && window !== null) {
    window.lddatetimepicker = lddatetimepicker;
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
