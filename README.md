![logo](https://github.com/DanisFabric/Infinity/blob/master/images/logo.png)

# Infinity [中文教程](https://github.com/DanisFabric/Infinity/blob/master/README_CN.md)

## Introduction

`Infinity` is a simple to use library written in Swift2.1. there are some advantages: 

1. Flexibility: You  can write your animations.
2. Easy to use: One line code make UIScrollView support pull-to-refresh or infinity-scrolling


## Screens [More Sample Images](https://github.com/DanisFabric/Infinity/wiki/Screens)

![screen1](https://github.com/DanisFabric/Infinity/blob/master/images/add-default.gif)
![screen1](https://github.com/DanisFabric/Infinity/blob/master/images/bind-default.gif)

## Requirements

- iOS 8.0+
- Swift 2.0+

## Install

### CocoaPods

Add following to your `Podfile` and run `pod install`. 

```ruby
pod 'Infinity'
```

### Carthaga

Add the following code to your `Cartfile` and run `Carthage update`.

```ruby
github "DanisFabric/Infninity"
```

### Manual

1. Download the sample project
2. add the files in Infinity folder to your project


## Usage

Import `Infinity` 

```Swift
import Infinity
```

### Pull-To-Refresh

You need 2 steps to add pull-to-refresh to UIScrollView:

1. create animator which to show the progress of pull-to-refresh
2. add animator to your UIScrollView

```Swift
let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
self.tableView.addPullToRefresh(animator: animator, action: { [weak self] () -> Void in
	// ...
	self?.tableView?.endRefreshing()		//stop refreshing
})
```
Removing pull-to-refresh is also simple: 

```Swift
tableView.removePullToRefresh()
```
If you want to stop refreshing: 

```Swift
tableView.endRefreshing()
```
If you want to start refreshing programmatically:

```Swift
tableView.startRefreshing()
```

### Infinity-Scrolling

You need 2 steps to add infinite-scrolling to UIScrollView:

1. create animator to show the state of infinity-scroll:
2. add animator to your UIScrollView

```Swift
let animator = DefaultInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
self.tableView.addInfiniteScroll(animator: animator, action: { [weak self] () -> Void in	
	self?.tableView?.endInfiniteScrolling()
})
```
Remove infinite-scrolling:

```Swift
tableView.removeInfiniteScroll()
```
If you want to stop refreshing: 

```Swift
tableView.endInfiniteScrolling()
```
If you want to start infinity-scrolling programmatically: 

```Swift
tableView.beginInfiniteScrolling()
```

### Best Practice

#### When to add/remove Infinity

- `addPullToRefresh`/`addInfiniteScroll` in `viewDidLoad` of `UIViewController`
- `removePullToRefresh`/`removeInfiniteScroll` in `deinit` of `UIViewController`


```Swift
	override func viewDidLoad() {
        super.viewDidLoad()
        
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
	self.tableView.addPullToRefresh(animator: animator, action: { [weak self] () -> Void in
			self?.tableView?.endRefreshing()
		})
        
        let animator = DefaultInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		self.tableView.addInfiniteScroll(animator: animator, action: { [weak self] () -> Void in
			self?.tableView?.endInfiniteScrolling()
		})
    }

    deinit {
        self.tableView.removePullToRefresh()
        self.tableView.removeInfiniteScroll()
    }
```

### automaticallyAdjustsScrollViewInsets


`automaticallyAdjustsScrollViewInsets` property on UIViewController which is by default to true bother the `Infinity` control UIScrollView, so it will be automatically set to false when add pull-to-refresh. 

You need to adjsut the contentInset of UIScrollView by your self. `Infinity` offers some frequently used conentInset for you: 

```Swift
tableView.setInsetType(withTop: .NavigationBar, bottom: .None)
```

## Bind VS Add

Let's see the definition of add/bind operations: 

```Swift
// PullToRefresh
public func addPullToRefresh(height: CGFloat = 60.0, animator: CustomPullToRefreshAnimator, action:(()->Void)?) 
public func bindPullToRefresh(height: CGFloat = 60.0, toAnimator: CustomPullToRefreshAnimator, action:(()->Void)?) 

//InfinityScroll
public func addInfinityScroll(height: CGFloat = 80.0, animator: CustomInfinityScrollAnimator, action: (() -> Void)?) 
public func bindInfinityScroll(height: CGFloat = 80.0, toAnimator: CustomInfinityScrollAnimator, action: (() -> Void)?) 
```

The parameters of bind operation is the same as parameters of add operation, following is the differences: 

- add operation will add animator to UIScrollView as a subview
- bind operation don't do anything to animator, the animator just receive messages from pull-to-refresh/infinity-scrolling. It means you can bind any object to pull-to-refresh/infinity-scrolling, and you can control that object completely.

## Custom Animator

You just need to confirm one of following protocols to create your animator whose all behavior is under your control. 

```Swift
public protocol CustomPullToRefreshAnimator {
    func animateState(state: PullToRefreshState)
}
```

```
public protocol CustomInfinityScrollAnimator {
    func animateState(state: InfinityScrollState)
}
```
Let's create a most simple Animator which onlu has a label to show the state of pull-to-refresh. 

```Swift
class TextAnimator: UIView, CustomPullToRefreshAnimator {
    var textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel.frame = self.bounds
        self.addSubview(textLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func animateState(state: PullToRefreshState) {
        switch state {
        case .None:
            textLabel.text = "Pull Me To Refresh"
        case .Releasing(let progress):
            textLabel.text = String(progress)
        case .Loading:
            textLabel.text = "Loading ......."
        }
    }
}
// add TextAniamtor to UIScrollView
let animator = TextAnimator(frame: CGRect(x: 0, y: 0, width: 200, height: 24))
self.tableView.addPullToRefresh(animator: animator, action: { () -> Void in
	// ...
	self.tableView?.endRefreshing()
})

```


## Others

### supportSpringBounces

A bool value of UIScrollView to support spring effect

```Swift 
tableView.supportSpringBounces = true
```

### Contact

I'd be happy if you sent me links to your apps where you use `Infinity`. If you have any questions or suggestion, send me an email to let me know. 

Email : [DanisFabric](danisfabric@gmail.com)

### License

```
The MIT License (MIT)

Copyright © 2015 DanisFabric

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```