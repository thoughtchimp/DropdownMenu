DropdownMenu
====================
Inspired by [Dribbble shot](https://dribbble.com/shots/2293621-Hamburger-Menu-Animation)

##Installation

###CocoaPods

The easiest way to get started is to use [CocoaPods](http://cocoapods.org/). Add the following line to your Podfile:

```ruby
platform :ios, '8.0'
use_frameworks!
# The following is a Library of Swift.
pod 'DropdownMenu'
```

Then, run the following command:

```ruby
pod install
```

You can set the following property. If you don't set the these property, default value is used.
68,40,73

```Swift
let menu =  menu = DropdownMenu(item1: item1, item2: item2, item3: item3, item4: item4, otherItems:  [item5,item4,item3,item2,item4,item3,item2,item4,item3,item2], forViewController: self)

menu.textColor = UIColor.blackColor()                        // Default is UIColor.orangeColor().
menu.menuBackgroundColor = UIColor.yellowColor()              // Default is UIColor(red:0.267, green:0.157, blue:0.286, alpha:1).
```

In the rest of the details, refer to DropdownMenuSample project.

## Licence

[MIT](https://github.com/thoughtchimp/DropdownMenu/blob/master/LICENSE)

## Author

[ThoughtChimp](https://github.com/thoughtchimp)
