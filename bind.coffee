$ ->

  body = $ 'body'

  # 回到顶部
  (->
    if $('[bind-gotop]').length > 0
      body.delegate '[bind-gotop]', 'click', ->
          $ 'body, html'
            .stop().animate scrollTop : 0, 500
  )()

  # hover效果
  (->
    if $('[bind-hover]').length > 0
      body
        .delegate '[bind-hover]', 'mouseover', ->
          $ this
            .addClass 'bind-hover'
        .delegate '[bind-hover]', 'mouseout', ->
          $ this
            .removeClass 'bind-hover'
  )()

  # Tab 切换
  (->
    if $('[bind-tab-tit]').length > 0
      body
        .delegate '[bind-tab-tit]', 'click', ->
          my = $ this
          parent = my.parents '[bind-tab]'
          show(my, parent)

        .delegate '[bind-tab-tit]', 'mouseover', ->
          my = $ this
          parent = my.parents '[bind-tab]'
          type = parent.attr 'bind-tab'
          show(my, parent) if type is 'mouseover' or type is 'hover'

      show = (my, parent) ->
        tits = parent.find '[bind-tab-tit]'
        navs = parent.find '[bind-tab-nav]'

        index = tits.index(my)
        nav = navs.eq(index)

        actit = 'bind-tab-tit-active'
        actnv = 'bind-tab-nav-active'

        tits.removeClass(actit)
        navs.removeClass(actnv).hide()

        my.addClass(actit)
        nav.addClass(actnv).show()
  )()

  # Banner
  (->
    if $('[bind-banner]').length > 0
      $('[bind-banner]')
        .each(->
          my = $ this
          wrap = my.find '[bind-banner-wrap]'
          block = my.find '[bind-banner-block]'
          dot = my.find '[bind-banner-dot]'
          dotClass = 'bind-banner-dot-act'
          left = my.find '[bind-banner-left]'
          right = my.find '[bind-banner-right]'

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
          direction = 'left'             #方向，向左滚动
          dot.eq(0).addClass(dotClass)   #第一个点加高亮样式

          #移动的方法
          move = ->
            if index is (length * 2)
                index = length
                wrap.css('left', -width * (length - 1))

            if index < 0
                index = length - 1
                wrap.css('left', -width * length)
            console.log 

            dot.eq(index % length).addClass(dotClass)
              .siblings().removeClass(dotClass)

            wrap.stop().animate(
              left : -width * index                      
            )

          func = ->
            if direction is 'left' then index++ else index--
            move()

          fn = setInterval ->
            func()
          , 2000

          #右边按钮点击，向左移动
          right.on 'click', ->
            index++
            direction = 'left'
            move(index)

          #左边按钮点击，向右移动
          left.on 'click', ->
            index--
            direction = 'right' 
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
          dot.on 'click', ->
            index = $(this).index()
            move()
        )
  )()

  # Fix 固定
  (->
    fixBox = $ '[bind-fix]'         #需要定位的对象
    if fixBox.length > 0
      id = fixBox.attr 'bind-fix'
      pattern = /^[1-9]\d*$/
      test = pattern.test(id)
      reference = $('#' + id)         #参照物
      if test
        fixT = parseInt(id)
      else
        fixT = reference.offset().top if reference.length > 0
      $ window
        .on "scroll", ->
          t = $(window).scrollTop()
          if t > fixT 
            fixBox.addClass 'bind-fix'
          else
            fixBox.removeClass 'bind-fix'
  )()

  #Pop 弹出层
  (->
    mask = $ '[bind-pop-mask]'   #遮罩层
    if mask.length > 0
      pop = $ '[bind-pop-box]'    #弹出层
      body
        .delegate '[bind-pop-btn]', 'click', ->
          my = $ this
          num = my.attr 'bind-pop-btn'
          mask.show()
          $("[bind-pop-box=#{num}]").show()
        .delegate '[bind-pop-close]', 'click', ->
          my = $ this
          num = my.attr 'bind-pop-close'
          mask.hide()
          $("[bind-pop-box=#{num}]").hide()
  )()

return

    




      
