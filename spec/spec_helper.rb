require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

module OAuthSettings
  AccessToken = "token"
  AccessSecret = "secret"
  ConsumerKey = "consumer_key"
  ConsumerSecret = "consumer_secret"
  Site = "https://telcoassetmarketplace.com"
  
  OAuthParams = {"oauth_consumer_key" => /^#{ConsumerKey}$/, "oauth_signature_method" => /^HMAC-SHA1$/, "oauth_nonce" => /.+/,  "oauth_signature" => /.+/, "oauth_timestamp" => /^[0-9]+$/, "oauth_version" => /^1.0$/, "oauth_token" => /^#{AccessToken}$/}
end