###
# http://louisremi.github.io/jquery-smartresize/demo/index.html
# debouncedresize: special jQuery event that happens once after a window resize
# 
#   * latest version and complete README available on Github:
#   * https://github.com/louisremi/jquery-smartresize/blob/master/jquery.debouncedresize.js
#   *
#   * Copyright 2011 @louis_remi
#   * Licensed under the MIT license.
#  execAsap ? dispatch() : resizeTimeout = setTimeout(dispatch, $special.threshold);
###

(($, window, document) ->

  $event = $.event
  $special = undefined
  resizeTimeout = undefined
  $special = $event.special.debouncedresize =
    setup: ->
      $(this).on 'resize', $special.handler

    teardown: ->
      $(this).off 'resize', $special.handler

    handler: (event, execAsap) ->
      
      # Save the context
      context = this
      args = arguments
      dispatch = ->
        
        # set correct event type
        event.type = 'debouncedresize'
        $event.dispatch.apply context, args

      clearTimeout resizeTimeout  if resizeTimeout
      (if execAsap then dispatch() else resizeTimeout = setTimeout(dispatch, $special.threshold))

    threshold: 100

)(jQuery, window, document)