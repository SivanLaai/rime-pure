

require "import"
import "java.io.*"
import "android.content.*"
import "android.content.Context"  --导入类


import "script.包.文件操作.递归查找文件"
--字符串操作
import "script.包.字符串.其它"

local 参数=(...)

local 脚本目录=tostring(service.getLuaExtDir("script"))
local 脚本路径=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径

local 纯脚本名=File(脚本路径).getName()
local 目录=string.sub(脚本路径,1,#脚本路径-#纯脚本名-1)
local 脚本相对路径=string.sub(脚本路径,#脚本目录+1)

local 特效字集路径=string.sub(脚本路径,1,-4).."txt"
local 特效字集=io.open(特效字集路径):read("*a")
特效字集=string.gsub(特效字集,"\n","")



local function 加特效(内容,特效模板)
 
 local 加特效内容=""
 local 单字组=中英字符串转数组(内容)
 for i=1,#单字组 do
  if string.find(特效字集,单字组[i])!=nil then 单字组[i]=string.gsub(特效模板,"一",单字组[i]) end

  加特效内容=加特效内容..单字组[i]
 end--for
 return 加特效内容
end--加特效

local 特效={"一࿆","꯭一꯭","一ꦿ","一ོ","ٚ一","ٚ ؐؑؒ一ؓؔ","一⃢" ,"ۣ一̶ۣۨ","一້໌ᮩ","一๊"}

local 组合特效={"一ꦿོ","一̶͜♥","一ꦿ໊ོﻬ°"}

local 首尾特效={}
首尾特效[#首尾特效+1]={"꧁꫞꯭","꯭꯭꫞꧂"}

首尾特效[#首尾特效+1]={"༺❀ൢ꯭","꯭❀ൢ༻"}

--首尾特效[#首尾特效+1]={"",""}
首尾特效[#首尾特效+1]={"꧁༺ཌ༈","༈ད༻꧂"}

首尾特效[#首尾特效+1]={"","๑҉"}
首尾特效[#首尾特效+1]={"","✿"}
首尾特效[#首尾特效+1]={"","✿҉͜ "}
首尾特效[#首尾特效+1]={"⎛⎝","⎠⎞"}


--print(参数)
local 编号=1
local 短语数=10--单个键盘的短语数量
local 默认宽度=20

local 全局变量否=true
local 候选=""
 


if string.sub(参数,1,6)=="<<cv>>" then
 全局变量否=false
 local 剪贴板=service.getSystemService(Context.CLIPBOARD_SERVICE).getText() --获取剪贴板
 local 剪贴板=tostring(剪贴板)
 全局变量_候选=剪贴板
 全局变量_特效字=剪贴板
 print(全局变量_特效字.." 已转为组合特效起始字符")
end--string.find(参数


if string.sub(参数,1,6)=="【【" && string.find(参数,"】】")!=nil then
 全局变量否=false
 
 local 特效内容组={}
 if 全局变量_候选!=nil then
  候选=全局变量_候选
 else
  候选=string.sub(参数 ,string.find(参数,"】】")+6)
 end--if 全局变量_候选
 
 local 类型=string.sub(参数 ,7,7)
 local 特效编号=tonumber(string.sub(参数,8,string.find(参数,"】】")-1))
 local 特效内容=""
 if 类型=="a" then 特效内容=加特效(候选,特效[特效编号]) end
 if 类型=="b" then 特效内容=加特效(候选,组合特效[特效编号]) end
 if 类型=="c" then 特效内容=首尾特效[特效编号][1]..候选..首尾特效[特效编号][2] end
 特效内容组[1]=特效内容
 
 if 全局变量_特效字!=nil then
  local 特效内容=""
  if 类型=="a" then 特效内容=加特效(全局变量_特效字,特效[特效编号]) end
  if 类型=="b" then 特效内容=加特效(全局变量_特效字,组合特效[特效编号]) end
  if 类型=="c" then 特效内容=首尾特效[特效编号][1]..全局变量_特效字..首尾特效[特效编号][2] end
  特效内容组[2]=特效内容
 end--if 全局变量_特效字!
 全局变量_特效字=特效内容组[#特效内容组]
 print(#全局变量_特效字)
 task(300,function() 
  service.addCompositions(特效内容组)
 end)
end--string.find(参数

if 全局变量否 then
 全局变量_特效字=nil 
 全局变量_候选=nil
end--if 全局变量否


local 按键组={}
local 按键1={}
 按键1["width"]=100
 按键1["height"]=25
 按键1["click"]=""
 按键1["label"]=string.sub(纯脚本名,1,#纯脚本名-4)
 按键组[#按键组+1]=按键1

--候选按键
 local 按键={}
 按键["click"]="Up"
 按键["has_menu"]="Up"
 按键["width"]=20
 按键组[#按键组+1]=按键
 local 按键={}
 按键["click"]="Down"
 按键["has_menu"]="Down"
 按键["width"]=20
 按键组[#按键组+1]=按键
 local 按键={}
 按键["click"]="Left"
 按键["has_menu"]="Left"
 按键["width"]=20
 按键组[#按键组+1]=按键
 local 按键={}
 按键["click"]="Right"
 按键["has_menu"]="Right"
 按键["width"]=20
 按键组[#按键组+1]=按键
 local 按键={}
 按键["label"]="剪切板"
 按键["hint"]="转特效"
 按键["click"]={label="", send="function",command= 脚本相对路径,option= "<<cv>>%1$s"}
 按键["width"]=20
 按键组[#按键组+1]=按键

for i=1,#特效 do
 local 按键={}
 按键["label"]=加特效("特效",特效[i])
 按键["click"]={label="", send="function",command= 脚本相对路径,option= "【【a"..i.."】】%1$s"}
 按键组[#按键组+1]=按键
end--for



for i=1,#组合特效 do
 local 按键={}
 按键["label"]=加特效("特效",组合特效[i])
 按键["click"]={label="", send="function",command= 脚本相对路径,option= "【【b"..i.."】】%1$s"}
 按键组[#按键组+1]=按键
end--for


for i=1,#首尾特效 do
 local 按键={}
 按键["width"]=50
 按键["label"]=首尾特效[i][1].."特效"..首尾特效[i][2]
 按键["click"]={label="", send="function",command= 脚本相对路径,option= "【【c"..i.."】】%1$s"}
 按键组[#按键组+1]=按键
end--for




for i=1,30-#按键组 do
 local 按键={}
 按键["width"]=默认宽度
 按键组[#按键组+1]=按键
end--for




按键组[#按键组+1]=主键盘(24,100)



service.setKeyboard{
  name=string.sub(纯脚本名,1,#纯脚本名-4),
  ascii_mode=0,
  width=默认宽度,
  height=32,
  keys=按键组
  }





