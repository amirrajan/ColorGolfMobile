# Installing RubyMotion #

- You need a Mac.
- You need to be on the El Cap OS.
- You need to XCode (you can get it from the AppStore).
- You need Ruby installed, preferablly version `2.3.1p112` or
  later. I'd recommend using [`rbenv`](https://github.com/rbenv/rbenv) for managing ruby versions.
- Go to the RubyMotion website and [download the
  free version](http://www.rubymotion.com/download/starter/). You
  will need to provide an email address to get a license key.

# Ruby/ObjectiveC/Java Primer #

Answers on StackOverflow for iOS and Android issues are in their
respective languages (ObjectiveC, Java). There's no denying that. This
section goes into how you can translate ObjectiveC and Java to
Ruby. It's surprisingly simple, even if you've never written a line of
ObjectiveC or Java. Even if you're gun shy about using Ruby, you'll
still get a great overview of how to read ObjectiveC and Java code
contextualized through Ruby lenses. So let's get started.

# ObjectiveC to Ruby #

Here is how a `Person` class would be created in ObjectiveC. There are
two properties `firstName` and `lastName`, and instance function
called `sayHello` that returns a string. Instance methods in
ObjectiveC are denoted by the `-` sign preceeding the function name:

## Class Construction ##

```objectivec
//Person.h
@interface Person : NSObject
@property NSString *firstName;
@property NSString *lastName;
- (NSString*)sayHello;
@end

//Person.m
#import "Person.h"
@implementation Person
- (NSString*)sayHello {
  return [NSString stringWithFormat:@"Hello, %@ %@.",
                                    _firstName,
                                    _lastName];
}
@end
```

Here is how you would instanciate an instance of `Person` and call the
`sayHello` function.

```
Person *person = [[Person alloc] init];
person.firstName = @"Amir";
person.lastName = @"Rajan";
NSLog([person sayHello]);
```

Let's break this down:

Method invocation in ObjectiveC is done through
paired brackets `[]`. So instead of `person.sayHello()` you have
`[person sayHello]`. All ObjectiveC classes have an `alloc` class
method, and an `init` instance method. The `alloc` class method
creates a memory space for the instance of the class, and the `init`
method initializes it (essentially a constructor).

String literals must be preceded by an `@` sign. This is required for
backwards compatability with C (all C code is valid ObjectiveC
code... ObjectiveC is a superset of C).

`NSLog` is essentially `puts`. It's a global C method so is available anywhere.

Here is the same `Person` class and usage, but in Ruby.

```ruby
class Person
  attr_accessor :firstName, :lastName

  def sayHello
    "Hello, #{@firstName} #{@lastName}"
  end
end
```

The usage should be pretty straight forward. It's important to
interalize the _mechancial_ aspect of converting ObjectiveC to
Ruby. Basically, you remove the `[]` and replace it with `.`. We'll
have more examples later.

```
person = Person.alloc.init
person.firstName = "Amir"
person.lastName = "Rajan"
NSLog(person.sayHello)
```

Also, in Ruby, you _can_ use `Person.alloc.init`, but `Person.new` is
also available to you and does the same thing.

## Method Anatomy ##

Generally speaking, all APIs in iOS use named parameters (and by
extension, most iOS developers follow suit with their own
classes). Here is an example how you would declare a method in ObjectiveC.

```objectivec
- (void)setDobWithMonth:(NSInteger)month
                withDay:(NSInteger)day
               withYear:(NSInteger)year {

}
```

This was really weird the first time I saw it too. So let's break down
the code above. First, the `-` sign preceeding the method name denotes
that this is an instance method (a `+` sign denotes that it's a class
method... more on that later). The next token `(void)` denotes the
return type.

Now for the fun part. The method name _includes_ the name of the first
parameter (usually the method name is seperated from the parameter
name using the word `With` as a delimeter). The `setDobWithMonth`,
`withDay`, `withYear` are the _public_ names or the parameters. This
is what users of the method will see when autocompletion pops up.

The tokens `month`, `day`, `year` are what the public names are bound
to _within_ the method body. This is crazy/weird I know. Take a moment
to internalize this. In short, a method's name includes its named
parameters, and each parameter has a outward facing name and an
internal binding.

Here is how you would call the method.

```
[person setDobWithMonth:1 withDay:1 withYear:2013];
```

If you were to tell a teammate to call this method you would say.

>Call the `setDobWithMonth:withDay:withYear` method.

Now that you understand the anatomy of a ObjectiveC function. Here is
how you would do exact same thing in Ruby.

```ruby
def setDobWithMonth(month,
  withDay: day,
  withYear: year)

end
```

And here is the invocation:

```
person.setDobWithMonth(1, withDay: 1, withYear: 2013)
```

Now, of course, you can nix the public names of the methods if you
wish, and simply have:


```ruby
def setDobWithMonth(month, day, year)

end

person.setDobWithMonth(1, 1, 2013)
```

But it's important to know how to call methods with named parameters,
because all iOS APIs are built that way.

## Blocks ##

There is a reason why
[Fucking Block Syntax](http://fuckingblocksyntax.com/) exists. It's
because it's terrifying. Let's break down the next piece of code,
which does an `POST (HTTP)`, passing a dictionary, to a url, and
providing a callback on success.

```objectivec
- (void)
   post:(NSDictionary *)objectToPost
  toUrl:(NSString *)toUrl
success:(void (^)(RKMappingResult *mappingResult))success { }
```

```
[client post: @{ @"firstName": @"Amir", @"lastName": @"Rajan" }
       toUrl: @"http://localhost/people"
     success:^(RKMappingResult *result) {
       //callback code here
     }];
```

```ruby
def post(objectToPost, toUrl: toUrl, success: success)

end

client post({ firstName: "Amir", lastName: "Rajan" },
  toUrl: "http://localhost/people",
  success: lambda { |result|
    #callback code here
  })
```

Quiz

```objectivec
_label.layer.backgroundColor = [UIColor whiteColor].CGColor;

[UIView animateWithDuration:2.0 animations:^{
  _label.layer.backgroundColor = [UIColor greenColor].CGColor;
} completion:NULL];
```

```ruby
@label.layer.backgroundColor = UIColor.whiteColor.CGColor

UIView.animateWithDuration(2.0, animations: lambda {
  @label.layer.backgroundColor = UIColor.greenColor.CGColor
}, completion: nil)
```

Mixins vs Categories

```objectivec
@interface UIView (UIViewExtensions)
- (void)animate:(double)duration block:(void (^)(void))block;
- (void)animate:(void (^)(void))block;
@end

@implementation UIView (UIViewExtensions)
- (void)animate:(void (^)(void))block {
  [self animate:0.5 block:block];
}

- (void)animate:(double)duration block:(void (^)(void))block {
  [UIView beginAnimations:NULL context:NULL];
  [UIView setAnimationDuration:duration];
  block();
  [UIView commitAnimations];
}
@end

[label setAlpha:0];
[label animate:1 block:^{ [label setAlpha:1]; }];
```

```ruby
class UIView
  def animate duration = 0.5, &block
    UIView.beginAnimations(nil, context:nil)
    UIView.setAnimationDuration(duration)
    instance_eval &block
    UIView.commitAnimations
  end
end

  def animate duration = 0.5, &block
    UIView.beginAnimations(nil, context:nil)
    UIView.setAnimationDuration(duration)
    instance_eval &block
    UIView.commitAnimations
  end
end

label.setAlpha 0
label.animate 1 { label.setAlpha 1 }
```

class macros

```ruby
class SnarlingBeastEvent < EncounterEvent
  title "a snarling beast"
  text "a snarling beast leaps out of the underbrush."
  damage 1

  def loot
    {
      fur: { min: 3, max: 7, chance: 1.0 }
    }
  end
end

class EncounterEvent
  def self.title title
    define_method("title") { title }
  end

  def self.text text
    define_method("text") { text }
  end

  def self.health health
    define_method("health") { health }
  end
end
```

```objectivec
@interface SnarlingBeastEvent : EncounterEvent
+ (id)initNew;
- (NSDictionary *)loot;
@end

@implementation SnarlingBeastEvent
+ (id)initNew {
  return [super initWithAttributes: @{
    @"health": [[NSNumber alloc]initWithInt: 1],
    @"title": @"a snarling beast",
    @"text": @"a snarling beast leaps out of the underbrush."
  }];
}

- (NSDictionary *)loot {
  return @{
    @"fur": @{
      @"min": [[NSNumber alloc]initWithDouble:3.0],
      @"max": [[NSNumber alloc]initWithDouble:7.0],
      @"chance": [[NSNumber alloc]initWithDouble:1.7]
    }
  };
}
@end

@interface EncounterEvent : NSObject
@property NSString *title;
@property NSString *text;
@property NSInteger health;
+ (id)initWithAttributes:(NSDictionary *)attributes;
@end

@implementation EncounterEvent
+ (id)initWithAttributes:(NSDictionary *)attributes {
  EncounterEvent *e = [[EncounterEvent alloc] init];
  e.title = [attributes valueForKey:@"title"];
  e.text = [attributes valueForKey:@"text"];
  NSNumber *num = [attributes valueForKey:@"health"];
  e.health = [num integerValue];
  return e;
}
@end
```


Java to Ruby

https://developer.android.com/training/articles/perf-tips.html#GettersSetters

```ruby
class Person
  attr_accessor :firstName, :lastName

  def sayHello
    "Hello, #{@firstName} #{@lastName}"
  end
end

person = Person.alloc.init
person.firstName = "Amir"
person.lastName = "Rajan"
NSLog(person.sayHello)
```

functions

http://stackoverflow.com/questions/1988016/named-parameter-idiom-in-java

```java
Color color = Android.Graphics.Color.argb(255, 0, 96.0, 255.0)
```

```ruby
color = Android::Graphics::Color.argb(255, 0, 96.0, 255.0)
```
