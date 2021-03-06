defaults =
  speed: 150
  navigator: ".j-bullet-nav"
  classNames:
    image: "z-image"
  onSlide: () -> false

class Player
  timer = null
  isRunning = true
  playing = () -> false
  constructor: (Length, currentIndex, playAction) ->
    @Length = Length
    @currentIndex = currentIndex
    playing = playAction || playing
  # 自动轮播控制
  autoPlay: (interval) ->
    isRunning = true
    interval = interval || 3000
    if timer isnt null
      return this
    timer = setInterval (() =>
      if isRunning
        @currentIndex = if @currentIndex+1 > @Length-2 then 1 else @currentIndex+1
        playing.apply this
      ), interval
    return this
  # 暂停/自动轮播
  togglePlay: () ->
    isRunning = !isRunning
    return this
  # 播放下一张
  next: () ->
    ci = @currentIndex
    if @currentIndex is @Length-2 then ci = 0
    @play.apply this, [ci+1]
    return this
  # 播放上一张
  prev: () ->
    ci = @currentIndex
    if @currentIndex is 1 then ci = 0
    @play.apply this, [ci-1]
    return this
  # 播放第N张
  play: (N = @currentIndex) ->
    # 计算真实索引
    if Math.abs(N) > (@Length - 2)
      N = N % (@Length - 2)
    if N is 0
      return this
    N = if N > 0 then N else @Length - 2 + N
    @currentIndex = N
    playing.apply this
    return this
  # 停止播放
  stop: ->
    isRunning = false
    if timer is null
      return this
    clearInterval timer
    timer = null
    return this

$.fn.touchSlider = (options) ->
  options = $.extend {}, defaults, options

  $this = $(this)
  _$img = $this.find('img')
  _width = _$img.width()
  _height = _$img.height()
  Width = options.width || _width
  Height = options.height || _height

  speed = options.speed

  events =
    touch: "touchstart.ztouch"
    move: "touchmove.ztouch"
    end: "touchend.ztouch"

  noMore = "<div style=\"font-size: 18px;color: #888;text-align: center;line-height:#{ Height }px;\" class=\"j-no_more\">别拉了！真的没有了。。。</div>"

  $this.prepend noMore
  $this.append noMore

  # 清除原有事件
  $this.off events.touch
  $this.off events.move
  $this.off events.end

  $this.children("img").addClass options.classNames.image
  $images = $this.children "img,.j-no_more"
  $navigator = $this.children options.navigator
  $bullets = $navigator.children()

  # 样式初始化
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
      left: (index - 1) * Width
      top: 0
    }

  positionTouch =
    x: 0
    y: 0

  deltaTouch =
    sx: 0
    sy: 0

  player = new Player($images.length, 1, () ->
    $images.each (index, ele) =>
      $(ele).animate {
        left: (index - @currentIndex) * Width
      }, speed
    $bullets.css("background", "#AAAAAA").eq(@currentIndex-1).css("background", "#FFFFFF")
    options.onSlide.apply this, [@currentIndex]
    true)

  move = (delta) ->
    $images.each (index, ele) ->
      ele.style.left = "#{(index - player.currentIndex) * Width + delta.sx}px"

  # $this.on events.touch, ".#{options.classNames.image}", (eve) ->
  #   touchPoint = eve.originalEvent.touches[0]
  #   positionTouch.x = touchPoint.pageX
  #   positionTouch.y = touchPoint.pageY
  #   console.info "start"

  # $this.on events.move, ".#{options.classNames.image}", (eve) ->
  #   touchList = eve.originalEvent.touches
  #   for point, i in touchList
  #     deltaTouch.sx = point.pageX - positionTouch.x
  #     deltaTouch.sy = point.pageY - positionTouch.y
  #     move.apply this, [deltaTouch]

  # $this.on events.end, ".#{options.classNames.image}", (eve) ->
  #   player.play()
  #   positionTouch.x = 0
  #   positionTouch.y = 0
  #   deltaTouch.sx = 0
  #   deltaTouch.sy = 0

  $images.enableTouch()

  $this.on "swipeLeft", ".#{options.classNames.image}", (evt, o) ->
    if player.currentIndex is player.Length - 2
      return no
    player.next()
    return yes

  $this.on "swipeRight", ".#{options.classNames.image}", (evt, o) ->
    if player.currentIndex is 1
      return no
    player.prev()
    return yes

  return player
