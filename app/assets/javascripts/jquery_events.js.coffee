$ ->
  $('.preload-image').imagesLoaded ->
    setInterval ->
      unless PC.justClicked
        PC.showNextImage
          transition: true
      PC.justClicked = false
    , 3500

  PC.galleryImagesCount = $('.image_large-wrapper').length
  PC.currentImageIndex = 0
  fadeTime = 750
  PC.justClicked = false

  $('.image_large-wrapper').click (event) ->
    event.preventDefault()
    event.stopPropagation()
    PC.justClicked = true
    PC.showNextImage
      transition: false


PC.showNextImage = (attributes = {}) ->
  $lastImageWrapper = $('.image_large-wrapper').eq(PC.currentImageIndex)
  if attributes.transition == true
    $lastImageWrapper.addClass('with-transition')
  else
    $lastImageWrapper.removeClass('with-transition') # remove b/c we might be coming back to this image after looping once through the entire collection.
  $lastImageWrapper.css 'opacity', 0

  if PC.currentImageIndex == PC.galleryImagesCount - 1
    PC.currentImageIndex = 0
  else
    PC.currentImageIndex++

  $currentImageWrapper = $('.image_large-wrapper').eq(PC.currentImageIndex)
  $currentImage = $currentImageWrapper.children('.image_large')
  $('.image_large--caption .image-title').text($currentImage.data 'caption' or '')

  if attributes.transition == true
    $currentImageWrapper.addClass('with-transition')
  else
    $currentImageWrapper.removeClass('with-transition')
  $currentImageWrapper.css 'opacity', 1
