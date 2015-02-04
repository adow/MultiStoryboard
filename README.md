# 在一个项目中使用多个 Storyboard 

每当告诉一个 iOS 程序员可以使用 Storyboard 进行界面开发总能获得一致的反应：

* 显示器太小，Storyboard 占去太多的空间，要找到一个 ViewController 实在麻烦;
* Storyboard 文件太大，和 Xib 一样，产生的 xml 太臃肿;
* 多人开发简直就是噩梦，因为这个文件总是莫名其妙的更新，提交后合并时太痛苦；

只能说，使用 Storyboard 开发的体验已经得到了一些改善，Storyboard 和 Xib 产生的代码已经精简了很多，比如我现在开发的一个 App 中的 Storyboard，包含一个 UINavigationController, 6 个 ViewController，产生的代码大概在 600+ 行左右。而Storyboard 屏幕空间的问题只能通过买一台更大的显示器来解决了，唯一可以安慰的是，我们在一个项目中可以拆分出多个 Storyboard 来设计界面，这样在单个 Storyboard 中就不用包含太多的 ViewController，本文就是来讨论这个方法的实战。

## Storyboard 和  ViewController 

首先需要记住的一点是

> Storyboard 只是一种组织 ViewController 的工具，我们最终操作的还是 ViewController。

所以，一旦我们能获取到 Storyboard 中对应的 ViewController，我们就能和以前一样来操作。

在App启动时，默认的 Main.storyboard 会被载入并自定创建一个 UIStoryboard 实例。那如果我们的项目里有多个 Storyboard 文件时，我们该如何创建实例呢？其实也很简单

用 Storyboard 文件名来实例化一个 UIStoryboard  (文件名 First.storyboard):

	let story_first = UIStoryboard(name: "First", bundle: nil)
	
那如何获取 Storyboard 中的 ViewController？也很简单，在 Storybaord 上为每个 ViewController 设置一个 Storyboard ID, 然后通过 `instantiateViewControllerWithIdentifier:` 来获取 (UINavigationController 的 Storyboard ID 是 first-nav):

	let first_nav_viewcontroller = story_first.instantiateViewControllerWithIdentifier("first-nav") as UINavigationController

作为例子，我们来创建一个最经典的 UITabBarController App,包含两个 Tab 

第一个 Tab 包含了一个 UINavigationController，其中的第一个 ViewController(rootViewController) 是 FirstAViewConroller,点击按钮可以导航到下一个 FirstBViewController,在 FirstBViewController 可以调用最外层的Main.storyboard 中的一个segue 用来弹出 PopViewController;

第二个 Tab 没有 UINavigationController, 直接是一个 SecondAViewController, 有一个按钮来 Present Modal 方式打开到 SecnodBViewController;

还有一个不属于如何一个 Tab 的 PopViewController，因为有时我们需要在很多个地方都调用一个通用的弹出层（比如登录），把他放在 Main.storyboard 就可以不用在多个Storyboard文件中重复实现了。所以结构上是这样的：

	First(Tab) : UINavigationController(FirstAViewController) -> FirstBViewController -> PopViewController
	Second(Tab) : SecnondAViewController -> SecondBViewController
	

我们为Storyboard 中的每个 ViewController 设置了 Storyboard ID, 这样可以方便的在代码中引用到任意一个 controller。

我们现在将两个 Tab 对应的各个 ViewController 分散到两个 Storyboard 中，问题在于最外面的 Main.storyboard 没有引用到 First.storyboard 和 Second.storyboard, 因此也没有办法在 Storyboard 中设置对应的Tab的文字和 Icon.

解决办法有两个，如果非要在 Storyboard 中设置 Tab, 那可以在 Main.storyboard 中依旧引用链接两个 ViewController ，然后把 First.storyboard 和 Second.storyboard 中的 ViewController 通过代码添加到里面去 ( addChildViewController)。

这里用的另一种方法就是不管他Tab 在 Storyboard 中的设置了，我们通过代码来创建和引用tab 各自的 ViewController，同时设置他的 tabBarItem。

UITabBarController 中的 `viewCotnrollers` 包含了多个 ViewController 的数组，每个 tab 都对应了一个 开始的ViewController，所以我们只要得到ViewController 就可以为 Tab 手工设置 ViewController。看完上面的估计完全不知道我在说什么，所以按照下面的流程来做一下看看吧。

## 实践
### 创建项目

首先创建一个传统的 Xcode 项目，选择 `Tabbed Application`。

