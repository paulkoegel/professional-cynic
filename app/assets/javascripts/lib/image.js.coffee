'use strict'

class PC.Image extends Backbone.Model
  urlRoot: '/admin/images'

  initialize: (attributes = {}) ->
    console.log 'Hello from Image.constructor!'
    @hash            = attributes.hash || null
    @data            = attributes.data || null
    @fileType        = attributes.fileType || 'jpg'
    @inputFileObject = attributes.inputFileObject || {}
    @dropboxURL      = null
    console.log 'inputFileObject', @inputFileObject

  # trigger creation of image preview, SHA256 calculation, reading of EXIF data, as well as upload
  # TODO: decouple all of these steps...
  process: ->
    @$img = $("<img src='' width='100'>")
    $('.image-previews').append(@$img) if $('.image-previews').length
    @readerDeferred        = new $.Deferred()
    @exifReaderDeferred    = new $.Deferred()
    @dropboxUploadFinished = new $.Deferred()
    @weHaveTheURL          = new $.Deferred()

    @reader = new FileReader
    @reader.onload = @handleReaderLoaded
    @exifReader = new FileReader
    @exifReader.onload = @handleExifReaderLoaded
    @cryptor = CryptoJS.algo.SHA256.create()
    $.when(@readerDeferred).then =>
      console.log 'readerDeferred has been resolved'
      @exifReader.readAsArrayBuffer(@inputFileObject)
    $.when(@readerDeferred, @exifReaderDeferred).then @uploadToDropbox
    $.when(@dropboxUploadFinished).then =>
      @getURL()
    $.when(@weHaveTheURL).then =>
      console.log 'we have the URL! Saving...', @mappedAttributesForAPI()
      @save @mappedAttributesForAPI(), patch: true # only Rails 4 will be able to handle a PATCH request

    @reader.readAsDataURL(@inputFileObject)

  uploadToDropbox: =>
    console.log 'uploading to dropbox', @fileName()
    PC.client.writeFile @fileName(), @data, (error, stat) =>
      if error?
        console.log "An error occurred during Image.upload's .writeFile to Dropbox: ", error
      console.log 'File saved as revision: ', stat.revisionTag
      @dropboxUploadFinished.resolve()

  getURL: =>
    console.log 'getting sharable URL'
    PC.client.makeUrl @fileName(), (error, response) =>
      @dropboxURL = response.url
      console.log 'Image URL:', @dropboxURL
      @weHaveTheURL.resolve()

  fileName: ->
    "#{@hash}.#{@fileType}"

  handleReaderLoaded: (event) =>
    console.log 'handleReaderLoaded'
    if event.target.readyState is FileReader.DONE
      console.log 'handleReaderLoaded: FileReader is DONE'
      # result starts with "data:" when this callback is triggered by .readAsBinaryString
      if /^data:/.test(@reader.result)
        console.log 'handleReaderLoaded: read as data-URL'
        @$img.attr('src', event.target.result)
        @width  = @$img[0].naturalWidth # neeed to call naturalWidth on the DOM, not the jQuery object
        @height = @$img[0].naturalHeight
        console.log 'X|Y: ', @width, @height
        @reader.readAsBinaryString @inputFileObject # for some reason we need to call this within the .readAsDataURLs' callback - the `onload` callback doesn't fire twice when calling .readAsBinaryString right after .readAsDataURL
      else if @reader.result isnt null # callback's been called by .readAsDataURL
        console.log 'handleReaderLoaded: read as BinaryString'
        @cryptor.update CryptoJS.enc.Latin1.parse(event.target.result)
        @hash = @cryptor.finalize()
        $('.sha256-results').append '<p>SHA-256: ' + @hash + '</p>'
        @$img.data 'sha256', @hash
        @readerDeferred.resolve()

  handleExifReaderLoaded: (event) =>
    console.log 'reader 2 loaded - EXIF coming...'
    @data = event.target.result
    
    # Parse the Exif tags
    exif = new ExifReader()
    try
      exif.load(event.target.result)
      console.log 'loading exif success'
    catch error
      console.log 'Loading EXIF info failed with this error:', error # required in case an image has no valid EXIF data
    # Or, with jDataView you would use this:
    # exif.loadView(new jDataView(event.target.result));
    exifObject = exif.getAllTags()
    
    # Output the tags on the page.
    $exifTable = $('#exif-tables').append('<table></table>').children('table')
    for attribute of exifObject
      $exifTable.append('<tr><td>' + attribute + '</td><td>' + exifObject[attribute].description + '</td></tr>')
    @exifReaderDeferred.resolve()

  mappedAttributesForAPI: ->
    hash_checksum: "#{@hash}" # has is reserved by ActiveRecord
    width: @width
    height: @height
    dropbox_url: @dropboxURL
