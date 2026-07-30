# 🍀 rime-pure：手机 / PC 一站式 Rime 输入法配置

> **基于 Rime（小狼毫 / 同文）的极简、优雅、好用的中英文输入方案整合包。**  
> 包含：四叶草九宫格拼音 / 四叶草拼音 / 小鹤双拼 / 极品五笔 / QQ五笔 / 徐码 / 郑码 等主流方案。

![visitors](https://visitor-badge.laobi.icu/badge?page_id=SivanLaai/rime-pure)

---

## 🎉 [rime-pure] 久违的更新预告 / Update Teaser （预计近几天发布）

> **好久不见！** 感谢大家一直以来的关注与耐心等待。因个人原因一直忙碌，距离上次更新已经有很长一段时间，之前的主题配置文件在**最新版「同文输入法」 (Trime)** 上出现了一些兼容性与适配问题。  
> 
> 为了让大家能获得最顺畅的体验，我对项目进行了全面适配优化，并对安装流程做了极大的简化！

### 🚀 本次更新核心亮点

#### 1. 🔄 全面兼容新版同文输入法
- 修复了因为版本升级导致的主题样式错乱、按键错位等不兼容问题。
- 优化视觉体验，继续保持 `rime-pure` 一贯的**极简、优雅、高效**设计理念。
- **预览剧透：全新适配的九宫格布局界面**（清爽简洁的色调与精致的键位反馈）：

*(最新九宫格主页面预览)*  
<img src="https://cdn.statically.io/gh/SivanLaai/picx-images-hosting@master/rime/new_main_jiugong.6wrfq7miuq.webp" width="48%" alt="九宫格预览" />
*(最新九宫格输入中预览)*  
<img src="https://cdn.statically.io/gh/SivanLaai/picx-images-hosting@master/rime/new_jiugong.1lcj5hqhzw.webp" width="48%" alt="九宫格输入预览" />

#### 2. 📦 傻瓜式一键体验：Debug 完整包打包
为了降低新手配置 Rime 各种繁琐文件的门槛，本次更新新增了 **Debug 包集成安装** 方式（之后也可随时卸载 Debug 版并安装常规 Release 版本）：
- **开箱即用**：直接将**所有配置、词库、样式文件**以 Debug 包的形式统一整合。
- **告别繁琐**：无需再手动反复拷贝、替换配置文件，也不用担心因漏删改文件导致的解析报错。
- **即装即享**：一键安装生效，用最简单的方式拥有最纯粹的中文输入体验。

---

## 🛠️ 下一步计划 / Coming Soon

- [ ] 正式发布适配最新版 Trime 的完整 release 版本
- [ ] 欢迎大家试用并在 Issue 中提意见或反馈 Bug！

---

## 📦 极简安装说明

本项目提供了针对新旧用户、不同定制需求的灵活部署方式：

### 📱 安卓端（同文输入法）

#### 1. 安装方法
下载并直接安装本项目发布出的最新版 **Debug APK**，安装后即可直接开启极简中文输入体验。

#### 2. 主题样式（`backgrounds`）的两种配置方式
项目优化的皮肤与背景配置（`backgrounds`），支持以下两种加载方式：
*   **方式 A：内置免配置（新手推荐 / 开箱即用）**  
    本项目的 **Debug APK 中已直接内置了 `backgrounds` 相关文件与样式资源**。您在成功安装 APK 后，可以直接打开同文输入法的「主题 / 设置」页面进行切换使用，无需做任何文件复制。
*   **方式 B：手动解压放置（适合进阶 / 长期定制）**  
    您也可以从项目仓库中下载 `backgrounds` 文件夹，并将其**完整复制到手机内部存储的 `rime` 根目录下**。同文输入法会读取外部文件，这种方式更利于您对个性化皮肤进行独立修改、后续覆盖或在非内置包的 Release 版本中使用。

> 📖 **完整指南**：更详细的 PC 端安装及高级教程，请参考 **[官方安装方法指南](https://blog.laais.cn/posts/projects/rime/installation/)**。

---

## ⌨️ 实用功能与快捷操作 (非常重要)

同文输入法触控端配置了丰富的高效手势与隐藏功能，全键盘与九宫格状态均做了针对性优化：

| 功能 | 全键盘状态 | 九宫格状态 |
| :--- | :--- | :--- |
| **隐藏键盘** | 按键 `G` **向下滑动** | 按 **分词键** **向下滑动** |
| **编辑功能** | **长按** `G` 键（复制/粘贴/剪切等） | 按 **编辑** 键 |
| **清空文本** | 删除键 **向左滑动** | 删除键 **向左滑动** |
| **切换主题** | 进入设置中进行切换 | **长按** 带 **`❖`** 的按键 |
| **切换输入法** | **长按** 带 **`✎`** 的按键 | **长按** 带 **`✎`** 的按键 |
| **进入设置** | 长按 **`⚙` (设置)** 键 | 按 **`⚙` (设置)** 键 |

---

### 💡 进阶技巧：五笔字根助记键盘设置

对于正在学习或常用五笔的用户，同文手机端支持一键开启**「五笔字根助记键盘」**。为了获得最佳的键位和字根显示效果，**强烈建议搭配主推皮肤「五笔白色」使用**。

#### 🔧 设置步骤：
1. **切换推荐主题**：进入同文输入法设置（或长按带 `❖` 键），优先将主题切换为 **「五笔白色」**（字根排版最清晰、最适配）。
2. **打开菜单翻页**：打开键盘，点击进入功能菜单，滑动或点击菜单**最下侧的「两个点 (••)」**跳转至下一页【助记菜单】。
3. **开启助记键盘**：在界面中选择 **「助记」** 按钮，键盘即可实时切换为带有五笔字根分布的助记模式。
4. **还原默认键盘**：如需切回普通键盘，在同层菜单中点击 **「默认」** 按钮即可快速恢复。

#### 📸 五笔字根助记键盘预览

*(图 1：进入键盘设置 / 底部双点跳转演示)*  
<img src="https://cdn.statically.io/gh/SivanLaai/picx-images-hosting@master/rime/plus_menu_switch.362a66xo44.webp" width="68%" alt="五笔助记步骤一占位图" />

*(图 2：五笔白色主题 + 字根助记键盘实测效果)*  
<img src="https://cdn.statically.io/gh/SivanLaai/picx-images-hosting@master/rime/wubi_keyboard.9rk3x82iiz.webp" width="68%" alt="五笔字根键盘效果占位图" />

---

## 📖 项目说明 & 设计理念

- rime 是一款支持多平台的开源输入法，开源所以不需要担心自己的输入数据被输入法所搜集。虽然优点这么多，但是要使得输入法好用起来门槛比较高了，主要是在词库配置优化，依赖的东西多而且复杂。**本项目的目的在于安卓手机端和 Win pc 端都可以从本项目一站配置好 rime 输入法，达到省心好用的程度**。鉴于 PC 端已经有很多大神有现成的设置，所以花的时间较少，主要是整理收集。
- **发现手机端的优化一直没有做的较好的优化，本次主要的工作量是在手机端**，所以从资源收集、皮肤设计、全键盘按钮设计和九宫格按键设计的每一个过程很耗费时间，有很多细节需要调整不断的修改文件和部署，有些地方不是清楚配置的地方还需要去看源码，经过一周的优化和设置，手机端已经使用起来很顺畅了。
- **目前在手机端配置了基于四叶草拼音的九宫格输入法，为了表示对原作者的劳动致敬，遂命名为四叶草九宫方案，感觉已经和之前使用的百度或者讯飞输入法感觉相当。**
- **enjoy it! 好用的话就点个赞。感谢你的使用，因为本人同时在安卓和 windows 端使用，所以会一直更新。**

---

## 📚 包含输入方案

- [🍀️四叶草拼音九宫格](https://github.com/SivanLaai/rime-pure)（不再使用原来的词库，原来的词库有很多问题，现在只是保留名字。）
- [四叶草地球拼音](https://github.com/SivanLaai/rime-pure/tree/master/schemes/Clover%E5%9B%9B%E5%8F%B6%E8%8D%89%E5%9C%B0%E7%90%83%E6%8B%BC%E9%9F%B3)
- [极点五笔](https://github.com/KyleBing/rime-wubi86-jidian)
- [小鹤双拼](https://www.flypy.com/index.html)
- [🍀️四叶草简体拼音](https://github.com/fkxxyz/rime-cloverpinyin)
- 大写数字
- 自然双拼
- **QQ86五笔**（**提取自 QQ 五笔输入法，词库较为合理，推荐使用也是本人在使用的方案**）
- [徐码](https://www.xumax.top/)
- [郑码](http://zmdisk.ys168.com/)

---

## 🎨 皮肤与界面预览

### 同文输入法（安卓手机端）

#### 表情 \ 剪切板 \ 符号功能板

历史记录栏  
<img src="https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/clipboard2.3tyjgfvf6x40.jpg" width=380>

剪切板  
<img src="https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/clipboard.466h70ifs0i0.jpg" width=380>

表情包  
<img src="https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/clipboard1.7kten0vv8uo0.jpg" width=380>

#### 🍀️四叶草九宫输入方案
![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/trime_preview_jiugong.3vyf36hha4q0.jpg)

#### 手机端支持简繁转换
![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/trime_convert.5pjs6ljodh00.jpg)

#### 部分皮肤预览

##### 同文风优化版 [配色：SivanLaai，键盘布局：SivanLaai]
![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/trime_tongwen.3z9r9pmc5ko0.png)

##### 讯飞默认皮肤 [配色：SivanLaai，键盘布局：SivanLaai]
![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/trime_xunfei.5tewulxml340.png)

##### cherry机械键盘【小先生】
![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/trime_cherry.6ibtk68ohb80.png)

##### 极致简约 [配色：SivanLaai，键盘布局：SivanLaai]
![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/trime_preview.5g84abqu3a00.png)

##### 五笔字根【佚名】
![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/trime_wubizigen.58iqusedxr40.png)

##### 炫彩 [键盘布局：SivanLaai]
![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/trime_xuancai.5k9xzrtj80o0.png)

---

### 小狼毫输入法（PC端）

- 简约现代蓝 [配色：XNOM]  
  ![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/preview_blue.2lyjsr0q0cu0.png)
- 绿野仙踪绿 [配色：佛振]  
  ![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/preview_green.6b8wbkfogzc0.png)
- Aqua [配色：佛振]  
  ![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/preview_blue1.1zkbreawyluo.png)
- 安卓 [配色：Patricivs]  
  ![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/preview_android.752cop13gfg0.png)
- 暗堂 [配色：佛振]  
  ![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/preview_dark.fn4qmzlq1i8.png)
- 孤寺 [配色：佛振]  
  ![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/rime/preview_temple.eba0ht77dio.png)

---

## 📜 更新历史 (精选)

#### 2026-06-18
项目很久没有进行更新了，本人最近有更新的计划，目前可能会先把词库这些更新到最新版本，后续看工作量把 UI 这些也看是否能够迁移。

#### 2023-12-19
- 升级 bigram 语言模型至先用 IDA 逆向分析，再编写 C 代码提取和转换为 Rime 格式的 [华宇拼音 v7](https://pinyin.thunisoft.com/index.html) 模型，同时优化语言模型的 bigram 频率和参数，提升输入法预测短语和句子的准确率。[@warm-ice0x00](https://github.com/warm-ice0x00)

#### 2023-05-09
- 添加转换自 [华宇拼音 v6.9.1.183](http://srf.unispim.com/software/index.php) 的 bigram 语言模型，解决 Rime 缺乏符合简体中文语言习惯的语言模型的问题，提升预测短语和句子的准确性，从而提升输入效率。[@warm-ice0x00](https://github.com/warm-ice0x00)

#### 2022-12-30
- 1.移除九宫模式下 ascii 模式的切换。
- 2.优化九宫数字键盘布局。  
  ![Image text](https://cdn.staticaly.com/gh/SivanLaai/image-store-rep@master/note/20221230200634.png)

#### 2022-11-4
- 1.优化四叶草拼音的基础词库为华宇输入法词库[@warm-ice0x00](https://github.com/warm-ice0x00)（不再使用原来的词库，原来的词库有很多问题。）

#### 2022-3-19
- 1.调整剪切板功能快捷方式
- 2.qq86五笔用户词添加不成功修复

#### 2021-10-26
- 1.修复 3.2.3 所引入的键盘显示问题
- 2.调整键盘的符号页面，详情查看同文功能页面
- 3.调整数字页面为更加符合操作的九宫格数字页面
- 4.输入键盘快速跳转符号剪切栏

#### 2021-10-20
- 1.四叶草拼音的权重调整为最大概率保留，同时是以词组进行切割的，例如弹出如果是分词的话就是 `tanchu`，不会再出现 `danchu` 的拼音，如果弹出不是一个完整的分词那拼音可能是按单个字保留拼音的最大概率。主要改动在 [src/GenerateCloverData.py](./src/GenerateCloverData.py)。
- 2.四叶草简体支持符号输入优化，`/fh` 可以查看当前的符号，`/jq` 可以查看所有的节气
- 3.四叶草简体支持笔画反查（后输入 `hspnz` 分别表示 `一丨丿丶乙`）

#### 2021-10-17
- 1.修复同文端繁简转换 opencc 资源文件为最新的 ocd2，小狼毫端暂时不支持 ocd2。

#### 2021-10-14
- 1.同步更新同文官方支持的剪切板功能，可以查看剪切板和最近表情包历史，使用更为灵活的符号菜单。

#### 2021-09-01
- 1.前前后后、零零碎碎一共花了十来天的时间完成基于四叶草词库的地球拼音输入方案。  
  ![Image text](https://user-images.githubusercontent.com/33414148/131670446-5d9b6245-70cc-4ed0-8b6e-0667a56f06e7.png)

#### 2021-08-30
- 1.四叶草支持多音字，最大程序的避免拼音错误，同时是以词组来分词的所以，不至于对所有的词组进行挨个多音字支持，而是优先词组。例如 `弹出` 分词后还是 `弹出`，所以只有 `tan chu` 的拼音，如果分词为 `弹\出` 的话，则拼音会有 `tan chu` 和 `dan chu`。
- 2.四叶草保留最大概率拼音词组，例如 `是不` 其中 `不` 为多音字，`不` 的拼音有 `bu` 和 `fou`，基于四叶草统计概率，`bu` 的拼音概率更高，如果不是在词组的情况下，单字以 `bu` 为优先。

#### 2021-08-18
- 1.写 [爬虫exact-pinyin-mark](https://github.com/SivanLaai/exact-pinyin-mark) 抓取 [百度汉语](https://hanyu.baidu.com/) 字典 35W 个组词数据用来精准匹配 clover 拼音数据。
- 2.使用 [luna拼音](https://github.com/rime/rime-luna-pinyin) 修复 clover 拼音数据。
- 3.使用 [phrase-pinyin-data](https://github.com/mozillazg/phrase-pinyin-data) 修复 clover 拼音数据。
- 4.具有更高的基础词库，对于常见的拼音数据具有更高的识别率。

#### 2021-08-11
- 1.修复大字典中的拼音错误。
- 2.基于 [python-pinyin](https://github.com/mozillazg/python-pinyin) 对所有四叶草字典进行多音字修复，同时单字也支持多音字输入。
  ```text
  例如“朝”拼 chao zhao zhu 输入：
  词频调整 chao 保留最高，依次递减10倍
  例如 chao 为 123，zhao 为 12，zhu 为 1