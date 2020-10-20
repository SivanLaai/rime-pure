

require "import"
import "android.widget.*"
import "android.view.*"
import "java.io.*"
import "android.content.*"
import "android.os.*"

import "script.包.其它.主键盘"

import "com.osfans.trime.*" --载入包


import "script.包.文件操作.递归查找文件"
--字符串操作
import "script.包.字符串.分割字符串"
--import "script.包.字符串.中英字符串长度"
import "script.包.字符串.倒找字符串"
import "script.包.字符串.其它"


function 单字编码(单字,文件)
	 for 行内容 in io.lines(文件) do
     if string.find(行内容,"^"..单字) != nil && #行内容>0 then 
      return 行内容
     end 
    end
  return ""
end

function 候选编码(候选内容,文件)
	local 单字组={}
   local 中英字符串长=中英字符串长度(候选内容)
   local 内容编码=""
   for i=1, 中英字符串长 do
    单字组[i]=SubStringUTF8(候选内容,i,i)
    内容编码=内容编码..单字编码(单字组[i],文件).." "
   end
   local 内容提示=File(文件).getName()
   内容提示=string.sub(内容提示,1,#内容提示-4)
	内容编码=内容编码.."【"..内容提示.."】"
    return 内容编码
	
end

function 单字拆分(脚本目录,候选内容)
 local 文件组={}
 文件组=递归查找文件(File(脚本目录.."/拆分数据/"),".txt")
 local 返回内容组={}
 local 中英字符串长=中英字符串长度(候选内容)
 for i=1, 中英字符串长 do
  返回内容组[#返回内容组+1]=SubStringUTF8(候选内容,i,i)
 end
 for i=1, #文件组 do
  返回内容组[#返回内容组+1]=候选编码(候选内容,tostring(文件组[i]))
 end
 return 返回内容组
end



local 编码=Rime.RimeGetInput() --當前編碼
if 编码=="" then
 print("当前无候选,无法拆分内容")
 return --退出
end


local 参数 = (...) --当前候选或选中文字
local 编号=1
--print(参数)

local 目录=tostring(service.getLuaExtDir("script"))
local 脚本路径=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径
local 脚本相对路径=string.sub(脚本路径,#目录+1)
local 相对脚本路径=string.sub(脚本路径,#目录+1)--相对路径
local 纯脚本名=File(脚本路径).getName()
local 脚本目录=string.sub(脚本路径,1,#脚本路径-#纯脚本名)


--跳转位置
if string.find(参数,"<<")!=nil && string.find(参数,">>")!=nil then
 编号=tonumber(string.sub(参数,string.find(参数,"<<")+2,string.find(参数,">>")-1))
 --print(编号)
end


--查剪切板
if 参数=="【【cv】】" then
 import "android.content.Context"  --导入类
 local 内容=tostring(service.getSystemService(Context.CLIPBOARD_SERVICE).getText()) --获取剪贴板
 local 内容组={}
 内容组=单字拆分(脚本目录,内容)
 local 内容组1={内容}
  for i=1,#内容组 do
   内容组1[#内容组1+1]=内容组[i]
  end--if i=1,#内容组
  task(100,function() service.addCompositions(内容组1) end)
 return
 
end


--上屏数据
if string.find(参数,"【【")!=nil && string.find(参数,"】】")!=nil then
 local 内容=string.sub(参数,string.find(参数,"【【")+6,string.find(参数,"】】")-1)
 --print(内容)
 local 内容组={}
  内容组=单字拆分(脚本目录,内容)
  local 内容组1={内容}
  for i=1,#内容组 do
   内容组1[#内容组1+1]=内容组[i]
  end--if i=1,#内容组
  task(100,function() service.addCompositions(内容组1) end)
 return
 
 --键盘名称=内容.." 的拆分"
 
end



local 键盘名称="字词拆分"

local 候选组=Rime.getCandidates()

if #候选组<1 then return end


local 显示内容组={}
local 提示内容组={}
for i=1,#候选组 do
 显示内容组[#显示内容组+1]=tostring(候选组[i-1].text)
 提示内容组[#提示内容组+1]=tostring(候选组[i-1].comment)
 if 候选组[i-1].comment==nil then 提示内容组[#提示内容组]="" end
end




--定义键盘
--------------------
local 短语数=25--单个键盘的短语数量
local 默认宽度=20
local 默认高度=32



local 按键组={}

local 总序号=math.ceil(#显示内容组/短语数)
 local 按键={}
 按键["width"]=100
 按键["height"]=25
 按键["click"]=""
 按键["label"]=键盘名称.."("..编号.."/"..总序号..")【长按上屏】"
 按键组[#按键组+1]=按键

if 编号==1 then
 if #显示内容组<短语数 then
  for i=1,#显示内容组 do
    local 按键={}
    local 位置=i
    按键["hint"]=提示内容组[位置]
    按键["long_click"]={label="", commit=显示内容组[位置]}
    按键["click"]={label=显示内容组[位置], send="function",command= 脚本相对路径,option= "【【"..显示内容组[位置].."】】<<"..编号..">>"}
    按键组[#按键组+1]=按键
  end--
  local 按键={}
  按键["width"]=默认宽度
  for i=1,短语数-#显示内容组 do
   按键组[#按键组+1]=按键
  end--for
  local 按键={}
  按键["width"]=33
  按键["click"]={label="查剪切板", send="function",command= 脚本相对路径,option= "【【cv】】"}
  按键组[#按键组+1]=按键
  local 按键=主键盘()
  按键["width"]=67
  按键组[#按键组+1]=按键
 else
  
 按键组[#按键组+1]=按键2
  for i=1,短语数 do
   local 子编号=i
   if #显示内容组>子编号-1 then
    local 按键={}
    local 位置=子编号
    按键["hint"]=提示内容组[位置]
    按键["long_click"]={label="", commit=显示内容组[位置]}
    按键["click"]={label=显示内容组[位置], send="function",command= 脚本相对路径,option= "【【"..显示内容组[位置].."】】<<"..编号..">>"}
    按键组[#按键组+1]=按键
   end--if
  end--for
 local 按键={}
 按键["width"]=33
 按键["click"]={label="查剪切板", send="function",command= 脚本相对路径,option= "【【cv】】"}
 按键组[#按键组+1]=按键
 local 按键={}
 按键["width"]=33
 按键["click"]={label="下一页", send="function",command= 脚本相对路径,option= "<<"..(编号+1)..">>"}
 按键组[#按键组+1]=按键
 local 按键=主键盘()
 按键["width"]=34
 按键组[#按键组+1]=按键


 end--if #显示内容组<25
end--if 编号==1

if 编号>1 then
if #显示内容组<编号*短语数 then
  for i=1,#显示内容组-(编号-1)*短语数 do
    local 按键={}
    local 位置=i+(编号-1)*短语数
    按键["hint"]=提示内容组[位置]
    按键["long_click"]={label="", commit=显示内容组[位置]}
    按键["click"]={label=显示内容组[位置], send="function",command= 脚本相对路径,option= "【【"..显示内容组[位置].."】】<<"..编号..">>"}
    按键组[#按键组+1]=按键
  end--for
  local 按键={}
  按键["width"]=默认宽度
  for i=1,短语数*编号-#显示内容组 do
   按键组[#按键组+1]=按键
  end--for
  local 按键={}
  按键["width"]=33
  按键["click"]={label="上一页", send="function",command= 脚本相对路径,option= "<<"..(编号-1)..">>"}
 按键组[#按键组+1]=按键
 local 按键=主键盘()
 按键["width"]=34
 按键组[#按键组+1]=按键

else
  for i=1,短语数 do
   local 子编号=i
   if #显示内容组>子编号-1 then
    local 按键={}
    local 位置=子编号+(编号-1)*短语数
    按键["hint"]=提示内容组[位置]
    按键["long_click"]={label="", commit=显示内容组[位置]}
    按键["click"]={label=显示内容组[位置], send="function",command= 脚本相对路径,option= "【【"..显示内容组[位置].."】】<<"..编号..">>"}
    按键组[#按键组+1]=按键
   end--if
  end--for
  local 按键={}
  按键["width"]=33
 按键["click"]={label="上一页", send="function",command= 脚本相对路径,option= "<<"..(编号-1)..">>"}
 按键组[#按键组+1]=按键
 local 按键={}
 按键["width"]=33
 按键["click"]={label="下一页", send="function",command= 脚本相对路径,option= "<<"..(编号+1)..">>"}
 按键组[#按键组+1]=按键
 local 按键=主键盘()
 按键["width"]=34
 按键组[#按键组+1]=按键


end--if #显示内容组>编号*22
end--if 编号>1 

service.setKeyboard{
  name=键盘名称,
  ascii_mode=0,
  width=默认宽度,
  height=默认高度,
  keys=按键组
  }
