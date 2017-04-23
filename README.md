我们在开发iOS App过程中常会有这样的需求，就是每隔一段时间内做一些类似刷新数据的操作。比如股票行情软件，需要每隔几秒更新股指、股票价格。这样的定时事件可能有很多种，发生事件的间隔都各不相同。我们可以实现一个全局的事件发生器，统一管理这些定时事件，简化操作。[IFTimer](https://github.com/doublefishes/IFTimer)类就是为此目的而来。

## IFTimer的功能
1. 添加、删除定时事件
2. 添加、删除接收事件的对象
3. 开始、停止事件发生器
4. 设置事件发生器的灵敏度

## IFTimer的原理
1. 利用NSTimer作为事件的发生器
2. 利用NSNotificationCenter作为事件的注册和通知

## 示例代码讲解
![sample](http://note.youdao.com/yws/api/personal/file/WEB0a24dd84371f844c0cd339569b1b1bb4?method=download&shareKey=d192e6385cc5be0492f9a64b610fbd8a)
1. 创建IFTimer实例并初始化定时事件。在一个App里，你只需要创建一个实例即可。

```
[_timer addEvent:EVT_NAME1 interval:[NSNumber numberWithFloat:1.0]];
[_timer addEvent:EVT_NAME2 interval:[NSNumber numberWithFloat:5.0]];
[_timer addEvent:EVT_NAME3 interval:[NSNumber numberWithFloat:10.0]];
```
这里添加了三个事件，分别间隔1秒、5秒、10秒发生一次。

2. 注册需要监听这些事件的对象

```
[IFTimer addObserver:self selector:@selector(updateEvt1:) evtName:EVT_NAME1];
[IFTimer addObserver:self selector:@selector(updateEvt2:) evtName:EVT_NAME2];
[IFTimer addObserver:self selector:@selector(updateEvt3:) evtName:EVT_NAME3];

```
每个事件名对应一个响应的函数。

3. 启动事件发生器

```
[_timer start];
```

4. 处理事件响应函数

```
- (void)updateEvt1:(NSNotification*)sender
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self._evtCount1++;
        [_lable1 setText:[NSString stringWithFormat:@"%@ comes, count %ld", EVT_NAME1, self._evtCount1]];
    }];
}
```
5. 不需要再监听事件时，可以移除事件监听

```
[IFTimer removeObserver:self evtName:EVT_NAME1];
[IFTimer removeObserver:self evtName:EVT_NAME2];
[IFTimer removeObserver:self evtName:EVT_NAME3];
```

## 其他
IFTimer是100毫秒检查一次定时事件是否已到，你可以通过下面的接口调整这个事件，可以加快或减慢检查的频率

```
- (void)setActiveInterval:(NSTimeInterval)interval;
```
代码已放到GitHub，[点击下载](https://github.com/doublefishes/IFTimer/archive/master.zip)。如有帮助，请多点赞。
