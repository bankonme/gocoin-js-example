gocoin-js-example
=================

Example of gocoin-js in use

You need

A)
  * An Access token or API key with scope `"user_read invoice_read_write"` [Getting and API Key](http://help.gocoin.com/kb/api-authorization/api-keys-from-the-gocoin-dashboard)
B) 
  * An GoCoin application id, secret, and redirect_uri. More information on getting an access token using OAuth2.0 is [here](http://help.gocoin.com/kb/api-authorization/obtaining-an-access-token)

Optional:
  * Your GoCoin merchant_id (this applet will fetch it for you if you do not know it.) 

if you have foreman installed, store these values in your ENV. Use sample.env to mock your .env file. 

```
$ foreman start
```

If you do not have foreman installed, you can add the values to the commented out fields in src/example.coffee

```
npm start
```