![init.png](http://7vihfk.com1.z0.glb.clouddn.com/init.png)

###  删除自动产生的ViewController

创建好项目时会自动创建两个 Tab 对应的ViewController, FirstViewController.swift和SecondViewController.swift。

![clean.png](http://7vihfk.com1.z0.glb.clouddn.com/clean.png)

删除这两个文件，同时把 Main.storyboard 中的这两个ViewController 也一起删除，这时 Storyboard 文件中只有一个空的 TabBarControler 了:

![start.png](http://7vihfk.com1.z0.glb.clouddn.com/start.png)

### 创建两个Storyboard文件

我们将两个 Tab 对应的 ViewController 及各自的导航流程分散到两个单独的 Storyboard 中去，这两个 Tab 分别叫 First 和 Second, 他们的 Storyboard 文件分别叫 First.storyboard 和 Second.storyboard。

#### First.storyboard 

First.storyboard 对应第一个 Tab, 他里面有一个 UINavigationController, 开始的是 FirstAViewController, 然后可以导航到 FirstBViewController。他的 Storyboard 是这样的: 

![first-storyboard.png](http://7vihfk.com1.z0.glb.clouddn.com/first-storyboard.png)

为了要在代码里引用到各个ViewController，需要设置好每个 Storyboard ID:

![storyboard-first-nav.png](http://7vihfk.com1.z0.glb.clouddn.com/storyboard-id-first-nav.png) 

同时我们为这两个ViewController 准备好代码文件，FirstAViewController.swift 和 FirstBViewController.swift。

![first-files.png](http://7vihfk.com1.z0.glb.clouddn.com/first-files.png)

#### Second.storyboard 

Second.storyboard 对应第二个 Tab, 开始是 SecondAViewController, 然后弹出到 SecondBViewController: 

![second-storyboard.png](http://7vihfk.com1.z0.glb.clouddn.com/second-storyboard.png)

同时他们的代码文件 SecondAViewController.swift 和  SecondBViewController.swift

![second-files.png](http://7vihfk.com1.z0.glb.clouddn.com/second-files.png)

### Tab 链接到两个 Storyboard

由于程序开始时的 Storyboard (也就是 Main.storyboard) 并没有引用到tab 各自的ViewController，同时 First.storyboard 和 Second.storyboard 也没有自动载入。

回想一下 UITabBarController 的 App 结构，他有一个 viewControllers 数组，包含了每个 Tab 对应的开始时的 ViewController。每个 ViewController 设置自己的 tabBarItem 属性就可以实现对应 Tab 的标签设置。

所以最简单的方式是代码里创建出两个 Tab 对应的 ViewController，然后设置他们的 tabBarItem 就可以了。

由于我们需要对这个 UITabBarController 进行编程，用来载入各个 ViewController。所以我们创建一个 MainViewController.swift

![create-main-viewcontroller.png](http://7vihfk.com1.z0.glb.clouddn.com/crate-main-viewcontroller.png)

然后在 MainViewController 中载入 First.storyboard 和 Second.storyboard。

	/// 获取两个Tab对应的 Storyboard
        let story_first = UIStoryboard(name: "First", bundle: nil)
        let story_second = UIStoryboard(name: "Second", bundle: nil)

分别获取开始的 ViewController

	/// 获取Tab 对应的第一个 ViewController
        let first_nav_viewcontroller = story_first.instantiateViewControllerWithIdentifier("first-nav") as UINavigationController
        let second_a_viewcontroller = story_second.instantiateViewControllerWithIdentifier("second-a") as SecondAViewController
        
设置 tabBarItem 内容:

	        /// 设置 tabBar 内容
        first_nav_viewcontroller.tabBarItem = UITabBarItem(title: "First", image: nil, tag: 0)
        second_a_viewcontroller.tabBarItem = UITabBarItem(title: "Second", image: nil, tag: 1)
        
把他们作为UITabBarController 中的各个 tab 对应的ViewController

	self.viewControllers = [first_nav_viewcontroller, second_a_viewcontroller]
	
### 回到 Main.storyboard

Main.storyboard 中还有一个通用的 PopViewController 弹出窗口。

![main-storyboard-pop.png](http://7vihfk.com1.z0.glb.clouddn.com/main-storyboard-pop.png)

他不属于任何一个 Tab 的流程，所以如果要在任何 ViewController 中想调用弹出这个 PopViewController 时，只需要找到最外层的 UITabBarController(也就是 MainViewController ) ，然后调用对应的 segue 就可以了。

比如要在 FirstBViewController 中弹出 PopViewController:

	let main_viewcontroller = self.parentViewController!.parentViewController! as MainViewController
	main_viewcontroller.showPop()

其实我觉得通过 NSNotificationCenter 发送通知来调用应该应该更方便。	

## Source

说了这么多，实在不知道该如何更清晰的描述，其实看下代码就明白很简单了: [https://github.com/adow/MultiStoryboard](https://github.com/adow/MultiStoryboard)
