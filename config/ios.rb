# -*- coding: utf-8 -*-
Motion::Project::App.setup do |app|
  # Use `rake ios:config' to see complete project settings.
  app.name = 'Color Golf'
  app.identifier = 'com.scratchworkdevelopment.colorgolf'

  app.development do
    app.codesign_certificate = MotionProvisioning.certificat(
      type: :development,
      platform: :ios)

    app.provisioning_profile = MotionProvisioning.profile(
      bundle_identifier: app.identifier,
      app_name: app.name,
      platform: :ios,
      type: :development)
  end
end
