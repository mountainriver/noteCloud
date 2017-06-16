Windows中默认的文件格式是GBK(gb2312)，而Linux一般都是UTF-8)
# 查看文件编码
file xxx
# 只是解决VIM查看文件乱码问题
- 在~/.vimrc 中添加 set encoding=utf-8 fileencodings=ucs-bom,utf-8,cp936
- termencoding 
# 编码转换
1. vim 中
set fileencoding=utf-8  将会将文件以UTF-8格式保存
2. 直接转换文件
iconv -f GBK -t UTF-8 file1 -o file2
# 个人理解
1. encoding 决定VIM内部编码。
2. fileencoding 决定文件存储时使用的编码
3. fileencodings 决定读取文件的编码选择顺序、列表
4. termencoding 决定输出到屏幕使用那种编码

# 1.相关基础知识介绍

在Vim中，有四个与编码有关的选项，它们是：fileencodings、fileencoding、encoding和termencoding。在实际使用中，任何一个选项出现错误，都会导致出现乱码。因此，每一个Vim用户都应该明确这四个选项的含义。下面，我们详细介绍一下这四个选项的含义和作用。

（1）encoding
encoding是Vim内部使用的字符编码方式。当我们设置了encoding之后，Vim内部所有的buffer、寄存器、脚本中的字符串等，全都使用这个编码。Vim 在工作的时候，如果编码方式与它的内部编码不一致，它会先把编码转换成内部编码。如果工作用的编码中含有无法转换为内部编码的字符，在这些字符就会丢失。因此，在选择 Vim 的内部编码的时候，一定要使用一种表现能力足够强的编码，以免影响正常工作。
由于encoding选项涉及到Vim中所有字符的内部表示，因此只能在Vim启动的时候设置一次。在Vim工作过程中修改encoding会造成非常多的问题。用户手册上建议只在 .vimrc中改变它的值，事实上似乎也只有在 .vimrc中改变它的值才有意义。如果没有特别的理由，请始终将encoding设置为utf-8。为了避免在非UTF-8的系统如Windows下，菜单和系统提示出现乱码，可同时做这几项设置：
set encoding=utf-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8

（2）termencoding
termencoding是Vim用于屏幕显示的编码，在显示的时候，Vim会把内部编码转换为屏幕编码，再用于输出。内部编码中含有无法转换为屏幕编码的字符时，该字符会变成问号，但不会影响对它的编辑操作。如果termencoding没有设置，则直接使用encoding不进行转换。
举个例子，当你在Windows下通过telnet登录Linux工作站时，由于Windows的telnet是GBK编码的，而Linux下使用UTF-8编码，你在telnet下的Vim中就会乱码。此时有两种消除乱码的方式：一是把Vim的encoding改为gbk，另一种方法是保持encoding为utf-8，把termencoding改为gbk，让Vim在显示的时候转码。显然，使用前一种方法时，如果遇到编辑的文件中含有GBK无法表示的字符时，这些字符就会丢失。但如果使用后一种方法，虽然由于终端所限，这些字符无法显示，但在编辑过程中这些字符是不会丢失的。
对于图形界面下的GVim，它的显示不依赖TERM，因此termencoding对于它没有意义。在GTK2下的GVim 中，termencoding永远是utf-8，并且不能修改。而Windows下的GVim则忽略termencoding的存在。

（3）fileencoding
当Vim从磁盘上读取文件的时候，会对文件的编码进行探测。如果文件的编码方式和Vim的内部编码方式不同，Vim就会对编码进行转换。转换完毕后，Vim会将fileencoding选项设置为文件的编码。当Vim存盘的时候，如果encoding和fileencoding不一样，Vim就会进行编码转换。因此，通过打开文件后设置fileencoding，我们可以将文件由一种编码转换为另一种编码。但是，由前面的介绍可以看出，fileencoding是在打开文件的时候，由Vim进行探测后自动设置的。因此，如果出现乱码，我们无法通过在打开文件后重新设置fileencoding来纠正乱码。
简而言之，fileencoding是Vim中当前编辑的文件的字符编码方式，Vim保存文件时也会将文件保存为这种字符编码方式 (不管是否新文件都如此)。

