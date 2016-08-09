ObjectiveC to Ruby

Class

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

Person *person = [[Person alloc] init];
person.firstName = @"Amir";
person.lastName = @"Rajan";
NSLog([person sayHello]);
```

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

Named functions

```objectivec
- (void)setDobWithMonth:(NSInteger)month
                withDay:(NSInteger)day
               withYear:(NSInteger)year {

}

[person setDobWithMonth:1 withDay:1 withYear:2013];
```

```ruby
def setDobWithMonth(month,
  withDay: day,
  withYear: year)

end

person.setDobWithMonth(1, withDay: 1, withYear: 2013)
```

Blocks

```objectivec
- (void)
   post:(NSDictionary *)objectToPost
  toUrl:(NSString *)toUrl
success:(void (^)(RKMappingResult *mappingResult))success { }

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
