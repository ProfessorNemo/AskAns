Recaptcha.configure do |config|
  config.site_key = Rails.application.credentials.dig(:recaptcha, :site_key)
  config.secret_key = Rails.application.credentials.dig(:recaptcha, :secret_key)
  # config.site_key = ENV.fetch('RECAPTCHA_ASKME_PUBLIC_KEY', nil)
  # config.secret_key = ENV.fetch('RECAPTCHA_ASKME_PRIVATE_KEY', nil)
end

# Установка переменных окружения:
# 1-й способ:
# 1. $ nano ~/.bash_profile
# 2. export RECAPTCHA_ASKANS_PUBLIC_KEY="*****************************************"
#    export RECAPTCHA_ASKANS_PRIVATE_KEY="****************************************"

# 2-й способ:
# $ EDITOR=vim rails credentials:edit
# recaptcha:
#   site_key: ****************************************
#   secret_key: **************************************
