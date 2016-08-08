class AppDelegate
  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    main_screen = ColorGolfScreen.new
    navigation = UI::Navigation.new(main_screen)
    flow_app = UI::Application.new(navigation, self)
    flow_app.start
  end
end
