# CarrierWaveの設定(リージョン東京)
require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production? # 本番:AWS使用
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.secrets.aws_access_key_id,
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
      region: 'ap-northeast-1'
    }
  else
    config.storage :file # 開発:public/uploades下に保存
    config.enable_processing = false if Rails.env.test? #test:処理をスキップ
  end

  config.fog_directory  = 'freemarket-d'
  config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/freemarket-d'
end