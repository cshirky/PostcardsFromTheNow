CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => '03M10TN1XMHYB22AG182',       # required
    :aws_secret_access_key  => '+PsngMBpwskT8ehQuQniUhKtZUgKDtOOg/gOb93u',       # required
    :region                 => 'us-east-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'viewthroughthewindow'                     # required
  # config.fog_hos       = 'https://assets.example.com'            # optional, defaults to nil
  # config.fog_public     = false                                   # optional, defaults to true
  # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end