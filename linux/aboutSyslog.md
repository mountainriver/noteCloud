# 规范
关于syslog协议的描述，现在主要有两个规范：一个是RFC3164，另外一个是RFC3195。而这两个协议在内容上，并不一样，或者说相差很大。(目前RFC3164已经被RFC5424所取代)
- RFC3164主要讲的是关于syslog协议的格式以及在网络中传输的各种规则，但是其并没有很严格的规定，很多都是建议、约定之类的术语。这是因为RFC3164出来的比较晚，很多实际中已经应用了，所以目前该协议比较混乱，并没有很严格的要求。
- RFC3195主要说的是保证syslog消息可靠传输的规范。因为RFC3164依靠UDP协议是无法提供可靠的传输的。为了保证其安全性，此规范定义了使用tcp协议来实现可靠传输，但是目前这个协议应用并不多，所以接下来的讨论也并不会涉及到此方面。
# syslog的历史
Syslog 最早约在1980年代由 Sendmail project 的 Eric Allman 所发展，最初单纯只为了 Sendmail。由于 syslog 显示出了他的价值，所以后来慢慢的成为 unix 及 unix-like 系统的标准记录方式，直到演进成为大部分网路设备厂所支援的情况。可是奇妙的是，syslog 和大部分的网路协定标准不同，他一直没有任何标准去规定他的记录格式，造成许多的syslog判读及分析困难。直到2001年由 Internet Engineering Task Force (IETF) 才制定了 RFC3164 - The BSD Syslog Protocol 作为 syslog 第一个标准，这个标准一直到 2009年的 RFC 5424 - The Syslog Protocol 出现后才被废止，而 RFC 5424 也成为今日 syslog 的标准，但是此标准非常的新，只有非常少的系统会去支援RFC 5424，现存设备仍以RFC 3164为基准。由以上提到的 syslog 的历史可知，syslog 并没有一个大家共同的标准规范，也就造成了各式各样 syslog 格式的出现。但是只要目的是514端口的udp封包，我们就要当他是syslog 的封包，且受限于udp，一个syslog的封包最大是1024个bytes。
# syslog包格式(RFC3164)
Syslog包分为3个部分，PRI, HEADER,以及MSG，总长度不能超过1024个字节。
下面是一个syslog消息：
> <30>Oct 9 22:33:20 hlfedora auditd[1787]: The audit daemon is exiting.
1. PRI部分由尖括号包含的一个数字构成，这个数字包含了程序模块（Facility）、严重性（Severity），这个数字是由Facility乘以 8，然后加上Severity得来。  
也就是说这个数字如果换成2进制的话，低位的3个bit表示Severity，剩下的高位的部分右移3位，就是表示Facility的值。  
十进制30 = 二进制0001 1110  
0001 1... = Facility: DAEMON - system daemons (3)  
.... .110 = Severity: INFO - informational (6)))  
	- 因该字段只存在于syslog报文包头部分，在log中并不可见。
2. HEADER部分包括两个字段，时间和主机名（或IP）。
	1. 时间紧跟在PRI后面，中间没有空格，格式必须是“Mmm dd hh:mm:ss”，不包括年份。“日”的数字如果是1～9，前面会补一个空格（也就是月份后面有两个空格），而“小时”、“分”、“秒”则在前面补“0”。月份取值包括：  
	Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec  
	2. 时间后边跟一个空格，然后是主机名或者IP地址，主机名不得包括域名部分。
	因为有些系统需要将日志长期归档，而时间字段又不包括年份，所以一些不标准的syslog格式中包含了年份，例如：
	> <165>Aug 24 05:34:00 CST 1987 mymachine myproc[10]: %% It's
	time to make the do-nuts. %% Ingredients: Mix=OK, Jelly=OK #
	Devices: Mixer=OK, Jelly_Injector=OK, Frier=OK # Transport:
	Conveyer1=OK, Conveyer2=OK # %%

	这样会导致解析程序将“CST”当作主机名，而“1987”开始的部分作为MSG部分。解析程序面对这种问题，可能要做很多容错处理，或者定制能解析多种syslog格式，而不仅仅是只能解析标准格式。
3. HEADER部分后面跟一个空格，然后是MSG部分。
有些syslog中没有HEADER部分。这个时候MSG部分紧跟在PRI后面，中间没有空格。  
MSG部分一般包含生成消息的进程信息(TAG field)以及消息正文(CONTENT field)。TAG部分主要是包含生成消息的进程信息，不能超过32个字符。消息体必须是一些可见字符，这部分就是消息的正文。TAG与CONTENT之间的间隔用非字母表字母隔开，一般用”[“,”:”或者空格隔开。
>需要注意的是虽然RFC3164规定了syslog报文的大小不得超过1024字节，但是在实际情况中，会经常发现有大于该大小的报文(尤其是H3C的设备)，至于原因在前面已经说过了。另sysklogd和rsyslog两种程序对syslog报文的解析也不是完全相同，例如sysklogd就无法正确解析这样的时间戳：%May 2 19:07:49:225 2013；而rsyslog则会误将2013解析为header的hostname等等。
