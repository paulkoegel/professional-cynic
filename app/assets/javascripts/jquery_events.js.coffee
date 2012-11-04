$ ->
  imagesCount = $('.image_large-wrapper').length
  currentItem = 0
  fadeTime = 750
  justClicked = false

  setInterval ->
    unless justClicked
      $('.image_large-wrapper').eq(currentItem).fadeOut(fadeTime)
      if currentItem == imagesCount-1
        currentItem = 0
      else
        currentItem++
      $currentImageWrapper = $('.image_large-wrapper').eq(currentItem)
      $currentImage = $currentImageWrapper.children('.image_large')
      $('.image_large--caption .image-title').text($currentImage.data 'caption' or '')
      $currentImageWrapper.fadeIn(fadeTime)
    justClicked = false
  , 3500

  $('.image_large-wrapper').click (event) ->
    event.preventDefault()
    event.stopPropagation()
    justClicked = true
    $('.image_large-wrapper').eq(currentItem).fadeOut(fadeTime)
    currentItem++
    $currentImageWrapper = $('.image_large-wrapper').eq(currentItem)
    $currentImage = $currentImageWrapper.children('.image_large')
    $('.image_large--caption .image-title').text($currentImage.data 'caption' or '')
    $currentImageWrapper.fadeIn(fadeTime)
