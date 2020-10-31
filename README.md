# rime小狼毫\trime同文 极致简约 手机和PC一站配置【精选方案（四叶草拼音、小鹤双拼、极品五笔）\词库\皮肤配色\简繁转换\原创trime同文四叶草九宫拼音方案】
## 说明
- rime是一款支持多平台的开源输入法，开源所以不需要担心自己的输入数据被输入法所搜集。虽然优点这么多，但是要使得输入法好用起来门槛比较高了，主要是在词库配置优化，依赖的东西多而且复杂。**本项目的目的在于安卓手机端和Win pc端都可以从本项目一站配置好rime输入法，达到省心好用的程度**。鉴于PC端已经有很多大神有现成的设置，所以花的时间较少，主要是整理收集。

- **发现手机端的优化一直没有做的较好的优化，本次主要的工作量是在手机端**，所以从资源收集、皮肤设计、全键盘按钮设计和九宫格按键设计的每一个过程很耗费时间，有很多细节需要调整不断的修改文件和部署，有些地方不是清楚配置的地方还需要去看源码，经过一周的优化和设置，手机端已经使用起来很顺畅了。

- **目前在手机端配置了基于四叶草拼音的九宫格输入法，为了表示对原作者的劳动致敬，遂命名为四叶草九宫方案，感觉已经和之前使用的百度或者讯飞输入法感觉相当。**

