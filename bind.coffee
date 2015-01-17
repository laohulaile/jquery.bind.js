$ ->

  body = $ "body"
  click = "click"
  mouseover = "mouseover"
  mouseout = "mouseout"
  scroll = "scroll"
  $window = $ window

  # 回到顶部
  do ->
    body
      .on click, "[bind-gotop]", ->
        $ "body, html"
          .stop().animate scrollTop : 0, 500

  # hover效果
  do ->
    body
      .on mouseover, "[bind-hover]", ->
        $(this).addClass "bind-hover"

      .on mouseout, "[bind-hover]",  ->
        $(this).removeClass "bind-hover"

  # Tab 切换
  do ->
    actit = "bind-tab-tit-active"
    actnv = "bind-tab-nav-active"

    body
      .on click, "[bind-tab-tit]", ->
        my = $ this
        parent = my.parents "[bind-tab]"
        show(my, parent)

      .on mouseover, "[bind-tab-tit]", ->
        my = $ this
        parent = my.parents "[bind-tab]"
        type = parent.attr "bind-tab"
        show(my, parent) if type is "mouseover" or type is "hover"

      show = (my, parent) ->
        tits = parent.find "[bind-tab-tit]"
        tits.removeClass(actit)
        my.addClass(actit)

        index = tits.index(my)
        parent.find "[bind-tab-nav]"
          .removeClass(actnv).hide()
          .eq(index).addClass(actnv).show()

  # Banner
  do ->
    $("[bind-banner]")
      .each(->
        my = $ this
        wrap = my.find "[bind-banner-wrap]"
        block = my.find "[bind-banner-block]"
        dot = my.find "[bind-banner-dot]"
        dotClass = "bind-banner-dot-act"
        left = my.find "[bind-banner-left]"
        right = my.find "[bind-banner-right]"

        width = my.width()
        length = block.length

        block.width(width)
        if length is 1
          dot.hide()
          left.hide()
          right.hide()
          return false
        wrap.width(width * length * 2)

        block.clone().appendTo(wrap)   #复制一份
        index = 0;                     #默认为第一张
        direction = "left"             #方向，向左滚动
        dot.eq(0).addClass(dotClass)   #第一个点加高亮样式

        #移动的方法
        move = ->
          if index is (length * 2)
              index = length
              wrap.css("left", -width * (length - 1))

          if index < 0
              index = length - 1
              wrap.css("left", -width * length)

          dot.eq(index % length).addClass(dotClass)
            .siblings().removeClass(dotClass)

          wrap.stop().animate(
            left : -width * index                      
          )

        func = ->
          if direction is "left" then index++ else index--
          move()

        fn = setInterval ->
          func()
        , 2000

        #右边按钮点击，向左移动
        right.on "click", ->
          index++
          direction = "left"
          move(index)

        #左边按钮点击，向右移动
        left.on "click", ->
          index--
          direction = "right" 
          move(index)

        #移上去的时候，不再滚动
        my.hover(
          ->
            clearInterval(fn)
          ,
          ->
            fn = setInterval ->
              func()
            , 2000
        )

        # 点击切换
        dot.on "click", ->
          index = $(this).index()
          move()
      )

  # Fix 固定
  do ->
    fixBox = $ "[bind-fix]"           #需要定位的对象
    attr = fixBox.attr "bind-fix"     #
    test = /^[1-9]\d*$/.test(attr)
    
    if test
      fixT = attr
    else
      reference = $("#" + attr) #参照物
      fixT = reference.offset().top if reference.length > 0

    $window
      .on scroll, ->
        t = $window.scrollTop()
        if t > fixT 
          fixBox.addClass "bind-fix"
        else
          fixBox.removeClass "bind-fix"

  #Pop 弹出层
  do ->
    mask = $ "[bind-pop-mask]"
    body
      .on click, "[bind-pop-btn]", ->
        mask.show()
        num = $(this).attr "bind-pop-btn"
        $("[bind-pop-box=#{num}]").show()

      .on click, "[bind-pop-close]", ->
        mask.hide()
        num = $(this).attr "bind-pop-close"
        $("[bind-pop-box=#{num}]").hide()


  #imgLazy
  do ->

    win = $(window)

    watchScroll = ->
      winHeight = win.height()
      imgs = $('img[bind-imglazy]')

      if imgs.length is 0 then win.off('scroll resize', watchScroll)

      scrollTop = win.scrollTop()
      loadimg(imgs, scrollTop, winHeight)

    loadimg = (imgs, scrollTop, winHeight) ->
        imgs.each ->
          my = $ this
          imgTop = my.offset().top - 100
          imgHeight = my.height()
          imgBottom = imgTop + imgHeight
          winBottom = scrollTop + winHeight + 100
          src = my.attr 'bind-imglazy'

          load1 = imgBottom > scrollTop and imgBottom < winBottom
          load2 = imgTop > scrollTop and imgTop < winBottom
          load3 = imgTop < scrollTop and imgBottom > winBottom

          if load1 or load2 or load3
            my
              .attr 'src', src
              .load(->
                my
                .css 'opacity', 0
                .animate({opacity : 1}, 200)
                .removeAttr 'bind-imglazy'
              )

    win.on 'load scroll resize', watchScroll
return