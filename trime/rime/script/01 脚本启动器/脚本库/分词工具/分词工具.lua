

--[[
--无障碍版专用脚本
--脚本名称: 分词工具
--用途：将剪贴板内容分词
--版本号: 1.0
▂▂▂▂▂▂▂▂
日期: 2020年08月18日🗓️
农历: 鼠🐁庚子年六月廿九
时间: 23:45:21🕦
星期: 周二
--制作者: 风之漫舞
--首发qq群: Rime 同文斋(458845988)
--邮箱: bj19490007@163.com(不一定及时看到)
--特别说明
  基于学会忘记大佬工具脚本二次开发,感谢

--配置说明
用法一
第①步 将 脚本文件放置 Android/rime/script 文件夹内,

第②步 向主题方案中加入按键
以 XXX.trime.yaml主题方案为例
找到以下节点preset_keys，加入以下按键LuaFC

preset_keys:
  LuaFC: {label: 当前天气, send: function, command: '分词工具.lua', option: ""}

向该主题方案任意键盘按键中加入上述按键既可
--------------------
用法二
①放到脚本启动器->脚本库目录 下任意位置及子文件夹中,脚本启动器自动显示该脚本
②主题方案挂载脚本启动器
③显示一个键盘界面,点击按键即可
]]




require "import"
import "android.app.*"
import "android.os.*"

print("请稍等,剪切板内容正在分词中...")

local 脚本目录=tostring(service.getLuaExtDir("script"))
local 脚本名=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径
local 脚本相对路径=string.sub(脚本名,#脚本目录+1)
local 纯脚本名=File(脚本名).getName()
local p=string.sub(脚本名,1,#脚本名-#纯脚本名).."d.txt"

local t=dofile(p)


local function check(s,i)
  for n=5,1,-1
    local u=utf8.sub(s,i,i+n-1)
    local a=t[u]
    if a
      return a
    end
  end
  return 0
end

local function check2(s,i,m)
  for n=m,1,-1
    local u=utf8.sub(s,i,i+n-1)
    local a=t[u]
    if a
      return a
    end
  end
  return 0
end

function split(s)
  local l=utf8.len(s)
  local i=1
  local mm=2
  local nn=2
  local r={}
  while i<l
    --print(i)
    for n=5,1,-1
      if n==1
        local u=utf8.sub(s,i,i)
        i=i+1
        table.insert(r,u)
        break
      end
      local u=utf8.sub(s,i,i+n-1)
      local a=t[u]
      if a
        local b=check(s,i+1)
        if b>a*nn
          local c=check(s,i+2)
          if b>c
            local u=utf8.sub(s,i,i)
            i=i+1
            table.insert(r,u)
            goto eee
          end
        end
        if check2(s,i,n-1)>a*mm
          continue
        end
        i=i+n
        table.insert(r,u)
        break
      end
    end
@eee
  end
  return r
end




import "android.content.Context"  --导入类
剪贴板=service.getSystemService(Context.CLIPBOARD_SERVICE).getText() --获取剪贴板 

  local 内容组=split(tostring(剪贴板))
  local 内容=table.concat(内容组," ")

task(300,function() service.addCompositions({内容}) end)

--print(数据文件)