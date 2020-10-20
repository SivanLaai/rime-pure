

require "import"
import "java.io.*"
import "android.content.*"

import "script.包.文件操作.递归查找文件"
--字符串操作
import "script.包.字符串.分割字符串"
import "script.包.字符串.其它"
--import "script.包.字符串.倒找字符串"
import "script.包.其它.java随机数"

--悬浮窗口搜索语句,搜索指定文件,匹配单行内容
--例子 搜索语句("诗词","古诗三百首.txt",t)
--当前侯选为 诗词XXX 词条时,XXX可为空,自动匹配
--数据文件默认rime/data目录下,候选数默认为1,最多可选5个
local function 搜索语句(文件,候选内容,候选数)  
--参数【指定前缀】指定候选关键字,根据关键字搜索文件。如果关键字和候选内容相比较有多出内容,则根据内容搜索匹配行,默认匹配全部行
--成功返回真,失败返回假
--参数【候选数】可选,默认1,最多5个

local 匹配内容=候选内容
local 匹配内容组={}
local 随机数组={}
local 匹配行数 =0
local 提示内容=""
    for 行内容 in io.lines(文件) do
     if string.find(行内容,匹配内容) != nil && #行内容>0 && 字符串首尾空(行内容)!="" && string.sub(行内容,1,1) != "#" then 
      匹配行数=匹配行数+1
      匹配内容组[匹配行数]=行内容
      随机数组[匹配行数]=匹配行数
     end 
    end
    if 匹配行数 ==0 then 
     提示内容="未找到【"..匹配内容.."】相关内容,随机显示以下内容"
     for 行内容 in io.lines(文件) do
     if #行内容>0 && 字符串首尾空(行内容)!="" && string.sub(行内容,1,1) != "#" then 
      匹配行数=匹配行数+1
      匹配内容组[匹配行数]=行内容
      随机数组[匹配行数]=匹配行数
     end --行内容
    end--for
    end --匹配行数
    local num,tmp
    for i = 1,匹配行数 do
        num = java随机整数(匹配行数)
        tmp = 随机数组[i]
        随机数组[i] = 随机数组[num]
        随机数组[num] = tmp    
    end
   候选数=tonumber(候选数)
   if 候选数==nil then 候选数=1 end
   if 候选数<0 then 候选数=1 end
   if 候选数==0 then 候选数=1 end
   if 候选数>5 then 候选数=5 end
   if 候选数>匹配行数 then 候选数=匹配行数 end
   local 候选组1={}
   local 全部内容=""
   if 提示内容!="" then 候选组1[#候选组1+1]=提示内容 end
    for i = 1,候选数 do
     候选组1[#候选组1+1]=string.gsub(匹配内容组[随机数组[i]],"<br>","\n")
     全部内容=全部内容..匹配内容组[随机数组[i]].."<br>"
    end
    全部内容=全部内容:gsub("\n","<br>")
    local 全部内容组={全部内容}
    task(300,function() 
     if #全部内容<600 then
      service.addCompositions(候选组1)--上屏内容
     else
      service.newActivity("网页浏览",全部内容组) --启动工具
     end
    end)

end

--悬浮窗口拆分搜索,搜索指定文件,匹配单行内容,并根据 <候选> 关键字将单行内容拆分为多个候选
--数据文件默认rime/data目录下个
local function 拆分搜索(文件,候选内容) 

--参数【指定前缀】指定候选关键字,根据关键字匹配文件。如果关键字和候选内容相比较有多出内容,则根据多出内容搜索匹配行,默认匹配全部行

   匹配内容=候选内容
   local 匹配行数 =0
   local 行内容全=""
   local 匹配内容组={}
   local 随机数组={}
   local 多候选否=false
   local 多候选首标识="[["
   local 多候选未标识="]]"
   local 多行单候选否=false
   local 多行单候选首标识="{{"
   local 多行单候选未标识="}}"
   local 提示内容=""

    for 行内容 in io.lines(文件) do
     if 字符串首尾空(行内容) == 多候选首标识 then  多候选否 = true end --处理[[ ]]字段里面的内容
     if 字符串首尾空(行内容) == 多行单候选首标识 then  多行单候选否 = true end --处理{{ }}字段里面的内容
     if 多候选否 && 行内容!="" && 字符串首尾空(行内容)!="" && 字符串首尾空(行内容)!=多候选首标识 && 字符串首尾空(行内容)!=多候选未标识 && 多行单候选否==false then 行内容全=行内容全..行内容.."\n" end --处理[[ ]]字段里面的内容
     
     if 多行单候选否 && 字符串首尾空(行内容)!=多行单候选首标识 && 字符串首尾空(行内容)!=多行单候选未标识 then 行内容全=行内容全..行内容.."<br>" end --处理{{ }}字段里面的内容
     if 字符串首尾空(行内容) == 多行单候选未标识 then
       多行单候选否 = false
       行内容全=string.sub(行内容全, 1, #行内容全-4)
       行内容全=行内容全.."\n" 
     end

     --检查内容匹配否
     if 字符串首尾空(行内容) == 多候选未标识 then  
       多候选否 = false
       if string.find(行内容全,匹配内容) != nil then 
        匹配行数=匹配行数+1
        行内容全=string.sub(行内容全, 1, #行内容全-1)
        匹配内容组[匹配行数]=行内容全
       end 
       行内容全=""
     end
  end
  
  
    if #匹配内容组 == 0 then 
     提示内容="未找到【"..匹配内容.."】相关内容,随机显示以下内容"--上屏内容
     匹配内容=""
     for 行内容 in io.lines(文件) do
     if 字符串首尾空(行内容) == 多候选首标识 then  多候选否 = true end --处理[[ ]]字段里面的内容
     if 字符串首尾空(行内容) == 多行单候选首标识 then  多行单候选否 = true end --处理{{ }}字段里面的内容
     if 多候选否 && 行内容!="" && 字符串首尾空(行内容)!="" && 字符串首尾空(行内容)!=多候选首标识 && 字符串首尾空(行内容)!=多候选未标识 && 多行单候选否==false then 行内容全=行内容全..行内容.."\n" end --处理[[ ]]字段里面的内容
     
     if 多行单候选否 && 字符串首尾空(行内容)!=多行单候选首标识 && 字符串首尾空(行内容)!=多行单候选未标识 then 行内容全=行内容全..行内容.."<br>" end --处理{{ }}字段里面的内容
     if 字符串首尾空(行内容) == 多行单候选未标识 then
       多行单候选否 = false
       行内容全=string.sub(行内容全, 1, #行内容全-4)
       行内容全=行内容全.."\n" 
     end

     --检查内容匹配否
     if 字符串首尾空(行内容) == 多候选未标识 then  
       多候选否 = false
       if string.find(行内容全,匹配内容) != nil then 
        匹配行数=匹配行数+1
        行内容全=string.sub(行内容全, 1, #行内容全-1)
        匹配内容组[匹配行数]=行内容全
       end 
       行内容全=""
     end
  end--for 行内容
 end --#匹配内容组
 
    local num = java随机整数(匹配行数)
    匹配内容组[num]=string.gsub(匹配内容组[num],"\n","@@@")
    匹配内容组[num]=string.gsub(匹配内容组[num],"<br>","\n")
    匹配内容组=string.split(匹配内容组[num],"@@@") 
    if 提示内容!="" then
     local 匹配内容组01={提示内容}
     for i=1,#匹配内容组 do
      匹配内容组01[#匹配内容组01+1]=匹配内容组[i]
     end--for
     匹配内容组=匹配内容组01
    end--if 提示内容
    
    local 全部内容=""
    for i = 1,#匹配内容组 do
     全部内容=全部内容..匹配内容组[i].."<br>"
    end
    全部内容=全部内容:gsub("\n","<br>")
    local 全部内容组={全部内容}
    task(300,function() 
     if #全部内容<600 then
      service.addCompositions(匹配内容组)--上屏内容
     else
      service.newActivity("网页浏览",全部内容组) --启动工具
     end
    end)
end




local 参数=(...)



local 编号=1
local 短语数=12--单个键盘的短语数量
local 默认宽度=25

local 脚本目录=tostring(service.getLuaExtDir("script"))
local 脚本路径=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径
--local 目录=string.sub(脚本路径,1,字符串_倒找(脚本路径,"/")-1)

local 纯脚本名=File(脚本路径).getName()
local 目录=string.sub(脚本路径,1,#脚本路径-#纯脚本名)

local 脚本相对路径=string.sub(脚本路径,#脚本目录+1)

local 文件组=递归查找文件(File(目录.."/data/"),".txt$")

table.sort(文件组)--数组排序

local 总序号=math.ceil(#文件组/短语数)




if 参数!=nil && string.find(参数,"<<")!=nil && string.find(参数,">>")!=nil then
 编号=tonumber(string.sub(参数,string.find(参数,"<<")+2,string.find(参数,">>")-1))
end

local 模式=nil
if 参数!=nil && string.find(参数,"《《")!=nil && string.find(参数,"》》")!=nil then
 模式=string.sub(参数,string.find(参数,"《《")+6,string.find(参数,"》》")-1)
end



if 参数!=nil && string.find(参数,"【【")!=nil && string.find(参数,"】】")!=nil && 模式!="编辑" then
 local 数据文件=string.sub(参数 ,string.find(参数,"【【")+6,string.find(参数,"】】")-1)
 local 候选=string.sub(参数 ,string.find(参数,">>")+2)
 local 候选数=tonumber(string.sub(数据文件,-5,-5))
 if 候选数==0 then 拆分搜索(数据文件,候选) end
 if 候选数>0 then 搜索语句(数据文件,候选,候选数) end
 return
end




if 参数!=nil && string.find(参数,"【【")!=nil && string.find(参数,"】】")!=nil && 模式=="编辑" then
 local 数据文件=string.sub(参数 ,string.find(参数,"【【")+6,string.find(参数,"】】")-1)
 service.editFile(数据文件) 
 return
end

local 模式判断=true
if 模式=="编辑" then
 模式="搜索" 
 模式判断=false
end
if 模式=="搜索" && 模式判断 then 模式="编辑" end
if 模式==nil then 模式="搜索" end



local 按键组={}

local 按键1={}
 按键1["width"]=15
 按键组[#按键组+1]=按键1
local 按键1={}
 按键1["width"]=70
 按键1["height"]=25
 按键1["click"]=""
 按键1["label"]=string.sub(纯脚本名,1,#纯脚本名-4).."("..tostring(编号).."/"..总序号..")"
 按键组[#按键组+1]=按键1
local 按键1={}
 按键1["width"]=15
 按键1["height"]=25
 按键1["click"]={label=模式, send="function",command= 脚本相对路径,option="《《"..模式.."》》<<"..编号..">>%1$s"}
 按键1["hint"]="模式"
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
	   按键["label"]=File(文件组[i]).getName():sub(1,-7)
   按键["click"]={label="", send="function",command= 脚本相对路径,option= "《《"..模式.."》》【【"..文件组[i].."】】<<"..编号..">>%1$s"}
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
    按键["label"]=File(文件组[i]).getName():sub(1,-7)
    按键["click"]={label="", send="function",command= 脚本相对路径,option= "《《"..模式.."》》【【"..文件组[i].."】】<<"..编号..">>%1$s"}
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
   按键["label"]=File(文件组[i+(编号-1)*短语数]).getName():sub(1,-7)
   按键["click"]={label="", send="function",command= 脚本相对路径,option= "《《"..模式.."》》【【"..文件组[i+(编号-1)*短语数].."】】<<"..编号..">>%1$s"}
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
   按键["label"]=File(文件组[i+(编号-1)*短语数]).getName():sub(1,-7)
   按键["click"]={label="", send="function",command= 脚本相对路径,option= "《《"..模式.."》》【【"..文件组[i+(编号-1)*短语数].."】】<<"..编号..">>%1$s"}
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



if 模式!="命令行" then
service.setKeyboard{
  name=string.sub(纯脚本名,1,#纯脚本名-4),
  ascii_mode=0,
  width=默认宽度,
  height=34,
  keys=按键组
  }
end
