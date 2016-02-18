# SwViewCapture

A nice iOS View Capture Library which can capture all content.

一个用起来还不错的iOS截图库.(支持截取所有内容, 适用于所有ScrollView组成的视图, 包括WebView)

 <img src="https://raw.githubusercontent.com/startry/SwViewCapture/master/capture_demo.gif" width = "320" alt="Example" align=center />

## Feature

1. API is more easy to use.
	* use swift extension
2. Support to capture all content of scrollView. 
	* eg: UIScrollView, UITableView, UIWebView
3. Support capture WKWebView. 
	* WKWebview is hard to capture; 
	* Screenshots of WKWebview's content isn't good now
4. Flasing will not appear in the process of Screenshots.
	* SwCaptureView use a fake screenshots as a cover which over target view. All the action of target will be hidden below the fake screenshots.

###功能

1. API更容易使用.
	* 使用Extension去封装API

2. 支持截取滚动视图内的所有内容.
	* 支持UIScrollView, UITableView, UIWebView

3. 支持截取WKWebView的内容.
	* 因为WKWebView的内部实现问题, WKWebView比较难去截屏
	* 目前SwViewCapture对WKWebView的截屏也不完美, 还存在一些瑕疵, 尤其表现在*CSS*样式为`dispaly: absolute;`的元素上。
   
4. 截图过程中不会出现视图闪烁.
	* 截图过程中, 使用一张伪装截图遮盖屏幕, 底层截图活动不透明化。

## Usage

1. Capture basic screenshots (size of view's frame)

``` Swift
import SwViewCapture
// ...
view.swCapture { (capturedImage) -> Void in
	// capturedImage is a UIImage.           
}
```

2. Capture all content screenshots (size of content)

``` Swift
import SwViewCapture
// ...
view.swContentCapture { (capturedImage) -> Void in
	// capturedImage is a UIImage.           
}
```

###用法

1. 普通截屏(屏幕大小)

``` Swift
import SwViewCapture
// ...
view.swCapture { (capturedImage) -> Void in
	// capturedImage is a UIImage.           
}
```

2. 内容截屏(全部内容的大小)

``` Swift
import SwViewCapture
// ...
view.swContentCapture { (capturedImage) -> Void in
	// capturedImage is a UIImage.           
}
```

## Requirement

iOS 8.0+

<!--## Installation
 
 SwViewCapture is available through [CocoaPods](http://cocoapods.org). To install
 it, simply add the following line to your Podfile:
 
 ```ruby
 pod "SwViewCapture"
 ```
-->

SwViewCapture isn't available through [CocoaPods](http://cocoapods.org) now. To Install it, simply and the following line to your Podfile:

``` ruby
pod "SwViewCapture", :git => "https://github.com/startry/SwViewCapture.git"
```

## License

SwViewCapture is available under the MIT license. See the LICENSE file for more info.