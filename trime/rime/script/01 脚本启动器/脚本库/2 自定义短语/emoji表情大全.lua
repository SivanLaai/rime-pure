
require "import"
import "java.io.File"
import "android.os.*"

import "script.包.其它.主键盘"
import "script.包.其它.自定义短语键盘"
--自定义短语键盘(键盘名称,单个键盘短语数,默认宽度,默认高度,按键组,参数,脚本相对路径,数据文件)

local 参数=(...)


local 脚本目录=tostring(service.getLuaExtDir("script"))
local 脚本名=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径

local 脚本相对路径=string.sub(脚本名,#脚本目录+1)
local 纯脚本名=File(脚本名).getName()
local 数据文件=string.sub(脚本名,1,#脚本名-4)..".txt"




local 短语数=50--单个键盘的短语数量
local 默认宽度=10
local 默认高度=32

自定义短语键盘(string.sub(纯脚本名,1,#纯脚本名-4),短语数,默认宽度,默认高度,参数,脚本相对路径,数据文件)





