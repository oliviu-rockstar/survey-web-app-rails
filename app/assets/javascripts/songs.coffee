uploadable = []
paramNames = []
uploadProgressBox = null

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

  $('#songForm').fileupload(
    autoUpload: false
    singleFileUploads: false
    add: (event, data) ->
      uploadable.push data.files[0]
      paramNames.push(event.delegatedEvent.target.name);
      false
    send: ->
      submitSong = $('#songForm [type="submit"]')
      submitSong.attr('data-loading', true)
      submitSong.attr('disabled', true)

      uploadProgressBox = Lobibox.progress(
        title: 'Please wait'
        label: 'Uploading files...'
      )
      return
    done: (event, data) ->
      location.href = data.result.redirect_url
      return
    fail: (event, data) ->
      $('#newArtistSongPage .song').html(data.jqXHR.responseText)
      songFormReady()
      return
    always: ->
      submitSong = $('#songForm [type="submit"]')
      submitSong.attr('data-loading', false)
      submitSong.attr('disabled', false)
      uploadProgressBox.hide()
      return
    progress: (event, data) ->
      uploadProgressBox.setProgress(data.loaded / data.total * 100)
      return
  )

  $('#songForm').submit (event) ->
    event.preventDefault()
    $('#songForm').fileupload 'send',
      files: uploadable
      paramName: paramNames
#      formData: [
#        { name: 'authenticity_token', value: $('meta[name="csrf-token"]').attr('content') }
#      ]
    return

  showSelectedFileName = (input) ->
    fullPath = $(input).val()
    if fullPath
      startIndex = if fullPath.indexOf('\\') >= 0 then fullPath.lastIndexOf('\\') else fullPath.lastIndexOf('/')
      filename = fullPath.substring(startIndex)
      if filename.indexOf('\\') == 0 or filename.indexOf('/') == 0
        filename = filename.substring(1)
      $('.song_zipfile_filename').html(filename)
    return

  $('input#song_zipfile').change ->
    showSelectedFileName(this)
    return

  return

$(document).on 'ready page:load', ->
  if $('#songForm').length > 0
    songFormReady() 

  return

$ ->
  $('[rel="popover"]').popover(
    container: 'body'
    html: true
    content: ->
      clone = $($(this).data('popover-content')).clone(true).removeClass('hide')
      clone
  ).click (e) ->
    e.preventDefault()
    event.stopPropagation()
    return
  return
$(document).click ->
  $('.popover').css 'display', 'none'
  return