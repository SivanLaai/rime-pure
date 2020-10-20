

require "import"
import "java.io.*"
import "android.content.*"

import "script.包.文件操作.递归查找文件"
--字符串操作
import "script.包.字符串.分割字符串"
import "script.包.字符串.其它"
--import "script.包.字符串.倒找字符串"
import "script.包.其它.java随机数"



local function 单词典搜索(参数,文件)
 local 内容1=""
 for 行内容 in io.lines(文件) do
 if string.lower(string.sub(行内容,1,#参数+1))==string.lower(参数.."\t") then
  内容1=string.sub(行内容,#参数+1,#行内容)
  return 内容1
 end
 end
return 内容1
end


local 参数=(...)



local 编号=1
local 短语数=10--单个键盘的短语数量
local 默认宽度=50

local 脚本目录=tostring(service.getLuaExtDir("script"))
local 脚本路径=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径

local 纯脚本名=File(脚本路径).getName()

local 目录=string.sub(脚本路径,1,#脚本路径-#纯脚本名)

local 脚本相对路径=string.sub(脚本路径,#脚本目录+1)

local 文件组=递归查找文件(File(目录.."/data/"),".txt$")

table.sort(文件组)--数组排序

local 总序号=math.ceil(#文件组/短语数)



local 按键组={}

if 参数!=nil && string.find(参数,"<<")!=nil && string.find(参数,">>")!=nil then
 编号=tonumber(string.sub(参数,string.find(参数,"<<")+2,string.find(参数,">>")-1))
end



if 参数!=nil && string.find(参数,"【【")!=nil && string.find(参数,"】】")!=nil then
 local 数据文件=string.sub(参数 ,string.find(参数,"【【")+6,string.find(参数,"】】")-1)
 local 候选=string.sub(参数 ,string.find(参数,">>")+2)
 local 全部内容=单词典搜索(候选,数据文件)
 local 单词典=File(数据文件).getName():sub(1,-5)
  if 全部内容=="" or 全部内容==nil then 全部内容=单词典.." 无【"..候选.."】相关内容"  end
 local 全部内容组={全部内容}
    task(300,function() 
     if #全部内容<300 then
      service.addCompositions({全部内容})--上屏内容
     else
      service.newActivity("网页浏览",全部内容组) --启动工具
     end
    end)

 
end


local 按键1={}
 按键1["width"]=100
 按键1["height"]=25
 按键1["click"]=""
 按键1["label"]=string.sub(纯脚本名,1,#纯脚本名-4).."("..tostring(编号).."/"..总序号..")"
 按键组[#按键组+1]=按键1

--候选按键
 local 按键={}
 按键["click"]="Up"
 按键["has_menu"]="Up"
 按键["width"]=25
 按键组[#按键组+1]=按键
 local 按键={}
 按键["click"]="Down"
 按键["has_menu"]="Down"
 按键["width"]=25
 按键组[#按键组+1]=按键
 local 按键={}
 按键["click"]="Left"
 按键["has_menu"]="Left"
 按键["width"]=25
 按键组[#按键组+1]=按键
 local 按键={}
 按键["click"]="Right"
 按键["has_menu"]="Right"
 按键["width"]=25
 按键组[#按键组+1]=按键



if 编号==1 then
 if #文件组<短语数 then
  --按键组=文件组
  for i=1,#文件组 do
   local 按键={}
   按键["label"]=File(文件组[i]).getName():sub(1,-5)
   按键["click"]={label="", send="function",command= 脚本相对路径,option= "【【"..文件组[i].."】】<<"..编号..">>%1$s"}
   按键组[#按键组+1]=按键
   
  end--for
  local 按键={}
  按键["width"]=默认宽度
  for i=1,短语数-1-#文件组 do
   按键组[#按键组+1]=按键
  end--for
  按键组[#按键组+1]=主键盘()
 else
  for i=1,短语数 do
   local 子编号=i
   if #文件组>子编号-1 then
    local 按键={}
    按键["label"]=File(文件组[i]).getName():sub(1,-5)
    按键["click"]={label="", send="function",command= 脚本相对路径,option= "【【"..文件组[i].."】】<<"..编号..">>%1$s"}
    按键组[#按键组+1]=按键
   end--if
  end--for

 local 按键2={}
 按键2["click"]={label="下一页", send="function",command= 脚本相对路径,option= "<<"..(编号+1)..">>"}
 按键组[#按键组+1]=按键2
 按键组[#按键组+1]=主键盘()

 end--if #文件组<25
end--if 编号==1

if 编号>1 then
if #文件组<编号*短语数 then
  for i=1,#文件组-(编号-1)*短语数 do
  local 按键={}
   按键["label"]=File(文件组[i+(编号-1)*短语数]).getName():sub(1,-5)
   按键["click"]={label="", send="function",command= 脚本相对路径,option= "【【"..文件组[i+(编号-1)*短语数].."】】<<"..编号..">>%1$s"}
   按键组[#按键组+1]=按键
  end--for
  local 按键={}
  按键["width"]=默认宽度
  for i=1,短语数*编号-#文件组 do
   按键组[#按键组+1]=按键
  end--for
  local 按键1={}
  按键1["click"]={label="上一页", send="function",command= 脚本相对路径,option= "<<"..(编号-1)..">>"}
 按键组[#按键组+1]=按键1
 
 按键组[#按键组+1]=主键盘()
else
  for i=1,短语数 do
   local 按键={}
   按键["label"]=File(文件组[i+(编号-1)*短语数]).getName():sub(1,-5)
   按键["click"]={label="", send="function",command= 脚本相对路径,option= "【【"..文件组[i+(编号-1)*短语数].."】】<<"..编号..">>%1$s"}
   按键组[#按键组+1]=按键
  end--for
  local 按键1={}
  按键1["width"]=33
 按键1["click"]={label="上一页", send="function",command= 脚本相对路径,option= "<<"..(编号-1)..">>"}
 按键组[#按键组+1]=按键1
 local 按键2={}
 按键2["width"]=33
 按键2["click"]={label="下一页", send="function",command= 脚本相对路径,option= "<<"..(编号+1)..">>"}
 按键组[#按键组+1]=按键2
 
 
 按键组[#按键组+1]=主键盘(32,33)

end--if #文件组>编号*22
end--if 编号>1 



 
service.setKeyboard{
  name=string.sub(纯脚本名,1,#纯脚本名-4),
  ascii_mode=0,
  width=默认宽度,
  height=32,
  keys=按键组
  }

