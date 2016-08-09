```
ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-darwin15]
```

```
gem install motion-flow

motion create --template=flow ColorGolfMobile
cd ColorGolfMobile
```

directory structure

```
/
└─ app/
   └─ ios/
   |  └─ app_delegate.rb
   └─ android/
      └─ main_activity.rb
```

create file

touch `app/color_golf_screen.rb`

directory structure

```
/
└─ app/
   └─ ios/
   |  └─ app_delegate.rb
   └─ android/
   |  └─ main_activity.rb
   └─ color_golf_screen.rb
```

add the follow code in `app/ios/app_delegate.rb`:

```ruby
1   class AppDelegate
2       attr_accessor :window
3
4     def application(application, didFinishLaunchingWithOptions:launchOptions)
5       main_screen = ColorGolfScreen.new
6       navigation = UI::Navigation.new(main_screen)
7       flow_app = UI::Application.new(navigation, self)
8       flow_app.start
9     end
10  end
```

[todo line by line explanation]

add the follow code in `app/android/main_activity.rb`:

```ruby
1   class MainActivity < Android::Support::V7::App::AppCompatActivity
2     def onCreate(savedInstanceState)
3       super
4       UI.context = self
5
7       main_screen = ColorGolfScreen.new
8       navigation = UI::Navigation.new(main_screen)
9       flow_app = UI::Application.new(navigation, self)
10      flow_app.start
11    end
12  end
```

[todo line by line explanation]

add the following code in `app/color_golf_screen.rb`:

```ruby
class ColorGolfScreen < UI::Screen
  def on_show
    self.navigation.hide_bar
  end

  def on_load
    background = UI::View.new
    background.flex = 1
    background.margin = 25
    background.background_color = :white
    view.add_child(background)

    label = UI::Label.new
    label.margin = [10, 10, 5, 10]
    label.text = "Hello world"
    label.text_alignment = :center
    background.add_child(label)
    view.update_layout
  end
end
```
