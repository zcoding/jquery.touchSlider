// Generated by CoffeeScript 1.8.0
(function() {
  var defaults;

  defaults = {
    speed: 100,
    navigator: ".z-bullet",
    classNames: {
      image: "z-image"
    }
  };

  $.fn.touchSlider = function(options) {
    var $bullets, $images, $navigator, $this, Height, Length, Slider, Width, animate, currentIndex, deltaTouch, events, move, noMore, positionTouch;
    options = $.extend({}, defaults, options);
    Width = options.width;
    Height = options.height;
    events = {
      touch: "touchstart.ztouch",
      move: "touchmove.ztouch",
      end: "touchend.ztouch"
    };
    noMore = "<div style=\"font-size: 18px;color: #888;text-align: center;line-height:" + Height + "px;\" class=\"j-no_more\">别拉了！真的没有了。。。</div>";
    $this = $(this);
    $this.prepend(noMore);
    $this.append(noMore);
    $this.children("img").addClass(options.classNames.image);
    $images = $this.children("img,.j-no_more");
    $navigator = $this.children(options.navigator);
    $bullets = $navigator.children();
    $navigator.css({
      position: "absolute",
      width: Width,
      top: Height,
      left: 0,
      textAlign: "center"
    });
    $bullets.css({
      display: "inline-block",
      margin: "10px 10px 0 0",
      width: 10,
      height: 10,
      background: "#AAAAAA",
      borderRadius: 10
    }).eq(0).css({
      background: "#FFFFFF"
    });
    Length = $images.length;
    $this.off(events.touch);
    $this.off(events.move);
    $this.off(events.end);
    currentIndex = 1;
    $this.css({
      overflow: "hidden",
      position: "relative",
      width: Width,
      height: Height + 20
    });
    $images.each(function(index, ele) {
      return $(ele).css({
        display: "block",
        margin: 0,
        padding: 0,
        position: "absolute",
        width: Width,
        height: Height,
        left: (index - currentIndex) * Width,
        top: 0
      });
    });
    positionTouch = {
      x: 0,
      y: 0
    };
    deltaTouch = {
      sx: 0,
      sy: 0
    };
    move = function(delta) {
      return $images.each(function(index, ele) {
        return ele.style.left = "" + ((index - currentIndex) * Width + delta.sx) + "px";
      });
    };
    animate = function(delta) {
      var ci, zf;
      if (Math.abs(delta.sx) < 0.2 * Width || currentIndex === 1 && delta.sx > 0 || currentIndex === Length - 2 && delta.sx < 0) {
        return $images.each(function(index, ele) {
          return $(ele).animate({
            left: (index - currentIndex) * Width
          }, 100);
        });
      } else {
        zf = delta.sx > 0 ? 1 : -1;
        ci = currentIndex;
        $images.each(function(index, ele) {
          return $(ele).animate({
            left: (index - ci + zf) * Width
          }, 100);
        });
        currentIndex += -zf;
        return $bullets.css("background", "#AAAAAA").eq(currentIndex - 1).css("background", "#FFFFFF");
      }
    };
    $this.on(events.touch, "." + options.classNames.image, function(eve) {
      var touchPoint;
      touchPoint = eve.originalEvent.touches[0];
      positionTouch.x = touchPoint.pageX;
      return positionTouch.y = touchPoint.pageY;
    });
    $this.on(events.move, "." + options.classNames.image, function(eve) {
      var i, point, touchList, _i, _len, _results;
      touchList = eve.originalEvent.touches;
      _results = [];
      for (i = _i = 0, _len = touchList.length; _i < _len; i = ++_i) {
        point = touchList[i];
        deltaTouch.sx = point.pageX - positionTouch.x;
        deltaTouch.sy = point.pageY - positionTouch.y;
        _results.push(move.apply(this, [deltaTouch]));
      }
      return _results;
    });
    $this.on(events.end, "." + options.classNames.image, function(eve) {
      animate.apply(this, [deltaTouch]);
      positionTouch.x = 0;
      positionTouch.y = 0;
      deltaTouch.sx = 0;
      return deltaTouch.sy = 0;
    });
    Slider = (function() {
      function Slider() {
        this.currentIndex = 0;
      }

      Slider.prototype.config = function(options) {
        return $.extend(this.options, options);
      };

      Slider.prototype.autoPlay = function(interval) {
        return this;
      };

      return Slider;

    })();
    return new Slider();
  };

}).call(this);
