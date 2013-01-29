
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

asset pipeline 中最棒的事情就是其能够在生产模式中大大优化服务器的效率。传统的服务器是将 CSS 和 JavaScript 逐文件地传送至浏览器上。虽然这样便于开发，但是却大大增加客户端的载入时间(客户的交互速度是应用设计重要环节)。然而通过 asset pipeline ,在生产模式中所有应用的样式表和脚本代码将会分别合并压缩成单个文件
One of the best things about the asset pipeline is that it automatically
results in assets that are optimized to be efficient in a production
application. Traditional methods for organizing CSS and JavaScript
involve splitting functionality into separate files and using nice
formatting (with lots of indentation). While convenient for the
programmer, this is inefficient in production; including multiple
full-sized files can significantly slow page-load times (one of the most
important factors affecting the quality of the user experience). With
the asset pipeline, in production all the application stylesheets get
rolled into one CSS file (`application.css`), all the application
JavaScript code gets rolled into one JavaScript file (`javascripts.js`),
and all such files (including those in `lib/assets` and `vendor/assets`)
are *minified* to remove the unnecessary whitespace that bloats file
size. As a result, we get the best of both worlds: multiple nicely
formatted files for programmer convenience, with single optimized files
in production.

### [5.2.2 Syntactically awesome stylesheets](filling-in-the-layout#sec-sass)