- **感谢rime作者@[lotem](https://github.com/lotem)**

- **感谢trime作者@[osfans](https://github.com/osfans)**

- **感谢四叶草拼音作者@[fkxxyz](https://github.com/fkxxyz)**

- **感谢极品五笔作者@[KyleBing](https://github.com/KyleBing)**

- **感谢opencc作者@[BYVoid](https://github.com/BYVoid)**

- **感谢小鹤双拼@[flypy](https://www.flypy.com/)**

- **没有以上各位的辛苦付出，也就没有这么好用的输入法**

- **enjoy it! 好用的话就点个赞。感谢你的使用，因为本人同时在安卓和windows端使用，所以会一直更新。**
## 更新说明
#### 2020-10-31
- 1.新增双拼输入方案支持-小鹤双拼
- 2.所有输入方案配置支持繁简转换、中英转换、字符输入、emoji表情、全半角转换

#### 2020-10-27
- 1.新增讯飞皮肤
- 2.更新部分细节

#### 2020-10-25
- 1.去除了明月拼音，添加了以搜狗为基础的输入方案——🍀️四叶草简体拼音
- 2.以🍀️四叶草简体拼音为基础，添加了四叶草九宫输入方案，方便在手机端可以使用
- 3.同文手机端添加了两款机械键盘主题，cherry机械键盘/罗技
- 4.四叶草拼音输入法在手机端支持简繁转有一些问题，原因是没有正确配置opencc，修改后手机端支持简繁转换
- 5.极品五笔方案增加支持字符（输入`平方`可以选择`²`），emoji表情，繁简转换

### 包含输入方案
 - 极点五笔：https://github.com/KyleBing/rime-wubi86-jidian 
>支持五笔反查
>
>![Image text](/Res/wubireverse.png)
 - 小鹤双拼：https://www.flypy.com/index.html 
>
>![Image text](/Res/xiaohe.png)
 - 🍀️四叶草简体拼音：https://github.com/fkxxyz/rime-cloverpinyin
 - 大写数字

## 输入法预览：
### 小狼毫（PC端）
- 简约现代蓝[配色：XNOM]

![Image text](/Res/preview_blue.png)
- 绿野仙踪绿[配色：佛振]

![Image text](/Res/preview_green.png)
- Aqua[配色：佛振]

![Image text](/Res/preview_blue1.png)
- 安卓[配色：Patricivs]

![Image text](/Res/preview_android.png)
- 暗堂[配色：佛振]

![Image text](/Res/preview_dark.png)
- 孤寺[配色：佛振]

![Image text](/Res/preview_temple.png)

### 同文（安卓端）

##### 🍀️四叶草九宫输入方案
![Image text](/Res/trime_preview_jiugong.jpg)

##### 手机端支持简繁转换

![Image text](/Res/trime_convert.jpg)


#### 部分皮肤预览

##### 讯飞默认皮肤[配色：Jaaiko，键盘布局：Jaaiko]

![Image text](/Res/trime_xunfei.png)

##### cherry机械键盘【小先生】

![Image text](/Res/trime_cherry.png)


##### 极致简约[配色：Jaaiko，键盘布局：Jaaiko]

![Image text](/Res/trime_preview.png)


##### 默认黑【佚名】

![Image text](/Res/trime_wubi.png)


##### 五笔字根【佚名】

![Image text](/Res/trime_wubizigen.png)


##### 炫彩[键盘布局：Jaaiko]

![Image text](/Res/trime_xuancai.png)



## 安装方法
#### 小狼毫（PC端）
><font face="微软雅黑" color=#000000>0.备份小狼毫输入法安装目录的`data`文件夹，备份`~\AppData\Rime`文件夹</font>
><font face="微软雅黑" color=#000000>1.文件夹`weasel\data`内所有文件复制到小狼毫输入法`data`目录覆盖</font>
><font face="微软雅黑" color=#000000>2.文件夹`weasel\Rime`内所有文件复制到`~\AppData\Rime`目录覆盖</font>
><font face="微软雅黑" color=#000000>3.文件夹`schemes\基础文件`内所有文件复制到`~\AppData\Rime`目录覆盖</font>
><font face="微软雅黑" color=#000000>4.拼音、五笔和双拼方案安装</font>
>><font face="微软雅黑" color=#000000>4.1 拼音方案安装</font>
>>><font face="微软雅黑" color=#000000>文件夹`schemes\Clover四叶草拼音`内所有文件复制到`~\AppData\Rime`目录覆盖</font>
>>
>><font face="微软雅黑" color=#000000>4.2 五笔方案安装（五笔反查依赖拼音词库，需先安装3.1拼音方案）</font>
>>><font face="微软雅黑" color=#000000>文件夹`schemes\极点五笔`内所有文件复制到`~\AppData\Rime`目录覆盖</font>
>>
>><font face="微软雅黑" color=#000000>4.3 双拼方案安装</font>
>>><font face="微软雅黑" color=#000000>文件夹`schemes\小鹤双拼`内所有文件复制到`~\AppData\Rime`目录覆盖</font>
>>
><font face="微软雅黑" color=#000000>5.重新部署</font>

#### 同文（安卓端）
><font face="微软雅黑" color=#000000>0.备份`sdcard\rime`文件夹</font>
><font face="微软雅黑" color=#000000>1.文件夹`trime\rime`内所有文件复制到`sdcard\rime`目录覆盖</font>
><font face="微软雅黑" color=#000000>2.文件夹`schemes\基础文件`内所有文件复制到`sdcard\rime`目录覆盖</font>
><font face="微软雅黑" color=#000000>3.拼音、五笔和双拼方案安装</font>
>><font face="微软雅黑" color=#000000>3.1 拼音方案安装</font>
>>><font face="微软雅黑" color=#000000>文件夹`schemes\Clover四叶草拼音`内所有文件复制到`sdcard\rime`目录覆盖</font>
>>
>><font face="微软雅黑" color=#000000>3.2 五笔方案安装（五笔反查依赖拼音词库，需先安装3.1拼音方案）
>>>文件夹`schemes\极点五笔`内所有文件复制到`sdcard\rime`目录覆盖</font>
>>
>><font face="微软雅黑" color=#000000>3.3 双拼方案安装</font>
>>><font face="微软雅黑" color=#000000>文件夹`schemes\小鹤双拼`内所有文件复制到`sdcard\rime`目录覆盖</font>
>>
><font face="微软雅黑" color=#000000>4.重新部署</font>


## 相关资源
 - 小狼毫输入法：https://github.com/rime/weasel
 - 同文输入法：https://github.com/osfans/trime
 - 简繁转换opencc：https://github.com/BYVoid/OpenCC
 - 部分配色均整理自互联网，配色包含作者信息。
