--[[中文输入法 （同文无障碍版）

【自定义剪切板 3.3】

作者： 星乂尘 1416165041@qq.com

调用方式：
trime.yaml
_Keyboard_clip: {label: ⏍, send: function, command: '剪切板.lua'}

2020-09-10
]]
require "import"
import "android.widget.*"
import "android.view.*"
import "android.media.MediaPlayer"
import "android.graphics.RectF"
import "android.graphics.drawable.StateListDrawable"

local function Back() --生成功能键背景
  local bka=LuaDrawable(function(c,p,d)
    local b=d.bounds
    b=RectF(b.left,b.top,b.right,b.bottom)
    p.setColor(0x49ffffff)
    c.drawRoundRect(b,20,20,p) --圆角20
  end)
  local bkb=LuaDrawable(function(c,p,d)
    local b=d.bounds
    b=RectF(b.left,b.top,b.right,b.bottom)
    p.setColor(0x49d3d7da)
    c.drawRoundRect(b,20,20,p)
  end)

  local stb=StateListDrawable()
  stb.addState({-android.R.attr.state_pressed},bkb)
  stb.addState({android.R.attr.state_pressed},bka)
  return stb
end

local function Icon(k,s) --获取k功能图标，没有返回s
  k=Key.presetKeys[k]
  return k and k.label or s
end

local function Bu_R(id) --生成功能键
  local Bu={LinearLayout,
    layout_height=-1,
    layout_width=-1,
    layout_weight=1,
    padding="2dp",
    {FrameLayout,
      layout_height=-1,
      layout_width=-1,
      Background=Back(),
      {TextView,
        gravity=17|48,
        layout_height=-1,
        layout_width=-1,
        layout_marginTop="2dp",
        textColor=0xff232323,
        textSize="10dp"},
      {TextView,
        gravity=17,
        layout_height=-1,
        layout_width=-1,
        textColor=0xff232323,
        textSize="18dp"}}}
  local msg=Bu[2][2] --上标签
  local label=Bu[2][3] --主标签

  if id==1 then
    label.text=Icon("BackSpace","⌫")
    label.textSize="18dp" --默认符号⌫太小，字体大小改为22dp，后面同理
    Bu.onClick=function()
      service.sendEvent("BackSpace")
    end
    Bu.OnLongClickListener={onLongClick=function() return true end}
   elseif id==2 then
    msg.text=Icon("undo","↶")
    label.text=Icon("space","␣")
    label.textSize="25dp"
    Bu.onClick=function()
      service.sendEvent("space")
    end
    Bu.OnLongClickListener={onLongClick=function()
        service.sendEvent("undo")
        return true
    end}
   elseif id==3 then
    label.text=Icon("Return","⏎")
    label.textSize="22dp"
    Bu.onClick=function()
      service.sendEvent("Return")
    end
    Bu.OnLongClickListener={onLongClick=function() return true end}
   elseif id==4 then
    label.text=Icon("Keyboard_default","返回")
    Bu.onClick=function()
      service.sendEvent("Keyboard_default")
    end
    Bu.OnLongClickListener={onLongClick=function() return true end}
  end
  return Bu
end

local height="240dp" --键盘高度
pcall(function()
  --键盘自适应高度，旧版中文不支持，放pcall里防报错
  height=service.getLastKeyboardHeight()
end)
local ids,layout={},{FrameLayout,
  --键盘高度
  layout_height=height,
  layout_width=-1,
  --背景颜色
  BackgroundColor=0x88ffffff,
  {TextView,
    layout_height="1dp",
    layout_width=-1,
    BackgroundColor=0xffdfdfdf},
  {ListView,
    id="list",
    layout_width=-1},
  {LinearLayout,
    orientation=1,
    --右侧功能键宽度
    layout_width="60dp",
    layout_height=-1,
    layout_gravity=5|84,
    Bu_R(1),
    Bu_R(2),
    Bu_R(3),
    Bu_R(4)}}
layout=loadlayout(layout,ids)

local data,item={},{LinearLayout,
  layout_width=-1,
  padding="4dp",
  gravity=3|17,
  {TextView,
    id="a",
    textColor=0xff232323,
    textSize="10dp"},
  {TextView,
    id="b",
    gravity=3|17,
    paddingLeft="4dp",
    --最大显示行数
    MaxLines=3,
    --最小高度
    MinHeight="30dp",
    textColor=0xff232323,
    textSize="15dp"}}
local adp=LuaAdapter(service,data,item)
ids.list.Adapter=adp

local Clip=service.getClipBoard()
local function fresh()
  table.clear(data)
  for i=0,#Clip-1 do
    local v=Clip[i]
    local a,b,c=v:match("^%s*([^\n]+)(\n*[^\n]*)(\n*[^\n]*)")
    a=table.concat{utf8.sub(a,1,99),utf8.sub(b,1,99),utf8.sub(c,1,99)}
    table.insert(data,{a=tostring(i+1),b=a})
  end
  adp.notifyDataSetChanged()
end
fresh()

ids.list.onItemClick=function(l,v,p)
  local s=Clip[p]
  service.commitText(s)
  --置顶已上屏内容
  if p>0 then
    Clip.remove(p)
    Clip.add(0,s)
    fresh()
  end
end

ids.list.onItemLongClick=function(l,v,p)
  local str=Clip[p]
  local lay={TextView,
    padding="16dp",
    MaxLines=20,
    textIsSelectable=true,
    text=utf8.sub(str,1,3000)..(utf8.len(str)>3000 and "\n..." or ""),
    textColor=0xff232323,
    textSize="15dp"}
  LuaDialog(service)
  .setTitle(string.format("%s  预览/操作",p+1))
  .setView(loadlayout(lay))
  .setButton("置顶",function()
    if p>0 then
      Clip.remove(p)
      Clip.add(0,str)
      fresh()
    end
  end)
  .setButton2("删除",function()
    Clip.remove(p)
    fresh()
  end)
  .setButton3("清空",function()
    Clip.clear()
    service.sendEvent("Keyboard_default")
    local pa=service.LuaDir.."/clipboard.json"
    io.open(pa,"w"):write("[]"):close()
  end)
  .show()

  --返回（真），否则长按也会触发点击事件
  return true
end

service.setKeyboard(layout)

--视频路径
local path=service.LuaDir.."/sounds/mv.mp4"

pcall(function()
  local play=MediaPlayer()
  play.setDataSource(path)
  --循环播放
  play.setLooping(true)
  play.prepare()
  --音量设为0
  play.setVolume(0,0)

  local video=loadlayout{SurfaceView,
    --添加背景色，避免看不清按键
    BackgroundColor=0x99ffffff,
    layout_width=-1,
    layout_height=-1}
  layout.addView(video,0) --把视频布局放到layout的第一个，也就是显示在最底层
  video.getHolder().addCallback({
    surfaceCreated=function(holder)
      play.start()
      play.setDisplay(holder)
    end,
    surfaceDestroyed=function()
      --界面关闭，释放播放器
      play.release()
  end})
end)
