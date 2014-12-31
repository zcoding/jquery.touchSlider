defaults =
  speed: 100
  navigator: ".z-bullet"
  classNames:
    image: "z-image"

$.fn.touchSlider = (options) ->
  options = $.extend {}, defaults, options
  Width = options.width
  Height = options.height

  events =
    touch: "touchstart.ztouch"
    move: "touchmove.ztouch"
    end: "touchend.ztouch"

  noMore = "<div style=\"font-size: 18px;color: #888;text-align: center;line-height:#{ Height }px;\" class=\"j-no_more\">别拉了！真的没有了。。。</div>"

  $this = $(this)
  $this.prepend noMore
  $this.append noMore
  $this.children("img").addClass options.classNames.image
  $images = $this.children "img,.j-no_more"
  $navigator = $this.children options.navigator
  $bullets = $navigator.children()

  $navigator.css {
    position: "absolute"
    width: Width
    top: Height
    left: 0
    textAlign: "center"
  }

  $bullets.css({
    display: "inline-block"
    margin: "10px 10px 0 0"
    width: 10
    height: 10
    background: "#AAAAAA"
    borderRadius: 10
  }).eq(0).css {
    background: "#FFFFFF"
  }

  Length = $images.length

  # 清除原有事件
  $this.off events.touch
  $this.off events.move
  $this.off events.end

  currentIndex = 1

  $this.css {
    overflow: "hidden"
    position: "relative"
    width: Width
    height: Height + 20
  }

  $images.each (index, ele) ->
    $(ele).css {
      display: "block"
      margin: 0
      padding: 0
      position: "absolute"
      width: Width
      height: Height
      left: (index - currentIndex) * Width
      top: 0
    }

  positionTouch =
    x: 0
    y: 0

  deltaTouch =
    sx: 0
    sy: 0

  move = (delta) ->
    $images.each (index, ele) ->
      ele.style.left = "#{(index - currentIndex) * Width + delta.sx}px"

  animate = (delta) ->
    if Math.abs(delta.sx) < 0.2 * Width or currentIndex is 1 and delta.sx > 0 or currentIndex is Length - 2 and delta.sx < 0
      $images.each (index, ele) ->
        $(ele).animate {
          left: (index - currentIndex) * Width
        }, 100
    else
      zf = if delta.sx > 0 then 1 else -1
      ci = currentIndex
      $images.each (index, ele) ->
        $(ele).animate {
          left: (index - ci + zf) * Width
        }, 100
      currentIndex += -zf
      $bullets.css("background", "#AAAAAA").eq(currentIndex-1).css("background", "#FFFFFF")

  $this.on events.touch, "." + options.classNames.image, (eve) ->
    touchPoint = eve.originalEvent.touches[0]
    positionTouch.x = touchPoint.pageX
    positionTouch.y = touchPoint.pageY

  $this.on events.move, "." + options.classNames.image, (eve) ->
    touchList = eve.originalEvent.touches
    for point, i in touchList
      deltaTouch.sx = point.pageX - positionTouch.x
      deltaTouch.sy = point.pageY - positionTouch.y
      move.apply this, [deltaTouch]

  $this.on events.end, "." + options.classNames.image, (eve) ->
    animate.apply this, [deltaTouch]
    positionTouch.x = 0
    positionTouch.y = 0
    deltaTouch.sx = 0
    deltaTouch.sy = 0

  class Slider
    constructor: () ->
      @currentIndex = 0
    config: (options) ->
      $.extend @options, options
    autoPlay: (interval) ->
      return this

  return new Slider()