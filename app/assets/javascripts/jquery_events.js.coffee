$ ->
  imagesCount = $('.title-image').length
  currentItem = 0
  fadeTime = 750

  setInterval ->
    $('.title-image').eq(currentItem).fadeOut(fadeTime)
    if currentItem == imagesCount-1
      currentItem = 0
    else
      currentItem++
    $('.title-image').eq(currentItem).fadeIn(fadeTime)
  , 3500
