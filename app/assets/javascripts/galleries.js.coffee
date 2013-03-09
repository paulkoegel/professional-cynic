# uploadFile = ->
#   if PC.sha and PC.data
#     PC.client.writeFile("#{PC.sha}.jpg", PC.file, (error, stat) ->
#       if error?
#         console.log 'error during writeFile to Dropbox: ', error
#       console.log 'file saved as revision: ', stat.revisionTag
#     )

$ ->

  # source: http://stackoverflow.com/questions/13981832/how-do-i-use-sha256-on-a-filebinary-file-such-as-images-in-javascript
  $('#js-image-uploader').change (event) ->
    $('.image-previews, .sha256-results').html('') # clear previously rendered previews and SHA2s
    target = event.originalEvent.srcElement or event.originalEvent.target # IE needs srcElement

    _(target.files).each (file, index) ->
      new PC.Image
        inputFileObject: file
      # # do creates an IIFE, which we need here to force block scope
      # # without it, index would be equal to target.files.length every time the .onloadend callback is triggered
      # # and we'd just keep overwriting the last <img> tag's src attribute
      # do (index) ->
      #   # $img = $("<img src='' width='100'>")
      #   # $('.image-previews').append($img)

      #   reader = new FileReader()
      #   exifReader = new FileReader() # need to use a separate reader for EXIF since EXIF needs an ArrayBuffer and I couldn't yet find a way to distinguish current data in the .onload callback
      #   sha256 = CryptoJS.algo.SHA256.create()

      #   reader.onload = (evt) ->
      #     if evt.target.readyState is FileReader.DONE
      #       # result starts with "data:" when this callback is triggered by .readAsBinaryString
      #       if /^data:/.test(reader.result)
      #         $img.attr('src', evt.target.result)
      #         $img.data 'width', $img[0].naturalWidth # neeed to call naturalWidth on the DOM, not the jQuery object
      #         $img.data 'height',$img[0].naturalHeight
      #         reader.readAsBinaryString file # for some reason we need to call this within the .readAsDataURLs' callback - the `onload` callback doesn't fire twice when calling .readAsBinaryString right after .readAsDataURL
      #       else if reader.result isnt null # callback's been called by .readAsDataURL
      #         sha256.update CryptoJS.enc.Latin1.parse(evt.target.result)
      #         hash = sha256.finalize()
      #         PC.sha = hash
      #         $('.sha256-results').append '<p>SHA-256: ' + hash + '</p>'
      #         $img.data 'sha256', hash
      #         exifReader.readAsArrayBuffer(file)

      #   exifReader.onload = (evt) ->
      #     console.log 'reader 2 loaded - EXIF coming...'
      #     exif = new ExifReader()
      #     
      #     # Parse the Exif tags
      #     exif.load(evt.target.result)
      #     # Or, with jDataView you would use this:
      #     # exif.loadView(new jDataView(evt.target.result));
      #     
      #     # Output the tags on the page.
      #     $exifTable = $('#exif-tables').append('<table></table>').children('table')
      #     exifObject = exif.getAllTags()
      #     for attribute of exifObject
      #       $exifTable.append('<tr><td>' + attribute + '</td><td>' + exifObject[attribute].description + '</td></tr>')


      #     PC.data = evt.target.result
      #     uploadFile()
      #     # PC.client.writeFile('test.jpg', evt.target.result, (error, stat) ->
      #     #   if error?
      #     #     console.log 'error during writeFile to Dropbox: ', error
      #     #   console.log 'file saved as revision: ', stat.revisionTag
      #     # )

      #   reader.readAsDataURL(file)
