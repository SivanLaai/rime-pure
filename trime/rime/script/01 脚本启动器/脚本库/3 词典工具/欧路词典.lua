--[[
--无障碍版专用脚本
--用途：欧路词典，自动打开欧路词典(若存在)查词界面，查询指定内容

--版本号: 2.0
--制作日期
▂▂▂▂▂▂▂▂
日期: 2020年03月25日🗓️
农历: 鼠(庚子)年三月初二
时间: 22:53:50🕥
星期: 周三
--制作者: 风之漫舞
--首发qq群: 同文堂(480159874)
--邮箱: bj19490007@163.com(不一定及时看到)
--如何安装并使用: 请参考群文件，路径[同文无障碍LUA脚本]->同文无障碍版lua脚本使用说明.pdf

--配置说明
第①步 将 词典.lua 文件放置 rime/script 文件夹内


]]

require "import"
import "android.widget.*"
import "android.view.*"
import "java.io.*"
import "android.content.*" 

import "script.包.其它.首次启动提示"


local function 分享文字到欧路(导入内容)
 --分享文字到欧路
 text=导入内容
 intent=Intent(Intent.ACTION_SEND); 
 intent.setType("text/plain"); 
 intent.putExtra(Intent.EXTRA_SUBJECT, "分享"); 
 intent.putExtra(Intent.EXTRA_TEXT, text); 
 intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); 
 --重点，指定包名和分享界面
 componentName =ComponentName("com.qianyan.eudic","com.eusoft.dict.activity.dict.LightpeekActivity");
 intent.setComponent(componentName)
 
 service.startActivity(Intent.createChooser(intent,"分享到:")); 

end--function 分享文字到欧路

--大写字母前面加空格
local function 大写字母前加空格(内容)
 大写字母="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 for i=1,#大写字母 do
  内容=内容:gsub(大写字母:sub(i,i)," "..大写字母:sub(i,i))
  
  
 end
 
 return 内容
end--function 大写加空格(内容)


local 参数 = (...)
local 默认宽度=33


local 脚本目录=tostring(service.getLuaExtDir("script"))
local 脚本路径=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径
--local 目录=string.sub(脚本路径,1,倒找字符串(脚本路径,"/")-1)
local 纯脚本名=File(脚本路径).getName()
local 脚本相对路径=string.sub(脚本路径,#脚本目录+1)
local 配置文件=脚本目录.."/脚本配置_勿删.txt"

local 脚本名=File(脚本路径).getName()
local 提示内容=[[
说明:本脚本需配合欧路词典app
将自动打开欧路词典(若存在)查词界面，查询指定内容
若存在多个候选,可通过方向键移动到指定候选再进行查询
]]
首次启动提示(脚本名,提示内容)


local 候选=""
if string.find(参数,"【【")!=nil && string.find(参数,"】】")!=nil then
 if 参数:sub(-13)=="【【3】】" then 
  候选=service.getSystemService(Context.CLIPBOARD_SERVICE).getText() --获取剪贴板 
  候选=tostring(候选)
 end--if 参数=="【【3】】"
 if 参数:sub(-13)=="【【1】】" then 
  候选=string.sub(参数,1,string.find(参数,"【【")-1)
 end--if 参数=="【【1】】"
 if 参数:sub(-13)=="【【2】】" then 
  候选=string.sub(参数,1,string.find(参数,"【【")-1)
  候选=大写字母前加空格(候选)
 end--if 参数=="【【2】】"
end--if string.find(参数


if 候选!="" then 分享文字到欧路(候选) end

local 已启用=false
local 定制宽度=默认宽度
if File(配置文件).exists() then--配置文件存在
  for c in io.lines(配置文件) do--按行读取文件,检测脚本是否己启用
   if c=="欧路词典定制=已启用" then
    已启用=true
    定制宽度=25
   end
  end--for
end--if 配置文件




local 按键组={}
 --第1行
 local 按键={}
 按键["width"]=100
-- 按键["height"]=25
 按键["click"]=""
 按键["label"]=string.sub(纯脚本名,1,#纯脚本名-4)
 按键组[#按键组+1]=按键
 --第2行
  local 按键={}
 按键["width"]=定制宽度
 按键["click"]={label="查编码", send="function",command= 脚本相对路径,option= "%2$s【【1】】"}
 按键组[#按键组+1]=按键
 
  local 按键={}
 按键["width"]=定制宽度
 按键["click"]={label="查候选", send="function",command= 脚本相对路径,option= "%1$s【【1】】"}
 按键组[#按键组+1]=按键
 
 local 按键={}
 按键["width"]=定制宽度
 按键["click"]={label="查剪切板", send="function",command= 脚本相对路径,option= "【【3】】"}
 按键组[#按键组+1]=按键
 if 已启用 then
  local 按键={}
  按键["width"]=定制宽度
  按键["click"]={label="查变量名", send="function",command= 脚本相对路径,option= "%1$s【【2】】"}
  按键组[#按键组+1]=按键
 end--if 已启用

 --第3行
 local 按键={}
 按键["click"]="Left"
 按键["has_menu"]="Left"
 按键组[#按键组+1]=按键
 
 local 按键={}
 按键["click"]="Up"
 按键["has_menu"]="Up"

 按键组[#按键组+1]=按键
 local 按键={}
 按键["click"]="Right"
 按键["has_menu"]="Right"

 按键组[#按键组+1]=按键
 
 --第4行
 local 按键={}
 按键["width"]=33
 按键组[#按键组+1]=按键
 local 按键={}
 按键["click"]="Down"
 按键["has_menu"]="Down"

 按键组[#按键组+1]=按键
 
 import "script.包.其它.主键盘"
 local 按键=主键盘()
 按键组[#按键组+1]=按键
 
service.setKeyboard{
  name=string.sub(纯脚本名,1,#纯脚本名-4),
  ascii_mode=0,
  width=默认宽度,
  height=50,
  keys=按键组
  }









