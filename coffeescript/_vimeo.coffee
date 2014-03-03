###
 *
 * @refactoring to CofeeScript by Alfredo Llanos <alfredo@tallerdelsoho.es> || @biojazzard
###

(($) =>

  videoDefault = '87882921'
  iframe = $("#player")[0]
  player = $f(iframe)
  ###
  player.addEvent "ready", ->
    player.addEvent "pause", onPause
    player.addEvent "finish", onFinish
    player.addEvent "playProgress", onPlayProgress
  ###

  #player.api 'setColor', '#4090a0'

  #Resize
  
  $(window).on 'debouncedresize.video', ->
    modalHeight = $('.modal-content').height()      
    modalWidth = $('.modal-content').width()
    playerWidth = modalWidth
    playerHeight = modalWidth * (506 / 900)
    @$('.modal-content').css
      height: playerHeight
    , 333 
    #$('.modal-content').height playerHeight
    $('#player').css
      height: playerHeight
    , 222

  # Retrieve Video Value.

  if $('.btn-video').size()
    # Get de Hash from Markup.
    if $('.btn-video').attr('data-vimeo') != '' || $('.btn-video').attr('data-vimeo') != undefined
      videoHash = $('.btn-video').attr('data-vimeo')
      console.log videoHash
    else
      videoHash = videoDefault
    # Bind Click
    $('.btn-video').on 'click', ->
      $('#videoModal').modal 'toggle'

  # Play Pause Modal Events 

  $('#videoModal').on 'shown.bs.modal', (e) ->
    $(window).trigger 'debouncedresize.video'
    player.api 'play'
  
  $('#videoModal').on 'hide.bs.modal', (e) ->
    player.api 'pause'

  # Call the API when a button is pressed
  onPause = (id) ->
    console.log "paused"
    return
  onFinish = (id) ->
    console.log "finished"
    return
  onPlayProgress = (data, id) ->
    console.log data.seconds + "s played"
    return

)(jQuery)