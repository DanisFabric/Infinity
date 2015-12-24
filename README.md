![logo](https://github.com/DanisFabric/Infinity/blob/master/images/logo.png)

# Infinity

## 运行图片

## 介绍

`Infinity`是一个为`UIScrollView`快速集成下拉刷新和上拉加载更多功能的框架。`Infinity`设计的核心是易用性、灵活性以及非入侵性。

- 易用性：内置基本的刷新组件，能够通过一句代码快速集成和移除`Infinity`
- 灵活性：动画组建的设计是面向协议的，只需要实现协议就能够轻松自定义动画。
- 非入侵性：不对原生的`UIScrollView`相关功能造成影响，让你不需要在集成后，担心对其他功能的影响

## 集成

### Carthaga

将下面代码添加到你的cartfile里面

```
github "DanisFabric/Infninity"
```

### 手动添加

下载工程文件，然后将Infinity文件夹里所有的Swift文件添加到你的项目里就OK了。

## 使用

需要导入框架

```
import Infinity
```

### 下拉刷新

集成下拉刷新

```
let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
tableView.addPullToRefresh(animator: animator, action: { () -> Void 
	// ... 异步操作，在回调中调用下一句代码
	//self.tableView?.endRefreshing()
})
```
移除下拉刷新

```
tableView.removePullToRefresh()
```

### 上拉加载更多

集成上拉加载更多

```
let animator = DefaultInfinityAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
tableView.addInfinityScroll(animator: animator, action: { () -> Void in
	// ... 异步操作，在回调中调用下一句代码
	self.tableView?.endInfinityScrolling()
})
```

移除上拉加载更多

```
tableView.removeInfinityScroll()
```

### 绑定