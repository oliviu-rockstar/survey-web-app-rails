@initializePlayer = (jpPlayerSelector, jpAudioSelector) ->
  trackElement = $(jpPlayerSelector).closest('.track')

  trackElement.find('.play').click ->
    trackElement.find('.jp-player').jPlayer('play')
    return

  trackElement.find('.pause').click ->
    trackElement.find('.jp-player').jPlayer('pause')
    return

  $(jpPlayerSelector).jPlayer
    ready: ->
      trackElement.find('.pause').hide()
      trackElement.find('.play').show()

      audio = trackElement.data('audio')
      trackElement.find('.jp-player').jPlayer 'setMedia',
        m4a: audio.m4a
      return

    play: ->
      $(this).jPlayer('pauseOthers')
      trackElement.find('.play').hide()
      trackElement.find('.pause').show()
      return

    pause: ->
      trackElement.find('.pause').hide()
      trackElement.find('.play').show()
      return

    cssSelectorAncestor: jpAudioSelector
    swfPath: '/swf'
    supplied: 'm4a'
    wmode: 'window'
    smoothPlayBar: true
    keyEnabled: true
    remainingDuration: true
  return

@artistProfilePageReady = ->
  $.each $('#artistProfilePage .mix8-player'), (index, player) ->
    initializePlayer '#' + $(player).find('.jp-player').prop('id'), '#' + $(player).find('.jp-audio').prop('id')
    return

  return

@editArtistProfilePageReady = ->
  $('#user_profile_image').filestyle
    icon: false
    badge: false
    input: false
    buttonText: 'Update Profile Image'
    buttonName: 'btn-primary btn-round'

  $('#user_profile_background_image').filestyle
    icon: false
    badge: false
    input: false
    buttonText: 'Update Background Image'
    buttonName: 'btn-primary btn-round'

  $('#user_genre_list').tagsinput()

  return

@songFormReady = ->
  $('#song_image').filestyle
    icon: false
    badge: false
    input: false
    buttonText: 'Update Image'
    buttonName: 'btn-primary btn-round'

  $('#song_zipfile').filestyle
    icon: false
    badge: false
    input: false
    buttonText: 'Update Zipfile'
    buttonName: 'btn-primary btn-round'

  $('#song_genre_list').tagsinput()

  $('#songForm').submit ->
    submitSong = $('[type="submit"]')
    submitSong.attr('data-loading', true)
    submitSong.attr('disabled', true)
    return

  return

$(document).on 'ready page:load', ->
  if $('#artistProfilePage').length > 0
    artistProfilePageReady()

  if $('#editArtistProfilePage').length > 0
    editArtistProfilePageReady()

  if $('#songForm').length > 0
    songFormReady()

  return