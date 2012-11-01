$ ->
  imagesCount = $('.image_large-wrapper').length
  currentItem = 0
  fadeTime = 750

  setInterval ->
    $('.image_large-wrapper').eq(currentItem).fadeOut(fadeTime)
    if currentItem == imagesCount-1
      currentItem = 0
    else
      currentItem++
    $currentImageWrapper = $('.image_large-wrapper').eq(currentItem)
    $currentImage = $currentImageWrapper.children('.image_large')
    $('.image_large--caption').text($currentImage.data 'caption')
    $currentImageWrapper.fadeIn(fadeTime)
  , 3500
