'use strict'

class PC.Image extends Backbone.Model
  urlRoot: '/admin/images'

  defaults:
    hash: null
    data: null
    fileType: 'jpg'
    inputFileObject: {}
    galleryName: null
    dropboxURL: null
    exifObject: null

  initialize: ->
    # can't put these under defaults as they don't seem to get generated per instance then
    @set '$img', $("<img src='' width='100'>")
    @set 'readerDeferred',        new $.Deferred()
    @set 'exifReaderDeferred',    new $.Deferred()
    @set 'dropboxUploadFinished', new $.Deferred()
    @set 'weHaveTheURL',          new $.Deferred()
    @set 'reader',     new FileReader
    @set 'exifReader', new FileReader
    @set 'cryptor',    CryptoJS.algo.SHA256.create()

  # create image previews, calculate SHA256, read EXIF data
  readImageInfo: ->
    console.log('READ IMAGE INFO FOR')
    $('.image-previews').append(@get('$img')) if $('.image-previews').length
    @get('reader').onload = @handleReaderLoaded
    @get('exifReader').onload = @handleExifReaderLoaded
    $.when(@get 'readerDeferred').then =>
      console.log 'readerDeferred has been resolved'
      @get('exifReader').readAsArrayBuffer(@get 'inputFileObject')

    @get('reader').readAsDataURL(@get 'inputFileObject')

  uploadToDropbox: =>
    $.when(@get 'dropboxUploadFinished').then =>
      @getURL()
    $.when(@get 'weHaveTheURL').then =>
      console.log 'we have the URL! Saving...', @mappedAttributesForAPI()
      @save @mappedAttributesForAPI(), patch: true # only Rails 4 will be able to handle a PATCH request

    console.log 'uploading to dropbox', @fileName()
    PC.client.writeFile @fileName(), @get 'data', (error, stat) =>
      if error?
        console.log "An error occurred during Image.upload's .writeFile to Dropbox: ", error
      console.log 'File saved as revision: ', stat.revisionTag
      @get('dropboxUploadFinished').resolve()

  getURL: =>
    console.log 'getting sharable URL'
    PC.client.makeUrl @fileName(), (error, response) =>
      @set 'dropboxURL', response.url
      console.log 'Image URL:', @get 'dropboxURL'
      @get('weHaveTheURL').resolve()

  fileName: ->
    "#{@get('galleryName')}/#{@dateWithPartialHash()}.#{@get('fileType')}"

  dateWithPartialHash: ->
    "#{@cleanEXIFDate()}_#{@partialHash()}"

  hashString: ->
    "#{@get('hash')}"

  partialHash: ->
    @hashString().substr(0, 5)

  cleanEXIFDate: ->
    return null unless @get('exifObject')?
    @get('exifObject').DateTimeOriginal.description.replace(/:/g, '-').replace(' ', '_') # turns '2013:03:07 22:26:21' into '2013-03-07_22-26-21'

  handleReaderLoaded: (event) =>
    console.log 'handleReaderLoaded'
    if event.target.readyState is FileReader.DONE
      console.log 'handleReaderLoaded: FileReader is DONE'
      # result starts with "data:" when this callback is triggered by .readAsBinaryString
      if /^data:/.test(@get('reader').result)
        console.log 'handleReaderLoaded: read as data-URL'
        @get('$img').attr('src', event.target.result)
        console.log @get('$img')
        @set 'width', @get('$img')[0].naturalWidth # neeed to call naturalWidth on the DOM, not the jQuery object - [0] gets the DOM object
        @set 'height', @get('$img')[0].naturalHeight
        console.log 'width x height: ', @get('width'), @get('height')
        @get('reader').readAsBinaryString @get('inputFileObject') # for some reason we need to call this within the .readAsDataURLs' callback - the `onload` callback doesn't fire twice when calling .readAsBinaryString right after .readAsDataURL
      else if @get('reader').result? # callback's been called by .readAsDataURL
        console.log 'handleReaderLoaded: read as BinaryString'
        @get('cryptor').update CryptoJS.enc.Latin1.parse(event.target.result)
        @set 'hash', @get('cryptor').finalize()
        $('.sha256-results').append '<p>SHA-256: ' + @get('hash') + '</p>'
        @get('$img').data 'sha256', @get('hash')
        @get('readerDeferred').resolve()

  handleExifReaderLoaded: (event) =>
    console.log 'reader 2 loaded - EXIF coming...'
    @set 'data', event.target.result

    # Parse the Exif tags
    exif = new ExifReader()
    try
      exif.load(event.target.result)
      console.log 'loading exif success'
    catch error
      console.log 'Loading EXIF info failed with this error:', error # required in case an image has no valid EXIF data
    # Or, with jDataView you would use this:
    # exif.loadView(new jDataView(event.target.result));
    @set 'exifObject', exif.getAllTags()

    # Output the tags on the page.
    $exifTable = $('#exif-tables').append('<table></table><hr class="red">').children('table')
    for attribute of @get('exifObject')
      $exifTable.append('<tr><td>' + attribute + '</td><td>' + @get('exifObject')[attribute].description + '</td></tr>')
    @get('exifReaderDeferred').resolve()

  mappedAttributesForAPI: ->
    hash_checksum: @hashString() # 'hash' is reserved by ActiveRecord
    width: @get 'width'
    height: @get 'height'
    dropbox_url: @get 'dropboxURL'
