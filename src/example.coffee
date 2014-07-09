GoCoin = require 'gocoin'

###
This is the easiest path to integration. 

If you get an api key from the dashboard, enter it here.
Or if you have obtained an access token by previously, 
it can be entered here. Preferably, it is stored in your 
environment. 
###

# access_token = process.env.GOCOIN_ACCESS_TOKEN || null

### 
If you don't have an Api key, or want your application to be 
responsible for authentication with the GoCoin API, you can 
enter your application ID, Secret, and redirect_uri
###

# gocoin_client_id = null
# gocoin_client_secret = null
# gocoin_redirect_uri = null

###
Set the scope for your access token
###

# scope = "user_read invoice_read_write"

###
If you plan to authenticate multiple users and store access 
tokens on their behalf, you should use the state parameter 
to track requests to your redirect_uri. Using a session cookie
is one way to accomplish this.
###

# state = null

###
If you know your merchant_id, enter it here. Otherwise, we 
will make an extra request to retrieve it. In a more complex
integration, you will likely want to cache this or store it 
in your db to avoid making requests in series.
###

merchant_id = process.env.GOCOIN_MERCHANT_ID || null

# Instantiate client
gocoin = new GoCoin.Client()

unless access_token?
  unless gocoin_client_id? && gocoin_client_secret? && gocoin_redirect_uri? 
    throw new Error "Please include an access_token or a client id, secret, and redirect_uri"
  auth_url = gocoin.auth.construct_code_url
    client_id:        gocoin_client_id
    client_secret:    gocoin_client_secret
    redirect_uri:     gocoin_redirect_uri
    scope:            if scope? then scope else "user_read invoice_read_write"
    state:            if state? then state else null

  console.log "Visit this url to obtain your authorization code", auth_url
  console.log 'Exiting...'

  ###
  You need to visit the above url to allow your application to access 
  your account. Clicking 'allow' will redirect to your 
  redirect_uri with an authorization code in the querystring. 

  This code block should  be executed by the controller on your redirect_uri.
  
  ```
  code   = req.query.code #if you are using express
  state  = req.query.state 
  
  # If you are using the state parameter to keep track
  # unless state = session.id then throw new Error 'State does not match'
  
  unless code? then throw new Error 'No authorization code exists'
  else
    gocoin = new GoCoin.Client
      grant_type: "authorization_code"
      client_id: gocoin_client_id
      client_secret: gocoin_client_secret
      redirect_uri: gocoin_redirect_uri
      code: code
    gocoin.authenticate (err, result) ->
      if err 
        console.log err
      else
        result = JSON.parse result
        console.log result
        # store the access_token in your environment or db, or add it to
        # the top of this file

  ```

  ###

else
  #set the access token since you have it
  gocoin.set_token access_token

  unless merchant_id?
    gocoin.user.self (err, currentUser) ->
      if err then console.error "Could not get merchant_id:", err
      else 
        merchant_id = (JSON.parse currentUser).merchant_id
        console.log "Please store this merchant id to create an invoice: #{merchant_id}      Exiting..."
        # store the merchant_id in your environment or db, or add it to
        # the top of this file
  else 
    # Create an Invoice
    # params.data contains the invoice parameters
    params =
      id: merchant_id
      data: 
        base_price: "1"
        base_price_currency: "USD"
        price_currency: "BTC"

    gocoin.invoices.create params, (err, invoice) ->
      if err then console.error err
      else 
        invoice = JSON.parse invoice
        console.log invoice
        console.log "You have successfully created an invoice. Exiting..."

      # go to invoice.gateway_url to view the invoice

