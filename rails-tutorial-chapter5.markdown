
[第五章 布局](filling-in-the-layout#top)
============================================================

经过简单的第四章 Ruby 语言的学习之后,我们掌握了在程序中引入布局文件的技巧，但是目前这个布局文件还是空的。在这一章节，我们将要通过使用 *Bootstrap* 框架来对自定义我们的网页布局。我们还要构建出网站中所需要元素和链接，而在这期间，我们将会学会 partial, routes , 和asset pipeline ,同时还会介绍 Sass。
我们同时还要运用最新的Rspec技术重构第三章的测试.在本章的最后，我们将会实现第一个重要功能：用户注册.

[5.1 布局结构](filling-in-the-layout#sec-structure)
----------------------------------------------------------------

*Rails Tutorial* 是一本关于WEB开发的书，并非WEB设计，但是如果一整个应用程序之中都没有网页的设计将会让我们的成果显得很烂，也会让自己觉得很失败。所以我们在这一章节我们需要用上一点点的CSS技术，为了让我们能更轻松地上手使用CSS进行Web设计开发，我们使用了[Bootstrap](http://twitter.github.com/bootstrap/),一个又Twitter开源的web设计框架我们将会给我们的代码加上一些不同的风格，我们还要用上 partials 来然我们的布局代码显得更加简洁紧凑。

一般来说，当你开发web应用的时候，如果事先越早从较高的层次上想好自己要写的应用越好。所以在剩下的书中，我们将会使用 *mockups* (和 *wireframes* 差不多，就是网络线框图 ), 的方法对应用进行开发。在这一章，我们主要将开发我们在 3.1 中说过的静态页面，包括网站logo，导航栏，和网站的页脚。于是我们事先已经对我们的作品作出一个 mockup 设计：
[Figure 5.1](filling-in-the-layout#fig-home_page_mockup).你可以在这里看到最终结果[Figure 5.7](filling-in-the-layout#fig-site_with_footer).你或许会发现他们之间有着一些细节的差别--例如我们在最后加上了Rails的logo，但是没关系，Mockup 不需要太精确。


![home\_page\_mockup\_bootstrap](/images/figures/home_page_mockup_bootstrap.png)

Figure 5.1: A mockup of the sample application’s Home page. [(full
size)](http://railstutorial.org/images/figures/home_page_mockup_bootstrap-full.png)

和平常一样，如果你使用了Git作为版本管理工具那么现在是时候开始再建立一个新的分支了：

    $ git checkout -b filling-in-layout

### [5.1.1 Site navigation](filling-in-the-layout#sec-adding_to_the_layout)

和我们在示例应用中做过的一样，我们先要更改网站的模板文件 `application.html.erb`，其中包含了你的 HTML 文件的大体框架。还有你的CSS和JS文件。全文如下：


Listing 5.1. The site layout with added structure. \
`app/views/layouts/application.html.erb`

    <!DOCTYPE html>
    <html>
      <head>
        <title><%= full_title(yield(:title)) %></title>
        <%= stylesheet_link_tag    "application", media: "all" %>
        <%= javascript_include_tag "application" %>
        <%= csrf_meta_tags %>
        <!--[if lt IE 9]>
        <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
      </head>
      <body>
        <header class="navbar navbar-fixed-top navbar-inverse">
          <div class="navbar-inner">
            <div class="container">
              <%= link_to "sample app", '#', id: "logo" %>
              <nav>
                <ul class="nav pull-right">
                  <li><%= link_to "Home",    '#' %></li>
                  <li><%= link_to "Help",    '#' %></li>
                  <li><%= link_to "Sign in", '#' %></li>
                </ul>
              </nav>
            </div>
          </div>
        </header>
        <div class="container">
          <%= yield %>
        </div>
      </body>
    </html>
    

这里要注意，我们用的哈希是Ruby-1.9的形式。

例如在这里：

    <%= stylesheet_link_tag "application", :media => "all" %>

被替换成了：

    <%= stylesheet_link_tag "application", media: "all" %>

因为旧的哈希形式在Ruby on Rails 社区之中依然十分流行，所以认得这两种形式的哈希写法还是必须的。

现在我们再来看看文件中的其他元素。Rails 3 默认使用了HTML5 （文档开头需要标注 `<!DOCTYPE html>`）；然而 HTML5 标准相对较新，有的浏览器并未全面支持（例如IE），因此我们加入一些 JavaScript 代码来作为解决方案：

    <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

在这里用上了一个奇怪的语句：

    <!--[if lt IE 9]>

该语句表明在关闭符号线以内的语句将在浏览器 Microsoft Internet Explorer (IE) 低于 9 (`if lt IE 9`)的时候执行。其中怪怪的语句  `[if lt IE 9]` 并不是 Rails 的一部分，它是IE浏览器支持的语法，具体看这里[conditional comment](http://en.wikipedia.org/wiki/Conditional_comment) 。这样一来，就保证了我们只会在IE浏览器的版本低于9的时候加载我们需要的脚本文件。

下一部分是网站的头部，包含了 logo ，还有一些用来封装内容的 div 标签，还有一个 list 元素作为导航链接页面。

    <header class="navbar navbar-fixed-top navbar-inverse">
      <div class="navbar-inner">
        <div class="container">
          <%= link_to "sample app", '#', id: "logo" %>
          <nav>
            <ul class="nav pull-right">
              <li><%= link_to "Home",    '#' %></li>
              <li><%= link_to "Help",    '#' %></li>
              <li><%= link_to "Sign in", '#' %></li>
            </ul>
          </nav>
        </div>
      </div>
    </header>

这里的 `header` 标签指出了标签内部的元素应该位于页面的顶端。我们在  `header` 标签上标明了三个 CSS Class 分别为  `navbar`, `navbar-fixed-top`, and
`navbar-inverse` ，

    <header class="navbar navbar-fixed-top navbar-inverse">

所有的HTML元素都可以分配一个 id 或者多个 class，这在CSS布局中是极为常用的技巧。这三个类名是实现封装在Bootstrap前端框架中的，我们将实现在[Section 5.1.2](filling-in-the-layout#sec-custom_css)中.

在 `header` 标签中，我们看到两个 div 标签：

    <div class="navbar-inner">
      <div class="container">

div 标签就是一个常见的分割符，它对于文档不做任何事实上的分割作用。在HTML5出现之前，几乎所有的网站的布局分割都需要div标签，现在，我们可以运用HTML5技术加入 `header`,
`nav`, 和 `section` 元素用来更为明确地对网页文档进行分割布局。在这里，我们也为了每一个div加上了class属性，这里每一个class属性都在Bootstrap中有着特殊的意义。

看完了div，接着就是数行内嵌的Ruby代码：

    <%= link_to "sample app", '#', id: "logo" %>
    <nav>
      <ul class="nav pull-right">
        <li><%= link_to "Home",    '#' %></li>
        <li><%= link_to "Help",    '#' %></li>
        <li><%= link_to "Sign in", '#' %></li>
      </ul>
    </nav>

这里使用了 Rails helper  `link_to`  来创建链接(我们曾经使用 `a` 元素来创建链接).`link_to`的第一个参数是链接的文本，而第二个是URI。我们暂时在链接的目标URI都先填上了固定链接 ‘#’ ，这在网页设计中十分常见。第三个参数，我们填上了一个id为logo的哈希。Rails helper 用这样的方式来给用户提供更加便捷的HTML选项。

第二个div包含的元素是一个导航链接产生的list，通过 “无顺序清单” `ul` 标签和 `list` 标签 `li` 的运用即可达到效果：

    <nav>
      <ul class="nav pull-right">
        <li><%= link_to "Home",    '#' %></li>
        <li><%= link_to "Help",    '#' %></li>
        <li><%= link_to "Sign in", '#' %></li>
      </ul>
    </nav>

在这里，虽然 `nav` 标签好似优点多余，但是表明了块内的代码作用，并且在这里，`nav` 和 `pull-right` class 在 `Bootstrap` 中存在特殊含义。当经过Rails处理了内嵌的Ruby代码之后，这样的列表就会变成这样:

    <nav>
      <ul class="nav pull-right">
        <li><a href="#">Home</a></li>
        <li><a href="#">Help</a></li>
        <li><a href="#">Sign in</a></li>
      </ul>
    </nav>

在整个布局文件的末尾才是主要内容的 `div`。

    <div class="container">
      <%= yield %>
    </div>

同样，`container` 也在Bootstrap中有着特殊意义。我们曾经在 3.3.4 中学过了 `yield` 方法可以将内容页插入布局页。页脚我们将会在 5.1.3 中加入，我们的布局页面暂时已经完成，我们已经可以通过访问首页来对其进行访问了。要想用上这个布局文件，我们还需要在 `home.html.erb` 页面之中插入一些元素：

Listing 5.2. The Home page with a link to the signup page. \
`app/views/static_pages/home.html.erb`

    <div class="center hero-unit">
      <h1>Welcome to the Sample App</h1>

      <h2>
        This is the home page for the
        <a href="http://railstutorial.org/">Ruby on Rails Tutorial</a>
        sample application.
      </h2>

      <%= link_to "Sign up now!", '#', class: "btn btn-large btn-primary" %>
    </div>

    <%= link_to image_tag("rails.png", alt: "Rails"), 'http://rubyonrails.org/' %>

我们在这里就为第七章的用户系统做好准备，第一个 `link_to` 建立了一个固定链接。

    <a href="#" class="btn btn-large btn-primary">Sign up now!</a>

在这里，div标签中的 `hero-unit` 在Bootstrap中有着特殊意义的，同理对于注册按钮中的 `btn`, `btn-large`, 和 `btn-primary` 类名。

第二个  `link_to` 中见加上了 `image_tag` helper函数，它接受的参数为图片的路径和一个可选的哈希，在这里，我们把图片链接的  `alt`  属性通过符号进行了设置，它能产生出这样的HTML代码：

    <img alt="Rails" src="/assets/rails.png" />

 `alt` 属性的值将会当在图片不存在的时候显示，它是一种当图片无法显示时对读者补偿机制。由于人们常常漏过图片的 alt 属性，Rails 在你使用了 image_tag 函数的时候默认把图片的文件名作为其 alt 属性。在这个例子里，我们把 alt 文字值指定为 “Rails”。

现在，我们终于可以看到我们辛苦劳动的果实。很酷，不是么？([Figure 5.2](filling-in-the-layout#fig-layout_no_logo_or_custom_css)).

另外，你可能会很惊讶地发现首页上 `rails.png` 竟然确实存在。它在哪里？事实上，每一个新建的Rails应用都可以在 `app/assets/images/rails.png` 找到一张Rails的标志。因为我们实用了 `image_tag` Helper , Rails 将会通过 asset pipeline 技术自动链接到正确地地址([Section 5.2](filling-in-the-layout#sec-sass_and_the_asset_pipeline)).


![layout\_no\_logo\_or\_custom\_css\_bootstrap](/images/figures/layout_no_logo_or_custom_css_bootstrap.png)

Figure 5.2: The Home page
([/static\_pages/home](http://localhost:3000/static_pages/home)) with no
custom CSS. [(full
size)](http://railstutorial.org/images/figures/layout_no_logo_or_custom_css_bootstrap-full.png)


### [5.1.2 Bootstrap 自定义 CSS](filling-in-the-layout#sec-custom_css)

在 [Section 5.1.1](filling-in-the-layout#sec-adding_to_the_layout)中，我们将许多HTML元素设置了class，它让我们便捷地产生许多CSS效果。事实上，其中绝大多数的效果来自于[Bootstrap](http://twitter.github.com/bootstrap/),一个来自Twitter的网页框架，它使我们能够更加便捷地添加交互与设计网页。在这一章里，我们将会把 Bootstrap 和一些自定义CSS规则结合起来，制作自己的网站应用。

我们首先要添加 Bootstrap,它在 Rails 应用中已经被编译成了  `bootstrap-sass` 我们可以在这里看到[Listing 5.3](filling-in-the-layout#code-bootstrap_sass).Bootstrap 框架最初实用的是 [LESS CSS](http://lesscss.org/) 语言，它是一种构建动态样式表的语言。然而，Rails 的 asset pipeline 支持的是另一种(很类似)的语言 Sass，([Section 5.2](filling-in-the-layout#sec-sass_and_the_asset_pipeline))。所以我们添加的是 `bootstrap-sass` 的gem ，它已经Bootstrap从LESS语言转换为SASS语言，让他能够被应用正常实用。


Listing 5.3. Adding the `bootstrap-sass` gem to the `Gemfile`.

    source 'https://rubygems.org'

    gem 'rails', '3.2.9'
    gem 'bootstrap-sass', '2.1'
    .
    .
    .


接下来我们运行`bundle install` 安装 Bootstrap：    


    $ bundle install


之后我们要重启网页服务器，一次来保证新加入的插件正常工作。(在大部分系统上，重启服务器只需要按 `Ctrl-C` 之后重新运行`rails server`. )

要加入自定义CSS到应用程序中就是要创建一个文件包含：


    app/assets/stylesheets/custom.css.scss

在这里，目录和文件的名字都被加上了。目录：

    app/assets/stylesheets

是 asset pipeline的一部分，而在该目录下的任何一部分都会被包含在文件  `application.css` 中作为网站的布局。另外，文件 `custom.css.scss` 的名字中包含 `.css` 后缀，说明了它是一个 CSS 文件，而 `.scss` 后缀，说明了它是 “Sassy CSS” 文件以便 asset pipeline 实用 Sass 处理该文件。

建立了自定义CSS文件之后，我们可以使用 `@import` 函数来加入 Bootstrap 如下：

Listing 5.4. Adding Bootstrap CSS. \
`app/assets/stylesheets/custom.css.scss`

    @import "bootstrap";

折一行，包含了整个Bootstrap 的 CSS 框架，结果如下：

![sample\_app\_only\_bootstrap](/images/figures/sample_app_only_bootstrap.png)

Figure 5.3: The sample application with Bootstrap CSS. [(full
size)](http://railstutorial.org/images/figures/sample_app_only_bootstrap-full.png)

然后我们将要添加一些全站共用的CSS代码到布局文件中去。为了让自己写的代码更加清晰易懂，我们常常实用CSS注释，即在 `/* … */` 中加入注释文字。


Listing 5.5. Adding CSS for some universal styling applying to all
pages. \
`app/assets/stylesheets/custom.css.scss`

    @import "bootstrap";

    /* universal */

    html {
      overflow-y: scroll;
    }

    body {
      padding-top: 60px;
    }

    section {
      overflow: auto;
    }

    textarea {
      resize: vertical;
    }

    .center {
      text-align: center;
    }

    .center h1 {
      margin-bottom: 10px;
    }

![sample\_app\_universal](/images/figures/sample_app_universal.png)

Figure 5.4: Adding some spacing and other universal styling. [(full
size)](http://railstutorial.org/images/figures/sample_app_universal-full.png)

注意[Listing 5.5](filling-in-the-layout#code-universal_css) 中展示了一个相对固定的格式。通常来说，CSS 规则由一个class 或 id 或 html tag 或多种的组合，接着一行或者数行的样式命令，例如：
 
  body {
      padding-top: 60px;
    }

它将设置60像素的顶部间隔长。因为 `navbar-fixed-top` 类处于  `header` tag之中，Bootstrap 将导航栏置于页面顶端，为了和正文保持距离，所以设置了正文的顶端间隔。

此外，CSS中的这条规则

    .center {
      text-align: center;
    }

同理，在这里 把 `center` 类绑定了 `text-align: center` 属性。在这里，`.center` 中的 `.`  表示匹配的是类对象(而井号 `#` 表示匹配的是 id )。这条意味着包含了`center` 类的元素将会被在置于页面的中央。 

虽然通过 Bootsrtap 的 CSS 规则能够获得很漂亮的排版，但是我们还是要加入一些自定义规则来运用在网站和页面的布局上。


Listing 5.6. Adding CSS for nice typography. \
`app/assets/stylesheets/custom.css.scss`

    @import "bootstrap";
    .
    .
    .

    /* typography */

    h1, h2, h3, h4, h5, h6 {
      line-height: 1;
    }

    h1 {
      font-size: 3em;
      letter-spacing: -2px;
      margin-bottom: 30px;
      text-align: center;
    }

    h2 {
      font-size: 1.7em;
      letter-spacing: -1px;
      margin-bottom: 30px;
      text-align: center;
      font-weight: normal;
      color: #999;
    }

    p {
      font-size: 1.1em;
      line-height: 1.7em;
    }

![sample\_app\_typography](/images/figures/sample_app_typography.png)

Figure 5.5: Adding some typographic styling. [(full
size)](http://railstutorial.org/images/figures/sample_app_typography-full.png)


最后，我们为网站的 LOGO 添加几条CSS规则，还要为我们的文字 “sample app”，设置大写，颜色，位置。x

Listing 5.7. Adding CSS for the site logo. \
`app/assets/stylesheets/custom.css.scss`

    @import "bootstrap";
    .
    .
    .

    /* header */

    #logo {
      float: left;
      margin-right: 10px;
      font-size: 1.7em;
      color: #fff;
      text-transform: uppercase;
      letter-spacing: -1px;
      padding-top: 9px;
      font-weight: bold;
      line-height: 1;
    }

    #logo:hover {
      color: #fff;
      text-decoration: none;
    }

这里的  `color: #fff` 将 logo 的颜色改成白色。HTML 颜色可以用三对十六进制数表示，分别表示红，绿，蓝三色。代码 `#ffffff` 是 `#fff` 的完整形式，他们都表示纯白色。CSS 标准也允许使用很多特定名字来作为属性，[HTML colors](http://www.w3schools.com/html/html_colornames.asp),例如这里可以使用 `white` 来代替 `#fff`。代码产生的结果如下：[Listing 5.7](filling-in-the-layout#code-logo_css) 
[Figure 5.6](filling-in-the-layout#fig-sample_app_logo).

![sample\_app\_logo](/images/figures/sample_app_logo.png)

Figure 5.6: The sample app with nicely styled logo. [(full
size)](http://railstutorial.org/images/figures/sample_app_logo-full.png)


### [5.1.3 Partials](filling-in-the-layout#sec-partials)

虽然我们已经在5.1之中完成了所有布局文件的内容，但是它看起来还是有一点 cluttered .  HTML 的注释和分割代码的功能非常薄弱，整个页面的代码都必须放在一个文件里。Rails想出了一个方法来解决这个问题，叫做 *partials*. 让我们先看看经过 partials 处理之后的布局文件。

([Listing 5.8](filling-in-the-layout#code-layout_with_partials)).

Listing 5.8. The site layout with partials for the stylesheets and
header. \
`app/views/layouts/application.html.erb`

    <!DOCTYPE html>
    <html>
      <head>
        <title><%= full_title(yield(:title)) %></title>
        <%= stylesheet_link_tag    "application", media: "all" %>
        <%= javascript_include_tag "application" %>
        <%= csrf_meta_tags %>
        <%= render 'layouts/shim' %>    
      </head>
      <body>
        <%= render 'layouts/header' %>
        <div class="container">
          <%= yield %>
        </div>
      </body>
    </html>

我们注意到了，我们把烦人的 HTML 标注部分给换成了一个 Rails 的helper 叫 `render`: 

    <%= render 'layouts/shim' %>

这句话的效果是去寻找一个文件叫做 `app/views/layouts/_shim.html.erb` ，处理文件中的内容之后吧结果插入到当前的视图文件之中。注意这里的文件名，文件名之前有一个下划线  `_shim.html.erb`; 这个下划线使我们的 partial 文件和普通的视图文件区别开来，使我们能轻易地分辨他们。

当然为了让 partial 运作起来，我们需要向其中加上一下内容，在这个 shim partial 中，我们只需要简单的三行代码就足够了。

[Listing 5.9](filling-in-the-layout#code-stylesheets_partial).

Listing 5.9. A partial for the HTML shim. \
`app/views/layouts/_shim.html.erb`

    <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

类似地，我们可以把头部内容抽取出来放到另一个partial中，然后再加入一行 render 来调用。

Listing 5.10. A partial for the site header. \
`app/views/layouts/_header.html.erb`

    <header class="navbar navbar-fixed-top navbar-inverse">
      <div class="navbar-inner">
        <div class="container">
          <%= link_to "sample app", '#', id: "logo" %>
          <nav>
            <ul class="nav pull-right">
              <li><%= link_to "Home",    '#' %></li>
              <li><%= link_to "Help",    '#' %></li>
              <li><%= link_to "Sign in", '#' %></li>
            </ul>
          </nav>
        </div>
      </div>
    </header>

现在我们知道了 partial 是怎么回事，我们来加入一个网站的 footer 部分吧。首先我们要在layouts目录下新建一个文件叫 `_footer.html.erb`。

([Listing 5.11](filling-in-the-layout#code-footer_partial)).

Listing 5.11. A partial for the site footer. \
`app/views/layouts/_footer.html.erb`

    <footer class="footer">
      <small>
        <a href="http://railstutorial.org/">Rails Tutorial</a>
        by Michael Hartl
      </small>
      <nav>
        <ul>
          <li><%= link_to "About",   '#' %></li>
          <li><%= link_to "Contact", '#' %></li>
          <li><a href="http://news.railstutorial.org/">News</a></li>
        </ul>
      </nav>
    </footer>

和刚刚处理header的方式一样，在footer中我们使用了 `link_to` 函数来链接 About 和 Content 页面，并暂时先用 `'#'` 来代替目标地址，然后用同样的方法调用 render。 

([Listing 5.12](filling-in-the-layout#code-layout_with_footer)).

Listing 5.12. The site layout with a footer partial. \
`app/views/layouts/application.html.erb`

    <!DOCTYPE html>
    <html>
      <head>
        <title><%= full_title(yield(:title)) %></title>
        <%= stylesheet_link_tag    "application", media: "all" %>
        <%= javascript_include_tag "application" %>
        <%= csrf_meta_tags %>
        <%= render 'layouts/shim' %>    
      </head>
      <body>
        <%= render 'layouts/header' %>
        <div class="container">
          <%= yield %>
          <%= render 'layouts/footer' %>
        </div>
      </body>
    </html>

footer 这时候还没有样式表支持，十分地丑陋。我们现在来给它润润色。

Listing 5.13. Adding the CSS for the site footer. \
`app/assets/stylesheets/custom.css.scss`

    .
    .
    .

    /* footer */

    footer {
      margin-top: 45px;
      padding-top: 5px;
      border-top: 1px solid #eaeaea;
      color: #999;
    }

    footer a {
      color: #555;
    }  

    footer a:hover { 
      color: #222;
    }

    footer small {
      float: left;
    }

    footer ul {
      float: right;
      list-style: none;
    }

    footer ul li {
      float: left;
      margin-left: 10px;
    }

![site\_with\_footer\_bootstrap](/images/figures/site_with_footer_bootstrap.png)

Figure 5.7: The Home page
([/static\_pages/home](http://localhost:3000/static_pages/home)) 加上footer. [(full
size)](http://railstutorial.org/images/figures/site_with_footer_bootstrap-full.png)

[5.2 Sass 和 Asset pipeline](filling-in-the-layout#sec-sass_and_the_asset_pipeline)
----------------------------------------------------------------------------------------


Rails 3.0 和 当前版本的Rails 最引人关注的区别就是新版加入了 asset pipeline，显著地提升了管理例如 CSS  Javascript ，图片等静态资源的能力。在这一部分我们会大致地介绍 asset pipeline和其默认使用的 SASS 这个神奇的 CSS 工具。

### [5.2.1 Asset Pipeline](filling-in-the-layout#sec-the_asset_pipeline)

Asset Pipeline 的出现让Rails的内部结构改变了很多，但是从一个Rails开发人员的角度上来说，主要是有三个新增特性： asset 目录，文件清单，和预处理引擎。我们会依次介绍。

#### [Asset 目录](filling-in-the-layout#sec-5_2_1_1)

在Rails 3.0 之前( 包括 3.0 )，静态资源都放在  `public/` 目录之下，包括了

-   `public/stylesheets`
-   `public/javascripts`
-   `public/images`

该目录下的资源将能够被例如 http://example.com/stylesheets  的路径访问到。

而从 Rails 3.1 开始，将有三个目录来放置静态资源，但是他们又有一些分别：

-   `app/assets`: 应用程序所需静态资源 
-   `lib/assets`: 为你自己程序所写的程序库静态资源
-   `vendor/assets`: 第三方插件的静态资源 

你可能可以猜到，每个的目录下面都有三个资源类目录：

    $ ls app/assets/
    images      javascripts stylesheets

这是我们就理解了为什么当时我们要把 `custom.css.scss` 放置在`app/assets/stylesheets` 的原因了吧。

#### [清单文件与管理静态资源](filling-in-the-layout#sec-5_2_1_2)

一旦你把你的静态资源布置到了指定的位置上之后，你只需要一个清单文件(通过[Sprockets](https://github.com/sstephenson/sprockets)这个gem)来告诉 Rails 到底如何把多个文件组合成单个文件。例如，我们可以看一下app目录下的样式表清单文件。

([Listing 5.14](filling-in-the-layout#code-app_css_manifest)).

Listing 5.14. The manifest file for app-specific CSS. \
`app/assets/stylesheets/application.css`

    /*
     * This is a manifest file that'll automatically include all the stylesheets
     * available in this directory and any sub-directories. You're free to add
     * application-wide styles to this file and they'll appear at the top of the
     * compiled file, but it's generally better to create a new file per style 
     * scope.
     *= require_self
     *= require_tree . 
    */
以下一行虽然是CSS的注释，但是它们却会被Sprockets处理，把对应文件引入。

    /*
     .
     .
     .
     *= require_self
     *= require_tree . 
    */

这里

    *= require_tree .

保证了所有 `app/assets/stylesheets` 目录下的 CSS 文件都被引入到应用中去。
而

    *= require_self

这一行保证了 `application.css`  文件本身也被引入。

Rails 应用新建的时候就有一个默认的清单文件，而在本教程中我们不需要做任何的更改，你可以在 [Rails Guides entry on the asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html) 中找到更多的信息。

#### [文件预处理](filling-in-the-layout#sec-5_2_1_3)

当你把你的静态文件准备妥当之后，Rails会根据你的文件清单进行预处理，之后通过Rails服务器传送给浏览器。文件的后缀指示出Rails要用什么如何处理对应的文件。例如使用Sass来处理  `.scss` 后缀，用CoffeeScript处理 `.coffee` ，用 Ruby 自带的 ERb 插件处理 `.erb` 文件。ERb和Sass我们都在前文提到过，本教程中我们不会使用 CoffeScript，但是这是一个轻量而优雅的 Javascript 编译语言(建议从[RailsCast on CoffeeScript basics](http://railscasts.com/episodes/267-coffeescript-basics)开始CoffeeScript的学习)。

预处理可以通过后缀的链接而依次执行，例如

`foobar.js.coffee`

将运行 CoffeeScript 处理器，而

`foobar.js.erb.coffee`

将运行CoffeeScript 处理器之后再执行 ERb 处理。

#### [高效的生产模式](filling-in-the-layout#sec-5_2_1_4)

asset pipeline 中最棒的事情就是其能够在生产模式中大大优化服务器的效率。传统的服务器是将 CSS 和 JavaScript 逐文件地传送至浏览器上。虽然这样便于开发，但是却大大增加客户端的载入时间(客户的交互速度是应用设计重要环节)。然而通过 asset pipeline ,在生产模式中所有应用的样式表和脚本代码将会分别合并压缩成单个文件(`application.css`和`javascripts.js),并且排除掉页面上无需载入的文件，大大方便了编程人员，也加速了页面的访问速度。

### [5.2.2 强化语法样式表](filling-in-the-layout#sec-sass)


*Sass*  是一种为了改善CSS语言而存在的工具。在这一节，我们将会对CSS进行两项重要的优化，为CSS加上 *nesting* 和 变量。(我们还会在 [Section 7.1.1](sign-up#sec-rails_environments)加上第三个技术 *mixins*).

我们曾经在[Section 5.1.2](filling-in-the-layout#sec-custom_css)中提到，Sass支持SCSS格式的文件(用 `.scss` 当作后缀)，该技术完全对CSS兼容————这意味着你完全可以在一个scss文件中写满css语法.最初，我们是因为Bootstrap中要用上SASS，而事实上，Rails 的asset pipeline 支持Sass的处理，Rails会自动地识别scss后缀的文件，并使用SASS软件进行预处理。

#### [Nesting](filling-in-the-layout#sec-5_2_2_1)

一种样式表中常见的形式就是内嵌。例如在下面我们把`.center h1` 表示存在于 `.center` 的属性中。

    .center {
      text-align: center;
    }

    .center h1 {
      margin-bottom: 10px;
    }

在Sass 中，我们可以这么表示：

    .center {
      text-align: center;
      h1 {
        margin-bottom: 10px;
      }  
    }

这里的 `h1` 就将自动继承上文的 `.center` 。

还有另外一个例子：

    #logo {
      float: left;
      margin-right: 10px;
      font-size: 1.7em;
      color: #fff;
      text-transform: uppercase;
      letter-spacing: -1px;
      padding-top: 9px;
      font-weight: bold;
      line-height: 1;
    }

    #logo:hover {
      color: #fff;
      text-decoration: none;
    }

这里id为 `#logo` 的元素出现了两次，一次是定义自己的属性，另一次是定义其 `hover` 状态的属性。在SCSS文件中，我们就可以运用 `&` 更优雅地表达我们的语句：

    #logo {
      float: left;
      margin-right: 10px;
      font-size: 1.7em;
      color: #fff;
      text-transform: uppercase;
      letter-spacing: -1px;
      padding-top: 9px;
      font-weight: bold;
      line-height: 1;
      &:hover {
        color: #fff;
        text-decoration: none;
      }
    }

Sass在进行处理的时候会把 把`&:hover` 转换为 `#logo:hover` 的CSS语法。

我们再把这两种nesting技巧运用到我们footer段的CSS文件中，把它改写成这样：

    footer {
      margin-top: 45px;
      padding-top: 5px;
      border-top: 1px solid #eaeaea;
      color: #999;
      a {
        color: #555;
        &:hover { 
          color: #222;
        }
      }  
      small { 
        float: left; 
      }
      ul {
        float: right;
        list-style: none;
        li {
          float: left;
          margin-left: 10px;
        }
      }
    }

这段代码是一个好很的练习机会，改写后你会发现页面并没有出现改变。

#### [变量](filling-in-the-layout#sec-5_2_2_2)

Sass 可以让我们可以使用变量来减少重复的表达式代码。如下，我们出现了一个语句的重复

    h2 {
      .
      .
      .
      color: #999;
    }
    .
    .
    .
    footer {
      .
      .
      .
      color: #999;
    }

在这里  `#999`  是亮灰色，我们可以给它一个一个变量名：

    $lightGray: #999;

现在我们可以这么撰写SCSS文件：

    $lightGray: #999;
    .
    .
    .
    h2 {
      .
      .
      .
      color: $lightGray;
    }
    .
    .
    .
    footer {
      .
      .
      .
      color: $lightGray;
    }

变量名 `$lightGray`，比原本的 `#999` 显得更加简单易懂，这种技巧常常运用在一块代码中出现了多次重复的表达式时。事实上，Bootstrap框架已经定义了很多种的颜色，公布在网上， [Bootstrap中的LESS](http://bootstrapdocs.com/v2.0.4/docs/less.html)，这里定义的时候用的是LESS语法，但是我们加入了 `bootstrap-sass` gem之后，同样的变量也被移植了过来。看出来其和Sass的对应关系应该不是什么难事，Less在 "@" 符号的地方用 "at" , Sass使用美元符号 `$`.看Bootstrap的变量，我们发现有一行定义：

    @grayLight: #999;
    

这意味着，在使用了 `bootstrap-sass` gem 的Rails应用中，我们直接写上`$lightGray`就可以获得所需要的功能：



    h2 {
      .
      .
      .
      color: $grayLight;
    }
    .
    .
    .
    footer {
      .
      .
      .
      color: $grayLight;
    }

应用上Sass的技巧之后我们整个SCSS文件变成了这样。

Listing 5.15. The initial SCSS file converted to use nesting and
variables. \
`app/assets/stylesheets/custom.css.scss`

    @import "bootstrap";

    /* mixins, variables, etc. */

    $grayMediumLight: #eaeaea;

    /* universal */

    html {
      overflow-y: scroll;
    }

    body {
      padding-top: 60px;
    }

    section {
      overflow: auto;
    }

    textarea {
      resize: vertical;
    }

    .center {
      text-align: center;
      h1 {
        margin-bottom: 10px;
      }
    }

    /* typography */

    h1, h2, h3, h4, h5, h6 {
      line-height: 1;
    }

    h1 {
      font-size: 3em;
      letter-spacing: -2px;
      margin-bottom: 30px;
      text-align: center;
    }

    h2 {
      font-size: 1.7em;
      letter-spacing: -1px;
      margin-bottom: 30px;
      text-align: center;
      font-weight: normal;
      color: $grayLight;
    }

    p {
      font-size: 1.1em;
      line-height: 1.7em;
    }


    /* header */

    #logo {
      float: left;
      margin-right: 10px;
      font-size: 1.7em;
      color: white;
      text-transform: uppercase;
      letter-spacing: -1px;
      padding-top: 9px;
      font-weight: bold;
      line-height: 1;
      &:hover {
        color: white;
        text-decoration: none;
      }
    }

    /* footer */

    footer {
      margin-top: 45px;
      padding-top: 5px;
      border-top: 1px solid $grayMediumLight;
      color: $grayLight;
      a {
        color: $gray;
        &:hover { 
          color: $grayDarker;
        }
      }  
      small { 
        float: left; 
      }
      ul {
        float: right;
        list-style: none;
        li {
          float: left;
          margin-left: 10px;
        }
      }
    }

Sass给了我们简化样式表的手段，但是这只是Sass强大功能的冰山一角，如果你有兴趣，可以参照 [Sass website](http://sass-lang.com/) 获取更多信息。

[5.3 Layout 链接](filling-in-the-layout#sec-layout_links)
----------------------------------------------------------

我们已经完成了网站的布局样式代码，现在是时候让我们把原本预留的 `’#’` 链接替换成其他的链接了。当然，我们可以用这样的硬编码来实现

    <a href="/static_pages/about">About</a>

但是这就没有 Rails 的感觉了。一般来说，对于URI，使用 /about 会比 /static\_pages/about 更好一点，在Rails 中，Rails 通常使用  *named routes* ，代码看起来可能像这样：

    <%= link_to "About", about_path %>

这样的代码能够更加明确地说明代码含义，并且可移植性更强。

下面这个列表是我们准备在首页上实现的所有URI链接和路由配置,我们将会依次实现它们。

  **Page**   **URI**    **Named route**
  ---------- ---------- -----------------
  Home       /          `root_path`
  About      /about     `about_path`
  Help       /help      `help_path`
  Contact    /contact   `contact_path`
  Sign up    /signup    `signup_path`
  Sign in    /signin    `signin_path`

Table 5.1: Route and URI mapping for site links.

首先，我们先加入一个内容页面，在这之前我们要先写测试代码。

Listing 5.16. Tests for a Contact page. \
`spec/requests/static_pages_spec.rb`

    require 'spec_helper'

    describe "Static pages" do
      .
      .
      .
      describe "Contact page" do

        it "should have the h1 'Contact'" do
          visit '/static_pages/contact'
          page.should have_selector('h1', text: 'Contact')
        end

        it "should have the title 'Contact'" do
          visit '/static_pages/contact'
          page.should have_selector('title',
                        text: "Ruby on Rails Tutorial Sample App | Contact")
        end
      end
    end

我们可以进行测试，它很理所应当地失败了。

    $ bundle exec rspec spec/requests/static_pages_spec.rb

之后，我们为我们加上路由配置，我们为 StaticPages 控制器加上了一个`contact` 行为，最后我们新建了一个 Contact 的视图。


Listing 5.17. Adding a route for the Contact page. \
`config/routes.rb`

    SampleApp::Application.routes.draw do
      get "static_pages/home"
      get "static_pages/help"
      get "static_pages/about"
      get "static_pages/contact"
      .
      .
      .
    end

Listing 5.18. Adding an action for the Contact page. \
`app/controllers/static_pages_controller.rb`

    class StaticPagesController < ApplicationController
      .
      .
      .
      def contact
      end
    end

Listing 5.19. The view for the Contact page. \
`app/views/static_pages/contact.html.erb`

    <% provide(:title, 'Contact') %>
    <h1>Contact</h1>
    <p>
      Contact Ruby on Rails Tutorial about the sample app at the
      <a href="http://railstutorial.org/contact">contact page</a>.
    </p>

现在那个测试应该是通过了。

    $ bundle exec rspec spec/requests/static_pages_spec.rb

### [5.3.1 路由测试](filling-in-the-layout#sec-route_tests)

我们现在已经成功地完成了静态页面的测试，下一步是测试路由的正常运作。撰写一个路由测试很简单：我们只要把每一个硬编码的路由路径改为命名路由路径即可，例如我们把

    visit '/static_pages/about'

改为

    visit about_path

其他的页面也类似，最后页面样式这样：

Listing 5.20. Tests for the named routes. \
`spec/requests/static_pages_spec.rb`

    require 'spec_helper'

    describe "Static pages" do

      describe "Home page" do

        it "should have the h1 'Sample App'" do
          visit root_path
          page.should have_selector('h1', text: 'Sample App')
        end

        it "should have the base title" do
          visit root_path
          page.should have_selector('title',
                            text: "Ruby on Rails Tutorial Sample App")
        end

        it "should not have a custom page title" do
          visit root_path
          page.should_not have_selector('title', text: '| Home')
        end
      end

      describe "Help page" do

        it "should have the h1 'Help'" do
          visit help_path
          page.should have_selector('h1', text: 'Help')
        end

        it "should have the title 'Help'" do
          visit help_path
          page.should have_selector('title',
                            text: "Ruby on Rails Tutorial Sample App | Help")
        end
      end

      describe "About page" do

        it "should have the h1 'About'" do
          visit about_path
          page.should have_selector('h1', text: 'About Us')
        end

        it "should have the title 'About Us'" do
          visit about_path
          page.should have_selector('title',
                        text: "Ruby on Rails Tutorial Sample App | About Us")
        end
      end

      describe "Contact page" do

        it "should have the h1 'Contact'" do
          visit contact_path
          page.should have_selector('h1', text: 'Contact')
        end

        it "should have the title 'Contact'" do
          visit contact_path
          page.should have_selector('title',
                        text: "Ruby on Rails Tutorial Sample App | Contact")
        end
      end
    end

和往常一样，我们先看看我们错误百出的测试。

    $ bundle exec rspec spec/requests/static_pages_spec.rb

如果你觉得文中的代码反复而冗长，别担心，你不是唯一这么想的人，我们很快就会对该页面进行改进的。

### [5.3.2 Rails 路由](filling-in-the-layout#sec-rails_routes)

现在我们已经如我们所愿测试了URI，是时候让它们跑起来看看了。另外提一句，我们在打开 `config/routes.rb` 文件的时候我们看到了默认路由中密密麻麻的注释代码，事实上，这些被注释的代码是对Rails路由语法的一种示例，你可以在这里[Rails Guides article “Rails Routing from the outside in”](http://guides.rubyonrails.org/routing.html)找到关于Rails路由的更多信息。

要定义一个命名路由，我们首先要把get规则替换成match规则

    get 'static_pages/help'

改成

    match '/help', to: 'static_pages#help'

这样让  `/help` 和命名路由 `help_path` 都将能返回我们所需要的路径。在这里，get 和 match 其实结果都是一样的，但是实用 match 会更方便一点。

我们只有在 Home 页面中使用静态的路由配置.

Listing 5.21. Routes for static pages. \
`config/routes.rb`

    SampleApp::Application.routes.draw do
      match '/help',    to: 'static_pages#help'
      match '/about',   to: 'static_pages#about'
      match '/contact', to: 'static_pages#contact'
      .
      .
      .
    end

如果你仔细地阅读了上面的代码，你一定能明白它说的是什么意思。

    match '/about', to: 'static_pages#about'

这里将匹配 '/about' 路径到 StaticPages 控制器 下的 `about` 方法。之前，我们用了更易懂的方法来处理： 

    get 'static_pages/about'

这其实是同样的意思，但是 `/about` 显得更简洁一点。正如上文所提到的。 `match ’/about’` 同样为控制器和视图产生了命名路由：

    about_path => '/about'
    about_url  => 'http://localhost:3000/about'

注意，`about_url` 生成的是完整的 URI 地址  http://localhost:3000/about。（在部署的时候，`localhost:3000` 会被替换成域名，例如 `example.com` 。）正如我们在[Section 5.3](filling-in-the-layout#sec-layout_links)中讨论的那样，要访问/about,你可以用 `about_path` 。在  *Rails Tutorial* 中，通常使用 `path`。然而当我们我们需要进行重定向的时候，我们将需要完整的 HTTP 地址，这时候我们将会用 `url` 后缀的格式，事实上，大部分浏览器这两种格式都是支持的。

路由定义好了之后，我们可以开始测试 Help, About,Contact 页面了：

    $ bundle exec rspec spec/requests/static_pages_spec.rb

这时候应该只有 Home 页面还是处于fail状态。

要建立路由的Home页面，我们可以用这样的代码：


    match '/', to: 'static_pages#home'

然而这是没有必要的，因为在Rails中存在一个特殊的指令来表示 URI / 表示文件的最底层。

Listing 5.22. The commented-out hint for defining the root route. \
`config/routes.rb`

    SampleApp::Application.routes.draw do
      .
      .
      .
      # You can have the root of your site routed with "root"
      # just remember to delete public/index.html.
      # root :to => "welcome#index"
      .
      .
      .
    end

Using [Listing 5.22](filling-in-the-layout#code-root_route_hint) as a
model, we arrive at
[Listing 5.23](filling-in-the-layout#code-root_route) to route the root
URI / to the Home page.

Listing 5.23. Adding a mapping for the root route. \
`config/routes.rb`

    SampleApp::Application.routes.draw do
      root to: 'static_pages#home'

      match '/help',    to: 'static_pages#help'
      match '/about',   to: 'static_pages#about'
      match '/contact', to: 'static_pages#contact'  
      .
      .
      .
    end

这代码将根URI / 映射到  /static\_pages/home，并且建立这样的Helper函数：

    root_path => '/'
    root_url  => 'http://localhost:3000/'

这里我们需要留心提到过的[Listing 5.22](filling-in-the-layout#code-root_route_hint) 中删除 `public/index.html` 文件的问题。
删除了之后，如果你有用 git 进行代码管理，还需要运行：

    $ git rm public/index.html

来保证 git 删除了该文件。我们曾经在[Section 1.3.5](beginning#sec-git_commands)提到过了git的基本命令， 我们使用了Git命令   `git commit -a -m "Message"` 其中-a为 ”all changes “， -m 为message。作为缩写，Git 支持把两个标签缩写成一个，变成 `git commit -am "Message"`。

现在，所有的路由设置与静态页面都已经完成了，现在的测试就会通过：

    $ bundle exec rspec spec/requests/static_pages_spec.rb

现在我们只是需要把链接写入布局文件中就可以了。

### [5.3.3 命名路由](filling-in-the-layout#sec-named_routes)

让我们在把[Section 5.3.2](filling-in-the-layout#sec-rails_routes) 中写好的路由名称填到布局文件中来。我们只要把对应的路由命填到 `link_to`  的第二个参数中就可以了，例如，我们把

    <%= link_to "About", '#' %>

改成

    <%= link_to "About", about_path %>

就好。

我们从 header partial 开始，`_header.html.erb` 中有着 Home 和 Help 页面的链接，我们对他们作一些修改:

Listing 5.24. Header partial with links. \
`app/views/layouts/_header.html.erb`

    <header class="navbar navbar-fixed-top navbar-inverse">
      <div class="navbar-inner">
        <div class="container">
          <%= link_to "sample app", root_path, id: "logo" %>
          <nav>
            <ul class="nav pull-right">
              <li><%= link_to "Home",    root_path %></li>
              <li><%= link_to "Help",    help_path %></li>
              <li><%= link_to "Sign in", '#' %></li>
            </ul>
          </nav>
        </div>
      </div>
    </header>

我们在第八章才会开始制作登录界面，所以我们先留一个 `’#’` 在这里。

而在 footer partial文件中， `_footer.html.erb`,我们需要修改 About 和 Contact 页面。

Listing 5.25. Footer partial with links. \
`app/views/layouts/_footer.html.erb`

    <footer class="footer">
      <small>
        <a href="http://railstutorial.org/">Rails Tutorial</a>
        by Michael Hartl
      </small>
      <nav>
        <ul>
          <li><%= link_to "About",   about_path %></li>
          <li><%= link_to "Contact", contact_path %></li>
          <li><a href="http://news.railstutorial.org/">News</a></li>
        </ul>
      </nav>
    </footer>

此时，我们已经把页面文件中所有的静态页面链接上了。

另外，值得一提的是，一旦填上了对应的Helper名，测试就会自动检测是否存在对应的路由定义。

![about\_page\_styled](/images/figures/about_page_styled.png)

Figure 5.8: The About page at
[/about](http://localhost:3000/about). [(full
size)](http://railstutorial.org/images/figures/about_page_styled-full.png)

### [5.3.4 为RSpec锦上添花](filling-in-the-layout#sec-pretty_rspec)

我们注意到在 [Section 5.3.1](filling-in-the-layout#sec-route_tests) 中，我们的测试文件有一些冗长和重复。在这一节里，我们将会用上 Rspec 的新特性来让代码显得更优雅。


先关注一下我们原本的代码是怎么样的：

    describe "Home page" do

      it "should have the h1 'Sample App'" do
        visit root_path
        page.should have_selector('h1', text: 'Sample App')
      end

      it "should have the base title" do
        visit root_path
        page.should have_selector('title',
                          text: "Ruby on Rails Tutorial Sample App")
      end

      it "should not have a custom page title" do
        visit root_path
        page.should_not have_selector('title', text: '| Home')
      end
    end

首先被注意到的是所有的例子都包含了一个 visit 到 root path 的属性。我们可以通过使  用 `before` 代码块来处理它：

    describe "Home page" do
      before { visit root_path } 

      it "should have the h1 'Sample App'" do
        page.should have_selector('h1', text: 'Sample App')
      end

      it "should have the base title" do
        page.should have_selector('title',
                          text: "Ruby on Rails Tutorial Sample App")
      end

      it "should not have a custom page title" do
        page.should_not have_selector('title', text: '| Home')
      end
    end

这里我们修改了这一行

    before { visit root_path }

这样保证了每一个测试都是在访问 root path.

另一个重复代码是

    it "should have the h1 'Sample App'" do

和

    page.should have_selector('h1', text: 'Sample App')

这两个表达的其实是一样的事情。这里我们注意到，每个测试都引用了`page`变量，我们可以运用 Rspec 的  *subject*  语法来消除这一冗余。

    subject { page }

并且在单行的 it 语法中，我们使用闭合式的代码块表示：

    it { should have_selector('h1', text: 'Sample App') }

因为我们申明了 `subject { page }`，所以调用 `should` 时 Capybara 会自动帮你选择使用page变量。

现在，Home 页面的测试代码显得更加紧凑和优雅了：

      subject { page }

      describe "Home page" do
        before { visit root_path } 

        it { should have_selector('h1', text: 'Sample App') }
        it { should have_selector 'title',
                            text: "Ruby on Rails Tutorial Sample App" }
        it { should_not have_selector 'title', text: '| Home' }
      end

这样的代码看起来好多了。但是测试的标题看起来还是长了一点，事实上，在每一个测试的开头都有一行这样的长标题：

    "Ruby on Rails Tutorial Sample App | About"

在 [Section 3.5](static-pages#sec-static_pages_exercises) 的练习中，我们试着定义一个 `base_title` 变量来消除重复的标题字符串。现在，我们有更好的办法：定义一个 `full_title` 函数。为此，我们需要建立 `spec/support` 文件夹和 `utilities.rb`  文件。

Listing 5.26. A file for RSpec utilities with a `full_title` function. \
`spec/support/utilities.rb`

    def full_title(page_title)
      base_title = "Ruby on Rails Tutorial Sample App"
      if page_title.empty?
        base_title
      else
        "#{base_title} | #{page_title}"
      end
    end

其实，这函数本质上还是我们在[Listing 4.2](rails-flavored-ruby#code-title_helper)中写的那个。但是两个独立的函数允许我们更加自由地组织我们的标题。这是一种很奇怪的设计，而更好的方法我们会在测试([Section 5.6](filling-in-the-layout#sec-layout_exercises))给出。

在  `spec/support`  目录下的文件夹默认包括了 RSpec，这意味着我们可以在写 Home 页面测试可以这样：

      subject { page }

      describe "Home page" do
        before { visit root_path } 

        it { should have_selector('h1',    text: 'Sample App') }
        it { should have_selector('title', text: full_title('')) }
      end

这样我们就可以轻松地对 Home 页面照葫芦花瓢，写出我们的 Help, About, 和 Contact 页面。结果如下

Listing 5.27. Prettier tests for the static pages. \
`spec/requests/static_pages_spec.rb`

    require 'spec_helper'

    describe "Static pages" do

      subject { page }

      describe "Home page" do
        before { visit root_path }

        it { should have_selector('h1',    text: 'Sample App') }
        it { should have_selector('title', text: full_title('')) }
        it { should_not have_selector 'title', text: '| Home' }
      end

      describe "Help page" do
        before { visit help_path }

        it { should have_selector('h1',    text: 'Help') }
        it { should have_selector('title', text: full_title('Help')) }
      end

      describe "About page" do
        before { visit about_path }

        it { should have_selector('h1',    text: 'About') }
        it { should have_selector('title', text: full_title('About Us')) }
      end

      describe "Contact page" do
        before { visit contact_path }

        it { should have_selector('h1',    text: 'Contact') }
        it { should have_selector('title', text: full_title('Contact')) }
      end
    end

好了，我们现在可以进行测试，修改你的代码知道让他们全部通过：

    $ bundle exec rspec spec/requests/static_pages_spec.rb


[5.4 新的开始：用户注册](filling-in-the-layout#sec-user_signup)
----------------------------------------------------------------------

有了完整的 Rails 页面布局与路由作为一个基础，在这一章，我们要开始写用户注册界面，着意味着我们需要一个新的控制器。用户注册是用户在网站中的入口，是交互中极其重要的一环，在这一章我们会作出控制器，在下一章，我们会完成用户模型的搭建，我们会在第七章完成注册页面的工作。

### [5.4.1 用户控制器](filling-in-the-layout#sec-users_controller)

上一个控制器似乎已经是非常遥远的事情了，StaticPages controller，要追溯到[Section 3.1.2](static-pages#sec-static_pages_with_rails)，是时候新建一个新控制器了： User controller .  和原来一样，我们需要运行 `generate` 命令来创建用户注册控制器的基础框架。根据我们之前提到的 [REST 架构](http://en.wikipedia.org/wiki/Representational_State_Transfer) ，我们要建立一个 建立用户的行为 `new`， 我们可以把 new 作为一个参数传给  ` generate controller ` 命令。


Listing 5.28. Generating a Users controller (with a `new` action).

    $ rails generate controller Users new --no-test-framework
          create  app/controllers/users_controller.rb
           route  get "users/new"
          invoke  erb
          create    app/views/users
          create    app/views/users/new.html.erb
          invoke  helper
          create    app/helpers/users_helper.rb
          invoke  assets
          invoke    coffee
          create      app/assets/javascripts/users.js.coffee
          invoke    scss
          create      app/assets/stylesheets/users.css.scss

这样，我们就创建了一个包含new行为的用户控制器，同时还新建了一个简单用户页面：

Listing 5.29. The initial Users controller, with a `new` action. \
`app/controllers/users_controller.rb`

    class UsersController < ApplicationController
      def new
      end

    end

Listing 5.30. The initial `new` action for Users. \
`app/views/users/new.html.erb`

    <h1>Users#new</h1>
    <p>Find me in app/views/users/new.html.erb</p>

### [5.4.2 注册 URI](filling-in-the-layout#sec-signup_url)

完成了[Section 5.4.1](filling-in-the-layout#sec-users_controller)之后，我们已经在  /users/new 地址处获得了一个页面，但是根据我们在 [Table 5.1](filling-in-the-layout#table-url_mapping)计划的，我们想要一个  /signup 的uri 来作为注册页面地址。在开始我们的改动之前，和 [Section 5.3](filling-in-the-layout#sec-layout_links)一样，我们首先要写一个测试，可以这样生成： 

    $ rails generate integration_test user_pages

然后如同我们在 static 页面测试中所做的一样，我们将会写上测试代码来对 `h1` 和  `title` 标签进行测试，如下：

Listing 5.31. The initial spec for users, with a test for the signup
page. \
`spec/requests/user_pages_spec.rb`

    require 'spec_helper'

    describe "User pages" do

      subject { page }

      describe "signup page" do
        before { visit signup_path }

        it { should have_selector('h1',    text: 'Sign up') }
        it { should have_selector('title', text: full_title('Sign up')) }
      end
    end

我们可以使用 `rspec` 来进行测试：

    $ bundle exec rspec spec/requests/user_pages_spec.rb

还可以直接对目录下的所有文件进行测试：

    $ bundle exec rspec spec/requests/

或许你也猜到了，你甚至可以这样运行所有的 specs 测试：

    $ bundle exec rspec spec/

为了测试的完整，我们将来可能常常会使用这条命令进行测试。顺便提一句，有的人喜欢用 rake task 来进行完整的测试，像这样

    $ bundle exec rake spec

甚至他们只需要键入 `rake` 就足够了，因为默认的rake行为就是运行测试套件。

至今，我们的用户控制器已经有了一个 `new` 行为，为了让我们的测试通过，我们需要写出正确的路由设置和视图内容。我们将会依据 [Listing 5.21](filling-in-the-layout#code-static_page_routes) 然后加入一行 `match ’/signup’` 。

Listing 5.32. A route for the signup page. \
`config/routes.rb`

    SampleApp::Application.routes.draw do
      get "users/new"

      root to: 'static_pages#home'

      match '/signup',  to: 'users#new'

      match '/help',    to: 'static_pages#help'
      match '/about',   to: 'static_pages#about'
      match '/contact', to: 'static_pages#contact'
      .
      .
      .
    end

注意到文件中已经存在了 `get "users/new"` ，它由控制器的 generate 命令自动添加。虽然 `’users/new’` 这样的地址现在已经可用，但是这并不符合我们的REST标准 ([Table 2.2](a-demo-app#table-demo_RESTful_users))，我们将会在 [Section 7.1.2](sign-up#sec-a_users_resource)对其作出处理.

为了让测试通过，我们所需要第一件事就是为视图文件添加一个 titile 和 “Sign up” 的头部标签：

Listing 5.33. The initial (stub) signup page. \
`app/views/users/new.html.erb`

    <% provide(:title, 'Sign up') %>
    <h1>Sign up</h1>
    <p>Find me in app/views/users/new.html.erb</p>

现在 signup 的测试应该能够通过了，接下来的是给 Home 页面加入一个 button 。我们在路由文件中写入了  `match ’/signup’`，这将生成一个叫  `signup_path` 的路径helper，我们可以把它用上了：

Listing 5.34. Linking the button to the Signup page. \
`app/views/static_pages/home.html.erb`

    <div class="center hero-unit">
      <h1>Welcome to the Sample App</h1>

      <h2>
        This is the home page for the
        <a href="http://railstutorial.org/">Ruby on Rails Tutorial</a>
        sample application.
      </h2>

      <%= link_to "Sign up now!", signup_path, class: "btn btn-large btn-primary" %>
    </div>

    <%= link_to image_tag("rails.png", alt: "Rails"), 'http://rubyonrails.org/' %>

至此，我们已经暂时完成了所有的链接和命名路由的设置，最终结果如图：

![new\_signup\_page\_bootstrap](/images/figures/new_signup_page_bootstrap.png)

Figure 5.9: The new signup page at
[/signup](http://localhost:3000/signup). [(full
size)](http://railstutorial.org/images/figures/new_signup_page_bootstrap-full.png)

此时应该能够通过所有的测试：

    $ bundle exec rspec spec/

[5.5 总结整理](filling-in-the-layout#sec-layout_conclusion)
-------------------------------------------------------------

在这一章中，我们对应用的布局和路由进行了修改。接下来，本书会渐渐地完善这一个简单的示例程序：用户可以在这样的程序中注册，登录，登出，发布微博，最后能够让用户互相关注。

而现在，我们应该使用 Git 来把我们的成果合并到 master 分支上：

    $ git add .
    $ git commit -m "Finish layout and routes"
    $ git checkout master
    $ git merge filling-in-layout

然后push到Github上

    $ git push

部署

    $ git push heroku

查看自己的成果

    $ heroku open

如果出错了，可以如下查看日志

    $ heroku logs

并根据 heroku 的日志来进行 debug.

