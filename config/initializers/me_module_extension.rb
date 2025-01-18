Rails.application.config.after_initialize do
  module Me
    extend ::MeHelper
  end
end
