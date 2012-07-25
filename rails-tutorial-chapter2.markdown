翻译 [ruby on rails Tutorial](http://ruby.railstutorial.org/chapters/a-demo-app#top),原作者 [Michael Hartl](http://michaelhartl.com/) .


###第二章

##示例程序

在这一章里面，我们将会开发一个演示性的程序来展示 Rails 的强大。目的是为了能够从比较高的层面上理解如何通过 Ruby on Rails 的 scaffold generators 功能进行 rails 敏捷开发。在上一章的推荐书目中，有的书运用了相反的方法，通过一点点的增加新功能开发一个完整的应用程序，同时解释相关的概念。但是在我们的这个实例程序中，脚手架（scaffold）功能是无可替代的，它将迅速而全面的通过 URLs 来让我们了解rails的组成结构和 REST 特性。

这个示例程序完成了用户和与用户关联的微博（像是超级简化的twitter）。由于这个程序用到的功能隐藏了许多细节，所以这里很多步骤可能会看起来像是魔法，但是别担心，我们会从第三章开始从底层开发一个类似的应用，保证会让你能学到rails最重要的特性的。所以现在，就请乖乖的从这里开始学习Rails，制作我们这章的， 超酷脚手架驱动（superficial, scaffold-driven ）应用吧。

###2.1 计划整个应用程序

在这里我们先跳出我们的示例程序，和1.2.3节中一样，我们要用rails命令来建立一个rails的基本框架：

	$ cd ~/rails_projects
	$ rails new demo_app
	$ cd demo_app

然后如同 2.1节，我们用文本编辑器来更改Gemfile：

	source 'http://rubygems.org'

	gem 'rails', '3.0.11'
	gem 'sqlite3', '1.3.3'

我们接着安装被包括到Gemfile中的 bundle

	$ bundle install

最后我们新建一个Git仓库并做一次确认

	$ git init
	$ git add .
	$ git commit -m "Initial commit"

![Creating a demo app repository at GitHub. ](http://ruby.railstutorial.org/images/figures/create_demo_repo.png)

	$ git remote add origin git@github.com:<username>/demo_app.git
	$ git push origin master

现在我们就已经做好了准备工作了，对于建立一个网络应用程序通常我们会先建立一个数据库模型来展现出这个应用的数据结构。对于我们来说，这个实例程序只有简单的一层关系：每个用户拥有许多微博。所以我们会先建立用户模型，然后为用户模型添加微博。
<!--more-->
####2.1.1 用户模型

user不用的结构对应着在页面上会有不同的表格，我们用最简单的结构来创建User model，它有一个唯一的int类型的主键，id，和一个公共可见的名字，string类型，和一个email地址，可以看做用户的第二用户名。所以，user的数据模型如下图2.2所示，

![user model](http://dl.iteye.com/upload/attachment/367717/04b466eb-0d36-36ba-84b5-96c28ee04ac8.png)

图2.2

我们将在6.1.1节中学到，上表中的Users标签，代表着在数据库中的一个users表，上表的属性就是它的字段。

####2.1.2 微博模型


micropost的数据模型比user的更简单，它只有一个id和一个string类型的content来代表发言的内容。有一个附加的关系，我们希望将micropost和特定的user联系起来，我们可以可以添加一个user_id来记录post的所有者，这样，micropost的最终结果如图2.3所示，

![microposts model](http://dl.iteye.com/upload/attachment/367723/52b778a4-8e43-3074-b2c5-3d0738495adc.png)

\  											图2.3

我们可以在2.3.3节（更详细的在第11章）中找到user_id的属性如何可以让我们更简单的表达user和micropost之间一对多的关系。

###2.2用户资源

在这一节，我们将实现2.1.1节中User数据模型的网络接口。通过这个网络接口和模型的组合，使我们可以通过HTTP协议来实现对user资源的CRUD（添加，查询，更新，和删除）
简介里面提到的，我们的User资源将会通过脚手架生成器（Scaffold generator）来产生。脚手架生成器是每一个Rails项目的标配；scaffold的参数是要产生的资源名称，在这里是User，后面可以的可选参数，可以使数据模型的属性和类型。

``` bash
    $ rails generate scaffold User name:string email:string
          invoke  active_record
          create    db/migrate/20100615004000_create_users.rb
          create    app/models/user.rb
          invoke    test_unit
          create      test/unit/user_test.rb
          create      test/fixtures/users.yml
           route  resources :users
          invoke  scaffold_controller
          create    app/controllers/users_controller.rb
          invoke    erb
          create      app/views/users
          create      app/views/users/index.html.erb
          create      app/views/users/edit.html.erb
          create      app/views/users/show.html.erb
          create      app/views/users/new.html.erb
          create      app/views/users/_form.html.erb
          invoke    test_unit
          create      test/functional/users_controller_test.rb
          invoke    helper
          create      app/helpers/users_helper.rb
          invoke      test_unit
          create        test/unit/helpers/users_helper_test.rb
          invoke  stylesheets
          create    public/stylesheets/scaffold.css

```

命令后面跟上 name：string 和email：string，可以让我们在rails自己产生的页面表单中有这2个数据模型的属性。如图2.2，提示，在命令中没必要添加属性id，因为他会被rails自动创建。
程序的第一步，我们应该使用rake运行数据库迁移，如下：

``` bash

    $ rake db:migrate
    ==  CreateUsers: migrating ====================================================
    -- create_table(:users)
       -> 0.0017s
    ==  CreateUsers: migrated (0.0018s) ===========================================

```
就这样非常简单的更新了数据库，我们创建了一个新的users数据模型，我们将会在6.1.1节中学习数据库迁移migrations。
（如果大家的数据库是空的，或者程序新建的话，先运行 rake db：create，他会创建开发环境和测试环境的数据库）
之后我们可以通过命令 rails s（rails server的简写）来启动服务器，
（该命令也可以带参数，可以设置启动的服务器，默认启动的是WEBrick，也可以设置启动的环境，默认是开发环境）

``` bash
    $ rails s
    => Booting WEBrick
    => Rails 3.0.3 application starting on http://0.0.0.0:3000
    => Call with -d to detach
    => Ctrl-C to shutdown server
```

我们可以在 http://localhost:3000/上看到我们的演示程序。

**Box 2.1**
>**Rake**         :
>在Unix系统上，make工具在执行源代码上有着非常重要的作用，非常多的电脑黑客输下面的代码输到不用大脑了。。。（可以这样翻译吧。。。muscle memory）
>	$ ./configure && make && sudo make install
>通常这个使用与在unix（包括linux和Mac OS X）底下编译源码；

rake可以说是ruby的make工具,他是用ruby写的类似make的语言或者说是工具；rake在rails里的运用非常广泛，特别是在开发有数据库支持的web程序中用于大量小任务的管理；
rake db:migrate命令可能是最经常使用到的，但是这只是其中之一，你可以运行
	$ rake —T db
的命令来查看rake命令中关于数据库的小任务；
	$ rake —T
可以查看所有可用的任务；
出现的列表可能让人觉得恶心，但是不要担心，现在你不必要知道列表中所有项（或者大部分）的意思，学完本书后，你会知道里面所有重要的任务项.

####2.2.1 用户模块开发


打开项目的根目录，http://localhost:3000/ 将会如图1.3（第一章的图。我挪过来了）所示的显示rails默认的根目录，

![pic](http://dl.iteye.com/upload/attachment/367806/d7bba2bc-be01-3135-a5c6-441712dc19fb.png)

\									图1.3

在生成User的资源的时候，我们也创建了很多的页面，用于操作这个用户；
例如，用于列出所有用户的 “/users”页面，用于创建新用户的“/users/new”页面等，
本节剩下的部分会用来快速的访问并解说这些页面，随着我们的进行，我们可以把页面和URL的关系列在下表中，

<br>
<table class="bbcode"><tbody><tr><td>URL</td><td>	Action</td><td>	Purpose</td></tr><tr><td>/users	</td><td>index	</td><td>page to list all users</td></tr><tr><td>/users/1</td><td>	show	</td><td>page to show user with id</td><td> </td></tr><tr><td>/users/new</td><td>	new&nbsp;&nbsp;&nbsp;&nbsp; </td><td>page to make a new user</td></tr><tr><td>/users/1/edit</td><td>	edit&nbsp;&nbsp;&nbsp; </td><td>page to edit user with id </td></tr></tbody></table>

<br>Table 2.1: 用户资源和URL之间的关系对照

我们从列出所有用户的index 页面开始吧，和你想的一样，一开始是什么都没有，如图2.4所示，

![pict](http://dl.iteye.com/upload/attachment/368100/9187441f-a73a-367b-b2e6-e1ba2b5cd785.png)

\								图2.4    初始状态下的index页面(/users).


我们通过"users/new"页面来创建新的用户，如图2.5所示

![pic](http://dl.iteye.com/upload/attachment/368103/e2c436e2-53d1-3518-a4e2-53c6a9c13506.png)

\								图 2.5: 创建用户页面 (/users/new).

我们可以在页面中输入用户name和email的值，然后点击Create按钮。
成功之后呢会跳向show页面，如图2.6所示，（绿色的欢迎信息是成功创建后flash的信息，我们将在8.3.3中学习它）

![pic](http://dl.iteye.com/upload/attachment/368106/eb735daa-d41b-3ca0-ae7f-78a6efd77ad4.png)

\								图2.6，显示一个用户信息的页面(/users/1)


注意此时的URL是 “/users/1”，你可能想到，那个1个就是代表图2.2中用户的id属性。
在7.3节中，这个页面就会变成用户的详细信息页。
我们通过访问edit页面来修改用户信息，如图2.7所示，我们修改信息后点击更新按钮。在演示程序中，我们可以修改用户信息，我们将在第六章中详细的介绍，这些用户的信息是被存储在数据库中的。我们将会把添加编辑用户的功能加入第10.1节的示范程序中。

![picc](http://dl.iteye.com/upload/attachment/368170/2cce9343-7ec9-367f-8963-2a103139a9ff.png)

\								  图2.7 用户编辑页面(/users/1/edit).

![pic](http://dl.iteye.com/upload/attachment/368179/89b60b5b-537a-3ef9-a146-bb217c4916e8.png)

\							     图2.8 用户更新成功页面.


现在我们可以通过new页面填入和提交信息再创建一个用户；所以，在index页面中就会如下图2.9所示。在第10.3节中巍峨哦门将开发一个更精致index页面来列出所有用户。

![pic](http://dl.iteye.com/upload/attachment/368179/89b60b5b-537a-3ef9-a146-bb217c4916e8.png)

\							图2.9 加入了第二个用户的index页面(/users).

在演示了如何创建，显示，修改单个用户之后，我们将要看看如何删掉他们。你必须验证下图中用于删除第二个用户的链接是正确的。如果它不能使用，首先应该保证你的浏览有把javascript打开，Rails用JavaScript来发送删除用户的请求的。
我们将会把添加删除用户的功能加入到第10.4节的示例程序。在一个管理用户的类中小心的使用它。
![pic](http://dl.iteye.com/upload/attachment/368196/01cf1ae1-3a89-38e5-800b-a36db253baf0.png)

\							图2.30 删除一个用户


####2.2.2 上节操作的MVC应用

现在我们基本完成了用户资源，让我们用一个过程来讲述第1.2.6中提到的MVC模式，这个模式可以只是浏览器上普通的一次点击。例如访问user的index页面“/users”;

![pic](http://dl.iteye.com/upload/attachment/368202/23d6b46a-2b50-3cda-8352-732936b18ccc.png)


\				       图2.11，Rails中MVC的详细图解


\						上表中步骤对应：


1.The browser issues a request for the /users URL.    浏览器发送请求/users
2.Rails routes /users to the index action in the Users controller.    Rails的路由组建分析它为对应users 控制器，index 的方法。
3.The index action asks the User model to retrieve all users (User.all).    index通过User.all方法请求用户模型查找所有的用户。
4.The User model pulls all the users from the database.    User模型从数据库提取出所有需要的用户。
5.The User model returns the list of users to the controller.    User模型返回用户列表给控制器。
6.The controller captures the users in the @users variable, which is passed to the index view.    控制器将这些用户注入@users的类变量中。该变量将会被传到视图中使用。
7.The view uses Embedded Ruby to render the page as HTML.    视图利用内嵌的ruby代码来产生HTML文件；
8.The controller passes the HTML back to the browser.7    控制器将HTML传回浏览器

我从浏览器（如IE）的地址栏出入URL或者点击一个链接开始发出一个请求，这个请求将会先会请求rails的“路由器router”，路由器将会基于URL选择目标控制器和ACTION（在BOX3.1中我将看到请求的方法。）。下表中的代码会为用户资源创建一个URL到控制器action的映射，这些代码会创建如前面表2.1所示的那样URL/action 对应关系。

*Listing 2.2. Rails的映射Users 资源的路由.*


``` ruby  config/routes.rb

   DemoApp::Application.routes.draw do
      resources :users
      .
      .
      .
    end

```

在第2.2.1中的页面对应了User控制器中的各个action。控制器是由Rails的scaffold生成器生产的，结构如listing 2.3所示。

提示， class UsersController \< ApplicationController 的写法是Ruby中类继承的写法。（我们将会在第2.3.4中简短的介绍继承，在第4.4中详细介绍。）

####Listing 2.3. Users控制器示意图。



``` ruby app/controllers/users_controller.rb
    class UsersController < ApplicationController

      def index
        .
        .
        .
      end

      def show
        .
        .
        .
      end

      def new
        .
        .
        .
      end

      def create
        .
        .
        .
      end

      def edit
        .
        .
        .
      end

      def update
        .
        .
        .
      end

      def destroy
        .
        .
        .
      end
    end
```
###2.3Microposts资源

在生成和探索了Users资源之后，让我们转过来看看另一个相关资源——Microposts。
在这一节中，我建议对比一下2个资源中相似的元素。你会看到2个资源之间会有很多地方都是相同的。Rails程序的RESTful结构是这种重复结构最好的实现方式。的确，研究这种Users和Microposts资源早期的重复结构也是本章最初的动机。（我们将会明白写一个健壮的toy programe程序需要耗费相当多的精力、我将会在第11章再次见到microposts资源——其实我不想隔那么久。。。）。

####2.3.1 Microposts初步探索


和Users资源一样，我们先用Rails generate Scaffold创建Microposts资源的基本结构（Scaffold脚手架），如图2.3所示的那样，我们也创建了数据模型。

``` bash

    $ rails generate scaffold Micropost content:string user_id:integer
          invoke  active_record
          create    db/migrate/20100615004429_create_microposts.rb
          create    app/models/micropost.rb
          invoke    test_unit
          create      test/unit/micropost_test.rb
          create      test/fixtures/microposts.yml
           route  resources :microposts
          invoke  scaffold_controller
          create    app/controllers/microposts_controller.rb
          invoke    erb
          create      app/views/microposts
          create      app/views/microposts/index.html.erb
          create      app/views/microposts/edit.html.erb
          create      app/views/microposts/show.html.erb
          create      app/views/microposts/new.html.erb
          create      app/views/microposts/_form.html.erb
          invoke    test_unit
          create      test/functional/microposts_controller_test.rb
          invoke    helper
          create      app/helpers/microposts_helper.rb
          invoke      test_unit
          create        test/unit/helpers/microposts_helper_test.rb
          invoke  stylesheets
       identical    public/stylesheets/scaffold.css

```

你可能注意到了，在这个控制器中已经有几个action存在。Index，show，new，和edit等几个action对应第2.2.1中提到的页面，但是同时还有附加的create，update和destroy三个方法，通常这三个方法是不会去产生页面（并不绝对），相反，他们的主要作用是去修改数据库中User的信息。如表2.2所示，这基本是一个控制器的所有action，表中还显示了，Rails的REST运用。从表中看，有的URL是重复的，例如，控制器的show和update方法对应URL：“/users/1”，不同之处只是两者之间响应的HTTP请求方式不同。我们将在第3.2.2中详细学习HTTP请求方式。

<br><table class="bbcode"><tbody><tr><td>HTTP 请求方式</td><td>	URL</td><td>	Action</td><td>	目的</td></tr><tr><td>GET</td><td>	/users	</td><td>index	</td><td>请求一个用于列出所有用户的页面</td></tr><tr><td>GET</td><td>	/users/1	</td><td>show	</td><td>请求显示id为1的用户的页面</td></tr><tr><td>GET</td><td>	/users/new</td><td>new	</td><td>请求创建用户的页面</td></tr><tr><td>POST</td><td>	/users	</td><td>create	</td><td>根据前面表单中的信息，向数据库创建用户</td></tr><tr><td>GET</td><td>	/users/1 </td><td>edit	</td><td>请求编辑id为1的用户的页面</td></tr><tr><td>PUT</td><td>	/users/1 </td><td>update	</td><td>将更新的信息更新到数据库</td></tr><tr><td>DELETE</td><td>	/users/1	</td><td>destroy	</td><td>删除数据库中id为1的用户</td></tr></tbody></table>


\		表2.2 Listing 2.2 中提供的用户资源的RESTful架构的路由

>BOX 2.2
>**REpresentational State Transfer (REST)表述性状态转移**
>如果你阅读了很多关于Ruby on Rails的阅读材料，你就会发现有很多地方提到“REST”（表述性状态转移的简写）REST是一种开发分布式应用例如网络应用程序例如web程序的一种架构。
>REST原始的很抽象的，具体到Rails下的REST应用就是指大部分程序的组件（例如上文的users,microposts）都是可以视为资源，都是可以被创建，读取，更新和删除，这几>个动作就是关系数据库常说的CRUD操作和四个基本的HTTP请求方式：POST，GET，PUT和删除。（我们将在第3.2.2，特别是Box3.1更详细的学习）；

作为一个Rails运用程序的开发人员来说，RESTful的开发方式有助于知道写哪个控制器和哪个action，你可以使用资源的CRUD构造程序的简单结构。在上面的users，microposts中，只要他们是你权限范围内的资源，你都可以直接的CRUD。在12章中，我们将看到一个例子，REST原则允许我们自然方便地塑造一个微妙的问题，“following users”。

检查user控制器和user模型之间的关系，让我们来看看精简版本的index 方法（action翻译成方法。）吧。如下代码2.4（listing 翻译成代码。前面的就不去改了）

**代码2.4 演示程序中user简化版的index方法**

``` ruby
class UsersController < ApplicationController
  def index
    @users = User.all
  end
  .
  .
  .
end
```

在index方法中有 @users = User.all，这是告诉User模型去数据库检索出所有的用户，并把值赋给@users变量（发音“at-users”），User模型的代码如下2.5所示。尽管他非常的简单，但是它却有着非常牛B的功能，因为它继承了那个东西（可见2.3.4节和4.4）。特别是，因为使用Rails的Actuve Record库，下面的代码已经可以接受User.all来返回所有的用户了。

**代码2.5. 演示程序的user模型**

``` ruby app/models/user.rb
    class User < ActiveRecord::Base
    end
```

一旦@users被定义（赋值）之后，控制器就可以条用视图（View），如代码2.6。以“@”符号开始的变量成为类变量，可以自动的在视图中调用，在这里，index.html.erb（代码2.6）中的游标将会遍历@users数组变量然后为每一项输出一串HTML代码。

**代码2.6. 用户index的视图(现在你不明白没关系。)**


``` ruby app/views/users/index.html.erb
    <h1>Listing users</h1>

    <table>
      <tr>
        <th>Name</th>
        <th>Email</th>
        <th></th>
        <th></th>
        <th></th>
      </tr>

    <% @users.each do |user| %>
      <tr>
        <td><%= user.name %></td>
        <td><%= user.email %></td>
        <td><%= link_to 'Show', user %></td>
        <td><%= link_to 'Edit', edit_user_path(user) %></td>
        <td><%= link_to 'Destroy', user, :confirm => 'Are you sure?',
    :method => :delete %></td>
      </tr>
    <% end %>
    </table>

    <br />

    <%= link_to 'New User', new_user_path %>
```
这个视图将会被转换成HTML然后传回给浏览器，显示给用户。

####2.2.3 当前用户资源的缺陷


初步了解了Rails生成用户资源的优势之后，我们也该知道，他目前存在着不少的缺陷；

* 没有数据验证：模型接受一些非法的数据，例如空名字，不合法的email地址等。没有反馈
*  没有认证：没有登录/退出的概念，这样我们就没办法阻止随便一个用户操作某些操作。
* 没有测试：其实这不是非常准确，因为scaffolding会自己产生一些测试，但是生成的测试难看且死板，他们不会测试上面说的那2点或者其他用户自定义的一些需求。
 * 没有布局：没有一致的网站风格和导航。
* 还没有正理解：其实你要是真的理解了scaffold的代码，你或许就不会来看这本书。

###2.3 Microposts资源

在生成和探索了Users资源之后，让我们转过来看看另一个相关资源——Microposts。
在这一节中，我建议对比一下2个资源中相似的元素。你会看到2个资源之间会有很多地方都是相同的。Rails程序的RESTful结构是这种重复结构最好的实现方式。的确，研究这种Users和Microposts资源早期的重复结构也是本章最初的动机。（我们将会明白写一个不是toy programe的健壮程序需要耗费相当多的精力、我将会在第11章再次见到microposts资源——其实我不想隔那么久。。。）。

####2.3.1 Microposts初步探索


和Users资源一样，我们先用Rails generate Scaffold创建Microposts资源的基本结构（Scaffold脚手架），如图2.3所示的那样，我们也创建了数据模型。

``` bash
    $ rails generate scaffold Micropost content:string user_id:integer
          invoke  active_record
          create    db/migrate/20100615004429_create_microposts.rb
          create    app/models/micropost.rb
          invoke    test_unit
          create      test/unit/micropost_test.rb
          create      test/fixtures/microposts.yml
           route  resources :microposts
          invoke  scaffold_controller
          create    app/controllers/microposts_controller.rb
          invoke    erb
          create      app/views/microposts
          create      app/views/microposts/index.html.erb
          create      app/views/microposts/edit.html.erb
          create      app/views/microposts/show.html.erb
          create      app/views/microposts/new.html.erb
          create      app/views/microposts/_form.html.erb
          invoke    test_unit
          create      test/functional/microposts_controller_test.rb
          invoke    helper
          create      app/helpers/microposts_helper.rb
          invoke      test_unit
          create        test/unit/helpers/microposts_helper_test.rb
          invoke  stylesheets
       identical    public/stylesheets/scaffold.css
```

如第2.2节，我们需要运行数据库迁移migration来更新数据库并添加新的数据模型。
``` bash
    $ rake db:migrate
    ==  CreateMicroposts: migrating ===============================================
    -- create_table(:microposts)
       -> 0.0023s
    ==  CreateMicroposts: migrated (0.0026s) ======================================
```

我们已经如第2.2.1节创建Users那样创建了Microposts。你或许猜到了，Scaffold 生成器也为Microposts更新了Rails的routes文件。如代码2.7。 和Users一样， 代码:“resources:microposts”的路由规则映射了URL和对应的Microposts控制器方法。如表2.3所示。

*代码2.7 新增了Microposts资源的Rails路由*

``` ruby config/routes.rb
    DemoApp::Application.routes.draw do
      resources :microposts
      resources :users
      .
      .
      .
    end
```

<br><table class="bbcode"><tbody><tr><td>HTTP request</td><td>	URL</td><td>	Action</td><td>	Purpose</td></tr><tr><td>GET</td><td>	/microposts</td><td>	index</td><td>	page to list all microposts</td></tr><tr><td>GET</td><td>	/microposts/1</td><td>	show</td><td>	page to show micropost with id 1</td></tr><tr><td>GET</td><td>	/microposts/new</td><td>	new</td><td>	page to make a new micropost</td></tr><tr><td>POST</td><td>	/microposts</td><td>	create</td><td>	create a new micropost</td></tr><tr><td>GET</td><td>	/microposts/1/edit</td><td>edit</td><td>	page to edit micropost with id 1</td></tr><tr><td>PUT</td><td>	/microposts/1</td><td>	update</td><td>	update micropost with id 1</td></tr><tr><td>DELETE</td><td>	/microposts/1</td><td>	destroy</td><td>	delete micropost with id 1</td></tr></tbody></table>



*表2.3 代码2.7中，microposts资源提供的RESTful路由。*

Microposts控制器示意代码如代码2.8所示。和代码2.3相比，除了用icropostsController替换掉UsersController之外基本一样，这是RESTful架构在2者只运用的体现。


*代码2.8，Microposts的示意代码*

``` ruby app/controllers/microposts_controller.rb
    class MicropostsController < ApplicationController

      def index
        .
        .
        .
      end

      def show
        .
        .
        .
      end

      def new
        .
        .
        .
      end

      def create
        .
        .
        .
      end

      def edit
        .
        .
        .
      end

      def update
        .
        .
        .
      end

      def destroy
        .
        .
        .
      end
    end
```

让我们在“/microposts/new”页面添加一些实际的microposts（微博），如图2.12

![pic](http://dl.iteye.com/upload/attachment/369972/05fd9922-276e-39eb-992f-71eb189f1162.png)

\						图2.12 添加微博的页面（/microposts/new）

就这样子，建立一两条微博，注意user_id为1是为了对应在2.2.1节中建立的第一个用户。结果如2.13图所示

![pic](http://dl.iteye.com/upload/attachment/369978/cc2087d7-e57c-37d8-9aea-f923778d8d5f.png)

\					图2.13 Microposts的index页面（/microposts）

####2.3.2 给微博真正的“微”


任何敢叫微博的帖子要对得起他的称呼就要意味着要限制他的长度。要实现这个约束条件在Rails中是非常容易——使用模型验证（validations of rails）。我们可以使用length这个验证条件来限制微博的最大长度为140个字符（学习 Twitter）。你需要用你的IDE或者文本编辑器打开app/models/micropost.rb填入如代码2.9所示的代码（这个验证的使用是rails3的特性，如果你之前有使用Rails2.3.X版本，你可以对比一下“validates_length_of”的用法）。
代码2.9 约束微博最大字符长度为140。

``` ruby app/models/micropost.rb
    class Micropost < ActiveRecord::Base
      validates :content, :length => { :maximum => 140 }
    end
```

代码2.9看起来很神秘，不过不要紧,我们将在6.2节中学习更多的验证，但是如果我们回到New页面然后输入超过140个字符的微博就会发现他的影响已经出来了；Rails会渲染错误的信息并提示微博的内容过长（我们将在第8.2.3中学习更多的错误。）。

![p](http://dl.iteye.com/upload/attachment/369988/7a511f79-f186-36d6-a3d7-73903ceeef16.png)

图2.14：创建微博失败的错误信息

####2.3.3 一个user可以有多条微博
在两个不同的数据模型中创建关系是Rails最强大的功能之一。这里，用户模型中，每一个用户都可以多条的微博信息，我们可以如代码2.10和2.11那样更新User和Microposts模型的代码；

**代码 2.10. 一个user可以有多条微博信息microposts**


``` ruby app/models/user.rb
    class User < ActiveRecord::Base
      has_many :microposts
    end
```

**代码 2.11 每一条微博信息都是属于某一个用户的**

``` ruby app/models/micropost.rb
    class Micropost < ActiveRecord::Base
      belongs_to :user

      validates :content, :length => { :maximum => 140 }
    end
```

我们可以想象以上的关系就如图2.15所示。因为microposts表中有user_id的字段，Rails（使用Active Record）可以猜测出微博信息microposts和用户的关系

![pic](http://dl.iteye.com/upload/attachment/369992/c4c778f3-2b27-30c9-94e5-9cc21b404060.png)

**图 2.15： 微博信息microposts和用户users之间的关系**

在第11，12章中，我们将用这2者间的关系来显示所有用户的microposts信息和构建一个和Twitter类似的微博提要（microposts feed）。现在我们通过Rails的控制台（console）来验证user和microposts之间的关系，控制台是一个非常有用的工，他可以使我们和Rails程序之间进行交互。我们先从命令行输入“rails console”进入控制台，然后使用User.first从数据库检索出第一个user（将 结果赋值给变量first_user）；

``` bash
    $ rails console
    >> first_user = User.first
    => #<User id: 1, name: "Michael Hartl", email: "michael@example.org",
    created_at: "2010-04-03 02:01:31", updated_at: "2010-04-03 02:01:31">
    >> first_user.microposts
    => [#<Micropost id: 1, content: "First micropost!", user_id: 1, created_at:
    "2010-04-03 02:37:37", updated_at: "2010-04-03 02:37:37">, #<Micropost id: 2,
    content: "Second micropost", user_id: 1, created_at: "2010-04-03 02:38:54",
    updated_at: "2010-04-03 02:38:54">]
```

这样我们通过first_name.microposts获得了用户的微博信息：运行这个代码，Active Record 会自动返回所有user_id等于first_name的id（这里是1）。
我们将在11,12章中学习ActiveRecord的更多关联结构。

####2.3.4 继承的层次结构

我们结束关于演示程序的讨论，我们花点时间，简短的介绍一下Rails中控制器类和模型类的继承问题。这个介绍只有在你有面向对象编程经验的时候才会有较多的意义。如过你还没学习OOP，大可以跳过这一节，特别是，你对类（在第4.4节中讨论）很不了解的时候，我建议在以后的时间跳回来看这一节。
我们先从模型的继承结构开始。对比代码2.12和代码2.13，我们可以看到，User和Micropost两个模型都从ActiveRecord：：Base类继承（通过尖括号“<”）。
ActiveRecord：：Base类是ActiveRecord提供的模型的基类。图2.16总结了这种关系；正式由于这种继承使我们的模型可以喝数据库交互，也可以将数据表的字段当成Ruby的属性对待，等等特性。

**代码 2.12 继承的User类**

``` ruby app/models/user.rb
    class User < ActiveRecord::Base
      .
      .
      .
    end
```

**代码 2.13 继承的Micropost类**

``` ruby app/models/micropost.rb
    class Micropost < ActiveRecord::Base
      .
      .
      .
    end

```

![pic](http://dl.iteye.com/upload/attachment/370008/2119f47d-4fa9-3c59-9707-4a25863846b9.png)


控制器继承的层次结构较复杂一点。对比代码2.14和代码2.15，我们可以看到两个控制器都从ApplicationController。从代码2.16中可以看到ApplicationController自己继承自ApplicationController::base;这个是Rails的Acton Pack 库提供给控制器的基类，类之间的关系如图2.17所示。


**代码 2.14. UsersController继承自ApplicationController.**

``` ruby app/controllers/users_controller.rb
    class UsersController < ApplicationController
      .
      .
      .
    end
```


**代码 2.15. MicropostsController 继承自ApplicationController.**

``` ruby app/controllers/microposts_controller.rb
    class MicropostsController < ApplicationController
      .
      .
      .
    end
```

```ruby app/controllers/application_controller.rb
    class ApplicationController < ActionController::Base
      .
      .
      .
    end
```

![pic](http://dl.iteye.com/upload/attachment/370012/d53669cd-bc2a-3da3-91ad-6eb7e004518a.png)


\  						图 2.17: Users和Microposts控制器的继承结构.

就和模型的继承一样，因为最终都继承自 ActionController::Base ，Users和Microposts的控制都获得大量的功能，比如操作模型对象，过滤收到的请求和渲染HTML页面。因为所有的控制都继承自ApplicationController，所以所有定义在Application Controller 里面的规则都会被自动的运用到所有的方法（action）中去；例如在8.2.4节中我们将看到如何在Application controller中定义一个允许我们从所有的Rails 日志文件中过滤掉密码的规则，这样可以避免一些安全隐患。


####2.3.5 部署演示程序
我们完成了Microposts资源，现在正是我们把他push到GitHub库的时候；

``` bash
    $ git add .
    $ git commit -a -m "Done with the demo app"
    $ git push
```


你也可以把演示程序部署到Heroku：

``` bash
    $ heroku create
    $ git push heroku master
    $ heroku rake db:migrate
```


（如果上面的没有效果，你可以看看前面代码1.8，或许对你有帮助。）
请注意这里在heroku运行数据库迁移的最后一行代码，这是只是在heroku上创建user/micropost的数据模型。如果你希望吧数据也上传，你可以使用 data up命令。前提是你有taps这个gem：

``` bash
    $ [sudo] gem install taps
    $ heroku db:push
```



2.4 总结
现在我们站在一个Rails 程序30000英尺远的地方观察他，这一章中按这个方法开发的演示程序有一些优势和一些主机缺点（不明白什么意思， a host of weaknesses。）

优势

* High-level overview of Rails 	高水平的Rails概述

* Introduction to MVC    介绍了MVC

* First taste of the REST architecture    第一次尝试REST架构

* Beginning data modeling    开始数据建模

* A live, database-backed web application in production    制作了一个在线的数据库支持的Web程序


弱点

* No custom layout or styling    没有布局或者样式

* No static pages (like “Home” or “About”)    没有静态页面，比如首页

* No user passwords    用户没有密码

* No user images     用户没有图片

* No signing in     没有登录

* No security     不安全

* No automatic user/micropost association    没有自动关联user/micropost

* No notion of “following” or “followed”    没有 “following” or “followed”的概念.

* No micropost feed    没有微博提要

* No test-driven development    没有测试驱动

* No real understanding    还没弄明白

