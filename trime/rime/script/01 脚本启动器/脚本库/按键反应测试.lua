
require "import"

service.sendEvent("v")
--间隔时间
task(80,function() end)


Key.presetKeys.lua_script_Space={label= " ", functional="false", send="space"}
service.sendEvent("lua_script_Space")--这个是空格键,上屏候选文字用的


task(80,function() end)
service.sendEvent("r")

