![logo](https://github.com/DanisFabric/Infinity/blob/master/images/logo.png)

# Infinity

## 介绍

`Infinity`是一个为`UIScrollView`快速集成`下拉刷新`和`上拉加载更多`的框架。`Infinity`设计的核心是易用性、灵活性以及非入侵性。

- 易用性：内置基本的刷新组件，能够通过一句代码快速集成和移除`Infinity`
- 灵活性：动画组件的设计是面向协议的，只需要实现协议就能够轻松自定义动画。
- 非入侵性：不对原生的`UIScrollView`相关功能造成影响，集成后没有后顾之忧。

## 运行图片

![screen1](https://github.com/DanisFabric/Infinity/blob/master/images/add-default.gif)
![screen1](https://github.com/DanisFabric/Infinity/blob/master/images/add-arrow.gif)
![screen1](https://github.com/DanisFabric/Infinity/blob/master/images/add-gif.gif)
![screen1](https://github.com/DanisFabric/Infinity/blob/master/images/bind-default.gif)
![screen1](https://github.com/DanisFabric/Infinity/blob/master/images/bind-arrow.gif)

## 集成

### Carthaga

将下面代码添加到你的Cartfile里面

```ruby
github "DanisFabric/Infninity"
```

### 手动添加

1. 下载工程文件
2. 将Infinity文件夹添加到你的工程里就OK了

## 如何使用

导入框架

```
import Infinity
```

### 下拉刷新

集成下拉刷新

```swift
let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
tableView.addPullToRefresh(animator: animator, action: { () -> Void 
	// ... 异步操作，在回调中调用下一句代码
	//self.tableView?.endRefreshing()
})
```
移除下拉刷新

```swift
tableView.removePullToRefresh()
```

### 上拉加载更多

集成上拉加载更多

```swift
let animator = DefaultInfinityAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
tableView.addInfinityScroll(animator: animator, action: { () -> Void in
	// ... 异步操作，在回调中调用下一句代码
	self.tableView?.endInfinityScrolling()
})
```

移除上拉加载更多

```swift
tableView.removeInfinityScroll()
```

### 备注

#### 注意事项

`Infinity`将`UIViewController`的`automaticallyAdjustsScrollViewInsets`属性给直接设置为false，转而采用更为清晰的方式来进行Insets的设置。

> 最佳实践：
> 不用管automaticallyAdjustsScrollViewInsets，或者将其设置为false。
> 自己设定UIScrollView的contentInset的值

为了更便捷的设置`contentInset`，`Infinity`提供了以下的方法：

```swift
self.tableView.contentInset = InfinityContentInset.NavigationBar // 表示顶部空出导航栏的高度
// 	InfinityContentInset分别有三个属性 
//	NavigationBar			顶部空出NavigationBar的高度
//	TabBar					底部空出TabBar高度
//	NavigationBarTabBar		同时空出NavigationBar和TabBar高度
```

#### 其他属性

##### supportSpringBounces

是否为UIScrollView的回弹添加弹簧效果

##### infinityStickToContent

底部`加载更多控件`是否需要留出contentInset.bottom的间隔
如果为true，不留出间隔；为false，则留出间隔

### 内置动画

`Infinity`内置了基本的刷新动画，其中包括：

1. DefaultRefreshAnimator & DefaultInfinityAnimator: 默认的最简单的视图
2. NormalRefreshAnimator & NormalInfinityAnimator: 箭头+文字的视图 // 还未做好
3. GIFRefreshAnimator & GIFInfinityAnimator: 播放图片序列的视图

另外，我会在工程里面添加各种有趣好玩的刷新动画，但是我并不打算将其添加到`Infinity`库里，如果你感兴趣的话，把中意的动画文件直接拖到你的工程里用就OK了。

### 自定义动画

`Infinity`除了内置动画，你还能够定义自己的动画。动画的实现是依赖于协议：

```swift
public protocol CustomPullToRefreshAnimator {
    func animateState(state: PullToRefreshState)
}
```

```swift
public protocol CustomInfinityScrollAnimator {
    func animateState(state: InfinityScrollState)
}
```
你的类根据自己需要选择实现这两个协议之一。然后通过animateState方法，你就可以自定义动画了。

```swift
    public func animateState(state: PullToRefreshState) {
        switch state {
        case .None:
            stopAnimating() 
        case .Releasing(let progress):
            updateForProgress(progress) // progress 0->1 之间
        case .Loading:
            startAnimating()
        }
    }
```

### 绑定Animator

`Infinity`独特的设计在于绑定Animator，这里的animator特指实现了`CustomPullToRefreshAnimator`或`CustomInfinityScrollAnimator`协议的对象。
通过绑定，`Ininity`不会将你的animator添加到`UIScrollView`中。它只会响应刷新动作，然后给你的animator发送状态信息。

最开始的运行截图的后两张图片就是通过绑定操作，将作为`UIBarButtonItem`的animator绑定到了`Infinity`。

绑定操作的流程和集成操作基本相同：

```swift
let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: animator)
tableView.bindPullToRefresh(animator: animator, action: { () -> Void 
	// ... 异步操作，在回调中调用下一句代码
	//self.tableView?.endRefreshing()
})
```

因为这种设计，我们的animator可以是任意对象，最简单的就是一个Object，然后打印状态出来看看：

```swift
class PrintAnimator: CustomPullToRefreshAnimator {
    func animateState(state: PullToRefreshState) {
        print(state)
    }
}
// ...
let animator = PrintAnimator()
tableView.bindPullToRefresh(animator: animator, action: { () -> Void 
	// ... 异步操作，在回调中调用下一句代码
	//self.tableView?.endRefreshing()
})
```
就这么简单，你就自定义出了一个完整的Animator了，并且能够在控制台看到状态变化的输出。

## TODO 

继续补充刷新控件

## Contact

Email: [DanisFabirc](danisfabric@gmail.com)

# License

The MIT License (MIT)

Copyright (c) 2015 inspace.io

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

