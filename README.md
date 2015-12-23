![logo](https://github.com/DanisFabric/Infinity/blob/master/images/logo.png)

# Infinity

## 介绍

`Infinity`是为`UIScrollView`快速集成下拉刷新和上拉加载更多的框架。`Infinity`基于Swift2.1。`Infinity`设计核心就是易用性和灵活性。你只用通过一句代码就能集成下拉刷新功能；也能够完全自定义下拉刷新的动画。

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