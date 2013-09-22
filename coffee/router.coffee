###
Router.js -- 类似 Backbone 的路由实现

Copyright (C) 2013 Hexcles Ma, Zeno Zeng
Lincensed under the MIT License

主要基于 Backbone 的路由代码实现
###

class Router

  constructor: ->
    # 事件对象
    @events = {}

    # 路由存储对象
    @routes = []

    # 正则列表
    # 注意 \\ 在 new RegExp 后变为 \
    # /\((.*?)\)/g
    @optionalParam = new RegExp('\\((.*?)\\)', 'g')
    # /(\(\?)?:\w+/g
    @namedParam = new RegExp('(\\(\\?)?:\\w+', 'g')
    # /[\-{}\[\]+?.,\\\^$|#\s]/g
    @escapeRegExp = new RegExp('[\\-{}\\[\\]+?.,\\\\\\^$|#\\s]', 'g')

    # 绑定事件
    if window.addEventListener?
      window.addEventListener "hashchange", => @dispatch()
    else # IE
      window.attachEvent "hashchange", => @dispatch()

  ###
  Attach callback on router event

  @param [String] event
  @param [Function] callback
  ###
  on: (event, callback) ->
    @events[event] = {callbacks: []} unless @events[event]?
    @events[event].callbacks.push callback

  ###
  Trigger event

  @param [String] event
  @param [Object] args
  ###
  trigger: (event, args) ->
    if @events[event]?
      for callback in @events[event].callbacks
        callback args

  ###
  增加一条路由绑定
  ###
  add: (arg) ->
    if Object.prototype.toString.call(arg) is "[object Array]"
      @add elem for elem in arg
      return
    unless arg.route? && arg.callback?
      @add {route: key, callback: value} for key, value of arg
      return
    {route, callback, context} = arg
    context = window unless context?
    # 解析路由规则
    # 替换掉正则字符，保证生成的正则安全
    route = route.replace @escapeRegExp, '\\$&'
    # 替换可选字符串
    # ?: 保证外面的括号不进入匹配结果列表
    # 接下来一步替换得到的内部的括号得到的结果是匹配结果或 undefined
    route = route.replace @optionalParam, '(?:$1)?'
    # 所有 : 开头的字符串被替换成一个正则，取到的结果加入结果列表
    route = route.replace @namedParam, '([^\/]+)'
    # 为了 new RegExp，转义斜杠
    route = route.replace new RegExp('/', 'g'), '\\/'
    # 加上 ^ 和 $ 保证完整匹配
    route = "^#{route}$"
    regexp = new RegExp route

    # 加入路由列表
    @routes.push {regexp: regexp, callback: callback, context: context}

  ###
  分发路由
  ###
  dispatch: ->
    @trigger 'dispatch'
    path = window.location.hash.toString()
    for route in @routes
      if route.regexp.test path
        args = route.regexp.exec(path).slice(1) # 取出正则匹配结果列表
        route.callback.apply route.context, args
        return
    @trigger '404'

@Router = Router
