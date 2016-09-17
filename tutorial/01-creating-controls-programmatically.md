# Creating Controls Programmatically #

Before we jump into full blown cross platform apps with RubyMotion and
Flow, let's look using just the core iOS and Android controls first.

# Creating an iOS Only App and Adding a Button to the Screen #

Create a new projects.

```shell
motion create button-app
cd button-app
```

Make sure it runs:

```shell
rake
```

Exit app by pressing `ctrl+c`.

Add new file.

```shell
cd app
touch main_view_controller.rb
```

Here is how you would add a `UIButton` programmatically in ObjectiveC:

```objective-c
UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
[button addTarget:self
           action:@selector(aMethod:)
 forControlEvents:UIControlEventTouchUpInside];
[button setTitle:@"Tap Me" forState:UIControlStateNormal];
button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
[view addSubview:button];
```

Put the following code in `main_view_controller.rb`.

```ruby
class MainViewController < UIViewController
  def viewDidLoad
    button = UIButton.buttonWithType UIButtonTypeRoundedRect
    button.addTarget(
      self,
      action: :button_tapped,
      forControlEvents: UIControlEventTouchUpInside)

    button.setTitle 'Tap Me', forState: UIControlStateNormal
    button.frame = CGRectMake(80, 210, 160, 40)
    self.view.addSubview button
  end

  def button_tapped
    puts 'hello world'
  end
end
```

In `app_delegate.rb`, updated

```objective-c
rootViewController = UiViewController.alloc.init
```

to

```objective-c
rootViewController = MainViewController.alloc.init
```

Run the app and then click the button:

```shell
rake
```

# Creating an Android Only App and Adding a Button to the Screen #
