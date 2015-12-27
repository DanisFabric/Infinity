![logo](https://github.com/DanisFabric/Infinity/blob/master/images/logo.png)

# 如何使用Swift的下拉刷新库Infinity

## Infinity 基本介绍
`Infinity`是基于Swift2.1的为UIScrollView快速集成下拉刷新和上拉加载更多的开源库。`Infinity`有以下几个优点：

1. 灵活性：完全支持自定义交互动画
2. 易用性：一句代码集成/移除 下拉刷新功能
3. 低伤害性：对`UIScrollView`的行为不造成影响，让你放心使用`UIScrollView`相关功能。

## 运行效果图

![screen1](https://github.com/DanisFabric/Infinity/blob/master/images/add-default.gif)
![screen1](https://github.com/DanisFabric/Infinity/blob/master/images/add-arrow.gif)
![screen1](https://github.com/DanisFabric/Infinity/blob/master/images/add-gif.gif)
![screen1](https://github.com/DanisFabric/Infinity/blob/master/images/bind-default.gif)
![screen1](https://github.com/DanisFabric/Infinity/blob/master/images/bind-arrow.gif)

## 集成Infinity

### Carthaga

将下面代码添加到你的Cartfile里面

```ruby
github "DanisFabric/Infninity"
```

### 手动添加

1. 下载工程文件
2. 将Infinity文件夹添加到你的工程里就OK了


## Infinity 使用方法

### 集成/移除-下拉刷新(PullToRefresh)

集成的过程分为两步：

1. 为下拉刷新操作指定动画(Infinity提供了基本的刷新动画)
2. 设置触发后的回调闭包

```
let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
self.tableView.addPullToRefresh(animator: animator, action: { () -> Void in
	// 耗时操作（数据库读取，网络读取）
	self.tableView?.endRefreshing()
})
```
移除只需一句代码：
```
self.tableView.removePullToRefresh()
```

### 集成/移除-上拉加载更多(InfinityScroll)

集成过程与下拉刷新完全相同，代码如下：

```
let animator = DefaultInfinityAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
self.tableView.addInfinityScroll(animator: animator, action: { () -> Void in	
	// 耗时操作（数据库读取，网络读取）
	self.tableView?.endInfinityScrolling()
})
```
移除也只需一句代码
：
```
self.tableView.removeInfinityScroll()
```
### 好的使用范式

#### 何时集成/移除组件

必须在`UIViewController`释放之前，将`PullToRefresh`和`InfinityScroll`都移除掉。所以需要按以下方式来调用

- 在`UIViewController`的`viewDidLoad`方法里集成组件(推荐)
- 在`UIViewController`的`deinit`里移除组件(必须)

```
	override func viewDidLoad() {
        super.viewDidLoad()
        
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
	self.tableView.addPullToRefresh(animator: animator, action: { () -> Void in
			// 耗时操作（数据库读取，网络读取）
			self.tableView?.endRefreshing()
		})
        
        let animator = DefaultInfinityAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		self.tableView.addInfinityScroll(animator: animator, action: { () -> Void in	
			// 耗时操作（数据库读取，网络读取）
			self.tableView?.endInfinityScrolling()
		})
    }

    deinit {
        self.tableView.removePullToRefresh()
        self.tableView.removeInfinityScroll()
    }
```

### automaticallyAdjustsScrollViewInsets

`UIViewController`有`automaticallyAdjustsScrollViewInsets`属性，当其为true时，viewController内的`UIScrollView`的contentInset会被自动调整为合适的值（自动调整的依据为`UIViewController`是否包含于`UINavigationController`和`UITabBarController`中）。这种自动调整会为下拉刷新带来一些意想不到的BUG。[PullToRefresh](https://github.com/Yalantis/PullToRefresh)等被使用较多的第三方库会出现进入新的viewController后回弹失效的问题。

`Infinity`为了彻底解决这个问题以及让用户能够清楚地知晓其scrollView的contentInset值。所以默认将`automaticallyAdjustsScrollViewInsets`设置为false，转而推荐用护直接设置contentInset，并提供了基本的contentInset的值。

```
self.tableView.contentInset = InfinityContentInset.NavigationBar
```
InfinityContentInset有以下几个：

|type|ps|
|---|---|
|None|不留出inset空间|
|NavigationBar|留出顶部导航栏空间|
|TabBar|留出底部标签栏空间|
|NavigationBarTabBar|同时留出导航栏和标签栏空间|
|StatusBar|留出顶部状态栏空间|
|StatusBarTabBar|同时留出状态栏和标签栏空间|

## 绑定 VS 集成

下面代码是add和bind方法的定义，由定义可以看出，bind和add操作的参数是完全相同的。而实际上，add和bind操作唯一的区别就是：

- add操作会将animator作为UIView添加到`UIScrollView`上。
- bind操作不会对animator做任何事，只负责将下拉刷新/加载更多 的信息发给animator

```
// PullToRefresh
public func addPullToRefresh(height: CGFloat = 60.0, animator: CustomPullToRefreshAnimator, action:(()->Void)?) 
public func bindPullToRefresh(height: CGFloat = 60.0, toAnimator: CustomPullToRefreshAnimator, action:(()->Void)?) 

//InfinityScroll
public func addInfinityScroll(height: CGFloat = 80.0, animator: CustomInfinityScrollAnimator, action: (() -> Void)?) 
public func bindInfinityScroll(height: CGFloat = 80.0, toAnimator: CustomInfinityScrollAnimator, action: (() -> Void)?) 
```

bind操作提供了更多的灵活性。可以在示例项目里查看具体效果。

## 自定义动画

`Infinity`的动画是面向协议的：

```
public protocol CustomPullToRefreshAnimator {
    func animateState(state: PullToRefreshState)
}
```

```
public protocol CustomInfinityScrollAnimator {
    func animateState(state: InfinityScrollState)
}
```
你唯一要做的，就是实现对应的协议的animateState方法。根据具体的state来做动画就可以了。

下面来实现一个具体的animator看看动画实现多么简单：

```
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
// 在UIViewController的viewDidLoad使用TextAnimator
let animator = TextAnimator(frame: CGRect(x: 0, y: 0, width: 200, height: 24))
self.tableView.addPullToRefresh(animator: animator, action: { () -> Void in
	// 耗时操作（数据库读取，网络读取）
	self.tableView?.endRefreshing()
})

```
是不是很简单啊^_^。而因为bind操作的存在，你甚至能够用任意类型来做animator，不一定要继承UIView。

## 其他

### supportSpringBounces

- true: scrollView的回弹有弹簧特效
- false: scrollView回弹去掉弹簧特效

```
self.tableView.supportSpringBounces = true
```

### infinityStickToContent

- true: 底部`footer`忽略contentInset.bottom距离，而直接紧跟在UIScrollView的content后面
- false: 底部`footer`留出contentInset.bottom的距离。
- 默认为true, 一般情况下使用默认就OK了。

### 联系方式

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