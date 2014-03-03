###
 *
 * @refactoring to CofeeScript by Alfredo Llanos <alfredo@tallerdelsoho.es> || @biojazzard
###

(($) =>

  videoDefault = '87882921'
  # videoHolder div parent > iframe
  videoHolder = $('.video-holder')
  modalContent = $('.modal-content')
  iframeVideo = undefined
  playerID = 'player'
  player = undefined

  addEvent = (element, eventName, callback) ->
    if element.addEventListener
      element.addEventListener eventName, callback, false
    else
      element.attachEvent eventName, callback, false
    return

  ###
  Called once a vimeo player is loaded and ready to receive
  commands. You can add events and make api calls only after this
  function has been called.
  ###

  ready = (player_id) ->
    
    # Keep a reference to Froogaloop for this player
    
    ###
    Prepends log messages to the example console for you to see.
    ###
    apiLog = (message) ->
      red = message + "\n" + apiConsole.val()
      apiConsole.val(red)

    apiClear = (message) ->
      red = message
      apiConsole.val(red)
    
    ###
    Sets up the actions for the buttons that will perform simple
    api calls to Froogaloop (play, pause, etc.). These api methods
    are actions performed on the player that take no parameters and
    return no values.
    ###

    setupSimpleButtons = ->
      buttons = $('.simple')
      playBtn = $('.play')
      pauseBtn = $('.pause')
      unloadBtn = $('.unload')
      
      # Call play when play button clicked
      playBtn.on 'click', ->
        $(@).addClass 'disabled'
        pauseBtn.removeClass 'disabled' if pauseBtn.hasClass 'disabled'
        froogaloop.api 'play'
      
      # Call pause when pause button clicked
      pauseBtn.on 'click', ->
        $(@).addClass 'disabled'
        playBtn.removeClass 'disabled' if playBtn.hasClass 'disabled'
        froogaloop.api 'pause'
      
      # Call unload when unload button clicked
      unloadBtn.on 'click', ->
        pauseBtn.removeClass 'disabled' if pauseBtn.hasClass 'disabled'
        playBtn.removeClass 'disabled' if playBtn.hasClass 'disabled'
        froogaloop.api 'unload'
    
    ###
    Sets up the actions for the buttons that will modify certain
    things about the player and the video in it. These methods
    take a parameter, such as a color value when setting a color.
    ###
    setupModifierButtons = ->
      buttons = $('.modifiers')
      seekBtn = $('.seek')
      volumeBtn = $('.volume')
      loopBtn = $('.loop')
      colorBtn = $('.color')
      randomColorBtn = $('.randomColor')
      
      # Call seekTo when seek button clicked
      seekBtn.on 'click', (e)->
        # Don't do anything if clicking on anything but the button (such as the input field)
        return false unless e.target is @
        # Grab the value in the input field
        seekVal = $(@).find('input').attr('value')
        # Call the api via froogaloop
        froogaloop.api 'seekTo', seekVal
      
      # Call setVolume when volume button clicked
      volumeBtn.on 'click', (e)->
        # Don't do anything if clicking on anything but the button (such as the input field)
        return false  unless e.target is @
        # Grab the value in the input field
        volumeVal = $(@).find('input').attr('value')
        # Call the api via froogaloop
        froogaloop.api 'setVolume', volumeVal
      
      # Call setLoop when loop button clicked
      loopBtn.on 'click', (e)->
        # Don't do anything if clicking on anything but the button (such as the input field)
        return false  unless e.target is @
        # Grab the value in the input field
        loopVal = $(@).find('input').attr('value')
        #Call the api via froogaloop
        froogaloop.api 'setLoop', loopVal

      # Call setColor when color button clicked
      colorBtn.on 'click', (e)->        
        # Don't do anything if clicking on anything but the button (such as the input field)
        return false  unless e.target is @
        # Grab the value in the input field
        colorVal = $(@).find('input').attr('value')
        # Call the api via froogaloop
        froogaloop.api 'setColor', colorVal
      
      # Call setColor with a random color when random color button clicked
      randomColorBtn.on 'click', (e)->
        # Don't do anything if clicking on anything but the button (such as the input field)
        return false  unless e.target is @
        # Generate a random color
        colorVal = Math.floor(Math.random() * 16777215).toString(16)
        # Call the api via froogaloop
        froogaloop.api 'setColor', colorVal
        $(@).find('input').attr 'value', colorVal

    
    ###
    Sets up actions for buttons that will ask the player for something,
    such as the current time or duration. These methods require a
    callback function which will be called with any data as the first
    parameter in that function.
    ###
    setupGetterButtons = ->
      buttons = $('.getters')
      timeBtn = $('.time')
      durationBtn = $('.duration')
      colorBtn = $('.getColor')
      urlBtn = $('.url')
      embedBtn = $('.embed')
      pausedBtn = $('.paused')
      getVolumeBtn = $('.getVolume')
      widthBtn = $('.width')
      heightBtn = $('.height')
      
      # Get the current time and log it to the API console when time button clicked
      timeBtn.on 'click', ->
        froogaloop.api 'getCurrentTime', (value, player_id) ->          
          # Log out the value in the API Console
          apiLog 'getCurrentTime : ' + value

      
      # Get the duration and log it to the API console when time button clicked
      durationBtn.on 'click', ->
        froogaloop.api 'getDuration', (value, player_id) ->          
          # Log out the value in the API Console
          apiLog 'getDuration : ' + value

      
      # Get the embed color and log it to the API console when time button clicked
      colorBtn.on 'click',  ->
        froogaloop.api 'getColor', (value, player_id) ->
          # Log out the value in the API Console
          apiLog 'getColor : ' + value
      
      # Get the video url and log it to the API console when time button clicked
      urlBtn.on 'click', ->
        froogaloop.api 'getVideoUrl', (value, player_id) ->
          # Log out the value in the API Console
          apiLog 'getVideoUrl : ' + value
      
      # Get the embed code and log it to the API console when time button clicked
      embedBtn.on 'click', ->
        froogaloop.api 'getVideoEmbedCode', (value, player_id) ->
          # Use html entities for less-than and greater-than signs
          value = value.replace(/</g, '&lt;').replace(/>/g, '&gt;')
          # Log out the value in the API Console
          apiLog 'getVideoEmbedCode : ' + value
      
      # Get the paused state and log it to the API console when time button clicked
      pausedBtn.on 'click', ->
        froogaloop.api 'paused', (value, player_id) ->
          # Log out the value in the API Console
          apiLog 'paused : ' + value
      
      # Get the paused state and log it to the API console when time button clicked
      getVolumeBtn.on 'click', ->
        froogaloop.api 'getVolume', (value, player_id) ->
          # Log out the value in the API Console
          apiLog 'volume : ' + value
      
      # Get the paused state and log it to the API console when time button clicked
      widthBtn.on 'click', ->
        froogaloop.api 'getVideoWidth', (value, player_id) ->
          # Log out the value in the API Console
          apiLog 'getVideoWidth : ' + value
      
      # Get the paused state and log it to the API console when time button clicked
      heightBtn.on 'click', ->
        froogaloop.api 'getVideoHeight', (value, player_id) ->
          # Log out the value in the API Console
          apiLog 'getVideoHeight : ' + value
    
    ###
    Adds listeners for the events that are checked. Adding an event
    through Froogaloop requires the event name and the callback method
    that is called once the event fires.
    ###
    setupEventListeners = ->
      onLoadProgress = ->
        if loadProgressChk.attr('checked')
          froogaloop.addEvent 'loadProgress', (data) ->
            apiLog 'loadProgress event : ' + data.percent + ' : ' + data.bytesLoaded + ' : ' + data.bytesTotal + ' : ' + data.duration
        else
          froogaloop.removeEvent 'loadProgress'

      onPlayProgress = ->
        if playProgressChk.attr('checked')
          froogaloop.addEvent 'playProgress', (data) ->
            apiLog 'playProgress event : ' + data.seconds + ' : ' + data.percent + ' : ' + data.duration
        else
          froogaloop.removeEvent 'playProgress'

      onPlay = ->
        if playChk.attr('checked')
          froogaloop.addEvent 'play', (data) ->
            apiLog 'play event'
        else
          froogaloop.removeEvent 'play'

      onPause = ->
        if pauseChk.attr('checked')
          froogaloop.addEvent 'pause', (data) ->
            apiLog 'pause event'
        else
          froogaloop.removeEvent 'pause'

      onFinish = ->
        if finishChk.attr('checked')
          froogaloop.addEvent 'finish', (data) ->
            apiLog 'finish'
        else
          froogaloop.removeEvent 'finish'

      onSeek = ->
        if seekChk.attr('checked')
          froogaloop.addEvent 'seek', (data) ->
            apiLog 'seek event : ' + data.seconds + ' : ' + data.percent + ' : ' + data.duration
        else
          froogaloop.removeEvent 'seek'

      # UI

      checkboxes = $('.listeners')
      loadProgressChk = $('.loadProgress')
      playProgressChk = $('.playProgress')
      playChk = checkboxes.find('.playCheck')
      pauseChk = checkboxes.find('.pauseCheck')
      finishChk = checkboxes.find('.finishCheck')
      seekChk = checkboxes.find('.seekCheck')
      
      # Listens for the checkboxes to change
      loadProgressChk.on 'change', onLoadProgress, false
      playProgressChk.on 'change', onPlayProgress, false
      playChk.on 'change', onPlay, false
      pauseChk.on 'change', onPause, false
      finishChk.on 'change', onFinish, false
      seekChk.on 'change', onSeek, false
      
      # Calls the change event if the option is checked
      # (this makes sure the checked events get attached on page load as well as on changed)
      onLoadProgress()
      onPlayProgress()
      onPlay()
      onPause()
      onFinish()
      onSeek()
    
    ###
    Sets up actions for adding a new clip window to the page.
    ###
    setupAddClip = ->
      
      # Don't do anything if clicking on anything but the button (such as the input field)
      # Gets the index of the current player by simply grabbing the number after the underscore
      
      ###
      Resets the duplicate container's information, clearing out anything
      that doesn't pertain to the new clip. It also sets the iframe to
      use the new clip's id as its url.
      ###
      resetContainer = (element, index, clipId) ->
        newHeading = $('.videotitle')
        newIframe = $('<iframe>')
        newCheckBoxes = $('.listeners').find('input')
        newApiConsole = $('.console .output')
        newAddBtn = $('.addClip')
        
        # Set the heading text
        newHeading.html 'Vimeo Player ' + index
        
        # Set the correct source of the new clip id
        newIframe.attr
          src: 'http://player.vimeo.com/video/' + clipId + '?api=1&player_id=player_' + index
          id: 'player_' + index
        
        # Reset all the checkboxes for listeners to be checked on
        i = 0
        length = newCheckBoxes.length
        checkbox = undefined

        ###
        while i < length
          checkbox = newCheckBoxes[i]
          checkbox.setAttribute 'checked', 'checked'
          i++
        ###

        newCheckBoxes.each ->
          $(@).attr('checked', 'checked')
        
        # Clear out the API console
        newApiConsole.val ''
        
        # Update the clip ID of the add clip button
        newAddBtn.find('input').attr('value', clipId)

        element
        #newIframe
        
      ###
      setupAddClip Commands
      ###

      newContainer = undefined
      addBtnClip = $('.addClip')
      addBtnClip.on 'click', (e) ->
        return false unless e.target is @
        currentIndex = Math.floor(Math.random() * 10)
        clipId = $(@).find('input').attr('value')
        $('.btn-video').attr('data-vimeo', clipId)
        _initVideo $('.video-holder')

        ###
        container.html ''
        newContainer = resetContainer(container.clone(), currentIndex + 1, clipId)
        newContainer.appendTo container
        $f(newContainer.children()).addEvent 'ready', ready
        ###

    ###
    Ready Commands
    ###

    container = $('#' + player_id).parent()
    froogaloop = $f(player_id)
    apiConsole = $('.console .output')

    ###
    UI
    ###

    if container.parent().hasClass('modal-content')

      $('.modal').on 'shown.bs.modal', (e) ->
        _resizeVideo container, 1280, 720
        froogaloop.api 'play'
        #playVideo()

      $('.modal').on 'hide.bs.modal', (e) ->
        froogaloop.api 'pause'

      $(window).on 'resize', ->
        _resizeVideo container, 1280, 720

    else 
      $(window).on 'resize', ->
        _resizeVideo container, 1280, 720

    ###
    Actions
    ###

    setupSimpleButtons()
    setupModifierButtons()
    setupGetterButtons()
    setupEventListeners()
    setupAddClip()
    _resizeVideo container, 1280, 720
    
    # Setup clear console button
    clearBtn = $('.clear')
    clearBtn.on 'click', ->
      apiConsole.val ''
    apiLog player_id + ' ready!'
    return

  # Call the API when a button is pressed
  onPause = (id) ->
    console.log 'paused'

  onFinish = (id) ->
    console.log 'finished'

  onPlayProgress = (data, id) ->
    console.log data.seconds + 's played'

  _resizeVideo = ($holder, vidWidth = 1280, vHeight = 720)->

    holderHeight = $holder.height()      
    holderWidth = $holder.width()
    playerWidth = holderWidth
    playerHeight = holderWidth * (vHeight / vidWidth)
    $holder.css
      height: playerHeight
    #$('.modal-content').height playerHeight
    $holder.children().first().css
      height: playerHeight

  _initVideo = (videoHolderDiv) ->

    # Get the video ID from markup

    if $('.btn-video').size()
      # Get de Hash from Markup.
      if $('.btn-video').attr('data-vimeo') != '' || $('.btn-video').attr('data-vimeo') != undefined
        videoHash = $('.btn-video').attr('data-vimeo')
      else
        videoHash = videoDefault
      # Bind Click
      $('.btn-video').on 'click', ->
        $('#videoModal').modal 'toggle'

    # Builder

    if videoHolderDiv.find('iframe').size()
      iframeVideo = videoHolderDiv.children().first()
    else
      iframeVideo = $('<iframe>')
      iframeVideoModal = $('<iframe>')
      
      iframeVideo.attr
        id: playerID
        class: 'iframe-vimeo-player'
        width: '100%'
        height: '100%'
        frameborder: '0'
        src: 'http://player.vimeo.com/video/' + videoHash + '?api=1&player_id=' + playerID
      iframeVideo.appendTo videoHolderDiv

      iframeVideoModal.attr
        id: playerID + '_modal'
        class: 'iframe-vimeo-player'
        width: '100%'
        height: '100%'
        frameborder: '0'
        src: 'http://player.vimeo.com/video/' + videoHash + '?api=1&player_id=' + playerID + '_modal'
      videoHolderModal = $('<div class="video-holder"></div>')
      iframeVideoModal.appendTo videoHolderModal

      videoHolderModal.appendTo modalContent

    $('.iframe-vimeo-player').each ->
      player = @
      # frogaloop it!
      $f(player).addEvent 'ready', ready

  # Let´s go!
  _initVideo $('.video-holder')
  

)(jQuery)