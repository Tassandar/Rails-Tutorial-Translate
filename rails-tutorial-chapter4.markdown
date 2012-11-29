## 第四章 Rails 中的 Ruby

早在第三章的例子中，我们就已经介绍了一些 Rails 中用上的重要 Ruby 属性。Ruby 是一门博大精深的语言，庆幸的是，对于一个 Rails 开发者来说，你并不需要那么地精通。现在的做法或许和通常学习Ruby的方法有点相背，但是就我的建议来说：如果你的目标是写出一个完整的动态网站，那么你应该先学 Rails， 顺带学一学 Ruby，当你需要变成 Rails 专家的时候，你就需要更加深入地学习 Ruby了。而这本书将会为你打下良好的基础，如同我在 [章节1.1](http://ruby.railstutorial.org/chapters/beginning#sec-comments_for_various_readers) 当中所说，在完成了这部教程之后我建议能够认真地阅读一本纯粹的 Ruby 教程，例如 [Beginning Ruby](http://www.amazon.com/gp/product/1430223634), [The Well-Grounded Rubyist](http://www.amazon.com/gp/product/1933988657),或者 [The Ruby Way](http://www.amazon.com/gp/product/0672328844).


### 4.1 动机

正如我们上一章所看到的看，在不具备 Ruby 知识的情况下进行 Rails 应用程序开发，甚至开始测试是可能的。但是我们这样做是依靠本教程所提供的测试代码并处理每一个错误消息，这样反复修改直到经过测试。这种情况是不可能永远持续下去的。所以，现在，让我们打开本章的网站，与限制我们的 Ruby 语法来一次亲密接触。

让我们再看一眼我们上次的程序，我们更新了几乎全静态的 Rails 布局文件，并用Rails消灭了我们视图中的重复部分。

__Listing 4.1.__  示例应用布局
`app/views/layouts/application.html.erb`

    <!DOCTYPE html>
    <html>
      <head>
        <title>Ruby on Rails Tutorial Sample App | <%= yield(:title) %></title>
        <%= stylesheet_link_tag    "application", :media => "all" %>
        <%= javascript_include_tag "application" %>
        <%= csrf_meta_tags %>
      </head>
      <body>
        <%= yield %>
      </body>
    </html>

Let’s focus on one particular line in Listing 4.1:

    <%= stylesheet_link_tag "application", :media => "all" %>

这里使用的内建的 Rails 函数 `stylesheet_link_tag`(关于它你可以在Rails API 中找到更多信息)来把 `application.css` 的所有 _media types_都饱含进来。对于已经富有经验的 Rails 开发者来说，这是一句再简单不过的语句。但是就是这一小小的语句中至少包含了四个足以令新手困惑不解的Ruby概念：无调用者的函数调用，符号，哈西，Rails内建函数。我们把这些概念贯穿在这一章之中。

另外，Rails 已经内建了非常多的函数，并且，Rails 还允许我们建立新的函数，这些函数我们叫做 `Helpers` ;要想见识怎么新建一个 helper。我们先看看我们在 Listing 4.1: 中看到的：
    
    Ruby on Rails Tutorial Sample App | <%= yield(:title) %>

这个语句依赖于我们在页面标题处的定义（使用了 _provide_ 函数）,例如：

    <% provide(:title, 'Home') %>
    <h1>Sample App</h1>
    <p>
      This is the home page for the
      <a href="http://railstutorial.org/">Ruby on Rails Tutorial</a>
      sample application.
    </p>

那么如果我们没有提供一个标题变量呢？这是一个很实用的小技巧，如果可以最好在每一个页面上写入一个基本标题。于是，在当前布局下，如果你没有提供一个可以传入 view 中的变量，那么一个空位就会产生，大致像这样：

    Ruby on Rails Tutorial Sample App |

这样，就有了能适应所有网页的这一句话，但是在末尾还有一个讨厌的管道号字符。

要想解决这个问题，我们定义了一个 Helper 函数叫作 full_title. full_title helper 主要的功能就是返回一个基本的标题“Ruby on Rails Tutorial Sample App”，如果有指定的页面标题的话，就在这句话之后加入一个 管道号 之后再输出指定标题。

    module ApplicationHelper

      # Returns the full title on a per-page basis.
      def full_title(page_title)
        base_title = "Ruby on Rails Tutorial Sample App"
        if page_title.empty?
          base_title
        else
          "#{base_title} | #{page_title}"
        end
      end
    end

现在我们可以把我们的布局文件上的：

    <title>Ruby on Rails Tutorial Sample App | <%= yield(:title) %></title>

换成：

    <title><%= full_title(yield(:title)) %></title>

现在是这样了：


    <!DOCTYPE html>
    <html>
      <head>
        <title><%= full_title(yield(:title)) %></title>
        <%= stylesheet_link_tag    "application", :media => "all" %>
        <%= javascript_include_tag "application" %>
        <%= csrf_meta_tags %>
      </head>
      <body>
        <%= yield %>
      </body>
    </html>
    
要想我们的 helper 正常工作，我们需要把没必要的单词 “Home” 从首页中删除。这样让Helper 的标题能回到原来的状态。在这里我们先从测试文件做起。

  spec/requests/static_pages_spec.rb
    require 'spec_helper'

    describe "Static pages" do

      describe "Home page" do

        it "should have the h1 'Sample App'" do
          visit '/static_pages/home'
          page.should have_selector('h1', :text => 'Sample App')
        end

        it "should have the base title" do
          visit '/static_pages/home'
          page.should have_selector('title',
                            :text => "Ruby on Rails Tutorial Sample App")
        end

        it "should not have a custom page title" do
          visit '/static_pages/home'
          page.should_not have_selector('title', :text => '| Home')
        end
      end
      .
      .
      .
    end

然后我们来运行一下这个失败的测试文件。
    $ bundle exec rspec spec/requests/static_pages_spec.rb
为了让这个测试能够通过，我们需要把对应行从“首页”视图中拿掉，像这样：
    <h1>Sample App</h1>
    <p>
      This is the home page for the
      <a href="http://railstutorial.org/">Ruby on Rails Tutorial</a>
      sample application.
    </p>
修改之后的视图文件只包含一个 application css文件，这对于一个经验丰富的Rails开发者来说是再正常不过的事情，但是在这背后却有许多令人迷惑的Ruby难题：模块，注释，变量引用，bool变量，控制流，字符串解释器和返回值。这个章节会在下面对它们进行讲解。

### 4.2 字符串与方法

我们学习Ruby的主要工具将会是 Rails Console ，一个命令行的Rails解释器。这个解释器建立在Ruby自带的解释器之上（irb），它能够完全发挥出Ruby 和 Rails 的威力。开启一个Rails Console 只要这样

    $ rails console
    Loading development environment
    >> 
默认情况下，这个命令行将会在开发模式下运行，开发模式是三种Rails预先定义好的运行模式之一（还有两种是测试模式和生产模式）.他们的区别并不是本章的重点，我们将会在第七章涉及到这些内容。

命令行是一个非常棒的学习工具，你可以用它自由地浏览各类数据---别担心，你不会弄坏它的。当你实用命令行的时候，如果卡了就用 Ctrl-C 结束当前任务，或者用 Ctrl-D 退出命令行。在本章的剩余部分，你将会借助它发现Ruby API 的强大。如果需要，你可以上网查看Ruby 的api 文档。

#### 4.2.1 注释

Ruby 的注释使用用一个井号开头 \# 例如

    # Returns the full title on a per-page basis.
      def full_title(page_title)
        .
        .
        .
      end

这里的第一行注释了接下来的函数作用。
在console中，你同样可以实用这个方法来注释。

$ rails console
>> 17 + 42   # Integer addition
=> 59

总之，Ruby将会忽略 \# 之后的所有内容。

#### 4.2.2 字符串

字符串可能是web应用程序中最重要的一部分了，因为网页通过互联网发送给浏览器的终究是一大串字符。让我们从命令行开始，领略一下Ruby神奇的处理文本的能力吧。这次我们从 `rails c` 这个命令开始，这个命令是 `rails console` 的简写


    $ rails c
    >> ""         # An empty string
    => ""
    >> "foo"      # A nonempty string
    => "foo"

这些变量叫做字面量，或者你可以蛋疼地叫它字面字符串，它们可以用双引号来创建。每当创建一个字面量命令行总会回显一次是因为字面量的值就是本身。

我们可以用 ` + `  号来链接各个字面量

    >> "foo" + "bar"    # String concatenation
    => "foobar"

这里看到 `"foo"` 加上` "bar"` 输出了字符串` “foobar”` .

另外一个产生字符串的方法是实用特殊语法  `#{ }`.


    >> first_name = "Michael"    # Variable assignment
    => "Michael"
    >> "#{first_name} Hartl"     # String interpolation
    => "Michael Hartl"

在这里我们先定义了字符串变量 "Michael" 到 `first_name` 然后在把这个变量在字符串中引用  "#{first_name} Hartl"，这样我们就可以在一个字符串中同时使用变量和字符串。


    >> first_name = "Michael"
    => "Michael"
    >> last_name = "Hartl"
    => "Hartl"
    >> first_name + " " + last_name    # Concatenation, with a space in between
    => "Michael Hartl"
    >> "#{first_name} #{last_name}"    # The equivalent interpolation
    => "Michael Hartl"

主意最后两个表达式的值是相同的，但是我更倾向于后者，因为中间加上一个 “ ” 感觉优点怪怪的。

输出

要想输出一个字符串，在Ruby 中最常用的函数就是 puts 了，（念作  /put ess/ ,因为这其实是 'put string'的缩写）。

    >> puts "foo"     # put string
    foo
    => nil

这个 puts 方法却有一个副作用： 这个表达式在屏幕上输出 “foo” 之后却什么也不返回--- nil 是 Ruby 中 “什么都没有” 的意思。

另外，如果实用了 puts 函数将会自动换行，即在行末尾加上 \n , 然而类似的函数 print 就不会这样：

    >> print "foo"    # print string (same as puts, but without the newline)
    foo=> nil
    >> print "foo\n"  # Same as puts "foo"
    foo
    => nil

单引号字符串：

至此我们实用的字符串都是双引号字符串，但是Ruby同样也支持单引号字符串。在使用上，这两种字符串基本一致：

    >> 'foo'          # A single-quoted string
    => "foo"
    >> 'foo' + 'bar'
    => "foobar"

但是他们确有一个非常重要的区别，就是: Ruby 不会在单引号是引用字符串变量：


    >> '#{foo} bar'     # Single-quoted strings don't allow interpolation
    => "\#{foo} bar"

注意到这里的单引号中的变量引用失败了，其中的 \# 号被加上的反斜杠表示这里的 \# 号并不是一个注释号。

但是既然双引号字符串可以做到任何单引号字符串可以做到的事情，和留着后者有什么用呢？这是因为单引号之中的字符串是一种“纯正的字符串”，其中包含的每一个字符都是字面量的一部分。例如，反斜杠字符对于许多系统来说都是一个特殊值，例如 \n 指的是换行符。如果你想要一个变量包含了换行符（而不是换行），那么单引号能将你的操作简化：

    >> '\n'       # A literal 'backslash n' combination
    => "\\n"

同样的道理，# 字符也是一个例子，Ruby 在建立这些字符串的时候将字符串额外作出 “逃脱转换”，在双引号中，一个字面上的反斜杠需要写成两个反斜杠 ，或许这并不能让你节省出什么，但是却让你摆脱此次更改增减反斜杠的烦恼：

    >> 'Newlines (\n) and tabs (\t) both use the backslash character \.'
    => "Newlines (\\n) and tabs (\\t) both use the backslash character \\."



#### 4.2.3 对象与消息传送

Ruby中的所有东西，包括字符串乃至nil，都是一个对象，我们会在4.4.2节更加详细地接触到这个概念，但是没有人能够轻易地就从书中学到面向对象，你需要通过阅读更多的例子和代码才能够理解这个概念。

对象会对消息作出反映，一个对象，例如字符串，可以响应“长度”这个消息，它将会返回字符串的长度信息。

    >> "foobar".length        # Passing the "length" message to a string
    => 6

通常来说，传给对象的会是一个方法，这些方法在对象中被定义。字符串也可以对 `empty?` 方法作出响应：

    >> "foobar".empty?
    => false
    >> "".empty?
    => true

看到 `empty?` 中的那个问好了么。这在 Ruby 中说明这个方法将会返回一个boolean型变量： true 或者 false .  Boolean 变量在控制流中很常见:

    >> s = "foobar"
    >> if s.empty?
    >>   "The string is empty"
    >> else
    >>   "The string is nonempty"
    >> end
    => "The string is nonempty"

Boolean 变量可以通过 &&(且)， ||（或）， !（非） 进行操作：


    >> x = "foo"
    => "foo"
    >> y = ""
    => ""
    >> puts "Both strings are empty" if x.empty? && y.empty?
    => nil
    >> puts "One of the strings is empty" if x.empty? || y.empty?
    "One of the strings is empty"
    => nil
    >> puts "x is not empty" if !x.empty?
    "x is not empty"
    => nil

因为在Ruby 中一切都是对象，所以`nil`也是一个对象，它同样也可以对方法作出响应。一个例子是你可以用 `to_s` 方法把nil显式地转换成一个空字符串. 

>> nil.to_s
=> ""

结果显然是一个空的字符串，我们把传送给对象的消息给链接起来：

    >> nil.empty?
    NoMethodError: You have a nil object when you didn't expect it!
    You might have expected an instance of Array.
    The error occurred while evaluating nil.empty?
    >> nil.to_s.empty?      # Message chaining
    => true

这里我们看到 nil 对象本身并响应 `empty?` 方法，但是 `nil.to_s` 却可以。

下面这个是一个特殊的函数，用来判断对象是否是 `nil` 结果是什么你可以猜到：

    >> "foo".nil?
    => false
    >> "".nil?
    => false
    >> nil.nil?
    => true


下面的代码会在 `!x.empty?` 输出 'x 非空' ,在 Ruby 中，你可以用 if 语句来进行控制，只有在 if 之后的表达的值为true的时候对应语句才会执行。
而 unless 语句与 if 相互补，会在表达式的值为 false 的时候执行：

    >> string = "foobar"
    >> puts "The string '#{string}' is nonempty." unless string.empty?
    The string 'foobar' is nonempty.
    => nil

这里需要注意的事，nil对象十分的特殊，因为在Ruby中，除了 false本身，nil是唯一的值为 false 的对象。

    >> if nil
    >>   true
    >> else
    >>   false        # nil is false
    >> end
    => false

除了false和nil，其他的一切都是true，甚至是 0:

>> if 0
>>   true        # 0 (and everything other than nil and false itself) is true
>> else
>>   false
>> end
=> true


#### 4.2.4 函数定义 

在命令行中，我们可以像 3.6 中一样定义函数。我们来定义一个 `string_message` 方法来返回这个对象是否为空：

    >> def string_message(string)
    >>   if string.empty?
    >>     "It's an empty string!"
    >>   else
    >>     "The string is nonempty."
    >>   end
    >> end
    => nil
    >> puts string_message("")
    It's an empty string!
    >> puts string_message("foobar")
    The string is nonempty.

Ruby 函数有着隐形的返回值，它将把最后确定的表达式值作为返回值返回。因此，在这里显示哪一个字符串，取决于字符串是否为空。Ruby 也有一个显性的返回值，例如：    

    >> def string_message(string)
    >>   return "It's an empty string!" if string.empty?
    >>   return "The string is nonempty."
    >> end


在这里，其实第二个return是没有必要的。因为运行至此处该语句已经是函数的末尾，不管如何，字符串 "The string is nonempty." 都将作为函数的返回值返回。


#### 4.2.5 回到 title 的helper 方法上

现在我们已经足以理解 4.2 中的helper方法了

    module ApplicationHelper

      # Returns the full title on a per-page basis.       # Documentation comment
      def full_title(page_title)                          # Method definition
        base_title = "Ruby on Rails Tutorial Sample App"  # Variable assignment
        if page_title.empty?                              # Boolean test
          base_title                                      # Implicit return
        else
          "#{base_title} | #{page_title}"                 # String interpolation
        end
      end
    end

元素定义，函数定义，变量引用，控制语句，bool值，字符串的引用变量，这些技巧综合在一起，就造成了我们站点中的layout。唯一我们还不明白的是开头的模块： `ApplicationHelper` : 模块能够将相关的方法组合起来，并且还以在Ruby的类中通过 `include` 方法 `mixed in` 。当你从头写一个Ruby类的时候，你需要自己引用并整理好类和模块，但是在Rails Helper 中，你不需要做这么多，因为 ` full_title ` 会被 Rails 自动处理，你直接就可以在视图中使用。 

4.3 其他数据结构

虽然web应用最终通常都是字符串，但是在组成这些字符串的时候我们常常需要用到其他的一些数据结构。这里我们学习一些Rails 应用中常用的Ruby数据结构。

4.3.1 Array & Range


一个数组就是一组有序元素的组合。虽然我们还没有仔细讨论过数组，但是数组作为一个基本结构将会让你更好地理解后面的Hash数据结构和Rails数据模型。

至今我们已经花了一点时间理解字符串，那么我们从一个简单的方法开始，把字符串用 `split` 函数转换为数组：

    >>  "foo bar     baz".split     # Split a string into a three-element array
    => ["foo", "bar", "baz"]

操作的结果是包含三个字符串的数据，默认情况下，`split` 将会通过空格把一个字符串中的单词拆开，但是你可以指定其他的字符来作为分隔符：

    >> "fooxbarxbazx".split('x')
    => ["foo", "bar", "baz"]

沿用了计算机的传统，Ruby 的数据从 0 下标开始，着意味着数组是从0下标开始计数，第二个数下标为1:

    >> a = [42, 8, 17]
    => [42, 8, 17]
    >> a[0]               # Ruby uses square brackets for array access.
    => 42
    >> a[1]
    => 8
    >> a[2]
    => 17
    >> a[-1]              # Indices can even be negative!
    => 17

Ruby 中实用方括号对数组元素定位，对于一些位置特殊的元素，Ruby还有一些其他的方法可以定位：

    >> a                  # Just a reminder of what 'a' is
    => [42, 8, 17]
    >> a.first
    => 42
    >> a.second
    => 8
    >> a.last
    => 17
    >> a.last == a[-1]    # Comparison using ==
    => true

最后一行里用到了相等比较操作 == ，和其他语言一样，与 != 相反：

    >> x = a.length       # Like strings, arrays respond to the 'length' method.
    => 3
    >> x == 3
    => true
    >> x == 1
    => false
    >> x != 1
    => true
    >> x >= 1
    => true
    >> x < 1
    => false

另外， Ruby 的数组对象还定义了很多实用的方法：

    >> a
    => [42, 8, 17]
    >> a.sort
    => [8, 17, 42]
    >> a.reverse
    => [17, 8, 42]
    >> a.shuffle
    => [17, 42, 8]
    >> a
    => [42, 8, 17]

你发现了么，这里方法的调用并没有更改数组本身，若要改变数组本身，你可以使用相关的方法加上感叹号：

    >> a
    => [42, 8, 17]
    >> a.sort!
    => [8, 17, 42]
    >> a
    => [8, 17, 42]

用push方法或者 `<<` 操作符号对数组添加元素：

    >> a.push(6)                  # Pushing 6 onto an array
    => [42, 8, 17, 6]
    >> a << 7                     # Pushing 7 onto an array
    => [42, 8, 17, 6, 7]
    >> a << "foo" << "bar"        # Chaining array pushes
    => [42, 8, 17, 6, 7, "foo", "bar"]

最后一个例子里，我们把push方法连了起来，另外，你也发现了Ruby和其他语言的不同之处，在数组中可以存放不同类型的东西。

`split`能将字符串拆成数组，相反地我们可以使用 `join` 方法把数组组成字符串：

    => "428177foobar"
    >> a.join(', ')                 # Join on comma-space
    => "42, 8, 17, 7, foo, bar"

与数组很近似的是Range,它可以被 `to_a`函数转换成数组。

    >> 0..9
    => 0..9
    >> 0..9.to_a              # Oops, call to_a on 9
    NoMethodError: undefined method `to_a' for 9:Fixnum
    >> (0..9).to_a            # Use parentheses to call to_a on the range
    => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

虽然 `0..9` 是一个合法的 range 但是第二个表达式提醒我们在对其调用函数之前要加上括号。

Range 在输出数组元素的时候相当的有用。

    >> a = %w[foo bar baz quux]         # Use %w to make a string array.
    => ["foo", "bar", "baz", "quux"]
    >> a[0..2]
    => ["foo", "bar", "baz"]

Range 对字符也是有效的:

    >> ('a'..'e').to_a
    => ["a", "b", "c", "d", "e"]

4.3.2 代码块

数组和range都可以用一些方法来接受代码块参数，这里的内容是 Ruby 最为强大的功能也是一个最为让人迷惑的特性。


    >> (1..5).each { |i| puts 2 * i }
    2
    4
    6
    8
    10
    => 1..5

这份代码将会对 range (1..5) 中的每个元素传送代码块中的消息  { |i| puts 2 * i } 。其中用竖线包围起来的变量名 |i| 就是代码块变量，它决定了代码块中处理的对象。在这里，range 的each方法可以对代码块中的一个本地变量作出响应，我们把它叫做 i ，i 将以range中的内容依次执行代码块中内容。

尖括号是实现代码块的一种方式，还有第二种方式：

    >> (1..5).each do |i|
    ?>   puts 2 * i
    >> end
    2
    4
    6
    8
    10
    => 1..5

代码块通常是多于一行的。在这份 Rails 教程中，我们将会遵循这一简单的原则：当代码块只有一行的时候我们使用尖括号代码块，如果超过一行的时候我们使用do..end 语法实现代码块：

    >> (1..5).each do |number|
    ?>   puts 2 * number
    >>   puts '--'
    >> end
    2
    --
    4
    --
    6
    --
    8
    --
    10
    --
    => 1..5

在这里我用 number 替换了 i ，只是想说明你可以使用任何变量名。    




Unless you already have a substantial programming background, there is no shortcut to understanding blocks; you just have to see them a lot, and eventually you’ll get used to them.7 Luckily, humans are quite good at making generalizations from concrete examples; here are a few more, including a couple using the map method:

    >> 3.times { puts "Betelgeuse!" }   # 3.times takes a block with no variables.
    "Betelgeuse!"
    "Betelgeuse!"
    "Betelgeuse!"
    => 3
    >> (1..5).map { |i| i**2 }          # The ** notation is for 'power'.
    => [1, 4, 9, 16, 25]
    >> %w[a b c]                        # Recall that %w makes string arrays.
    => ["a", "b", "c"]
    >> %w[a b c].map { |char| char.upcase }
    => ["A", "B", "C"]
    >> %w[A B C].map { |char| char.downcase }
    => ["a", "b", "c"]

如你所见，map 方法将会把返回的结果替换数组或者range中的响应元素。


现在，我们可以解释我在 1.4.4 生成随机字符串的Ruby语句了：

    ('a'..'z').to_a.shuffle[0..7].join
    #让我们一步一步来

    >> ('a'..'z').to_a                     # An alphabet array
    => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
    "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    >> ('a'..'z').to_a.shuffle             # Shuffle it.
    => ["c", "g", "l", "k", "h", "z", "s", "i", "n", "d", "y", "u", "t", "j", "q",
    "b", "r", "o", "f", "e", "w", "v", "m", "a", "x", "p"]
    >> ('a'..'z').to_a.shuffle[0..7]       # Pull out the first eight elements.
    => ["f", "w", "i", "a", "h", "p", "c", "x"]
    >> ('a'..'z').to_a.shuffle[0..7].join  # Join them together to make one string.
    => "mznpybuj"

4.3.3 哈希和符号

哈希是一种更高层次的数组：你可以把哈希堪称一种数组，但是它不仅可以用数字作为索引（事实上，有一些语言，例如Perl，就把哈希叫做关联数组），而且可以用任何对象作为索引，我们也罢索引叫做键。例如我们可以把一串字符串当作键：

    >> user = {}                          # {} is an empty hash.
    => {}
    >> user["first_name"] = "Michael"     # Key "first_name", value "Michael"
    => "Michael"
    >> user["last_name"] = "Hartl"        # Key "last_name", value "Hartl"
    => "Hartl"
    >> user["first_name"]                 # Element access is like arrays.
    => "Michael"
    >> user                               # A literal representation of the hash
    => {"last_name"=>"Hartl", "first_name"=>"Michael"}

哈希用尖括号把键值对包含起来；而一对尖括号意味着没有任何键值对，例如，｛｝就是一个空的哈希，大家在这里要注意区分尖括号生成的block和哈希的区别。虽然哈希和数组很类似，但是一个巨大的区别就是哈希是无序的。所以如果你想要维护一个有序的结构，那么请使用数组。

相对于数组的用方括号来定义元素的方法，哈希的定义与引用都是很简单的，用 "=>" ———— 宇宙飞船符(hashrocket)把键值联系起来。


    >> user = { "first_name" => "Michael", "last_name" => "Hartl" }
    => {"last_name"=>"Hartl", "first_name"=>"Michael"}

在这里我们在Ruby的哈希表达式的两端都加入了空格，这会在输出中被忽略（加上空格只是为了好看……）。

现在我们已经用上字符串中作为键了，但是在Ruby on Rails 中，更为常见的键值类型是 “符号” 。符号看起来和字符串没什么两样，但是需要加上一个前缀 `:` 而不是用双括号括起来。例如 :name 是一个符号。你可以认为符号就是一种简化的字符串 :9


    >> "name".split('')
    => ["n", "a", "m", "e"]
    >> :name.split('')
    NoMethodError: undefined method `split' for :name:Symbol
    >> "foobar".reverse
    => "raboof"
    >> :foobar.reverse
    NoMethodError: undefined method `reverse' for :foobar:Symbol

相对于其他语言来说，符号是一种特殊的Ruby数据类型，所以他们在刚开始会显得很奇怪，但是当你Rails用得多了，你就会习惯他们并越用越快。

回到符号作为哈希键上，我们可以定义一个用户哈希作为关注者，

    >> user = { :name => "Michael Hartl", :email => "michael@example.com" }
    => {:name=>"Michael Hartl", :email=>"michael@example.com"}
    >> user[:name]              # Access the value corresponding to :name.
    => "Michael Hartl"
    >> user[:password]          # Access the value of an undefined key.
    => nil

最后一个例子我们看到了如果访问一个未定义键结果将是 nil.

因为符号与哈希在Ruby中太常用了，Ruby1.9 支持了一种新用法：

    >> h1 = { :name => "Michael Hartl", :email => "michael@example.com" }
    => {:name=>"Michael Hartl", :email=>"michael@example.com"}
    >> h2 = { name: "Michael Hartl", email: "michael@example.com" }
    => {:name=>"Michael Hartl", :email=>"michael@example.com"} 
    >> h1 == h2
    => true

在这种语法中，符号和太空船符被key+引号+值代替了。

    { name: "Michael Hartl", email: "michael@example.com" }

这样的结构就和一些其他语言类似了（例如Javascript），在Rails社区中也变得越来越流行。现在，两种语法都有着有着非常普遍的应用，在本书中，绝大部分会使用新的语法结构，而这个新语法对于1.8.7或之前的Ruby版本是非法的。因此，（如果你是Ruby 1.8 之前的版本）你最好把你的Ruby升级到1.9，或者你在自己的代码中实用旧的语法。

哈希值是什么都可以，甚至哈希。


    #Listing 4.6. Nested hashes.
    >> params = {}        # Define a hash called 'params' (short for 'parameters').
    => {}
    >> params[:user] = { name: "Michael Hartl", email: "mhartl@example.com" }
    => {:name=>"Michael Hartl", :email=>"mhartl@example.com"}
    >> params
    => {:user=>{:name=>"Michael Hartl", :email=>"mhartl@example.com"}}
    >>  params[:user][:email]
    => "mhartl@example.com"

我们可以称它做哈希的哈希或者嵌套哈希，它在Rails中被广泛实用，我们在 7.3 将会见识到它。

和数组和Range类一样，哈希能够响应 each 方法，例如，一个叫 flash 的哈希有两对键值，:success 和 :error:


    >> flash = { success: "It worked!", error: "It failed." }
    => {:success=>"It worked!", :error=>"It failed."}
    >> flash.each do |key, value|
    ?>   puts "Key #{key.inspect} has value #{value.inspect}"
    >> end
    Key :success has value "It worked!"
    Key :error has value "It failed."


注意，each方法的代码块对于数组来说只用一个变量，但是对于哈希来说就需要两个，一个是键，一个是值。因此，对于each方法来说，每次迭代会处理哈希中的一个键值对。

最后一个例子，我们介绍十分有用的函数：inspect，它能够返回对象的文字描述：

    >> puts (1..5).to_a            # Put an array as a string.
    1
    2
    3
    4
    5
    >> puts (1..5).to_a.inspect    # Put a literal array.
    [1, 2, 3, 4, 5]
    >> puts :name, :name.inspect
    name
    :name
    >> puts "It worked!", "It worked!".inspect
    It worked!
    "It worked!"

由于inspect太好用了，所以该方法有一个简写的 p 方法：

    >> p :name             # Same as 'puts :name.inspect'
    :name

4.3.4 CSS 再加工

是时候让我们回头看看过去在layout中写的层叠样式表了：

    <%= stylesheet_link_tag "application", :media => "all" %>
现在我们已经彻底明白了这句话中的含义。正如我们在4.1中所解释的那样，Rails定义了一个特殊的函数用来包含样式表而通过

    stylesheet_link_tag "application", :media => "all"

来调用这个函数。但是他们还是太神奇了，方法的圆括号呢？在Ruby中，圆括号是可选的，下面这两句表达式是相等的:

    # Parentheses on function calls are optional.
    stylesheet_link_tag("application", :media => "all")
    stylesheet_link_tag "application", :media => "all"
其次，:media 参数看起来好像一个哈希，但是他们的尖括号呢？事实上，当哈希作为函数的最后一个参数时，尖括号也是可选的，下面这两行是相等的:

    # Curly braces on final hash arguments are optional.
    stylesheet_link_tag "application", { :media => "all" }
    stylesheet_link_tag "application", :media => "all"

所以当我们看到下面这一样的时候

    stylesheet_link_tag "application", :media => "all"

它调用了` stylesheet_link_tag`  函数，传递了两个参数：一个是字符串，指定了样式表的路径，另一个是哈希，指定了媒体的链接类型。因为有 <%= %> 括号，它产生的结果将被转换至 ERB template.如果你看了浏览器上的代码的话，你会发现最后生成了这样的语句.

    <link href="/assets/application.css" media="all" rel="stylesheet"
type="text/css" />

如果你手动地访问服务器上的样式表文件，你将会看到这是一个空文件，别着急，我们将会在第五章对他进行完善。

4.4 Ruby 类

我们在之前说过了在Ruby中什么都是对象，在这一章的末尾我们将要自己下一点定义了。Ruby，和所有面向对象语言一样，使用类来组织方法，这些类能够创造对象。如果你是一个面向对象编程的新手，这听起来有点抽象，但是让我们看点具体的例子：


4.4.1 实现

我们已经见过很多类生成对象的例子，而且我们还做过。例如，当我们实用双引号的时候，将会产生一个字符串结构：

    >> s = "foobar"       # A literal constructor for strings using double quotes
    => "foobar"
    >> s.class
    => String

我们看到这里字符串响应了method类，并且返回了字符串对象所属的类。

事实上我们可以使用另一种方法生成字符串:

>> s = String.new("foobar")   # A named constructor for a string
=> "foobar"
>> s.class
=> String
>> s == "foobar"
=> true

其实这两种方法结果都是一样的，但是这样能把意图表现的更加明确。

数组中也是一样：

    >> a = Array.new([1, 3, 2])
    => [1, 3, 2]

哈希，相对来说有些变化。Array.new 根据参数初始化一个数组，而 Hash.new 根据参数生成所有未定义的键的值：

    >> h = Hash.new
    => {}
    >> h[:foo]            # Try to access the value for the nonexistent key :foo.
    => nil
    >> h = Hash.new(0)    # Arrange for nonexistent keys to return 0 instead of nil.
    => {}
    >> h[:foo]
    => 0

当一个函数在类中被调用，例如这里的 new 方法，将被称为类函数。在一个类对象中调用new函数的结果是生成一个对象而响应对象是这个类的实例。而一个实例被函数调用的话，例如length，将会调用类中的实例函数.

4.4.2 类与继承

既然我们学到了类，我们不妨尝试学着用 ssuperclass 找到该类的上级类：

    >> s = String.new("foobar")
    => "foobar"
    >> s.class                        # Find the class of s.
    => String
    >> s.class.superclass             # Find the superclass of String.
    => Object
    >> s.class.superclass.superclass  # Ruby 1.9 uses a new BasicObject base class
    => BasicObject 
    >> s.class.superclass.superclass.superclass
    => nil

这里是一份类与继承的表格，我们可以看到，String的父类是Object，而Object的父类是BasicObject,但是BasicObject没有父类。这份表格对于任何Ruby对象优势有效的。当若干次地查看对象的父类，任何一个Ruby类都将指向BasicObject。这也是为什么我们说"任何Ruby中的元素都是对象"的原因。

![superclass](http://ruby.railstutorial.org/images/figures/string_inheritance_ruby_1_9.png)

要更深入地理解类，没有什么办法比自己动手更棒了。我们先来构建一个具有 palindrome? 函数的 Word 类，该函数将会判断指定单词是否为回文。

    >> class Word
    >>   def palindrome?(string)
    >>     string == string.reverse
    >>   end
    >> end
    => nil

我们可以这么使用它：

    >> w = Word.new              # Make a new Word object.
    => #<Word:0x22d0b20>
    >> w.palindrome?("foobar")
    => false
    >> w.palindrome?("level")
    => true

这个例子似乎已经让你有了一点灵感了不是么？但是现在我们的Word类有一点奇怪，我们只是需要判断一下回文却需要让类的函数带上一个字符串参数。因为单词本身就是一个字符串类，所以我们让Word类继承自String似乎会更自然一点。

    >> class Word < String             # Word inherits from String.
    >>   # Returns true if the string is its own reverse.
    >>   def palindrome?
    >>     self == self.reverse        # self is the string itself.
    >>   end
    >> end
    => nil

在这里 Word < String 是Ruby的继承语法，这样就实现了在为字符串类加入新的方法的时候同样保持着原本的方法。

    >> s = Word.new("level")    # Make a new Word, initialized with "level".
    => "level"                  
    >> s.palindrome?            # Words have the palindrome? method.
    => true                     
    >> s.length                 # Words also inherit all the normal string methods.
    => 5
因为 Word 类继承自String，我们可以使用console来看看它的继承情况：

    >> s.class
    => Word
    >> s.class.superclass
    => String
    >> s.class.superclass.superclass
    => Object
这个继承数可以用下图表示出来：

![figure4.2](http://ruby.railstutorial.org/images/figures/word_inheritance_ruby_1_9.png)


Figure 4.2: The inheritance hierarchy for the (non-built-in) Word class from Listing 4.8.


在例4.8 中，在Word类中我们调用了self和reverse函数来检查单词是否是对象本身的倒置。Ruby 中，使用 self 代表着实例本身：在Word类中，self就是字符串对象本身，这也意味着我们可以在例子中这样： 

    self == self.reverse

来实现回文检查

4.4.3 修改内置(build-in)类

继承是一个非常强大的功能，在这个例子里，我们发现函数  palindromes 甚至比 palindrome? 更自然，因为我们可以直接用字符串对象调用它，但是这样的语句我们现在还没办法运行：

    >> "level".palindrome?
    NoMethodError: undefined method `palindrome?' for "level":String

酷的是，Ruby允许你通过打开类的方式来对内置类修改方法和定义自己的函数：

    >> class String
    >>   # Returns true if the string is its own reverse.
    >>   def palindrome?
    >>     self == self.reverse
    >>   end
    >> end
    => nil
    >> "deified".palindrome?
    => true

修改一个内建的类是一个非常强大的技巧，但是能力越大责任越大，如果没有一个很好的理由去这么做，打开和修改内置类并不是一个好实践。Rails 有着一些很好的例子来告诉你为什么：例如，在一个 web 应用之中，我们常常想要防止变量是blank，例如，用户名不应该是空格(space)或者空白(whitespace)--因此，Rails为Ruby加入了一个 blank? 方法。我们在Rails console 中可以看到：

    >> "".blank?
    => true
    >> "      ".empty?
    => false
    >> "      ".blank?
    => true
    >> nil.blank?
    => true

我们看到一个空格的字符串并不为empty，但是他是 blank的，另外nil也是blanck的（因为nil不是一个字符串），这就说明Rails中blank?方法是插入字符串类的更高级类中的，事实上，它插入了 Object 类。

4.4.4 控制器类

说了那么多，我们现在应该对继承有了一些了解，我们再来看一下我们曾经看过的一些东西：在 StaticPagesController 中

    class StaticPagesController < ApplicationController

      def home
      end

      def help
      end

      def about
      end
    end

你现在应该很明白了，至少也应该模糊地明白了这个代码的含义： StaticPagesController 是一个继承自 ApplicationController 的类, 并且类中含有 home,help,about函数，因为每个Rails console 会根据本地 Rails 环境中加载，所以我们可以直接在命令行中测试我们的类继承关系：

    >> controller = StaticPagesController.new
    => #<StaticPagesController:0x22855d0>
    >> controller.class
    => StaticPagesController
    >> controller.class.superclass
    => ApplicationController
    >> controller.class.superclass.superclass
    => ActionController::Base
    >> controller.class.superclass.superclass.superclass
    => ActionController::Metal
    >> controller.class.superclass.superclass.superclass.superclass
    => AbstractController::Base
    >> controller.class.superclass.superclass.superclass.superclass.superclass
    => Object

据此画出的图表

Figure 4.3: The inheritance hierarchy for the StaticPages controller.
![figure4.3](http://ruby.railstutorial.org/images/figures/static_pages_controller_inheritance.png)


我们甚至可以在console中直接调用控制器中的函数：

    >> controller.home
    => nil

他将返回nil, 因为事实上它就是一个空的函数。

不对啊？虽然action并没有返回任何值,好像也没有产生任何东西。但是我们在第三章看到，当我们访问 home 页面的时候，它确确实实返回了一个web页面，而不是一个值。而且我们似乎也从来没有在调用过 StaticPagesController.new ，不是么？这其中究竟发生了什么？

发生的事情，都在Rails之中。Rails用Ruby写成，但是终究不是Ruby，有的Rails的类表现得和Ruby类一样，但是有的生来就是为了加工成网页大餐的。Rails中有很多这样的魔法，所以不要认为只要懂了Ruby你就能懂Rails。这就是为什么我建议先学Rails，然后你会需要学Ruby，你看，现在又回到学Rails的时候了！

4.4.5 一个用户类

在这一章的最后，我们为自己写一个类，这个用户类将被第六章的用户model替代。

至今我们一直呆在Rails console的温室之中，现在，我们在application文件夹下面新建一个文件 example_user.rb 并输入： 

    Listing 4.9. Code for an example user. 
    example_user.rb
    class User
      attr_accessor :name, :email

      def initialize(attributes = {})
        @name  = attributes[:name]
        @email = attributes[:email]
      end

      def formatted_email
        "#{@name} <#{@email}>"
      end
    end

一下子看起来似乎挺多的，我们一步一步来，第一行：

  attr_accessor :name, :email


建立了用户的可存取属性name 和 email 。它将为类实例建立 "getter" 和 "setter" 方法以便我们存取实例变量 @name 和 @email 。 在 Rails 中实例变量是可以通过类直接传递给视图文件并表示出来，而实例变量总是用@符号开头，而他们的初始化的值为 nil 。

要第一个实现的方法： initialize, 对于 Ruby 来说是一个很特殊的方法：该方法会在执行 User.new 的时候被调用。这里initialize函数接受一个参数“attributes”:

    def initialize(attributes = {})
      @name  = attributes[:name]
      @email = attributes[:email]
    end

这里attributes变量值就是空的哈希，所以我们可以定义一个没有email也没有name属性的用户。

最后，我们的类定义一个方法 formatted_email ，我们用它来生成一串更友好的用户字符串：

    def formatted_email
      "#{@name} <#{@email}>"
    end

因为 @name 和 @email 都是实例变量，他们将在 formatted_email 方法中默认可用

让我们打开console，我们的 user 文件引用上，看看效果如何：

    >> require './example_user'     # This is how you load the example_user code.
    => ["User"]
    >> example = User.new
    => #<User:0x224ceec @email=nil, @name=nil>
    >> example.name                 # nil since attributes[:name] is nil
    => nil
    >> example.name = "Example User"           # Assign a non-nil name
    => "Example User"
    >> example.email = "user@example.com"      # and a non-nil email address
    => "user@example.com"
    >> example.formatted_email
    => "Example User <user@example.com>"

在这里， '.' 是 Unix 下“当前目录”的意思,而'./example_user'就是让Ruby在当前的目录之下找到与example user 相关的文件。

记起来我们在Hash中学到的了么，我们可以用预先定义好的哈希参数来创建一个用户：

>> user = User.new(name: "Michael Hartl", email: "mhartl@example.com")
=> #<User:0x225167c @email="mhartl@example.com", @name="Michael Hartl">
>> user.formatted_email
=> "Michael Hartl <mhartl@example.com>"

在第七章我们还会遇上 叫 mass assignment 的技术，这在Rails中很常用。

4.5 总结

复习一下我们学到的Ruby知识。在第五章，我们要用他们开发构建自己的应用。
我们以后并不会实用 example_user.rb 文件，所以我建议你把它删了。


    $ rm example_user.rb

最后，用git记录并管理你的代码：

    $ git add .
    $ git commit -m "Add a full_title helper"