*Sass* is a language for writing stylesheets that improves on CSS in
many ways. In this section, we cover two of the most important
improvements, *nesting* and *variables*. (A third technique, *mixins*,
is introduced in [Section 7.1.1](sign-up#sec-rails_environments).)

As noted briefly in
[Section 5.1.2](filling-in-the-layout#sec-custom_css), Sass supports a
format called SCSS (indicated with a `.scss` filename extension), which
is a strict superset of CSS itself; that is, SCSS only *adds* features
to CSS, rather than defining an entirely new syntax.^[9](#fn-5_9)^ This
means that every valid CSS file is also a valid SCSS file, which is
convenient for projects with existing style rules. In our case, we used
SCSS from the start in order to take advantage of Bootstrap. Since the
Rails asset pipeline automatically uses Sass to process files with the
`.scss` extension, the `custom.css.scss` file will be run through the
Sass preprocessor before being packaged up for delivery to the browser.

#### [Nesting](filling-in-the-layout#sec-5_2_2_1)

A common pattern in stylesheets is having rules that apply to nested
elements. For example, in
[Listing 5.5](filling-in-the-layout#code-universal_css) we have rules
both for `.center` and for `.center h1`:

    .center {
      text-align: center;
    }

    .center h1 {
      margin-bottom: 10px;
    }

We can replace this in Sass with

    .center {
      text-align: center;
      h1 {
        margin-bottom: 10px;
      }  
    }

Here the nested `h1` rule automatically inherits the `.center` context.

There’s a second candidate for nesting that requires a slightly
different syntax. In [Listing 5.7](filling-in-the-layout#code-logo_css),
we have the code

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

Here the logo id `#logo` appears twice, once by itself and once with the
`hover` attribute (which controls its appearance when the mouse pointer
hovers over the element in question). In order to nest the second rule,
we need to reference the parent element `#logo`; in SCSS, this is
accomplished with the ampersand character `&` as follows:

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

Sass changes `&:hover` into `#logo:hover` as part of converting from
SCSS to CSS.

Both of these nesting techniques apply to the footer CSS in
[Listing 5.13](filling-in-the-layout#code-footer_css), which can be
transformed into the following:

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

Converting [Listing 5.13](filling-in-the-layout#code-footer_css) by hand
is a good exercise, and you should verify that the CSS still works
properly after the conversion.

#### [Variables](filling-in-the-layout#sec-5_2_2_2)

Sass allows us to define *variables* to eliminate duplication and write
more expressive code. For example, looking at
[Listing 5.6](filling-in-the-layout#code-typography_css) and
[Listing 5.13](filling-in-the-layout#code-footer_css), we see that there
are repeated references to the same color:

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

In this case, `#999` is a light gray, and we can give it a name by
defining a variable as follows:

    $lightGray: #999;

This allows us to rewrite our SCSS like this:

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

Because variable names such as `$lightGray` are more descriptive than
`#999`, it’s often useful to define variables even for values that
aren’t repeated. Indeed, the Bootstrap framework defines a large number
of variables for colors, available online on the [Bootstrap page of LESS
variables](http://bootstrapdocs.com/v2.0.4/docs/less.html). That page
defines variables using LESS, not Sass, but the `bootstrap-sass` gem
provides the Sass equivalents. It is not difficult to guess the
correspondence; where LESS uses an “at” sign `@`, Sass uses a dollar
sign `$`. Looking the Bootstrap variable page, we see that there is a
variable for light gray:

     @grayLight: #999;

This means that, via the `bootstrap-sass` gem, there should be a
corresponding SCSS variable `$grayLight`. We can use this to replace our
custom variable, `$lightGray`, which gives

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

Applying the Sass nesting and variable definition features to the full
SCSS file gives the file in
[Listing 5.15](filling-in-the-layout#code-refactored_scss). This uses
both Sass variables (as inferred from the Bootstrap LESS variable page)
and built-in named colors (i.e., `white` for `#fff`). Note in particular
the dramatic improvement in the rules for the `footer` tag.

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

Sass gives us even more ways to simplify our stylesheets, but the code
in [Listing 5.15](filling-in-the-layout#code-refactored_scss) uses the
most important features and gives us a great start. See the [Sass
website](http://sass-lang.com/) for more details.

[5.3 Layout links](filling-in-the-layout#sec-layout_links)
----------------------------------------------------------

Now that we’ve finished a site layout with decent styling, it’s time to
start filling in the links we’ve stubbed out with `’#’`. Of course, we
could hard-code links like

    <a href="/static_pages/about">About</a>

but that isn’t the Rails Way. For one, it would be nice if the URI for
the about page were /about rather than /static\_pages/about; moreover,
Rails conventionally uses *named routes*, which involves code like

    <%= link_to "About", about_path %>

This way the code has a more transparent meaning, and it’s also more
flexible since we can change the definition of `about_path` and have the
URI change everywhere `about_path` is used.

The full list of our planned links appears in
[Table 5.1](filling-in-the-layout#table-url_mapping), along with their
mapping to URIs and routes. We’ll implement all but the last one by the
end of this chapter. (We’ll make the last one in
[Chapter 8](sign-in-sign-out#top).)

  **Page**   **URI**    **Named route**
  ---------- ---------- -----------------
  Home       /          `root_path`
  About      /about     `about_path`
  Help       /help      `help_path`
  Contact    /contact   `contact_path`
  Sign up    /signup    `signup_path`
  Sign in    /signin    `signin_path`

Table 5.1: Route and URI mapping for site links.

Before moving on, let’s add a Contact page (left as an exercise in
[Chapter 3](static-pages#top)). The test appears as in
[Listing 5.16](filling-in-the-layout#code-contact_page_test), which
simply follows the model last seen in
[Listing 3.18](static-pages#code-pages_controller_spec_title). Note
that, as in the application code, in
[Listing 5.16](filling-in-the-layout#code-contact_page_test) we’ve
switched to Ruby 1.9–style hashes.

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

You should verify that these tests fail:

    $ bundle exec rspec spec/requests/static_pages_spec.rb

The application code parallels the addition of the About page in
[Section 3.2.2](static-pages#sec-adding_a_page): first we update the
routes ([Listing 5.17](filling-in-the-layout#code-contact_route)), then
we add a `contact` action to the StaticPages controller
([Listing 5.18](filling-in-the-layout#code-contact_action)), and finally
we create a Contact view
([Listing 5.19](filling-in-the-layout#code-contact_view)).

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

Now make sure that the tests pass:

    $ bundle exec rspec spec/requests/static_pages_spec.rb

### [5.3.1 Route tests](filling-in-the-layout#sec-route_tests)

With the work we’ve done writing integration test for the static pages,
writing tests for the routes is simple: we just replace each occurrence
of a hard-coded address with the desired named route from
[Table 5.1](filling-in-the-layout#table-url_mapping). In other words, we
change

    visit '/static_pages/about'

to

    visit about_path

and so on for the other pages. The result appears in
[Listing 5.20](filling-in-the-layout#code-route_tests).

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

As usual, you should check that the tests are now red:

    $ bundle exec rspec spec/requests/static_pages_spec.rb

By the way, if the code in
[Listing 5.20](filling-in-the-layout#code-route_tests) strikes you as
repetitive and verbose, you’re not alone. We’ll refactor this mess into
a beautiful jewel in
[Section 5.3.4](filling-in-the-layout#sec-pretty_rspec).

### [5.3.2 Rails routes](filling-in-the-layout#sec-rails_routes)

Now that we have tests for the URIs we want, it’s time to get them to
work. As noted in
[Section 3.1.2](static-pages#sec-static_pages_with_rails), the file
Rails uses for URI mappings is `config/routes.rb`. If you take a look at
the default routes file, you’ll see that it’s quite a mess, but it’s a
useful mess—full of commented-out example route mappings. I suggest
reading through it at some point, and I also suggest taking a look at
the [Rails Guides article “Rails Routing from the outside
in”](http://guides.rubyonrails.org/routing.html) for a much more
in-depth treatment of routes.

To define the named routes, we need to replace rules such as

    get 'static_pages/help'

with

    match '/help', to: 'static_pages#help'

This arranges both for a valid page at `/help` and a named route called
`help_path` that returns the path to that page. (Actually, using `get`
in place of `match` gives the same named routes, but using `match` is
more conventional.)

Applying this pattern to the other static pages gives
[Listing 5.21](filling-in-the-layout#code-static_page_routes). The only
exception is the Home page, which we’ll take care of in
[Listing 5.23](filling-in-the-layout#code-root_route).

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

If you read the code in
[Listing 5.21](filling-in-the-layout#code-static_page_routes) carefully,
you can probably figure out what it does; for example, you can see that

    match '/about', to: 'static_pages#about'

matches `’/about’` and routes it to the `about` action in the
StaticPages controller. Before, this was more explicit: we used

    get 'static_pages/about'

to get to the same place, but `/about` is more succinct. In addition, as
mentioned above, the code `match ’/about’` also automatically creates
*named routes* for use in the controllers and views:

    about_path => '/about'
    about_url  => 'http://localhost:3000/about'

Note that `about_url` is the *full* URI http://localhost:3000/about
(with `localhost:3000` being replaced with the domain name, such as
`example.com`, for a fully deployed site). As discussed in
[Section 5.3](filling-in-the-layout#sec-layout_links), to get just
/about, you use `about_path`. In the *Rails Tutorial*, we’ll follow the
common convention of using the `path` form except when doing redirects,
where we’ll use the `url` form. This is because after redirects the HTTP
standard technically requires a full URI, although in most browsers it
will work either way.

With these routes now defined, the tests for the Help, About, and
Contact pages should pass:

    $ bundle exec rspec spec/requests/static_pages_spec.rb

This leaves the test for the Home page as the last one to fail.

To establish the route mapping for the Home page, we *could* use code
like this:

    match '/', to: 'static_pages#home'

This is unnecessary, though; Rails has special instructions for the root
URI / (“slash”) located lower down in the file
([Listing 5.22](filling-in-the-layout#code-root_route_hint)).

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

This code maps the root URI / to /static\_pages/home, and also gives URI
helpers as follows:

    root_path => '/'
    root_url  => 'http://localhost:3000/'

We should also heed the comment in
[Listing 5.22](filling-in-the-layout#code-root_route_hint) and delete
`public/index.html` to prevent Rails from rendering the default page
([Figure 1.3](beginning#fig-riding_rails_31)) when we visit /. You can
of course simply remove the file by trashing it, but if you’re using Git
for version control there’s a way to tell Git about the removal at the
same time using `git rm`:

    $ git rm public/index.html

You may recall from [Section 1.3.5](beginning#sec-git_commands) that we
used the Git command `git commit -a -m "Message"`, with flags for “all
changes” (`-a`) and a message (`-m`). As shown above, Git also lets us
roll the two flags into one using `git commit -am "Message"`.

With that, all of the routes for static pages are working, and the tests
should pass:

    $ bundle exec rspec spec/requests/static_pages_spec.rb

Now we just have to fill in the links in the layout.

### [5.3.3 Named routes](filling-in-the-layout#sec-named_routes)

Let’s put the named routes created in
[Section 5.3.2](filling-in-the-layout#sec-rails_routes) to work in our
layout. This will entail filling in the second arguments of the
`link_to` functions with the proper named routes. For example, we’ll
convert

    <%= link_to "About", '#' %>

to

    <%= link_to "About", about_path %>

and so on.

We’ll start in the header partial, `_header.html.erb`
([Listing 5.24](filling-in-the-layout#code-header_partial_links)), which
has links to the Home and Help pages. While we’re at it, we’ll follow a
common web convention and link the logo to the Home page as well.

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

We won’t have a named route for the “Sign in” link until
[Chapter 8](sign-in-sign-out#top), so we’ve left it as `’#’` for now.

The other place with links is the footer partial, `_footer.html.erb`,
which has links for the About and Contact pages
([Listing 5.25](filling-in-the-layout#code-footer_partial_links)).

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

With that, our layout has links to all the static pages created in
[Chapter 3](static-pages#top), so that, for example,
[/about](http://localhost:3000/about) goes to the About page
([Figure 5.8](filling-in-the-layout#fig-about_page)).

By the way, it’s worth noting that, although we haven’t actually tested
for the presence of the links on the layout, our tests will fail if the
routes aren’t defined. You can check this by commenting out the routes
in [Listing 5.21](filling-in-the-layout#code-static_page_routes) and
running your test suite. For a testing method that actually makes sure
the links go to the right places, see
[Section 5.6](filling-in-the-layout#sec-layout_exercises).

![about\_page\_styled](/images/figures/about_page_styled.png)

Figure 5.8: The About page at
[/about](http://localhost:3000/about). [(full
size)](http://railstutorial.org/images/figures/about_page_styled-full.png)

### [5.3.4 Pretty RSpec](filling-in-the-layout#sec-pretty_rspec)

We noted in [Section 5.3.1](filling-in-the-layout#sec-route_tests) that
the tests for the static pages are getting a little verbose and
repetitive ([Listing 5.20](filling-in-the-layout#code-route_tests)). In
this section we’ll make use of the latest features of RSpec to make our
tests more compact and elegant.

Let’s take a look at a couple of the examples to see how they can be
improved:

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

One thing we notice is that all three examples include a visit to the
root path. We can eliminate this duplication with a `before` block:

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

This uses the line

    before { visit root_path }

to visit the root path before each example. (The `before` method can
also be invoked with `before(:each)`, which is a synonym.)

Another source of duplication appears in each example; we have both

    it "should have the h1 'Sample App'" do

and

    page.should have_selector('h1', text: 'Sample App')

which say essentially the same thing. In addition, both examples
reference the `page` variable. We can eliminate these sources of
duplication by telling RSpec that `page` is the *subject* of the tests
using

    subject { page }

and then using a variant of the `it` method to collapse the code and
description into one line:

    it { should have_selector('h1', text: 'Sample App') }

Because of `subject { page }`, the call to `should` automatically uses
the `page` variable supplied by Capybara
([Section 3.2.1](static-pages#sec-TDD)).

Applying these changes gives much more compact tests for the Home page:

      subject { page }

      describe "Home page" do
        before { visit root_path } 

        it { should have_selector('h1', text: 'Sample App') }
        it { should have_selector 'title',
                            text: "Ruby on Rails Tutorial Sample App" }
        it { should_not have_selector 'title', text: '| Home' }
      end

This code looks nicer, but the title test is still a bit long. Indeed,
most of the title tests in
[Listing 5.20](filling-in-the-layout#code-route_tests) have long title
text of the form

    "Ruby on Rails Tutorial Sample App | About"

An exercise in [Section 3.5](static-pages#sec-static_pages_exercises)
proposes eliminating some of this duplication by defining a `base_title`
variable and using string interpolation
([Listing 3.30](static-pages#code-pages_controller_spec_exercise)). We
can do even better by defining a `full_title`, which parallels the
`full_title` helper from
[Listing 4.2](rails-flavored-ruby#code-title_helper). We do this by
creating both a `spec/support` directory and a `utilities.rb` file for
RSpec utilities
([Listing 5.26](filling-in-the-layout#code-rspec_utilities)).

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

Of course, this is essentially a duplicate of the helper in
[Listing 4.2](rails-flavored-ruby#code-title_helper), but having two
independent methods allows us to catch any typos in the base title. This
is dubious design, though, and a better (slightly more advanced)
approach, which tests the original `full_title` helper directly, appears
in the exercises
([Section 5.6](filling-in-the-layout#sec-layout_exercises)).

Files in the `spec/support` directory are automatically included by
RSpec, which means that we can write the Home tests as follows:

      subject { page }

      describe "Home page" do
        before { visit root_path } 

        it { should have_selector('h1',    text: 'Sample App') }
        it { should have_selector('title', text: full_title('')) }
      end

We can now simplify the tests for the Help, About, and Contact pages
using the same methods used for the Home page. The results appear in
[Listing 5.27](filling-in-the-layout#code-pretty_page_tests).

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

You should now verify that the tests still pass:

    $ bundle exec rspec spec/requests/static_pages_spec.rb

This RSpec style in
[Listing 5.27](filling-in-the-layout#code-pretty_page_tests) is much
pithier than the style in
[Listing 5.20](filling-in-the-layout#code-route_tests)—indeed, it can be
made even pithier
([Section 5.6](filling-in-the-layout#sec-layout_exercises)). We will use
this more compact style whenever possible when developing the rest of
the sample application.

[5.4 User signup: A first step](filling-in-the-layout#sec-user_signup)
----------------------------------------------------------------------

As a capstone to our work on the layout and routing, in this section
we’ll make a route for the signup page, which will mean creating a
second controller along the way. This is a first important step toward
allowing users to register for our site; we’ll take the next step,
modeling users, in [Chapter 6](modeling-users#top), and we’ll finish the
job in [Chapter 7](sign-up#top).

### [5.4.1 Users controller](filling-in-the-layout#sec-users_controller)

It’s been a while since we created our first controller, the StaticPages
controller, way back in
[Section 3.1.2](static-pages#sec-static_pages_with_rails). It’s time to
create a second one, the Users controller. As before, we’ll use
`generate` to make the simplest controller that meets our present needs,
namely, one with a stub signup page for new users. Following the
conventional [REST
architecture](http://en.wikipedia.org/wiki/Representational_State_Transfer)
favored by Rails, we’ll call the action for new users `new` and pass it
as an argument to `generate controller` to create it automatically
([Listing 5.28](filling-in-the-layout#code-generate_users_controller)).

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

This creates a Users controller with a `new` action
([Listing 5.29](filling-in-the-layout#code-initial_users_controller))
and a stub user view
([Listing 5.30](filling-in-the-layout#code-initial_new_action)).

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

### [5.4.2 Signup URI](filling-in-the-layout#sec-signup_url)

With the code from
[Section 5.4.1](filling-in-the-layout#sec-users_controller), we already
have a working page for new users at /users/new, but recall from
[Table 5.1](filling-in-the-layout#table-url_mapping) that we want the
URI to be /signup instead. As in
[Section 5.3](filling-in-the-layout#sec-layout_links), we’ll first write
some integration tests, which we’ll now generate:

    $ rails generate integration_test user_pages

Then, following the model of the static pages spec in
[Listing 5.27](filling-in-the-layout#code-pretty_page_tests), we’ll fill
in the user pages test with code to test for the contents of the `h1`
and `title` tags, as seen in
[Listing 5.31](filling-in-the-layout#code-user_pages_spec).

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

We can run these tests using the `rspec` command as usual:

    $ bundle exec rspec spec/requests/user_pages_spec.rb

It’s worth noting that we can also run all the request specs by passing
the whole directory instead of just one file:

    $ bundle exec rspec spec/requests/

Based on this pattern, you may be able to guess how to run *all* the
specs:

    $ bundle exec rspec spec/

For completeness, we’ll usually use this method to run the tests through
the rest of the tutorial. By the way, it’s worth noting (since you may
see other people use it) that you can also run the test suite using the
`spec` Rake task:

    $ bundle exec rake spec

(In fact, you can just type `rake` by itself; the default behavior of
`rake` is to run the test suite.)

By construction, the Users controller already has a `new` action, so to
get the test to pass all we need is the right route and the right view
content. We’ll follow the examples from
[Listing 5.21](filling-in-the-layout#code-static_page_routes) and add a
`match ’/signup’` rule for the signup URI
([Listing 5.32](filling-in-the-layout#code-signup_route)).

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

Note that we have kept the rule `get "users/new"`, which was generated
automatically by the Users controller generation in
[Listing 5.28](filling-in-the-layout#code-generate_users_controller).
Currently, this rule is necessary for the `’users/new’` routing to work,
but it doesn’t follow the proper REST conventions
([Table 2.2](a-demo-app#table-demo_RESTful_users)), and we will
eliminate it in [Section 7.1.2](sign-up#sec-a_users_resource).

To get the tests to pass, all we need now is a view with the title and
heading “Sign up”
([Listing 5.33](filling-in-the-layout#code-initial_signup_page)).

Listing 5.33. The initial (stub) signup page. \
`app/views/users/new.html.erb`

    <% provide(:title, 'Sign up') %>
    <h1>Sign up</h1>
    <p>Find me in app/views/users/new.html.erb</p>

At this point, the signup test in
[Listing 5.31](filling-in-the-layout#code-user_pages_spec) should pass.
All that’s left is to add the proper link to the button on the Home
page. As with the other routes, `match ’/signup’` gives us the named
route `signup_path`, which we put to use in
[Listing 5.34](filling-in-the-layout#code-home_page_signup_link).

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

With that, we’re done with the links and named routes, at least until we
add a route for signing in ([Chapter 8](sign-in-sign-out#top)). The
resulting new user page (at the URI /signup) appears in
[Figure 5.9](filling-in-the-layout#fig-new_signup_page).

![new\_signup\_page\_bootstrap](/images/figures/new_signup_page_bootstrap.png)

Figure 5.9: The new signup page at
[/signup](http://localhost:3000/signup). [(full
size)](http://railstutorial.org/images/figures/new_signup_page_bootstrap-full.png)

At this point the tests should pass:

    $ bundle exec rspec spec/

[5.5 Conclusion](filling-in-the-layout#sec-layout_conclusion)
-------------------------------------------------------------

In this chapter, we’ve hammered our application layout into shape and
polished up the routes. The rest of the book is dedicated to fleshing
out the sample application: first, by adding users who can sign up, sign
in, and sign out; next, by adding user microposts; and, finally, by
adding the ability to follow other users.

At this point, if you are using Git you should merge the changes back
into the master branch:

    $ git add .
    $ git commit -m "Finish layout and routes"
    $ git checkout master
    $ git merge filling-in-layout

You can also push up to GitHub:

    $ git push

Finally, you can deploy to Heroku:

    $ git push heroku

The result should be a working sample application on the production
server:

    $ heroku open

If you run into trouble, try running

    $ heroku logs

to debug the error using the Heroku logfile.

[5.6 Exercises](filling-in-the-layout#sec-layout_exercises)
-----------------------------------------------------------

1.  The code in
    [Listing 5.27](filling-in-the-layout#code-pretty_page_tests) for
    testing static pages is compact but is still a bit repetitive. RSpec
    supports a facility called *shared examples* to eliminate the kind
    of duplication. By following the example in
    [Listing 5.35](filling-in-the-layout#code-static_pages_spec_shared_example),
    fill in the missing tests for the Help, About, and Contact pages.
    Note that the `let` command, introduced briefly in
    [Listing 3.30](static-pages#code-pages_controller_spec_exercise),
    creates a local variable with the given value on demand (i.e., when
    the variable is used), in contrast to an instance variable, which is
    created upon assignment.
2.  You may have noticed that our tests for the layout links test the
    routing but don’t actually check that the links on the layout go to
    the right pages. One way to implement these tests is to use `visit`
    and `click_link` inside the RSpec integration test. Fill in the code
    in [Listing 5.36](filling-in-the-layout#code-layout_links_test) to
    verify that all the layout links are properly defined.
3.  Eliminate the need for the `full_title` test helper in
    [Listing 5.26](filling-in-the-layout#code-rspec_utilities) by
    writing tests for the original helper method, as shown in
    [Listing 5.37](filling-in-the-layout#code-full_title_helper_tests).
    (You will have to create both the `spec/helpers` directory and the
    `application_helper_spec.rb` file.) Then `include` it into the test
    using the code in
    [Listing 5.38](filling-in-the-layout#code-rspec_utilities_simplified).
    Verify by running the test suite that the new code is still valid.
    *Note*:
    [Listing 5.37](filling-in-the-layout#code-full_title_helper_tests)
    uses *regular expressions*, which we’ll learn more about in
    [Section 6.2.4](modeling-users#sec-format_validation). (Thanks to
    [Alex Chaffee](http://alexchaffee.com/) for the suggestion and code
    used in this exercise.)

Listing 5.35. Using an RSpec shared example to eliminate test
duplication. \
`spec/requests/static_pages_spec.rb`

    require 'spec_helper'

    describe "Static pages" do

      subject { page }

      shared_examples_for "all static pages" do
        it { should have_selector('h1',    text: heading) }
        it { should have_selector('title', text: full_title(page_title)) }
      end

      describe "Home page" do
        before { visit root_path }
        let(:heading)    { 'Sample App' }
        let(:page_title) { '' }

        it_should_behave_like "all static pages"
        it { should_not have_selector 'title', text: '| Home' }
      end

      describe "Help page" do
        .
        .
        .
      end

      describe "About page" do
        .
        .
        .
      end

      describe "Contact page" do
        .
        .
        .
      end
    end

Listing 5.36. A test for the links on the layout. \
`spec/requests/static_pages_spec.rb`

    require 'spec_helper'

    describe "Static pages" do
      .
      .
      .
      it "should have the right links on the layout" do
        visit root_path
        click_link "About"
        page.should have_selector 'title', text: full_title('About Us')
        click_link "Help"
        page.should # fill in
        click_link "Contact"
        page.should # fill in
        click_link "Home"
        click_link "Sign up now!"
        page.should # fill in
        click_link "sample app"
        page.should # fill in
      end
    end

Listing 5.37. Tests for the `full_title` helper. \
`spec/helpers/application_helper_spec.rb`

    require 'spec_helper'

    describe ApplicationHelper do

      describe "full_title" do
        it "should include the page title" do
          full_title("foo").should =~ /foo/
        end

        it "should include the base title" do
          full_title("foo").should =~ /^Ruby on Rails Tutorial Sample App/
        end

        it "should not include a bar for the home page" do
          full_title("").should_not =~ /\|/
        end
      end
    end

Listing 5.38. Replacing the `full_title` test helper with a simple
`include`. \
`spec/support/utilities.rb`

    include ApplicationHelper

-   `lib/assets
