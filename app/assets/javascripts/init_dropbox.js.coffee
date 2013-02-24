# Degbugging Tips
# ===============
# PC.client.authState
# PC.cleint.isAuthenticated()

showUserInfo = (client) ->
  console.log 'showUserInfo'
  client.getUserInfo (error, userInfo) ->
    if error?
      console.log 'getUserInfo: error'
      return
    $('.l-header .right').text(userInfo.name)

$ ->
  PC.client = new Dropbox.Client
    # key must be encoded from Dropbox app key & app secret by running this in your JS console: Dropbox.Util.encodeKey(myKey, mySecret)
    key: 'DrZzNtRBN7A=|mPI19Z9GiXGgyFdrCQf/7mpJi+/9gFFT/XipAyTw0g=='
    sandbox: true
  PC.client.authDriver new Dropbox.Drivers.Redirect(rememberUser: true)

  $('#js-dropbox-connect').click (event) ->
    event.preventDefault()
    PC.client.authenticate (error, client) ->
      if error?
        console.log error
        return
      console.log 'authenticate callback'
      showUserInfo(client)