（4）fileencodings
编码的自动识别是通过设置fileencodings实现的，注意是复数形式。fileencodings是一个用逗号分隔的列表，列表中的每一项是一种编码的名称。当我们打开文件的时候，VIM按顺序使用fileencodings中的编码进行尝试解码，如果成功的话，就使用该编码方式进行解码，并将fileencoding设置为这个值，如果失败的话，就继续试验下一个编码。
因此，我们在设置fileencodings的时候，一定要把要求严格的、当文件不是这个编码的时候更容易出现解码失败的编码方式放在前面，把宽松的编码方式放在后面。例如，latin1是一种非常宽松的编码方式，任何一种编码方式得到的文本，用latin1进行解码，都不会发生解码失败——当然，解码得到的结果自然也就是理所当然的“乱码”。因此，如果你把latin1放到了fileencodings的第一位的话，打开任何中文文件都是乱码也就是理所当然的了。
以下是网上推荐的一个fileencodings设置：

set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
其中，ucs-bom是一种非常严格的编码，非该编码的文件几乎没有可能被误判为ucs-bom，因此放在第一位。
utf-8也相当严格，除了很短的文件外(例如许多人津津乐道的GBK编码的“联通”被误判为UTF-8编码的经典错误)，现实生活中一般文件是几乎不可能被误判的，因此放在第二位。
接下来是cp936和gb18030，这两种编码相对宽松，如果放前面的话，会出现大量误判，所以就让它们靠后一些。cp936的编码空间比gb18030小，所以把cp936放在gb18030前面。
至于big5、euc-jp和euc-kr，它们的严格程度和cp936差不多，把它们放在后面，在编辑这些编码的文件的时候必然出现大量误判，但这是Vim内置编码探测机制没有办法解决的事。由于中国用户很少有机会编辑这些编码的文件，因此我们还是决定把cp936和gb18030放在前面以保证这些编码的识别。
最后就是latin1了。它是一种极其宽松的编码，以至于我们不得不把它放在最后一位。不过可惜的是，当你碰到一个真的latin1编码的文件时，绝大部分情况下，它没有机会fall-back到latin1，往往在前面的编码中就被误判了。不过，正如前面所说的，中国用户没有太多机会接触这样的文件。
如果编码被误判了，解码后的结果就无法被人类识别，于是我们就说，这个文件乱码了。此时，如果你知道这个文件的正确编码的话，可以在打开文件的时候使用 ++enc=encoding 的方式来打开文件，如：
:e ++enc=utf-8 myfile.txt

2.Vim的工作原理

好了，解释完了这一堆容易让新手犯糊涂的参数，我们来看看Vim的多字符编码方式支持是如何工作的。
（1）Vim启动，根据 .vimrc中设置的encoding的值来设置buffer、菜单文本、消息文的字符编码方式。
（2）读取需要编辑的文件，根据fileencodings中列出的字符编码方式逐一探测该文件编码方式。并设置fileencoding为探测到的，看起来是正确的字符编码方式。事实上，Vim 的探测准确度并不高，尤其是在encoding没有设置为utf-8时。因此强烈建议将encoding设置为utf-8，虽然如果你想Vim显示中文菜单和提示消息的话这样会带来另一个小问题。
（3）对比fileencoding和encoding的值，若不同则调用iconv将文件内容转换为encoding所描述的字符编码方式，并且把转换后的内容放到为此文件开辟的buffer里，此时我们就可以开始编辑这个文件了。注意，完成这一步动作需要调用外部的iconv.dll(注2)，你需要保证这个文件存在于$VIMRUNTIME或者其他列在PATH环境变量中的目录里。
（4）编辑完成后保存文件时，再次对比fileencoding和encoding的值。若不同，再次调用iconv将即将保存的buffer中的文本转换为fileencoding所描述的字符编码方式，并保存到指定的文件中。同样，这需要调用iconv.dll

3.解决办法示例

（1）方法一：设定.vimrc文件：
在/home/username/.vimrc或者/root/.vimrc下增加两句话：
let &termencoding=&encoding
set fileencodings=utf-8,gbk,ucs-bom,cp936
这种办法可以实现编辑UTF-8文件

（2）方法而二：打开文件后，在vi编辑器中设定：
:set encoding=utf-8 termencoding=gbk fileencoding=utf-8

（3）方法三：新建UTF-8文件，在vi编辑器设定：
:set fenc=utf-8
:set enc=GB2312
这样在编辑器里输入中文，保存的文件是UTF-8。

（4）方法四：一个推荐的～/.vimrc文件配置：
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,latin1
set termencoding=gb18030
set expandtab
set ts=4
set shiftwidth=4
set nu
syntax on

if has('mouse')
set mouse-=a
endif
