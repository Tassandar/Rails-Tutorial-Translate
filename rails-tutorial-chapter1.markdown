
开始翻译 [Ruby on Rails Tutorial](http://ruby.railstutorial.org/) 转载请注明出处与原作者 [Michael Hartl](http://ruby.railstutorial.org/) 

欢迎来到跟我实例学 [Ruby on Rails](http://ruby.railstutorial.org/)教程. 这本书的目的是要成为“我如何开始做Ruby on Rails ？”的最佳答案。当你完成这个ror教程之后你将学会与开发部署你自己的网页.

你可以在这里获取许多相关的资源例如书，博客，视频，另外，自从ruby on rails 教程使用了rails3，你也将会在这里学到全套的最新最强大的rails 3版本。

ruby on rails教程与许多别的rails教程书一样，通过构建许多小的简易程序来学习web开发。
与[Derek Sivers](http://sivers.org/)在前面提到的一样。这本书的构架会和一篇平铺的小故事一样，期望读者们能从头一篇篇的看到尾。如果你习惯跳跃性的阅读技术书记，你可能需要用一些不同的方法来读这篇教程，下面的这个引导段落可能对你有所帮助。你可以把**ruby on rails 教程**当作一个电子游戏，把你自己当成游戏的主角，然后在这篇教材中快乐的打怪升级。。。（这些练习都是小boss … ^_^ ）

在第一章，我们将会从安装ruby on rails的必须程序开始，同时设定我们的开发环境，之后我们会创建我们的第一个rails工程，我们会把它用上GIT版本控制。之后不管你们信不信，在这章我们就直接把它部署到网上去。

在第二章，我们将会制作第二个工程，做它的目的是为了展示rails的应用的基础特性。为了快速开发部署，我们建立了了<code>demo app</code>(名字是 demo_app）使用scaffolding脚手架来生成代码，——生成的代码又丑又复杂，第二章主要会关注它如何通过URLs和浏览器来浏览网页。

在第三章，我们将会创建一个 sample application (名叫sample_app),这次的代码将会全部用scratch的方法生成。我们将会开发那个例程通过使用 驱动驱动开发（TDD **test-driven-development**）从第三章开始我们将会创建一个静态的页面，然后我们再加入一些动态的内容。我们将会在第四章走开一会，来关注一下rails底下Ruby语言特性。然后在第五章到第十章我们将会通过使用网页布局，用户数据库，全方位的注册和认证系统来完整的建立这个实例程序。最后在第十一章和第十二章我们将会加入微博和社会化特性来完成这个实例站点。

最后这个实例程序将会与一个实实在在的流行的微博社交网站(twitter)十分相似，巧合的事，twitter也是用rails开发的。虽然我们一直在关注的是这个实实在在的示例站点，但是关键的是我们通过ruby on rails 教程将会学到许多通用的法则，这将会让你不管开发什么网站都一个扎实的基础。
<!--more-->
> #### BOX1.1 scaffolding，一个快速，简洁诱人的脚手架
从一开始，rails就从这样明显的可操作性中受益良多。不管是rails创始人avid Heinemeier Hansson著名的[15分钟开发一个博客系统](http://media.rubyonrails.org/video/rails_take2_with_sound.mov)，还是后来升级之后的[15分钟搭建博客系统by rails 2](http://media.rubyonrails.org/video/rails_blog_2.mov)这些时评都是非常棒的办法去体会rails的强大，同时我也推荐你们去看看这些视频。但是我要警告你们：他们在15分钟奇迹般的完成这份工作使用一个叫做scaffolding脚手架的功能，它将迅速生成大量代码，用的是<code> rails generate </code>命令。
然后回到我们的ruby on rails教程，如果我们在教程中过度依赖这个方法——虽然更快更简便更诱人，但是大量复杂而且固定的代码将会成为rails开发初学者不可逾越的障碍，你或许能够使用这个特性，但是但是你或许永远都不会明白它。
在ruby on rails 教程，我们将会使用几乎完全不同的方法。第二章我们将会用脚手架开发一个小的DEMO程序，但是本教程的核心仍然是第三章开始的sample app上。在每章开发sample app的过程中，我们都会生成一些短小的代码，这些代码能够让你更好的理解rails，你同样也能把它当作是一组挑战。这样循序渐进的方法能够给你一个rails学习的好环境让你更深刻，灵活的掌握rails。


### 1.1介绍

自从ruby on rails 在2004年一鸣惊人之后迅速成为了最强大而流行的动态网络框架。rails帮助那些小用户迅速成长为了大型的公司，包括[Posterous](http://posterous.com/), [UserVoice](http://uservoice.com/), [37signals](http://shopify.com/), [Shopify](http://shopify.com/), [GitHub](http://github.com/), [Scribd](http://scribd.com/), [Hulu](http://hulu.com/), [the Yellow Pages](http://yellowpages.com/).
世界同样还有许多web开发网店精通于rails，例如[ENTP](http://entp.com/), [thoughtbot](http://thoughtbot.com/), [Pivotal Labs](http://pivotallabs.com/), 和 [Hashrocket](http://hashrocket.com/),当然还有无数的独立开发者，培训师，顾问，承包商也是如此。

是什么让rails变得那么的强大？首先，ruby on rails是100%开源的，基于[MIT 认证](http://www.opensource.org/licenses/mit-license.php),对于任何人都是完全免费下载使用的。rails的成功也归功与它优雅而紧密的设计，在其底层的ruby语言同样让人感到惊叹不已。rails为网站开发有效的创建了一个全新的[专属语言（domain-specific language）](http://en.wikipedia.org/wiki/Domain_Specific_Language)。许多常见的网络开发任务，例如生成HTML，使用数据库模型，生成网址路由，对于rails都是轻而易举的。更重要的是，最终的rails应用程序总是简洁而可读性强。

rails同样适用于一个全新的网络框架与技术新手。举例来说，rails是第一个完整的使用digest实现REST网站构架的应用程序（我们很快就会在这篇教材里面学到了。）并且当其他框架拥有了新的功能的时候rails的开发者David Heinemeier Hansson和rails的核心小组绝不会对加入那些诱人的idea有任何的由于。其中最戏剧性的就是rails 和Merb的合并，（merb是另一个ruby网络框架）这样rails就拥有了merb中引入的更强大的模块设计，稳定的api和更佳的特性。

最后，rails也从不同的社区中受益良多，其中包括了成百个开源的作者，热闹的讨论组，大量的插件和gems（包括了对某些特定问题的解决方案例如图片上传和分页设计），丰富多彩的博客和rails论坛和irc频道。大量的rails编程人员也在让解决那些应用程式问题变得更佳简单：“Google the error message”几乎总是能把你带到你最需要的那篇博客或者论坛上去。

#### 对不同读者的建议

这个rails教程不但包括了rails，还有ruby，html，css以及一些javascript，甚至还有一点点的SQL。这意味着，不管你现在掌握了多少关于网络开发的知识，在你完成本教程之后你还是又必要阅读更多更高级的rails资源的，这样才能帮助你完成一个完整的网络开发知识体系。

rails 很多时候会有一些看起来如同“魔法”一般的特性（例如直接就能够建立数据库表单项目）来完成一个一个的奇迹，但是实际上rails的构造更佳的神秘，这个ruby on rails教程并不准备具体戒指这些“魔法”——主要是作为一个rails开发者你并不需要彻底明白在这一层华丽的外边后面的工作机制（就如同ruby绝大部分使用C语言设计的，但是你没必要去研究ruby的源代码来使用ruby一样）。如果你是一个打破砂锅问到底的人。那么我建议你去读读Obie Fernandez写的The Rails 3 Way，你可以把它收藏起来，在学习这个教程的统一读一读。

虽然本教程没有什么先决条件，但是你至少也应该有一些计算机经验。如果你连文本编辑器的使用经验都没有，那么恐怕你要学起来就会非常的困难。另一方面，即使你的 <code>.emacs</code>文件复杂到成年人都想哭的地步的话这篇教材同样会有让你感到挑战的东西的。rails教程被设计成一个无论你的背景是什么都能够通过你自己独特的方法学到很多东西的东西。

**对于所有读者**：学习rails最常见的一个问题就是是否应该先去学ruby语言。这个答案取决与你的个人学习习惯。如果你通常会系统的去学习一个东西的话，那么从ruby学起应该会是很好的选择。这章里会有几本相当不错的书推荐给你看。另一方面，许多rails开发者都对制作网络应用相当感兴趣，同时他们不想在制作出一个web应用之前阅读500页的ruby手册。而且rails开发者所关注的知识恐怕你在纯粹的ruby书中是找不到的——但是在本教程中你能够轻松获取。我建议你从这个rails教程开始，然后去阅读纯粹的ruby语言书。我觉得这个并不是二选一的事情，而是——如果你上手了rails开发并且感觉你需要一些ruby的知识，，那么，你可以停下来看看ruby编程书，然后在你觉得OK了的时候重新上路。你可能会想通过网络中简短的教程尝试一下ruby编程。你可以在(http://www.ruby-lang.org/) 或者 (http://rubylearning.com/)找到你想要的。

另外一个常见的问题是如何去运用测试。如果我在简介中提到的，rails教程使用了测试驱动的开发模式。
在我的观点里，这是最好的学习rails应用的方法。但是测试的确让你付出大量的时间。如果你发现发现你被这些测试程序困住了，那么你可以考虑在你第一次阅读这本书的时候跳过它。事实上，许多的读者将会教程中穿插着各种——测试，版本控制，部署——会让你刚开始让你有点喘不过气。如果你发现你为他们感到十分的烦躁，那么你应该毫不犹豫的放弃它，虽然我只加入了专业开发者最最精华的部件，但是对于你来说能够完成rails教程的核心代码才是最重要的 。

**对于非设计师的新手开发人员**：rails教程并不假设你有任何的计算机背景，但是如果你又一些计算机语言的学习经验你会更快的上手。请时刻记住，这只是你在web开发学习中的第一步，web开发还有许多诱人的部分，包括HTML/CSS，javascript，数据库（包括sql），版本控制和部署。这本书将会介绍关于他们的一点，但是你要走的路还很长。

**对于新手的网页设计师**：你的设计技能对学习rails帮助很大。因为你基本上了解了HTML和CSS/在完成这本书之后你将会成为一个更佳成功的设计师，并且你就拥有了独自开发网站的资本。你可能发现了编程方面的困难，但是ruby开发语言对于新手来说是非常非常友好的，尤其是那些神奇的单复数～

在完成这个ruby on rails教程之后，我建议编程新手阅读《[Beginning Ruby](Beginning Ruby)
》by Peter Cooper.这书基本和本教材保持了一致的结构。我同样建议你阅读[The Ruby Way ](http://www.amazon.com/gp/product/0672328844/ref=as_li_ss_tl?ie=UTF8&tag=httpwwwrailst-20&linkCode=as2&camp=217145&creative=399369&creativeASIN=0672328844)
最后作为一个资深的rails开发者我觉得你还应该阅读 《The Rails 3 Way》 by Obie Fernandez.

**对于网络开发来说**，即使是一个看起来简单的小应用也会做起来很复杂。如果你确实对于web编程感到头疼并却感觉这个教材是那么的无法逾越。那么恐怕你还没又做好网站制作的准备。你最好多学学HTML和CSS然后在开始这个教程。（不好意思，我并没有什么关于HTML的个人推荐，但是《Head First HTML》貌似值得一学，关于CSS你可以尝试：《CSS ：THE MISS MANUAL》by David Sawyer McFarland）。我也推荐你先去阅读一下《Beginning Ruby》的前几章，那些短小的程序可以让你迅速找到感觉。

**对于web开发新手但是经验丰富的编程人员**：你的经验可能已经帮助你明白了像：类，方法，数据结构的概念。这是你的优势。另外如果你原先用的是C++或者java，你可能发现Ruby a bit of an odd duck(估计是有点讨厌的意思。。。)。你可能需要一些时间来适应它。常用ruby，你将会适应并且喜欢上它的。（Ruby 甚至同意让你在句末加上分号。。。）Rails Tutorial 包含了所有的web专有概念，所以如果你不懂**PUT**和**POST**你可以完全不用担心。

**对于有经验的ruby程序员**：作为一个ruby程序员你不会rails实在是太不正常了，但是如果你确实是这样的一个另类的精英。我建议你可以跳过这个教材直接阅读《The Rails 3 Way》by Obie Fernandez.

**对于有经验的rails开发人员：**这个教材对你完全是多余的。但是许多经验丰富的rails开发者也能同样在这本教材中寻找到惊喜～所以我想你会喜欢对于本教材的独特视角的。

在阅读完本教材之后我建议那些有经验的程序员阅读《The Well-Grounded Rubyist》by David A. Black，它从底层深入讨论了ruby，或者《The Ruby Way 》by Hal Fulton,同样一本高级ruby书，然后你可以接着看《The Rails 3 Way》来做一些更深入的rails练习。

总而言之，无论你从哪里开始，你都应该关注一些更深入更直接的rails支援，这些是我有参加的一些参考：

* [Railscasts](http://railscasts.com/)
* [PeepCode](http://peepcode.com/)
* [Rails Guides](http://guides.rubyonrails.org/)
* [Rails blogs](http://www.google.com/search?q=ruby+on+rails+blogs)

####1.1.2 “Scaling”(谁知道怎么翻译？)的rails

在开始我们的教程之前我想要花一点时间来纠正一个多年来关于rails框架的最常见的问题：rails能不能去“架构“一个大型网站。我觉得关于这个问题你们有一些误区：[你架构的是一个网站，不是一个框架](http://idleprocess.wordpress.com/2009/11/24/presentation-summary-high-performance-at-massive-scale-lessons-learned-at-facebook/).而rails再牛逼也就是一个框架而已。所以你们真正想问的恐怕应该是：“大流量的网站能够用否rails框架来搭建？“。而如今，我想这个问题应该能够被很确定的回答：世界上某些流量最大的网站就是用rails搭建的！实施上做一个架构需要的东西远远不只是rails但是如果你确定你能够作出一个像Hulu,Yellow Pages那样的大型网站的话，我想rails是不会阻止你去颠覆世界的～！

####1.1.3 关于本书的标准约定

本书的约定我基本上都会在提出之前解释清楚。这里先说清楚一点：

不管是PDF还是HTML格式的这份教程都是充满链接的，包括了内部和外部链接，就像[Ruby on Rails download](http://rubyonrails.org/download)一样。

关于本书的当中的命令行：为了简便，所有命令行我都用类Unix风格的提示符来表示，例如：

    $ echo "hello,world"
    hello,world

Windows下的用户你可能会出现类似的的命令和命令提示符:

	C：\Sites>echo hello,world
	hello,world

在类Unix系统中一些命令需要执行<code>sudo</code>命令，它指的是“代替用户执行”。默认情况下这个命令将会让你以管理员权限运行自己的用户，它能让你更改和访问一些普通用户无法读写的文件，例如

	$ sudo ruby setup.rb

大部分的Unix/Linux/OS X系统需要加上一个<code>sudo</sudo> 命令，除非你使用了Ruby的版本管理软件（在1.2.2.3介绍）。如果这样的话你将可以这样运行：

	$ ruby setup.rb

Rails现在也可以作为一个命令来运行了,例如我们在1.2.5就会运行一个本地的web开发服务器运用到如下的命令：

	$ rails server

与命令提示符一样，Rails Tutorial使用了类Unix方式的地址分割栏（/）。我的Rails Tutorial应用就在我计算机中的

	/Users/mhartl/rails_orojects.sample_app

下面。在windows例，同样的目录就会变成

	C:\Sites\sample_app

所有我所说的“根目录”说的都是rails开发根目录，从今以后所有的目录都会相对与这个地址表示。例如我说<code>config</code>目录说的就是

	/Users/mhartl/rails_projects/sample_app/config

这个加上config的目录。同样，如果我表示：

	/Users/mhartl/rails_projects/sample_app/config/routes.rb

我会简写成<code>config/routes.rb</code>.

最后，Rails Rutorial 常常会输出不同的程序和文件，由于不同的计算机系统可能大家看到的又些许区别，但是这没有问题。另外，有意写命令可能由于你的计算机系统会产生错误信息，与其去一点一点的分析[Sisyphean](http://en.wikipedia.org/wiki/Sisyphus)错误日志，我觉得直接"Google 一下"回事更好的方法，这也将成为你在实践部署中的宝贵经验。

###  1.2   让它跑起来

是时候开始搭建我们的Ruby on Rails 开发环境了，同时我们会作出我们的第一个应用。刚开始可能有点难，尤其是对于毫无编程经验的人们来说，但是千万别在现在就灰心了。不仅仅是你，任何一个程序员都会经历这样的时刻的。

#### 1.2.1 开发环境

考虑到大家不同的环境和习惯，可能一万个开发者就有一万种开发环境，但是归根结底可能就两种：文本编辑器和集成开发环境（IDE）。关于后者：

IDEs

rails并不缺少支持 rails 的 IDE，有：[RadRails](http://www.aptana.com/rails/) , [RubyMine](http://www.jetbrains.com/ruby/index.html) 和 [3rd Rail](http://www.codegear.com/products/3rdrail) .所有这些都是跨平台的，我还听说了他们的一些很棒的功能，我建议你去尝试一下他们看看你用的舒服不舒服。我从来不觉得IDE适用与大部分的rails开发者，至少对我来说，我从来没有用过他们

文本编辑器和命令行

如果不用IDE那还能用什么开发rails呢？我想大部分的开发者会和我的选择一样：用文本编辑器来编辑rails代码，用命令行去让rails跑起来。具体用什么我想这个取决与你使用的平台：

    Machintosh OS X：和许多rails开发者一样，我推荐 [TextMate](http://macromates.com/).另一个选择是 [Emacs](www.gnu.org/s/emacs/) 和 MacVim（这是一个相当不错的vim的mac定制版）。我用 iTerm 来作为我的命令行终端，用自带的终端当然也没问题。

    Linux ：你的文本编辑器可能和 OS X 下的基本一直，除了没有了TextMate。。。我建议你使用图形界面的 gVim ，或者是带上 GMate 插件的 gedit 。或者 Kate 也行.命令行的话。。目前我还没有听说有哪个linux的发行般会没有带终端程序。

    Windows :推荐的 Windows 文本编辑器有： Vim ， [E Text Editor](http://www.e-texteditor.com/) , [Komodo Edit](http://www.activestate.com/komodo_edit/) 还有 [Sublime Text](http://www.sublimetext.com/).对于命令行，我建议使用 Rails Installer 自带的 命令行 程序。

如果你的选择是Vim，那么我建议你去好好看看 [Vim-using Rails hackers](http://www.google.com/search?q=vim+rails) 。尤其是 [rails.vim](http://www.vim.org/scripts/script.php?script_id=1567) 和 [NERDTree](http://www.vim.org/scripts/script.php?script_id=1567) 增强插件。

 									图1.1 : TextMate/iTerm 下的文本编辑器。

![http://ruby.railstutorial.org/images/figures/editor_shell.png](http://ruby.railstutorial.org/images/figures/editor_shell.png)

**浏览器**

虽然你有许许多多的浏览器可以选择，但是大部分的rails开发者来说他们用的都是 [Firefox](http://getfirebug.com/) ,Safari ,和 Chrome 来进行开发。这份教材的rails截图都将来自与 FireFox。另外，如果你也用 [Firefox](http://getfirebug.com/) 那么我强烈建议你用 Firebug 火狐插件。这可一让你的平台神奇的把所有的 HTML 和 CSS 语法都展现在你的页面上。 对于那些不用火狐的人来说 Firebug Lite 也对大部分浏览器有效。另外对于 大部分浏览器，包括 Safiri 和 Chrome 都有在右键内嵌的 “Inspect element” 功能。

**关于工具的注意事项**

在开动我们的开发之前，你可能要花费很多时间在准备工作上。学着使用编辑器和IDE是一件漫长的事情——我是说你完全可以在 TextMate 和 Vim 上琢磨上一个星期。如果你是一个新手，那么我希望你能 坚持的使用这些工具，每个人都有这个过程。虽然有时候这让人沮丧，虽然当你脑子里面又一个超级cool的点子和设计的时候 却只能坐在这里学 rails 的工具很烦，但是我想花一个星期去琢磨你的文本编辑器会使一个划得来的交易。去理解那些工具，他会给你带来奇迹般的效率的。

####1.2.2 Ruby,RubyGems,Rails 还有 Git

现在时候来安装 ruby 和 rails 了。最中规中矩的做法是去 [Ruby on Rails download page](http://rubyonrails.org/download) 找一份最新的然后下下来装上。哪里听不错的，有不少可以离线阅读的图书和资源下载，但是在这里我会推荐以下方法

**Rails Installer (Windows)**

在 Windows 上安装rails实在不是一件令人舒服的事情，但是感谢那些 Engine Yard 的好人们————尤其是 Dr. Nic Williams 和 Wayne E. Seguin————现在在windows安装ruby on rails 现在变得轻松无比。如果你正在使用 windows 直接下载 [Rails Installer](http://rubyforge.org/frs/download.php/75114/railsinstaller-1.3.0.exe) 下载安装 Rails Installer 并且双击执行，这里还会直接打包好Git版本控制软件，所以你是可以跳过这整个安装步骤啦！你可以直接在1.2.3开始看我们的第一个Ruby应用。

**安装 Git**

许多rails开发包用git版本控制软件进行管理。因为这种情况很普遍，所以我建议你也应该尽早的上手去学学git，我推荐这里的一份git安装与命令手册 [Installing Git section of Pro Git](http://progit.org/book/ch1-4.html) .

**安装 Ruby**

下一步就是安装Ruby了，你的计算机里面可能已经有Ruby了，你可以运行.

	$ ruby -v
	ruby 1.9.2

来确认你的版本号。Rails需要Ruby1.8.7以上才能工作，推荐版本为1.9.2。这份教材假设大家使用的是1.9.2的版本，不过如果你用的是1.8.7的版本也没什么问题。另外，Windows用户在安装 Rails Installer 1.3.0 会默认搭配上 ruby 1.8.7 。

Ruby 1.9 作出了非常多的改动，所以你想要直接用上最新的Ruby或许有意写困难，如果你喜欢总是能用上最新版本的指令的话，下面的不走是我推荐的于是我现在所使用的方法（在 macintosh OS X上），你可以在网络上找到和你系统配套的命令。

首先要声明的事，我还是建议你使用 OS X 或者 Linux ，在这两个系统上我强烈推荐你使用 [Ruby版本管理器 RVM](http://rvm.beginrescueend.com/) 来安装管理你的Ruby版本。如果你想在同一机器上运行 Rails 3 和 Rails 2 这是非常重要的，在这里我给出的建议是,安装两套 RoR 版本: Ruby 1.8.7/Rails 2.3 和 Ruby 1.9.2/Rails 3.如果你在运行或者安装RVM的时候出现了问题，你可以在RVM的IRC 频道找到 Wayne E.Swguin报告问题。

在安装了RVM之后你需要的只是：

	$ rvm get head
	$ rvm reload
	$ rvm install 1.8.7
	$ rvm install 1.9.2
	<wait a while>

前两个命令行是让RVM将自己升级并且重新加载的，RVM的更新很快，升级一下是一个好习惯。后面两个命令将会花一些时间下载和编译程序，如果它看上去好像死机，不要担心的太多，他会装好的。（有时候你可能需要在安装的版本号后面加上一个“补丁号”才可以让你正确的安装，例如你想要302版本的补丁可以

	$ rvm install 1.8.7-p302

)

Ruby程序通常通过 gems 分布式的进行管理，gems 包自己也包含着Ruby代码，如果你的gems会因为不同版本的Ruby而冲突，建立不同的 gemets 来管理gems是一个不错的选择。需要指出的是，rails也是一个gem包，而且rails 2 和rails 3 就是互相冲突的。所以如果你需要在同一个系统上面运行不同版本的rails你可以这样来创立两个不同的 gemset ：

	$ rvm --create 1.8.7-p302@rails2tutorial
	$ rvm --create use 1.9.2@rails3tutorial

其中第一个命令创立了gem包管理集合 rails2tutorial ，关联到Ruby 1.8.7-P302 ，第二个命令行是把 gem包管理集合 rails3tutorial关联到 1.9.2版本上去，并且开始使用（通过 use 命令），另外，RVM 还支持多样化的包管理操作，你可以这个文档里看到具体操作：(http://rvm.beginrescueend.com/gemsets/).

在教程里我们会用到 ruby 1.9.2 + Rails3 进行开发。所以你可以这样来配置：

	$ rvm --default use 1.9.2@rails3tutorial

这条命令同时设置的默认的 Ruby 程序和 gem包集合rails3tutorial。

如果你对RVM 感到疑惑的花运行下面这两个命令或许会给你带来帮助

	$ rvm --help
	$ rvm gemset --help

**安装RubyGems**

RubyGems是Ruby项目的包管理程序，包含的上千个优秀应用（包括rails），Ruby包，Gem。你安装了Ruby之后安装RubyGems也很简单，如果你安装了RVM那么RubyGems将会被自动添加。

	$ which gem
	/Users/mhartl/.rvm/rubies/ruby-head/bin/gem

如果你还没有，你可能需要下载 [RubyGems](http://rubyforge.org/frs/?group_id=126) , 你在这里可能需要 <code>sudo</code> 命令.

	$ruby setup.rb

如果你已经有了 RubyGems 你可以用

	$ gem update --system 1.8.5

升级你的gem来保持与本教材的一致。如果你用的是 Ubuntu Linux 那么你可以在the Ubuntu/Rails 3.0 blog post by Toran Billups这里得到完整的安装帮助。

当你安装gems的时候，RubyGems 就会生成两种不同的文档(叫做 ri 和 rdoc)，但是许多Ruby Rails开发者都发现建立这些文档的时间相当不值（因为很多程序员比较喜欢在线浏览他们需要的文档）。为了取消自动生成文档给你造成不必要的时间浪费我建议你在你的个人目录（home directory）下面的gem配置文件.gemrc加入一行：

 	gem: --no-ri --no-rdoc

**安装Rails**

你装完RubyGems之后安装Rails就会很轻松，保持与本教材一致的版本只需要

	$ gem install rails --version 3.0.11

确认rails工作了你可以

	$ rails -v
	Rails 3.0.11
目前最新的rails版本是rails3.1 ，本教材使用rails3.0是出于rails3.0目前还是最稳定版本的原因，你可以自行决定何时更换你的rails版本。另外对于一个rails新手来说，rails3.0 和 rails 3.1 是十分相似的，所以大部分你所学到的东西能够兼容 rails 3.1。

关于rails 3.1 的向后不兼容部分 与新特性你可以阅读第13章，我们会在那里会有简短的讨论和介绍。最后本书的rails 3.1版本的编写已经开始了，可能会加入一些新的特性（例如Sass 和 coffescript）.

####1.2.3 第一个应用

Running the rails script to generate a new application.

```
$ mkdir rails_projects
$ cd rails_projects
$ rails new first_app
      create
      create  README
      create  .gitignore
      create  Rakefile
      create  config.ru
      create  Gemfile
      create  app
      create  app/controllers/application_controller.rb
      create  app/helpers/application_helper.rb
      create  app/views/layouts/application.html.erb
      create  app/models
      create  config
      create  config/routes.rb
      create  config/application.rb
      create  config/environment.rb
      .
      .
      .
```

注意rails创建的这些文件和文件夹，这些标准文件和文件夹的结构是一个rails的优点，它能够迅速的从零开始搭建应用程序。另外，因为这些文件夹文件的结构对于任何rails工程都是相同的，所以你可以迅速上手不同rails开发者的代码。rails默认生成的文章结构如下：

![picture](http://ruby.railstutorial.org/images/figures/directory_structure_rails_3.png)

我们会在下面的学习中一一介绍这些文件和目录。

<div class="table"><div class="center"><table class="tabular"><tr><th class="align_left"><strong>File/Directory</strong></th><th class="align_left"><strong>Purpose</strong></th></tr><tr class="top_bar"><td class="align_left"><tt>app/</tt></td><td class="align_left">Core application (app) code, including models, views, controllers, and helpers</td></tr><tr><td class="align_left"><tt>config/</tt></td><td class="align_left">Application configuration</td></tr><tr><td class="align_left"><tt>db/</tt></td><td class="align_left">Files to manipulate the database</td></tr><tr><td class="align_left"><tt>doc/</tt></td><td class="align_left">Documentation for the application</td></tr><tr><td class="align_left"><tt>lib/</tt></td><td class="align_left">Library modules</td></tr><tr><td class="align_left"><tt>log/</tt></td><td class="align_left">Application log files</td></tr><tr><td class="align_left"><tt>public/</tt></td><td class="align_left">Data accessible to the public (e.g., web browsers), such as images and cascading style sheets (CSS)</td></tr><tr><td class="align_left"><tt>script/rails</tt></td><td class="align_left">A script provided by Rails for generating code, opening console sessions, or starting a local web server</td></tr><tr><td class="align_left"><tt>test/</tt></td><td class="align_left">Application tests (made obsolete by the <tt>spec/</tt> directory in <a class="ref" href="static-pages#sec:static_pages_with_rails">Section&nbsp;3.1.2</a>)</td></tr><tr><td class="align_left"><tt>tmp/</tt></td><td class="align_left">Temporary files</td></tr><tr><td class="align_left"><tt>vendor/</tt></td><td class="align_left">Third-party code such as plugins and gems</td></tr><tr><td class="align_left"><tt>README</tt></td><td class="align_left">A brief description of the application</td></tr><tr><td class="align_left"><tt>Rakefile</tt></td><td class="align_left">Utility tasks available via the <code>rake</code> command</td></tr><tr><td class="align_left"><tt>Gemfile</tt></td><td class="align_left">Gem requirements for this app</td></tr><tr><td class="align_left"><tt>config.ru</tt></td><td class="align_left">A configuration file for <a href="http://rack.rubyforge.org/doc/">Rack middleware</a></td></tr><tr><td class="align_left"><tt>.gitignore</tt></td><td class="align_left">Patterns for files that should be ignored by Git</td></tr></table></div><div class="caption"><span class="header">Table 1.1: </span> </div></div>

####1.2.4 Bundler

在创建了全新的rails应用之后下一步就是运用bundler来安装你所需要的 gem ，你可以用你最喜欢的文本编辑器打开 Gemfile

	$ cd first_app/
	$ mate Gemfile

你会看到类似的东西：

``` ruby
source 'http://rubygems.org'

gem 'rails', '3.0.11'

	# Bundle edge Rails instead:
	# gem 'rails', :git => 'git://github.com/rails/rails.git'

	gem 'sqlite3'

	# Use unicorn as the web server
	# gem 'unicorn'

	# Deploy with Capistrano
	# gem 'capistrano'

	# To use debugger
	# gem 'ruby-debug'

	# Bundle the extra gems:
	# gem 'bj'
	# gem 'nokogiri', '1.4.1'
	# gem 'sqlite3'
	# gem 'aws-s3', :require => 'aws/s3'

	# Bundle gems for certain environments:
	# gem 'rspec', :group => :test
	# group :test do
	#   gem 'webrat'
	# end

```

这个文件很大一部分内容都被 # 给注释掉了，他们是用bundler语法给出的一些最常用的 gems .现在我们只需要rails这个gem本身和ruby 接口的 SQLite Database. 在 Gemfile 中 我们可以给出明确的 sqlite3 gem.

	source 'http://rubygems.org'

	gem 'rails', '3.0.11'
	gem 'sqlite3', '1.3.3'

我们这里把

	gem 'sqlite3', '1.3.3'

给换成了

	gem 'sqlite3'

这样就指定 Bundler 安装1.3.3版本的sqlite了 （如果你在 OS X Leopard 上运行，那么请注意你还需要一个 1.2.5 版本的 sqlite3-ruby 的 gem：

	gem 'sqlite3-ruby', '1.2.5', :require => 'sqlite3'

这个是因为在最新的 gem 中，sqlite的包被改名叫做了 sqlite3 但是在雪豹中可能需要事先编译一下这个包。 ）

如果你在运行 Ubuntu Linux 你可能还额外的需要安装一下的包

	$ sudo apt-get install libxslt-dev libxml2-dev libsqlite3-dev    # Linux only

一旦你正确地建立了 Gemfile 安装这些gems 只需要一个命令 bundle install ：

	$ bundle install
	Fetching source index for http://rubygems.org /
	.
	.
	.

在这里可能会花上几分钟来安装，但是装好了之后我们就可以在上面跑应用程序了。

####1.2.5 rails server

通过 rails new 和 bundle install 我们已经获得了一个可以运行的应用的.怎么运行呢? rails自带了一个命令行程序或者说是 脚本 程序，它能帮我们在本地完成服务器的运行，并且让你可以看到你开发的成果。

	$ rails server
	=> Booting WEBrick
	=> Rails 3.0.11 application starting on http://0.0.0.0:3000
	=> Call with -d to detach
	=> Ctrl-C to shutdown server

这告诉了我们应用程序在IP 0.0.0.0 的端口 3000 已经跑起来了。他会让你的机器开始监听3000端口的所有请求，这时候我们可以通过一个特别的ip地址 127.0.0.1 ，也就是 localhost 来访问这个本地主机。我们在地址栏中输入：(http://localhost:3000/ )

![picture](http://ruby.railstutorial.org/images/figures/riding_rails_3.png)


在这里我们可以直接看到我们应用程序的相关信息，点击 “About your application’s environment” 你会看到

![picture](http://ruby.railstutorial.org/images/figures/riding_rails_3_environment.png)

我们也没必要看这个配置环境太多次，我们将会在下一章移除并替换这个默认页面。

####1.2.6 模型-视图-控制器（MVC）

在开发之前，我觉得先从整体上来认识一下rails的结构比较好。注意rails的默认的应用结构 有一个应用文件夹 app/ 其中包含了几个子目录 model , view , controllers . 这意味着rails遵守着一个模型-视图-控制器 [MVC](http://en.wikipedia.org/wiki/Model-view-controller) 设计模式，他将强制性的把管理层（“domain logic” also called “business logic” ）从 展示层（presentation logic）和用户界面（GUI）分离开来。 对于一个网络应用来说，管理层通常包含了例如 用户，文章，产品等等的模型和数据，而 GUI 是对于浏览器来说的一个页面。

对浏览器来说，要访问一个rails应用，浏览器首先会发送一个请求到rails的controllser上面去，controller会决定具体访问的文件或者模型。有时候controller会直接 抛会一个 view ，一个已经转换成 HTML 语言的一个模板页面。对于一个动态网站来说，更常见的是controller会与model（通常是一个ruby对象，类似用户这样的网站元素）交互，model又会和数据库通信，之后controller将这些数据渲染上视图组合成完整的网页抛回给浏览器。

![picture](http://ruby.railstutorial.org/images/figures/mvc_schematic.png)

如果你觉得这东西有点抽象，那么也别担心，我们还会解释 MVC 的 ,后面还有很多关于 MVC 的具体实践。

###1.3 GIT 版本控制

现在我们已经有了一个rails 程序 我们需要在这里完成一个大部分rails 开发者都认可的步骤————这是可选的————把你的程序放置在版本控制之下。版本控制会让你跟踪你的代码的改变，让合作更佳轻松愉快，并且可以轻松的抹去你的错误操作回滚到过去的代码。所以掌握版本控制是一项软件开发人员必须的技能。

要进行版本控制，又很多选在，但是rails 社区大部分都依赖于 Git ，一个分布式的版本控制工具，是由Linus Torvalds 为了管理 Linux 的内核而开发的。Git 是一个大项目，我们甚至可以为此写出整整一本书来介绍这个软件，我推荐 Scott Chacon 的书 Pro Git (Apress, 2009) .把你的代码都放到Git下面绝对是一个非常不错的选择，你不仅仅可以进行rails项目的开发管理，你还能够与他人共享你的代码并且轻易的将你的项目部署到服务器上面去。
####1.3.1 安装与配置

首先你应该安装git，关于这个步骤这里不再赘述，具体可以看Installing Git section of Pro Git

**第一次的系统配置**

	$ git config --global user.name "Your Name"
	$ git config --global user.email youremail@example.com

我也习惯用 co 这个命令来代替 checkout ,你可以这样

	$ git config --global alias.co checkout

教程都会使用 checkout 命令，对于那些还没有进行 co 绑定配置也没什么关系，反正在真实世界我用的都是 git co 。

你也可以设置Git 的 commit 命令的默认编辑器，如果你用了图形界面的编辑器例如 TextMate，gVim, 或者 MacVim,你在这里配置一下来让 Git能够在命令行住正确的用编辑器打开。

	$ git config --global core.editor "mate -w"

在这里请用 "gvim -f" –对于gvim "mvim -f" –对于MacVim 来替换这里的 "mate -w"

**代码仓库配置**

现在我们要进行系列步骤来创建一个代码操作，以后每次你都可这么做来新建一个代码库。首先定位到我们的 first app 的根目录下面新建一个代码库：
安装完Git之后，你可以进行如下的一次行配置。

	$ git init
	Initialized empty Git repository in /Users/mhartl/rails_projects/   first_app/.git/

下一个步骤就是为代码仓库添加上你的项目文件，这个不走可能那么一点复杂，Git会默认得跟踪每一个文件的改变，但是如果有一些文件我们不需要追踪那么多的文件，例如rails会创建一些日志文件来记录应用程序的运作，这些文件变化频繁，没有必要记录，我们也不希望让我们的版本控制中包含进这样的内容。 Git有一个简单的机制来让你忽略到这样的文件：根目录下面包括一个文件叫 .gitgnore ,这个文件记录着Git那些文件需要忽略上传。

	.bundle
	db/*.sqlite3
	log/*.log
	tmp/**/*


这就让Git忽略了那些log文件，rails 的暂时文件（ tmp ），还有 SQLite databases。（例如，要忽略那些 log/文件夹中的log文件，我们用 log/*.log ）大部分的这些文件都是变化频繁，自动生成的，把这些文件包括进版本控制并不合适，也会让同样使用这个资源的人产生不必要的冲突。

.gitignore 文件中的东西目前可以说是足够的了，但是根据你的系统不同你还是可以添加一些其他的文件，例如我们并不希望上传rails的帮助文档和我们的Vim或者Emacs的临时交换文件，对于OS X 系统的用户来说， Mac 自动索引还会加上一个 /DS_Store 目录，你可以用你最喜欢的编辑器来为你的 .gitignore 添加上你加上的设置。

	.bundle
	db/*.sqlite3*
	log/*.log
	*.log
	/tmp/
	doc/
	*.swp
	*~
	.project
	.DS_Store

####1.3.2 增加并且确认

最后我们将为新的Rails项目增加Git控制并确认提交我们的结果。我们可以这样增加所有的文件（除了我们在 .gitignore ）：

	$ git add .

这里的点 ‘.’ 代表了当前的文件夹。GIT 很聪明，他会递归的添加你文件夹中的每一个文件到临时区域，他将保存每一次我们作出的改变。我们可以用 status 命令：

``` bash
	$ git status
	# On branch master
	#
	# Initial commit
	#
	# Changes to be committed:
	#   (use "git rm --cached <file>..." to unstage)
	#
	#       new file:   README
	#       new file:   Rakefile
	.
	.
	.
```

结果很长，我在这里忽略了后面的内容。

你可以用 commit 命令

``` bash
	$ git commit -m "Initial commit"
	[master (root-commit) df0a62f] Initial commit
	42 files changed, 8461 insertions(+), 0 deletions(-)
	create mode 100644 README
	create mode 100644 Rakefile
	.
	.
	.
```

-m 标志能够让你添加一个对确认的描述信息，如果你忽略了 -m ，Git会打开你所设定的编辑来让你输入信息。

注意，Git的 commit 是本地进行的，仅仅记录了你机器上 commit时候的状态。 这里可以和另一个流行的版本控制工具 Subversion 对比一下， Sububversion是必须每次都与服务器端进行对比确认的。而Git把 Sububversion 的 Commit 功能分成了两块，一个在本地记录你的文件变化（用 git commit ） 然后 把改变推送到服务器端 （ git push ）。我们马上会就看到一个 push 的实例的。

另外，你可以用 log 命令来 查看你的所有 确认信息。

``` bash
$ git log
commit df0a62f3f091e53ffa799309b3e32c27b0b38eb4
Author: Michael Hartl <michael@michaelhartl.com>
Date:   Thu Oct 15 11:36:21 2009 -0700

Initial commit
```
如果要退出 git log 你可以输入 q 来退出。

####1.3.3 GIT 给你带来了什么

你可能现在都还是没有搞懂版本控制的好处到底是什么，现在我们来举个例子把（我们会在其他章节用到很多的。。。）假设我们现在做了一个意外的改动，例如。。。把我们的 app/controllers/ 文件夹给删除掉了。

``` bash
	$ ls app/controllers/
	application_controller.rb
	$ rm -rf app/controllers/
	$ ls app/controllers/
	ls: app/controllers/: No such file or directory
```

我们在这里使用 Unix 的 ls 命令列出了 app/controllers/ 文件夹然后我们还用了 rm 命令行删除了它。这里的 -rf 标志意味着“循环强制性”删除，这会循环地强制性删除所有的文件，文件夹，子文件夹并且不回馈任何确认信息。

现在我们来看看一看他们都做了什么：

``` bash

$ git status
# On branch master
# Changed but not updated:
#   (use "git add/rm <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working  directory)
#
#       deleted:    app/controllers/application_controller.rb
#
no changes added to commit (use "git add" and/or "git commit -a")

```
我们在这里看到了一些被删除掉的文件，这个改变只存在于 “工作分支” 上；意味着这些还没又被确认提交。这意味着我们还可以通过 checkout 命令还恢复它 （ -f 标志能够让他们强制覆盖掉原有的改变。）

``` bash
$ git checkout -f
$ git status
# On branch master
nothing to commit (working directory clean)
$ ls app/controllers/
application_controller.rb
```

####1.3.4 GitHub

现在我们应该把我们的项目至于 Git 的版本控制之下了，这时候我们就可以把代码推送到 GitHub 去了，这是一个社会化开源平台来让你共享你的Git 仓库。我们把代码仓库放到 GITHub上面去有两个目的：一个是对我们代码 进行备份，另一个是让代码更容易合作开发。这个步骤是可选的，但是成为一个GitHub 用户将会给你打开参加一个开源项目的大门。

![github](http://ruby.railstutorial.org/images/figures/github_first_page.png)


![git](http://ruby.railstutorial.org/images/figures/create_first_repository.png)

GitHub 有收费的项目，但是开源保管代码是免费的，你可以免费注册一个 Github帐号（如果你还没有的话，你可能需要跟随这个[配置教程](http://help.github.com/key-setup-redirect) 先）。 然后你要建立一个代码仓库，随后你就可以这样推送上你自己的第一个代码仓库了：

``` bash
$ git remote add origin git@github.com:<username>/first_app.git
$ git push origin master
``` bash

这个命令告诉了 Git 你想要添加 GitHub 作为你的 master （主分支）的 origin （起源）然后推送到GitHub上，当然你要在这里把 给替换成你自己的用户名。我这里用了 railstutorial 作为我的用户名。

	$ git remote add origin git@github.com:railstutorial/first_app.git

这就是我们上传到Github的成果啦～

![github](http://ruby.railstutorial.org/images/figures/github_repository_page.png)

####1.3.5 分支，编辑，确认，合并

如果你跟着我做了上一章，你将会发现GitHub自动显示了我们主分支的 README 文件。这是因为，对于我们的rails来说，我们用 rails 命令的时候rails 就会自动帮你创建一个 README 文件。这对别人来说毫无意义，所以首先我们应该先把 README 文件改成能够描诉我们工程的东西，而不是描述rails框架的东西。这里我们将会用上看到Git的分支，合并，编辑，确认提交。

![pic](http://ruby.railstutorial.org/images/figures/rails_readme.png)

**分支**

Git在建立分支上功能强大，它能够快速有效的创建一个代码仓库的备份，我们更改了这个备份文件（分支），父文件也不会受到任何影响。通常来说，我们可以通过 checkout 加上 -b的标签命令来新建一个分支：

	$ git checkout -b modify-README
	Switched to a new branch 'modify-README'
	$ git branch
	master
	* modify-README

分支的最大用处就是可以方便的管理多开发者的项目，不过对于单个开发者来说分支很有用。分支能和主分支完全隔离所以，我们如果突然不想要一个分支的时候我们可以直接 check out 到 master 上然后删除分支。

另外，对于教程中这么小的改动我通常不会特地建立一个分支，但是早点学习并实践一个新东西总不是坏事。

**编辑**

在建立了一个分支之后我们改修改一下我们的项目描诉文件了。在这里我建议使用 Markdown 标记语法 ,当你使用 .markdown 后缀的时候GitHub会自动识别出来并且转换成正确的格式。

首先我们要先用 Git版本的 Unix mv命令来更改文件名，然后我们在文件中输入我们需要的内容。

$ git mv README README.markdown
$ mate README.markdown

这个是新的 README.markdown 文件

	This is the first application for
	\[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
	by \[Michael Hartl](http://michaelhartl.com/).

**确定(commit)**

现在我们先来看看我们分支的状态

	$ git status
	# On branch modify-README
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       renamed:    README -> README.markdown
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   README.markdown
	#

在此时我们可一使用 git -a 命令来建立快照，但是Git提供了一个便捷的 -a标签用来合并快照和确定的两个动作。（很常用的哟～）

	$ git commit -a -m "Improved the README file"
	2 files changed, 5 insertions(+), 243 deletions(-)
	delete mode 100644 README
	create mode 100644 README.markdown

注意到我们这里使用了 -a 标志，如果你确认之后又加入了新文件，你还是必须先用 git add 来告诉Git。

**合并**

作出了改变之后我想我们可以这样来把我们的文件从分支合并进来了：

``` bash
$ git checkout master
Switched to branch 'master'
$ git merge modify-README
Updating 34f06b7..2c92bef
Fast forward
README          |  243      -------------------------------------------------------
README.markdown |    5 +
2 files changed, 5 insertions(+), 243 deletions(-)
delete mode 100644 README
create mode 100644 README.markdown
```

注意到Git的输出文件常常包括像 34f06b7 这样的东西，这个和Git的仓库表示方法有关系，你修改细节会在这里显示出来。

在你合并了修改之后你就可以用 git branch -d 命令来删除这个分支了。

	$ git branch -d modify-README
	Deleted branch modify-README (was 2c92bef).

这个步骤完全是可选的，事实上，当你合并了一个分支之后常常就是一个分支的结点了，所以合并过后直接删除分支是很常见的事情。

另外提一句，Git 中你可以这么做来放弃一整个分支 ，你可以用 git branch -D 命令：

``` bash
# For illustration only; don't do this unless you mess up a branch
$ git checkout -b topic-branch
$ <really screw up the branch>
$ git add .
$ git commit -a -m "Screwed up"
$ git checkout master
$ git branch -D topic-branch

```

**推送**

现在我们已经更新了我们的 README 文件了，现在该来把我们的新东西推送到GitHub上了。因为我们在之前已经做过了一次推送，所以这次我们可以忽略 origin master 而直接运行 git push：

$ git push

在某些系统上面可能会出现这样的问题：

	$ git push
	fatal: The current branch master is not tracking anything.

这种时候你可能还是应该运行 git push origin master 来完成提交。在这里我们可以看到 Github已经完成了对Markdown语法的识别并且显示在了你的仓库首页上。

![pic](http://ruby.railstutorial.org/images/figures/new_readme.png)

###1.4 部署

现在我们就可以把我们的rails程序部署到网络上去了（虽然还几乎是空的）。这个步骤也是可选的，但是早早部署运行上你的代码能让你的开发周期缩短，并且更快发现你在开发上面的问题。当然你也可以选择在你把整个程序都编写完成之后再部署————只是那样很容易出现各种让你崩溃的问题。

部署Rails 应用原本是一个不太容易的事情，但是随着技术快速发展，rails云服务的出现，现在已经有了一些很成熟的选择。有：共享主机或者VPN运行[Phusion Passenger](http://www.modrails.com/) （一个模块化 apache 和 Nginx 的部署解决方案），一条龙服务的服务商例如 [Engine Yard 和 Rails Machine](http://engineyard.com/) ，还有云端服务器 [Engine Yard Cloud](http://cloud.engineyard.com/) 和 [Heroku](http://heroku.com/).

在这里我的选择是 Heroku ，它是专为ruby on rails 打造的一个云端平台，它让部署rails应用变的无比的简单，只要你的代码是用 Git 版本控制的，下面我们就来把我们的应用部署到Heroku上去。

####1.4.1 安装 Heroku

在注册了一个 Heroku帐号之后我们可以这样来安装 Heroku：

	$ gem install heroku

然后用 heroku 命令来为我们的例程建立一个Heroku云端服务器。

	$ heroku create
	Created http://severe-fire-61.heroku.com/ | git@heroku.com:severe-fire-61.git
	Git remote heroku added

这里 heroku 命令为你已经建立了一个二级域名，当然现在还什么都没有，但是我们马上就可以把东西部署上去。
####1.4.2 Heroeroku部署，步骤一

要想部署Heroku第一步用 Git 工具推送到 heroku 的云端服务器上去。

	$ git push heroku master

（此时有些读者可能会遇到这样的报错：

	rake aborted! no such file to load -- sqlite3

这个命令大部分时候都可以很好的运行，但是如果出现了这样的问题你应该修改一下我们的Gemfile，它限制了heroku读取 sqlite3 数据库，如下修改后更新就好了。

	source 'http://rubygems.org'
	gem 'rails', '3.0.11'
	gem 'sqlite3', '1.3.3', :group => :development

）
####1.4.3 Heroku部署，步骤二

现在是步骤2，成功就在眼前了。在你运行了heroku create 后如果要看你部署上的应用程序，你直接访问刚刚创建的地址就可以了，或者你可以运行 heroku open命令来让计算机自动打开一个浏览器来浏览你的网页。

	$ heroku open

![pic](http://ruby.railstutorial.org/images/figures/heroku_app.png)

一旦成功部署之后 Heroku 就会提供给你一个非常漂亮的用户界面来让你管理自己的应用程序

![picc](http://ruby.railstutorial.org/images/figures/heroku_info.png)

####1.4.4 Heroku 命令

Heroku 有不少命令，我们不会在这本书里用到多少的。现在我之花几分钟来介绍一下如何重命名你的应用：

	$ heroku rename railstutorial

应为这个名字被我用了，所以你们千万别用这个名字了，。。。你们可以也用heroku自动分配给你们的域名。

###1.5 结论

我们在这一张里面做了很多：安装，开发环境安装，版本控制和部署，如果你想要分享你自己的心不或者提出一些建议，你可以在twitter 或者 facebook 上发类似的消息

I’m learning Ruby on Rails with @railstutorial! http://railstutorial.org/

每一句话都可以证明了你实实在在的开始了你的rails学习，下一章我们会学到更深入的东西，LET‘S GET TO IT～

