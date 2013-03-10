$ ->

  # source: http://stackoverflow.com/questions/13981832/how-do-i-use-sha256-on-a-filebinary-file-such-as-images-in-javascript
  $('#js-image-chooser').change (event) ->
    $('.image-previews, .sha256-results').html '' # clear previously rendered previews and SHA2s
    target = event.originalEvent.srcElement or event.originalEvent.target # IE needs srcElement

    PC.images = []
    _(target.files).each (file, index) ->
      image = new PC.Image
        inputFileObject: file
      PC.images.push image
      image.readImageInfo()

  $('#js-upload-new-gallery').click (event) ->
    event.preventDefault()
    unless galleryName = $("[name = 'gallery_name']").val()
      PC.showFlashError('Please enter a gallery name first')
      return
    _(PC.images).each (image) ->
      image.set('galleryName', galleryName)
      image.uploadToDropbox()
