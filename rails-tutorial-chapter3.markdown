翻译 [ruby on rails Tutorial](http://ruby.railstutorial.org/chapters/a-demo-app#top),原作者 [Michael Hartl](http://michaelhartl.com/) .


##第三章 Mostly static pages

在这一章中我们将开始开发一个例子程序，这个程序就是本书中接下来的所使用的例子。
尽管这个程序最终将会实现用户，微博信息，登录登出验证框架等，但是我们就从看起来蛮简单的开始——创建静态页面。尽管它很简单，但是创建静态页面是一项非常有意义和启发性的练习，对于我们新程序来说是一个完美的开端。
Rails虽然是用来设计数据库支持的动态网站，但是它也擅长用原生的HTML文件来产生静态网页。实际上用Rails产生静态网页会有明显的优势：我们可以非常容易的添加一小部分的动态内容。在这一章中我们也将学习如何添加这些内容。继续下去我们就将会第一次亲密接触自动测试，它会让我们对我们写过的代码更有自信。此外，有一个好的测试工具会是我们重构代码的时候更有信心——只改结构和形式没有改变它应有的功能。

如第二章所说，我们从新建一个Rails的应用程序开始，这次叫它：sample_app

``` bash
    $ cd ~/rails_projects
    $ rails new sample_app -T
    $ cd sample_app
```

在这里的 -T 参数是告诉 Rails 不要生成使用 Test::Unit 工具测试test文件夹。这意思是我门不要测试，正好相反，在第3.2节中我们将使用Rspec测试框架来代替 Test::Unit。

回到我们的项目，我们接下来要做的是使用文本编辑器去修改Gemfile文件。我们需要添加一些我们程序需要的gem包，和前一章中所声明的，sqlite3-ruby的gem的版本是1.2.5，这和以前一样，是我们在本地开发所需要的gem（重申：我的系统需要1.2.5版本，如果你无法使用它，你可以使用1.3.1版本），另一方面，对于这个示例次序来说，我们还需要2个以前没用的gem：Rspec和 Rails的rspec库，
示例代码如代码3.1（提示：如果你想要提前把我们这个程序的所有gem都安装，我觉得你应该参考代码10.42）：

``` ruby 代码3.1：示例程序的Gemfile
    source 'http://rubygems.org'

    gem 'rails', '3.0.3'
    gem 'sqlite3-ruby', '1.3.2', :require => 'sqlite3'

    group :development do
      gem 'rspec-rails', '2.3.0'
    end

    group :test do
      gem 'rspec', '2.3.0'
      gem 'webrat', '0.7.1'
    end
```
上面代码的开发模式里包含了rspec-rails，所以我们可以使用Rspec-specific生成器，在测试模式下包含了rspec，所以我们可以运行那些测试。（我们也包含Webrat测试工具，以前的版本它会被当成一个依赖包自动的添加，但是现在我们需要手动的添加它，它是目前用来生成页面测试的工具，所以我们需要它）。然后我们用Bundle install来安装这些gem。

	$ bundle install

为了让Rails知道我们使用Rspec代替Test::Unit，我们需要安装一些Rspec需要的文件。我们可以通过 rails generate：

    $ rails generate rspec:install

到这里，我要做的只剩下初始化Git库了：

    $ git init
    $ git add .
    $ git commit -m "Initial commit"


和第一程序一样，我还是建议更新“README”文件（位于程序的根目录。）。代码3.2的描述或许对你有些帮助。
<!--more-->
``` bash 代码 3.2 示例程序的README文件.
    # Ruby on Rails Tutorial: sample application

    This is the sample application for
    [*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
    by [Michael Hartl](http://michaelhartl.com/).
```


接下来，我们给他添上markdown的后缀名，然后提交它：

    $ git mv README README.markdown
    $ git commit -a -m "Improved the README"


![pic](http://ruby.railstutorial.org/images/figures/create_repository.png)

图3.1： 创建示例程序的GitHub库


为了将我们书中的程序放在github进行控制，增加一个新库是一个不错的主意。

    $ git remote add origin git@github.com:<username>/sample_app.git
    $ git push origin master

(提示：到这一步 http://github.com/railstutorial/sample_app 库中的代码是示例程序所有的代码，欢迎咨询参考，但是有2点要注意：1，自己输入代码比使用现成的代码会学到更多的东西；2，书中提到Github库的代码有的会有差别，这主要是由于一方面这个库合并了本书中的练习和视频教程中的练习。)
当然，我也可以在现在就部署到Heroku，

    $ heroku create
    $ git push heroku master


(如果错误可以参考代码1.8试着修复。) 在接下来的教程中，我建议你可以定期的push和发布程序；

    $ git push
    $ git push heroku

这样我们就可以开发示例程序了~


###3.1 静态页面

Rails有2个主要的方法产生静态网页。第一，Rails可以处理由原生的HTML文件组成的真正静态页面（我也不明白什么意思，看下去吧）。第二，Rails允许我们定义rails可以渲染的含有原生HTML的视图，这样服务器可以将它发送到浏览器。
回忆一下第1.2.3（图1.2）节中所讲Rails的结构对我们把握中心是很有帮助的。这一节我们主要的工作目录是app/controllers 和 app/views，在3.2节中我们会接触到新的目录（我们甚至可以添加自己的目录.）；

####3.1.1 真正的静态页面

让我们从真正的静态页面开始学习吧，回顾一下第1.2.5中关于每一个Rails程序一开始就就是一个非常小的程序（主要是Rails脚本的功劳，例如生成器）而且都有一个默认的欢迎页面（地址：http://localhost:3000/ .）

![pic](http://ruby.railstutorial.org/images/figures/public_index_rails_3.png)

图片3.2 public/index.html文件


看一下上图中代码，我们学习一下这个页面是从哪里来的。因为这个页面把样式直接包括进去，所以看起来有点乱，但是他的主要功能是：Rails将会把public文件夹下面的任何文件提供给浏览器。其中index.html文件是非常特别的，当你没有指定url地址的时候（http://localhost:3000/）他就是默认提供给浏览器的页面。当然你也可以包含它（http://localhost:3000/index.html）是没有区别的。
正如你所想的，如果我们喜欢，我们可以吧我们自己的静态网页像index.html文件一样放在public目录底下。所为例子，让我们创建一个问候用户的页面

	$ mate public/hello.html




``` html 代码3.3问候的HTML页面
    <!DOCTYPE html>
    <html>
      <head>
        <title>Greeting</title>
      </head>
      <body>
        <p>Hello, world!</p>
      </body>
    </html>
```

在代码3.3中，我们看到一个典型的HTML文件：在头部声明document type（或者doctype），告诉浏览器HTML的版本（我们使用HTML5），在HTML的head中，我们设置“Greeting”作为title标签，在Body里面，我们在一个段落标签里放入了“Hello，world！”（上面的缩进可以不必理会，HTML的空格和tab键没影响。加上必要的排版可以让我们的文档更方便查看。）。好了，和上面说的一样，我们可访问地址:
http://localhost:3000/hello.html，Rails将会直接将页面返回给我们（图3.3）。
（HTML文本的title在浏览器的顶部。）

![pic](http://ruby.railstutorial.org/images/figures/hello_world.png)

图3.3我们自己的静态网页
上述页面只是为了示范而已。它可不是我们程序的一部分，所以我们应该删除掉它。

    $ rm public/hello.html

我们先把index.html文件放一边，当然我们最终是要删除掉它的，我们可不想我们程序的根目录总是如图1.3所示那样的Rails默认页面。我们将会在第5.2节中学习如何让我们的地址“http://localhost:3000/”不指向public/index.html

3.1.2 Rails静态页面


可以返回静态页面是值得让人兴奋地，但是这对于开发一个动态web程序的来说并不是很有用。在这一节，我们学习创建动态页面的第一步：创建一些Rails的action方法，这些方法定义URL的能力比静态页面强很多。Rails的action方法在控制器里。第二章惊鸿一瞥的REST架构，我们将要在第六章深入的学习。本质上，controller是一组网页页面（可能是动态）的容器。

我们从回忆第1.3.5节中，我们如何使用Git开始，将我们工作的内容单独放在一个分支里面比直接在master分支更值得我们借鉴。如果你使用Git版本控制，你可以运行一下代码

	$ git checkout -b static-pages

Rails里面我们可以使用一个Generate的脚本来创建控制器；他的神奇之处就在于我们所要做的只是想一个控制器的名称。
由于我们的这个控制器主要用来处理静态页面，我们就叫他，Pages，而且我们希望给他几个action去响应Home page，contact page，和about page。我们可以在generate 脚本后面更上几个可选的参数作为actions，我们可以看到结果如下：

``` ruby 代码3.4创建Pages控制器
    $ rails generate controller Pages home contact
          create  app/controllers/pages_controller.rb
           route  get "pages/contact"
           route  get "pages/home"
          invoke  erb
          create    app/views/pages
          create    app/views/pages/home.html.erb
          create    app/views/pages/contact.html.erb
          invoke  rspec
          create    spec/controllers/pages_controller_spec.rb
          create    spec/views/pages
          create    spec/views/pages/home.html.erb_spec.rb
          create    spec/views/pages/contact.html.erb_spec.rb
          invoke  helper
          create    app/helpers/pages_helper.rb
          invoke    rspec
```

(注意，我们使用rails generate rspec：install来安装了Rspec所以，控制器自动在spec目录底下，生成了Rspec的测试文件。)。在这里，我故意遗忘了about page，我们可以在下一节3.2中学习如何手动添加它。
代码3.4中生成控制器的时候已经更新了routes的文件（位于config/routes.rb），Rails用该文件来查找URL和网页之间的对应关系。这是我们第一次遇到config这个文件夹，所以我们应该来快速的过一遍这个文件夹(如图3.4)。这个文件夹是rails放置一些配置文件的目录，故称其名。

![pic](http://ruby.railstutorial.org/images/figures/config_directory_rails_3.png)

由于我们生成了home和contact的action方法，所以，routes文件已经为每一个action配置好了规则，如代码3.5：


``` ruby config/routes.rb page控制器中home和contact的路由规则

    SampleApp::Application.routes.draw do
      get "pages/home"
      get "pages/contact"
      .
      .
      .
    end

```

规则：


	get "pages/home"



映射了请求url：pages/home到Pages控制器的home方法。此外，使用get我们制定这个路由只会响应GET(一种HTTP协议（见Box3.1）支持的基础HTTP动作)的请求。对我们来说，我们在Pages的控制器中创建一个home的方法之后就自动的获得了一个页面地址“pages/home”，可以用Ctrl+C关闭服务器之后，重新启动（其实可以不用重启，rails的可以动态载入这些方法），然后访问pages/home（见图3.5）

![pic](http://ruby.railstutorial.org/images/figures/raw_home_view.png)


>**Box 3.1.GET和其他.**
>HTTP协议定义了四种基本操作方式，分别是get，post, put, 和delete。这些是指在客户端和服务端之间的操作。（这个非常的重要，在开发中，一般客户端和服务器是同台机器，但是一般情况下，他们是不同的），强调HTTP动作是web框架（包括Rails）被REST架构影响的一个非常典型的特征。好处可以参考第2章，第八章会有深入的了解。
GET is the most common HTTP operation, used for reading data on the web;
get是HTTP操作中最常用的一个，一般用于请求数据。
it just means “get a page”, and every time you visit a site like google.com or craigslist.org your browser is submitting a GET request.
它的意思就是“获取页面”，所以每次你访问google.com 或者craigslist.org 的时候，你的浏览器都是提交一个Get的请求。
POST is the next most common operation; it is the request sent by your browser when you submit a form.
下一个常用的操作是Post，它一般在提交一个表单的时候使用。
In Rails applications, POST requests are typically used for creating things (although HTTP also allows POST to perform updates);
在rails里面Post的请求一般用于创建数据（尽管HTTP也允许post去实现更新。）
for example, the POST request sent when you submit a registration form creates a new user on the remote site.
比如，当你提交一个注册表单之后就会在服务器那边创建一个新的用户。
The other two verbs, PUT and DELETE, are designed for updating and destroying things on the remote server.
另外2个操作时put和delete，前者用来更新远程服务器数据，后者用来删除数据。
These requests are less common than GET and POST since browsers are incapable of sending them natively, but some web frameworks (including Ruby on Rails) have clever ways of making it seem like browsers are issuing such requests.
这2个没有前面2个操作那么普遍，有的浏览器没有支持发送这样的请求，但是一些web的框架（包括rails）有自己的方法去实现，让他发送这中请求。

让我们从Pages的控制器开始看看，这些页面是哪里来的。如代码3.6所示（你可能注意到，这个和第二章中的Users和Microposts控制器有区别，这个控制器并没有遵循REST规则。）


``` ruby 代码 3.6代码3.4产生的控制器代码。
  class PagesController < ApplicationController

      def home
      end

      def contact
      end
    end
```

我们看到pages_contoller.rb文件中定义了PagesController类。类是把功能（或方法，就像用def定义的home和contact方法一样。）组织起来的一种简单方法。尖括号“<”便是PacgesController从Rails的ApplicationContoller类；
正如我们将看到，这说明了我们的网页装备了大量的Rails的特定功能（我们将会在第4.4节中学习类个继承。）
在这里，控制器中页面的方法都是空的。
在ruby里，这些方法什么都不做，但是在Rails里面却有点却别。PagesController是一个Ruby的类，但是由于他继承自ApplicationController。所以他的方法有一些特别。当我们访问URL /pages/home、 Rails寻找Pages的控制器，然后执行home的方法，然后渲染页面响应页面的动作。因为在上面home的方法是空的，所以他除了渲染页面之外什么也没做。所以页面应该什么样子，我们应该如何找到它呢。
如果你再看看代码3.4的输出，你可能会猜出页面和方法之间的关系：一个方法如home页面对应一个视图如home.html.erb。我们将会在3.3中学“.erb”的意义。从".html"部分你也不用惊讶它看起来是基于HTML。

``` html app/views/pages/contact.html.erb
    <h1>Pages#contact</h1>
    <p>Find me in app/views/pages/contact.html.erb</p>
```



contact方法类似：
``` html app/views/pages/contact.html.erb
	<h1>Pages#contact</h1>
    <p>Find me in app/views/pages/contact.html.erb</p>
```



以上2个页面就类似占位符：一个顶级的h1标签，和一个包含了相关文件绝对路径的的P标签。我们从第3.3节开始学习添加一些动态（少量）的内容，但是他们说明了一个重要的知识：Rails的页面可以使只含有静态HTML的。只要浏览器链接，就很难区别开到底是由3.1.1中的静态页面显示，还是由控制器方法提供页面：因为浏览器都只看到HTML。
在这一章剩下的内容，我们将学习在3.1.2中故意遗漏的“about”，添加非常少的动态内容，然后第一次涉及页面的CSS样式。在进入下面的学习之前，我们应该将变动添加到Git的库里面去。


	$ git add .
	$ git commit -am "Added a Pages controller"


你或许想起来，我们再1.3.5节里面使用  git commit -a -m "Message"命令，用-a表示“all change”，用-m表示“信息”；git也允许我们将2个参数合到一起“-am”、我在本书中将会继续使用这种简写。

###3.2 我们的第一个测试

如果你去问五个 Rails 开发者如何去测试一段代码，你会得到15种不同的答案————不过他们都会认为写下测试代码是必要的。测试一段代码是一种精神，把一段心目中的想法写成测试而不用担心什么问题会让你的开发更佳完美。你也没有必要把 这里的测试方式当成是圣经，它们只不过是那些我从自己和我读到的代码中用到的东西。如果你想成为一个有经验的 Rails 开发者，你无疑在某日形成一个自己的测试开发风格的。

另外，在我们的示例程序中我们编写测试程序用了一种最近很流行的方法 在开发前编写测试文件（when to write tests by writing them before the application code）————一种测试驱动开发的方法，也叫TDD。我们的应用将要增加一个 About 页面。不用担心，增加一个额外的页面并不难————你或许都已经通过上面的学习猜到答案了————但是这一次我们要著重于测试文件的编写。

虽然为一个已经存在的界面进行测试似乎是有点闲的蛋疼，但是我的经验告诉我事实不是这样的。许多代码会写着写着就错了，有一个好的测试来约束你能够保证你的程序质量。另外，对于一个计算机程序来说，尤其是一个网络应用来说，扩展性是很重要的，这样每当你添加一个功能你都会面临一份程序写"跑题"了的危险。写下测试并不意味着程序中的bug会小时，而是让他们更容易被抓到和修复。而有的人确实会为抓bug而写测试。
  (正如我们在1.1.1中说的那样，如果你发现测试非常的让你头疼，你完全可以只把教程中的Ruby on Rails 抽出来先学习，然后再自行学习测试方面的技巧).

####3.2.1 测试工具

  为了给我们的示例程序进行测试，我们的主要工具是一个测试框架，叫做 [RSpec](http://rspec.info/),它使用“特别管理语言”来描述代码的行为，并判断代码是否完成了对应的工作。在Rails社区中，RSpec 测试Ruby程序十分高效，以至于 Obie Fernandez ， The Rails 3 way 的作者把RSpec 叫做 “Rails必由之路”，我在这里也表示赞同。

**autotest**

Autotest 是一个在你更改程序的时候，在后台自动帮你进行测试的套件。例如，如果你把一个 controller 改了 ，Autoest 就立马会对那个controller对应的view进行测试，测试结果也会马上反馈回来。我们会在 3.2.2 学到更多关于 Autotest 的东西。

安装 Autotest是可选的，不过安装Autotest 有点犯人，不过我保证当你发现它是多么的有用的时候你会觉得一些都是值得的。首先你要先安装一下 autotest 和 autotest-rails-pure 这两个gems

	$gem install autotest -v 4.4.6
	$gem install autotest-rails-pure -v 4.1.2

(如果你在这里遇到了 “权限不够”的提示的话那你可能需要使用 sudo 命令来运行它们)。

下一个步骤将要取决与你的系统平台，我会在这里用我的 OS X 来做演示，然后我会给出几篇关于安装在linux 和 windows方法 的 blog。在 OS X 上，你需要先安装 [Growl](http://growl.info/) 然后安装 auto-fsevent 和 autotest-growl 两个gems。

	$ gem install autotest-fsevent -v 0.2.4
	$ gem install autotest-growl -v 0.2.16

如果fsevent安装除了问题的话 ，你最好检查一下 你机子上的 Xcode 是否正常工作。

要想使用Growl 和 FSEvent 的Gem ，你需要把Autotest 的配置文件放到你的工作文件夹的根目录下面。并且在按如下方法添加一些文件内容：

	$ mate .autotest

配置文件需要加入：

	require 'autotest/growl'
	require 'autotest/fsevent'

或者你可以加入：

	require 'autotest-growl'
	require 'autotest-fsevent'

（这个设置文件只对你当前的应用程序起作用，如果你想要让你的所有 ruby 和rails 项目共享这一配置，你可以把这个  <code> .autotest </code>放到你的个人文件根目录下面去）

	$ mate ~/.autotest

如果你实在Linux的Gnome的桌面系统之下的话。我建议你尝试一下 这里（[Automate Everything]）的东西[http://automate-everything.com/2009/08/gnome-and-autospec-notifications/].通过它可以让你在 linux 上面运行和 OS X 差不多的 Growl 提示。至于 Windows 用户 ，你们可以尝试安装
[Growl for Windows](http://www.growlforwindows.com/gfw/),然后跟着 [GitHub 的 autotest-growl页面](http://github.com/svoop/autotest-growl)来做。不管是linux还是windows的用户都应该看看[autotest-notification](http://github.com/carlosbrando/autotest-notification), Rails Tutorial 的读者 Fred Schoeneman 写了一篇[博文](http://fredschoeneman.posterous.com/pimp-your-autotest-notification)也很值得一看.

####3.2.2 TDD:红灯，绿灯，重构

对于测试驱动开发来说，我们通常会事先写一个失败的测试————失败意味着是不能通过。在我们这个例子当中，刚开始我们就会写一段验证：“应该会是 about page ”的页面测试代码，当然这个时候about页面没有出现，所以如果运行测试的就会失败。如果要想让测试通过，我们就应该加入和about页面对应的行为和视图。那为什么我们反过来做，先写功能，在做测试呢？这是为了保证我们确确实实加入了我们所需要的特性。在我刚开始使用 TDD 的时候，我先为我自己的程序中又那么多的错误感到惊讶，然后慢慢让测试出的错误消失，确保刚开始测试的失败然后再慢慢让它成功，我们就会慢慢对我们写出的代码更有信心。

还有一点非常重要，TDD并非任何时候都使用的，尤其是，当你对某个问题还没有个确切的解决方法的时候。这时候通常会先忽略测试而直接完成功能代码（在极限编程 XP 中，这种试探性的步骤叫做 spike ），而一旦你发现了一个确切的方法去解决这个问题之后，你就可以重新用TDD来更优雅实现一个新的版本。

“红，绿，重构 ”是在测试驱动开发中使用的方法，第一步：红，指的是写一个失败的测试，大部分测试工具会在这里以红色指出错误，第二步：绿，意味着测试通过，然后当我们的测试都成功通过之后我们就可以在不改变功能的条件下随意的重构我们的代码：删除重复，更改设计模式等等。

当然现在我们还什么颜色都没有，让我们先从红色开始把，RSpec（其他的测试工具也一样）在刚开始可能又一些吓人，我们这里先从 rails generate controller pages （Listing3.4） 开始。这里因为我不太喜欢把 views/helpers 分离出来测试（我觉得这样很多余），我们的第一步就是把他们移除掉。如果你在使用 Git ，你可以这么做：

	$git rm -r spec/views
	$git rm -r spec/helpers

然后我们再把文件也移除了：

	$ rm -rf spec/views
	$ rm -rf spec/helpers

在开始前，我们来看看我们刚刚建立的 Page 的Controller 的 spec

``` ruby spec/controllers/pages_controller_spec.rb
require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end
end

```

这是纯粹的Ruby代码，但是即使你学习过Ruby你恐怕也不能看明白这些东西是什么意思。这是因为RSpec为了测试专门为Ruby语言进行了扩展，用的是一种 “domain-specific-language”（DSL）语言，这种语言的特点就是你完全不知道它的语法也可以使用RSpec,刚开始这或许看起来会有点不可思议，但是没有关系，Rspec 测试脚本读起来基本就和英语一样，如果你已经做了前面的那些 generate 和 实例程序之后我想搞定它也不难。

上面的代码中包括了两个 <code> describe </code> 代码块，他们与我们的 example 一一对应，这里我们先来看看第一个 describe 是怎么回事。

``` ruby
  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end
```
在这里，第一行指出我们正在对于 HOME 页面进行一个 GET 操作，这仅仅是一个描述性的语句，你完全可以在这里写任何你想要的东西，RSpec不会在乎的（其他人类会在乎的）。在这里 GET ‘home’ 指的是测试 HOME 相对应的 HTTP GET 请求，如同 上面 BOX 3.1 中讨论的那样。然后 RSpec 说如果你你访问了 HOME 页面，应该能够成功返回。这里的第一行其实和测试行为完全不相干的，仅仅是是对人类读者的一种描述行记录。第三行 <code>get ‘home’</code> 在这里RSpec才真正开始干活了，这里RSpec会先提交一个 GET 请求，换一句话说，在此时RSpec相当于打开浏览器并且链到你的网页上，这个网页就是你的 ** /PAGES/HOME ** (RSpec之所以知道控制器是 PAGES 因为我们在做的是 PAGES CONTROLLERS 的测试，访问HOME 则是因为你明确告诉了它)。最后，第四行告诉它这个页面应该会成功的返回（也就是说他应该返回一个状态码 200 ）

>**Box 3.2 HTTP 返回码**


>在一个客户端（例如浏览器）发送了一个HTTP的动词请求的时候，网络服务器会在返回的时候加上一段数字代码来作为 HTTP 状态字。例如状态字 200 意味着 “成功”，状态字301 意味着 “静态跳转” ，如果你安装了 curl ，一个可以解析HTTP请求的命令行客户端，你就可以直接看到状态字。例如访问 <code> www.google.com </code>

>  $ curl --head www.google.com
>  HTTP/1.1 200 OK
>  .
>  .
>  .

>在这里谷歌就成功完成了你的请求并且返回了状态码 200 OK .同样， GOOGLE.com  会静态的跳转到 www.google.com 所以他会指向一条 301 的状态码 （301 跳转）

>  $ curl --head google.com
  HTTP/1.1 301 Moved Permanently
  Location: http://www.google.com/
  .
  .
  .
>(注意，这个范例将会随着你的国家不同而又很大差别。。。)

>当我们在RSpec 的测试文件里面写了 response.should be_success ，RSpec会识别出我们的应用返回了一个正确的 200代码。

现在是时候让我们的测试跑起来了。这里有几种不同的方法来运行测试（但是总体上大同小异）。第一种方法是在命令行里运行 rspec 脚本，像这样

	$ bundle exec rspec spec/
	....

	Finished in 0.07252 seconds

	2 examples, 0 failures

（不幸的事，很多事情可能让你在这个时候运行出 fail ，如果你中枪了，你可以尝试着用命令 “bundle exec rake db:migrate” 来 migrate 一下数据库。如果rspec还是不工作，那你恐怕就要重新卸载安装数据库了：

	$ gem uninstall rspec rspec-rails
	$ bundle install

如果这也不行你那你恐怕就要用 RVM 来重新卸载安装你的 gems 了：

	$ rvm gemset delete rails3tutorial
	$ rvm --create use 1.9.2@rails3tutorial
	$ rvm --default 1.9.2@rails3tutorial
	$ gem install rails -v 3.0.11
	$ bundle install

如果这也不行，那我也没办法了 -_- .)

当你运行了 <code>bundle exec rspec spec/</code> 的时候, rspec 是作为一个由Rspec提供的程序来运行的，而 spec/ 是一个你所需要测试的目录。你也可以 rspec 只运行测试一个目录下的文件例如这个例子就运行spec测试了 controller ：

	$ bundle exec rspec spec/controllers/
	....
	Finished in 0.07502 seconds

	2 examples, 0 failures

你甚至可以运行一个单独的文件

	$ bundle exec rspec spec/controllers/pages_controller_spec.rb
	....
	Finished in 0.07253 seconds

	2 examples, 0 failures

注意，在这里我们再一次运用了 bundle exec 来执行我们的命令（bundle exec 可以以Gemfile中指定的gems版本来执行命令），因为这样命令看起来有一点冗长，所以 Bundler 允许创建二进制的程序集例如这样：

	$ bundle install --binstubs

这样一来所有需要的gems执行程序都将会生成到 bin/ 文件夹下面去。我们现在就可以直接这样运行：$

	bin/rspec spec/

rake也一样：

	$ bin/rake db:migrate

对于不想这么做的朋友们，那么在将来的课程里你们恐怕需要都用 bundle exec 来运行这些特定的命令了（当然也可以选择这个简单些的办法.）

由于这个页面控制器目前是我们唯一的测试文件，所以这三个命令应该输出都是一样的。在剩下的教程里面，我们不会把运行test的命令行打出来，但是你自己要知道用bundle exec rspec spec/ （或者其他的东西），或者自己用autotest之类的东西。

如果你安装了 Autotest 你可以自动进行的RSpec测试：

	$ autotest

如果你用的是 Mac 的 Growl 测试工具，你可以向我一样，如下图一样，autotest在后台运行，Growl 会提醒你当前测试的状态，这样用 TDD 是会上瘾的。 

![autotest](http://ruby.railstutorial.org/images/figures/autotest_green.png)

####Spork

在前面的例子里你可能已经注意到了，用这样的套件运行一次测试非常的慢（the overhead involved in running a test suite can be considerable.不知道是不是这意思）。这是因为每次运行RSpec来进行一次测试都会 Reload 一次 Rails 环境。Spork test server 就是针对这个问题产生的。





