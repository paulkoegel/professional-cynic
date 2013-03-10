# Degbugging Tips
# ===============
# PC.client.authState
# PC.client.isAuthenticated()

showUserInfo = (client) ->
  console.log 'showUserInfo'
  client.getUserInfo (error, userInfo) ->
    if error?
      console.log 'getUserInfo: error'
      return
    $('#js-dropbox-connect').html "<a href='http://dropbox.com'><span class='icon retweet'></span>#{userInfo.name}</a>"

$ ->
  PC.client = new Dropbox.Client
    # key must be encoded from Dropbox app key & app secret by running this in your JS console: Dropbox.Util.encodeKey(myKey, mySecret)
    key: 'DrZzNtRBN7A=|mPI19Z9GiXGgyFdrCQf/7mpJi+/9gFFT/XipAyTw0g=='
    sandbox: true
  PC.client.authDriver new Dropbox.Drivers.Redirect(rememberUser: true)

  PC.client.authenticate(interactive: false, (error, client) ->
    console.log 'authenticate callback'
    if error?
      console.log 'error authenticating with interactive: false', error
      return
    if client.isAuthenticated()
      showUserInfo(client)
    else
      $('#js-dropbox-connect').click (event) ->
        event.preventDefault()
        client.authenticate (error, client) ->
          if error?
            console.log 'error authenticating with interactive: true', error
          showUserInfo()
  )
