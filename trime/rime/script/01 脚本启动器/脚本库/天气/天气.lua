--[[
--无障碍版专用脚本
--脚本名称: 天气
--用途：联网查找天气相关信息
--版本号: 2.0
▂▂▂▂▂▂▂▂
日期: 2020年08月13日🗓️
农历: 鼠🐁庚子年六月廿四
时间: 11:28:34🕚
星期: 周四
--制作者: 风之漫舞
--首发qq群: 同文堂(480159874)
--邮箱: bj19490007@163.com(不一定及时看到)

--配置说明
用法一
第①步 将 脚本文件放置 Android/rime/script 文件夹内,

第②步 向主题方案中加入按键
以 XXX.trime.yaml主题方案为例
找到以下节点preset_keys，加入以下按键LuaTQ1，LuaTQ2

preset_keys:
  LuaTQ1: {label: 当前天气, send: function, command: '天气.lua', option: "《《命令行&&查当前候选》》"}#根据当前候选查找对应城市天气信息
  LuaTQ1: {label: 当前天气, send: function, command: '天气.lua', option: "《《命令行》》【【城市名称】】"}#城市名称为自定义项,可替换为 武汉,北京,广州等常用城市名
  
向该主题方案任意键盘按键中加入上述按键既可
--------------------
用法二
①放到脚本启动器->脚本库目录 下任意位置及子文件夹足中,脚本启动器自动显示该脚本
②主题方案挂载脚本启动器
③显示一个键盘界面,点击按键即可
]]




require "import"
import "java.io.File"
import "android.os.*"

import "android.widget.*"
import "android.view.*"
import "android.content.Context"
import "cjson"
import "com.osfans.trime.*" --载入包

import "script.包.其它.主键盘"


local 城市=[[
[
  {
    "_id": 1,
    "id": 1,
    "pid": 0,
    "city_code": "101010100",
    "city_name": "北京"
  },
  {
    "_id": 2,
    "id": 2,
    "pid": 0,
    "city_code": "",
    "city_name": "安徽"
  },
  {
    "_id": 3,
    "id": 3,
    "pid": 0,
    "city_code": "",
    "city_name": "福建"
  },
  {
    "_id": 4,
    "id": 4,
    "pid": 0,
    "city_code": "",
    "city_name": "甘肃"
  },
  {
    "_id": 5,
    "id": 5,
    "pid": 0,
    "city_code": "",
    "city_name": "广东"
  },
  {
    "_id": 6,
    "id": 6,
    "pid": 0,
    "city_code": "",
    "city_name": "广西"
  },
  {
    "_id": 7,
    "id": 7,
    "pid": 0,
    "city_code": "",
    "city_name": "贵州"
  },
  {
    "_id": 8,
    "id": 8,
    "pid": 0,
    "city_code": "",
    "city_name": "海南"
  },
  {
    "_id": 9,
    "id": 9,
    "pid": 0,
    "city_code": "",
    "city_name": "河北"
  },
  {
    "_id": 10,
    "id": 10,
    "pid": 0,
    "city_code": "",
    "city_name": "河南"
  },
  {
    "_id": 11,
    "id": 11,
    "pid": 0,
    "city_code": "",
    "city_name": "黑龙江"
  },
  {
    "_id": 12,
    "id": 12,
    "pid": 0,
    "city_code": "",
    "city_name": "湖北"
  },
  {
    "_id": 13,
    "id": 13,
    "pid": 0,
    "city_code": "",
    "city_name": "湖南"
  },
  {
    "_id": 14,
    "id": 14,
    "pid": 0,
    "city_code": "",
    "city_name": "吉林"
  },
  {
    "_id": 15,
    "id": 15,
    "pid": 0,
    "city_code": "",
    "city_name": "江苏"
  },
  {
    "_id": 16,
    "id": 16,
    "pid": 0,
    "city_code": "",
    "city_name": "江西"
  },
  {
    "_id": 17,
    "id": 17,
    "pid": 0,
    "city_code": "",
    "city_name": "辽宁"
  },
  {
    "_id": 18,
    "id": 18,
    "pid": 0,
    "city_code": "",
    "city_name": "内蒙古"
  },
  {
    "_id": 19,
    "id": 19,
    "pid": 0,
    "city_code": "",
    "city_name": "宁夏"
  },
  {
    "_id": 20,
    "id": 20,
    "pid": 0,
    "city_code": "",
    "city_name": "青海"
  },
  {
    "_id": 21,
    "id": 21,
    "pid": 0,
    "city_code": "",
    "city_name": "山东"
  },
  {
    "_id": 22,
    "id": 22,
    "pid": 0,
    "city_code": "",
    "city_name": "山西"
  },
  {
    "_id": 23,
    "id": 23,
    "pid": 0,
    "city_code": "",
    "city_name": "陕西"
  },
  {
    "_id": 24,
    "id": 24,
    "pid": 0,
    "city_code": "101020100",
    "city_name": "上海"
  },
  {
    "_id": 25,
    "id": 25,
    "pid": 0,
    "city_code": "",
    "city_name": "四川"
  },
  {
    "_id": 26,
    "id": 26,
    "pid": 0,
    "city_code": "101030100",
    "city_name": "天津"
  },
  {
    "_id": 27,
    "id": 27,
    "pid": 0,
    "city_code": "",
    "city_name": "西藏"
  },
  {
    "_id": 28,
    "id": 28,
    "pid": 0,
    "city_code": "",
    "city_name": "新疆"
  },
  {
    "_id": 29,
    "id": 29,
    "pid": 0,
    "city_code": "",
    "city_name": "云南"
  },
  {
    "_id": 30,
    "id": 30,
    "pid": 0,
    "city_code": "",
    "city_name": "浙江"
  },
  {
    "_id": 31,
    "id": 31,
    "pid": 0,
    "city_code": "101040100",
    "city_name": "重庆"
  },
  {
    "_id": 32,
    "id": 32,
    "pid": 0,
    "city_code": "101320101",
    "city_name": "香港"
  },
  {
    "_id": 33,
    "id": 33,
    "pid": 0,
    "city_code": "101330101",
    "city_name": "澳门"
  },
  {
    "_id": 34,
    "id": 34,
    "pid": 0,
    "city_code": "",
    "city_name": "台湾"
  },
  {
    "_id": 35,
    "id": 35,
    "pid": 2,
    "city_code": "101220601",
    "city_name": "安庆"
  },
  {
    "_id": 36,
    "id": 36,
    "pid": 2,
    "city_code": "101220201",
    "city_name": "蚌埠"
  },
  {
    "_id": 37,
    "id": 37,
    "pid": 3400,
    "city_code": "101220105",
    "city_name": "巢湖市"
  },
  {
    "_id": 38,
    "id": 38,
    "pid": 2,
    "city_code": "101221701",
    "city_name": "池州"
  },
  {
    "_id": 39,
    "id": 39,
    "pid": 2,
    "city_code": "101221101",
    "city_name": "滁州"
  },
  {
    "_id": 40,
    "id": 40,
    "pid": 2,
    "city_code": "101220801",
    "city_name": "阜阳"
  },
  {
    "_id": 41,
    "id": 41,
    "pid": 2,
    "city_code": "101221201",
    "city_name": "淮北"
  },
  {
    "_id": 42,
    "id": 42,
    "pid": 2,
    "city_code": "101220401",
    "city_name": "淮南"
  },
  {
    "_id": 43,
    "id": 43,
    "pid": 2,
    "city_code": "101221001",
    "city_name": "黄山"
  },
  {
    "_id": 44,
    "id": 44,
    "pid": 2,
    "city_code": "101221501",
    "city_name": "六安"
  },
  {
    "_id": 45,
    "id": 45,
    "pid": 2,
    "city_code": "101220501",
    "city_name": "马鞍山"
  },
  {
    "_id": 46,
    "id": 46,
    "pid": 2,
    "city_code": "101220701",
    "city_name": "宿州"
  },
  {
    "_id": 47,
    "id": 47,
    "pid": 2,
    "city_code": "101221301",
    "city_name": "铜陵"
  },
  {
    "_id": 48,
    "id": 48,
    "pid": 2,
    "city_code": "101220301",
    "city_name": "芜湖"
  },
  {
    "_id": 49,
    "id": 49,
    "pid": 2,
    "city_code": "101221401",
    "city_name": "宣城"
  },
  {
    "_id": 50,
    "id": 50,
    "pid": 2,
    "city_code": "101220901",
    "city_name": "亳州"
  },
  {
    "_id": 51,
    "id": 52,
    "pid": 3,
    "city_code": "101230101",
    "city_name": "福州"
  },
  {
    "_id": 52,
    "id": 53,
    "pid": 3,
    "city_code": "101230701",
    "city_name": "龙岩"
  },
  {
    "_id": 53,
    "id": 54,
    "pid": 3,
    "city_code": "101230901",
    "city_name": "南平"
  },
  {
    "_id": 54,
    "id": 55,
    "pid": 3,
    "city_code": "101230301",
    "city_name": "宁德"
  },
  {
    "_id": 55,
    "id": 56,
    "pid": 3,
    "city_code": "101230401",
    "city_name": "莆田"
  },
  {
    "_id": 56,
    "id": 57,
    "pid": 3,
    "city_code": "101230501",
    "city_name": "泉州"
  },
  {
    "_id": 57,
    "id": 58,
    "pid": 3,
    "city_code": "101230801",
    "city_name": "三明"
  },
  {
    "_id": 58,
    "id": 59,
    "pid": 3,
    "city_code": "101230201",
    "city_name": "厦门"
  },
  {
    "_id": 59,
    "id": 60,
    "pid": 3,
    "city_code": "101230601",
    "city_name": "漳州"
  },
  {
    "_id": 60,
    "id": 61,
    "pid": 4,
    "city_code": "101160101",
    "city_name": "兰州"
  },
  {
    "_id": 61,
    "id": 62,
    "pid": 4,
    "city_code": "101161301",
    "city_name": "白银"
  },
  {
    "_id": 62,
    "id": 63,
    "pid": 4,
    "city_code": "101160201",
    "city_name": "定西"
  },
  {
    "_id": 63,
    "id": 64,
    "pid": 4,
    "city_code": "",
    "city_name": "甘南州"
  },
  {
    "_id": 64,
    "id": 65,
    "pid": 4,
    "city_code": "101161401",
    "city_name": "嘉峪关"
  },
  {
    "_id": 65,
    "id": 66,
    "pid": 4,
    "city_code": "101160601",
    "city_name": "金昌"
  },
  {
    "_id": 66,
    "id": 67,
    "pid": 4,
    "city_code": "101160801",
    "city_name": "酒泉"
  },
  {
    "_id": 67,
    "id": 68,
    "pid": 4,
    "city_code": "101161101",
    "city_name": "临夏"
  },
  {
    "_id": 68,
    "id": 69,
    "pid": 4,
    "city_code": "101161010",
    "city_name": "陇南市"
  },
  {
    "_id": 69,
    "id": 70,
    "pid": 4,
    "city_code": "101160301",
    "city_name": "平凉"
  },
  {
    "_id": 70,
    "id": 71,
    "pid": 4,
    "city_code": "101160401",
    "city_name": "庆阳"
  },
  {
    "_id": 71,
    "id": 72,
    "pid": 4,
    "city_code": "101160901",
    "city_name": "天水"
  },
  {
    "_id": 72,
    "id": 73,
    "pid": 4,
    "city_code": "101160501",
    "city_name": "武威"
  },
  {
    "_id": 73,
    "id": 74,
    "pid": 4,
    "city_code": "101160701",
    "city_name": "张掖"
  },
  {
    "_id": 74,
    "id": 75,
    "pid": 5,
    "city_code": "101280101",
    "city_name": "广州"
  },
  {
    "_id": 75,
    "id": 76,
    "pid": 5,
    "city_code": "101280601",
    "city_name": "深圳"
  },
  {
    "_id": 76,
    "id": 77,
    "pid": 5,
    "city_code": "101281501",
    "city_name": "潮州"
  },
  {
    "_id": 77,
    "id": 78,
    "pid": 5,
    "city_code": "101281601",
    "city_name": "东莞"
  },
  {
    "_id": 78,
    "id": 79,
    "pid": 5,
    "city_code": "101280800",
    "city_name": "佛山"
  },
  {
    "_id": 79,
    "id": 80,
    "pid": 5,
    "city_code": "101281201",
    "city_name": "河源"
  },
  {
    "_id": 80,
    "id": 81,
    "pid": 5,
    "city_code": "101280301",
    "city_name": "惠州"
  },
  {
    "_id": 81,
    "id": 82,
    "pid": 5,
    "city_code": "101281101",
    "city_name": "江门"
  },
  {
    "_id": 82,
    "id": 83,
    "pid": 5,
    "city_code": "101281901",
    "city_name": "揭阳"
  },
  {
    "_id": 83,
    "id": 84,
    "pid": 5,
    "city_code": "101282001",
    "city_name": "茂名"
  },
  {
    "_id": 84,
    "id": 85,
    "pid": 5,
    "city_code": "101280401",
    "city_name": "梅州"
  },
  {
    "_id": 85,
    "id": 86,
    "pid": 5,
    "city_code": "101281301",
    "city_name": "清远"
  },
  {
    "_id": 86,
    "id": 87,
    "pid": 5,
    "city_code": "101280501",
    "city_name": "汕头"
  },
  {
    "_id": 87,
    "id": 88,
    "pid": 5,
    "city_code": "101282101",
    "city_name": "汕尾"
  },
  {
    "_id": 88,
    "id": 89,
    "pid": 5,
    "city_code": "101280201",
    "city_name": "韶关"
  },
  {
    "_id": 89,
    "id": 90,
    "pid": 5,
    "city_code": "101281801",
    "city_name": "阳江"
  },
  {
    "_id": 90,
    "id": 91,
    "pid": 5,
    "city_code": "101281401",
    "city_name": "云浮"
  },
  {
    "_id": 91,
    "id": 92,
    "pid": 5,
    "city_code": "101281001",
    "city_name": "湛江"
  },
  {
    "_id": 92,
    "id": 93,
    "pid": 5,
    "city_code": "101280901",
    "city_name": "肇庆"
  },
  {
    "_id": 93,
    "id": 94,
    "pid": 5,
    "city_code": "101281701",
    "city_name": "中山"
  },
  {
    "_id": 94,
    "id": 95,
    "pid": 5,
    "city_code": "101280701",
    "city_name": "珠海"
  },
  {
    "_id": 95,
    "id": 96,
    "pid": 6,
    "city_code": "101300101",
    "city_name": "南宁"
  },
  {
    "_id": 96,
    "id": 97,
    "pid": 6,
    "city_code": "101300501",
    "city_name": "桂林"
  },
  {
    "_id": 97,
    "id": 98,
    "pid": 6,
    "city_code": "101301001",
    "city_name": "百色"
  },
  {
    "_id": 98,
    "id": 99,
    "pid": 6,
    "city_code": "101301301",
    "city_name": "北海"
  },
  {
    "_id": 99,
    "id": 100,
    "pid": 6,
    "city_code": "101300201",
    "city_name": "崇左"
  },
  {
    "_id": 100,
    "id": 101,
    "pid": 6,
    "city_code": "101301401",
    "city_name": "防城港"
  },
  {
    "_id": 101,
    "id": 102,
    "pid": 6,
    "city_code": "101300801",
    "city_name": "贵港"
  },
  {
    "_id": 102,
    "id": 103,
    "pid": 6,
    "city_code": "101301201",
    "city_name": "河池"
  },
  {
    "_id": 103,
    "id": 104,
    "pid": 6,
    "city_code": "101300701",
    "city_name": "贺州"
  },
  {
    "_id": 104,
    "id": 105,
    "pid": 6,
    "city_code": "101300401",
    "city_name": "来宾"
  },
  {
    "_id": 105,
    "id": 106,
    "pid": 6,
    "city_code": "101300301",
    "city_name": "柳州"
  },
  {
    "_id": 106,
    "id": 107,
    "pid": 6,
    "city_code": "101301101",
    "city_name": "钦州"
  },
  {
    "_id": 107,
    "id": 108,
    "pid": 6,
    "city_code": "101300601",
    "city_name": "梧州"
  },
  {
    "_id": 108,
    "id": 109,
    "pid": 6,
    "city_code": "101300901",
    "city_name": "玉林"
  },
  {
    "_id": 109,
    "id": 110,
    "pid": 7,
    "city_code": "101260101",
    "city_name": "贵阳"
  },
  {
    "_id": 110,
    "id": 111,
    "pid": 7,
    "city_code": "101260301",
    "city_name": "安顺"
  },
  {
    "_id": 111,
    "id": 112,
    "pid": 7,
    "city_code": "101260701",
    "city_name": "毕节"
  },
  {
    "_id": 112,
    "id": 113,
    "pid": 7,
    "city_code": "101260801",
    "city_name": "六盘水"
  },
  {
    "_id": 113,
    "id": 114,
    "pid": 7,
    "city_code": "101260506",
    "city_name": "黔东南"
  },
  {
    "_id": 114,
    "id": 115,
    "pid": 7,
    "city_code": "101260413",
    "city_name": "黔南"
  },
  {
    "_id": 115,
    "id": 116,
    "pid": 7,
    "city_code": "101260906",
    "city_name": "黔西南"
  },
  {
    "_id": 116,
    "id": 117,
    "pid": 7,
    "city_code": "101260601",
    "city_name": "铜仁"
  },
  {
    "_id": 117,
    "id": 118,
    "pid": 7,
    "city_code": "101260201",
    "city_name": "遵义"
  },
  {
    "_id": 118,
    "id": 119,
    "pid": 8,
    "city_code": "101310101",
    "city_name": "海口"
  },
  {
    "_id": 119,
    "id": 120,
    "pid": 8,
    "city_code": "101310201",
    "city_name": "三亚"
  },
  {
    "_id": 120,
    "id": 121,
    "pid": 8,
    "city_code": "101310207",
    "city_name": "白沙县"
  },
  {
    "_id": 121,
    "id": 122,
    "pid": 8,
    "city_code": "101310214",
    "city_name": "保亭县"
  },
  {
    "_id": 122,
    "id": 123,
    "pid": 8,
    "city_code": "101310206",
    "city_name": "昌江县"
  },
  {
    "_id": 123,
    "id": 124,
    "pid": 8,
    "city_code": "101310204",
    "city_name": "澄迈县"
  },
  {
    "_id": 124,
    "id": 125,
    "pid": 8,
    "city_code": "101310209",
    "city_name": "定安县"
  },
  {
    "_id": 125,
    "id": 126,
    "pid": 8,
    "city_code": "101310202",
    "city_name": "东方"
  },
  {
    "_id": 126,
    "id": 127,
    "pid": 8,
    "city_code": "101310221",
    "city_name": "乐东县"
  },
  {
    "_id": 127,
    "id": 128,
    "pid": 8,
    "city_code": "101310203",
    "city_name": "临高县"
  },
  {
    "_id": 128,
    "id": 129,
    "pid": 8,
    "city_code": "101310216",
    "city_name": "陵水县"
  },
  {
    "_id": 129,
    "id": 130,
    "pid": 8,
    "city_code": "101310211",
    "city_name": "琼海"
  },
  {
    "_id": 130,
    "id": 131,
    "pid": 8,
    "city_code": "101310208",
    "city_name": "琼中"
  },
  {
    "_id": 131,
    "id": 132,
    "pid": 8,
    "city_code": "101310210",
    "city_name": "屯昌县"
  },
  {
    "_id": 132,
    "id": 133,
    "pid": 8,
    "city_code": "101310215",
    "city_name": "万宁"
  },
  {
    "_id": 133,
    "id": 134,
    "pid": 8,
    "city_code": "101310212",
    "city_name": "文昌"
  },
  {
    "_id": 134,
    "id": 135,
    "pid": 8,
    "city_code": "101310222",
    "city_name": "五指山"
  },
  {
    "_id": 135,
    "id": 136,
    "pid": 8,
    "city_code": "101310205",
    "city_name": "儋州"
  },
  {
    "_id": 136,
    "id": 137,
    "pid": 9,
    "city_code": "101090101",
    "city_name": "石家庄"
  },
  {
    "_id": 137,
    "id": 138,
    "pid": 9,
    "city_code": "101090201",
    "city_name": "保定"
  },
  {
    "_id": 138,
    "id": 139,
    "pid": 9,
    "city_code": "101090701",
    "city_name": "沧州"
  },
  {
    "_id": 139,
    "id": 140,
    "pid": 9,
    "city_code": "101090402",
    "city_name": "承德"
  },
  {
    "_id": 140,
    "id": 141,
    "pid": 9,
    "city_code": "101091001",
    "city_name": "邯郸"
  },
  {
    "_id": 141,
    "id": 142,
    "pid": 9,
    "city_code": "101090801",
    "city_name": "衡水"
  },
  {
    "_id": 142,
    "id": 143,
    "pid": 9,
    "city_code": "101090601",
    "city_name": "廊坊"
  },
  {
    "_id": 143,
    "id": 144,
    "pid": 9,
    "city_code": "101091101",
    "city_name": "秦皇岛"
  },
  {
    "_id": 144,
    "id": 145,
    "pid": 9,
    "city_code": "101090501",
    "city_name": "唐山"
  },
  {
    "_id": 145,
    "id": 146,
    "pid": 9,
    "city_code": "101090901",
    "city_name": "邢台"
  },
  {
    "_id": 146,
    "id": 147,
    "pid": 9,
    "city_code": "101090301",
    "city_name": "张家口"
  },
  {
    "_id": 147,
    "id": 148,
    "pid": 10,
    "city_code": "101180101",
    "city_name": "郑州"
  },
  {
    "_id": 148,
    "id": 149,
    "pid": 10,
    "city_code": "101180901",
    "city_name": "洛阳"
  },
  {
    "_id": 149,
    "id": 150,
    "pid": 10,
    "city_code": "101180801",
    "city_name": "开封"
  },
  {
    "_id": 150,
    "id": 151,
    "pid": 10,
    "city_code": "101180201",
    "city_name": "安阳"
  },
  {
    "_id": 151,
    "id": 152,
    "pid": 10,
    "city_code": "101181201",
    "city_name": "鹤壁"
  },
  {
    "_id": 152,
    "id": 153,
    "pid": 10,
    "city_code": "101181801",
    "city_name": "济源"
  },
  {
    "_id": 153,
    "id": 154,
    "pid": 10,
    "city_code": "101181101",
    "city_name": "焦作"
  },
  {
    "_id": 154,
    "id": 155,
    "pid": 10,
    "city_code": "101180701",
    "city_name": "南阳"
  },
  {
    "_id": 155,
    "id": 156,
    "pid": 10,
    "city_code": "101180501",
    "city_name": "平顶山"
  },
  {
    "_id": 156,
    "id": 157,
    "pid": 10,
    "city_code": "101181701",
    "city_name": "三门峡"
  },
  {
    "_id": 157,
    "id": 158,
    "pid": 10,
    "city_code": "101181001",
    "city_name": "商丘"
  },
  {
    "_id": 158,
    "id": 159,
    "pid": 10,
    "city_code": "101180301",
    "city_name": "新乡"
  },
  {
    "_id": 159,
    "id": 160,
    "pid": 10,
    "city_code": "101180601",
    "city_name": "信阳"
  },
  {
    "_id": 160,
    "id": 161,
    "pid": 10,
    "city_code": "101180401",
    "city_name": "许昌"
  },
  {
    "_id": 161,
    "id": 162,
    "pid": 10,
    "city_code": "101181401",
    "city_name": "周口"
  },
  {
    "_id": 162,
    "id": 163,
    "pid": 10,
    "city_code": "101181601",
    "city_name": "驻马店"
  },
  {
    "_id": 163,
    "id": 164,
    "pid": 10,
    "city_code": "101181501",
    "city_name": "漯河"
  },
  {
    "_id": 164,
    "id": 165,
    "pid": 10,
    "city_code": "101181301",
    "city_name": "濮阳"
  },
  {
    "_id": 165,
    "id": 166,
    "pid": 11,
    "city_code": "101050101",
    "city_name": "哈尔滨"
  },
  {
    "_id": 166,
    "id": 167,
    "pid": 11,
    "city_code": "101050901",
    "city_name": "大庆"
  },
  {
    "_id": 167,
    "id": 168,
    "pid": 11,
    "city_code": "101050701",
    "city_name": "大兴安岭"
  },
  {
    "_id": 168,
    "id": 169,
    "pid": 11,
    "city_code": "101051201",
    "city_name": "鹤岗"
  },
  {
    "_id": 169,
    "id": 170,
    "pid": 11,
    "city_code": "101050601",
    "city_name": "黑河"
  },
  {
    "_id": 170,
    "id": 171,
    "pid": 11,
    "city_code": "101051101",
    "city_name": "鸡西"
  },
  {
    "_id": 171,
    "id": 172,
    "pid": 11,
    "city_code": "101050401",
    "city_name": "佳木斯"
  },
  {
    "_id": 172,
    "id": 173,
    "pid": 11,
    "city_code": "101050301",
    "city_name": "牡丹江"
  },
  {
    "_id": 173,
    "id": 174,
    "pid": 11,
    "city_code": "101051002",
    "city_name": "七台河"
  },
  {
    "_id": 174,
    "id": 175,
    "pid": 11,
    "city_code": "101050201",
    "city_name": "齐齐哈尔"
  },
  {
    "_id": 175,
    "id": 176,
    "pid": 11,
    "city_code": "101051301",
    "city_name": "双鸭山"
  },
  {
    "_id": 176,
    "id": 177,
    "pid": 11,
    "city_code": "101050501",
    "city_name": "绥化"
  },
  {
    "_id": 177,
    "id": 178,
    "pid": 11,
    "city_code": "101050801",
    "city_name": "伊春"
  },
  {
    "_id": 178,
    "id": 179,
    "pid": 12,
    "city_code": "101200101",
    "city_name": "武汉"
  },
  {
    "_id": 179,
    "id": 180,
    "pid": 12,
    "city_code": "101201601",
    "city_name": "仙桃"
  },
  {
    "_id": 180,
    "id": 181,
    "pid": 12,
    "city_code": "101200301",
    "city_name": "鄂州"
  },
  {
    "_id": 181,
    "id": 182,
    "pid": 12,
    "city_code": "101200501",
    "city_name": "黄冈"
  },
  {
    "_id": 182,
    "id": 183,
    "pid": 12,
    "city_code": "101200601",
    "city_name": "黄石"
  },
  {
    "_id": 183,
    "id": 184,
    "pid": 12,
    "city_code": "101201401",
    "city_name": "荆门"
  },
  {
    "_id": 184,
    "id": 185,
    "pid": 12,
    "city_code": "101200801",
    "city_name": "荆州"
  },
  {
    "_id": 185,
    "id": 186,
    "pid": 12,
    "city_code": "101201701",
    "city_name": "潜江"
  },
  {
    "_id": 186,
    "id": 187,
    "pid": 12,
    "city_code": "101201201",
    "city_name": "神农架林区"
  },
  {
    "_id": 187,
    "id": 188,
    "pid": 12,
    "city_code": "101201101",
    "city_name": "十堰"
  },
  {
    "_id": 188,
    "id": 189,
    "pid": 12,
    "city_code": "101201301",
    "city_name": "随州"
  },
  {
    "_id": 189,
    "id": 190,
    "pid": 12,
    "city_code": "101201501",
    "city_name": "天门"
  },
  {
    "_id": 190,
    "id": 191,
    "pid": 12,
    "city_code": "101200701",
    "city_name": "咸宁"
  },
  {
    "_id": 191,
    "id": 192,
    "pid": 12,
    "city_code": "101200202",
    "city_name": "襄阳"
  },
  {
    "_id": 192,
    "id": 193,
    "pid": 12,
    "city_code": "101200401",
    "city_name": "孝感"
  },
  {
    "_id": 193,
    "id": 194,
    "pid": 12,
    "city_code": "101200901",
    "city_name": "宜昌"
  },
  {
    "_id": 194,
    "id": 195,
    "pid": 12,
    "city_code": "101201001",
    "city_name": "恩施"
  },
  {
    "_id": 195,
    "id": 196,
    "pid": 13,
    "city_code": "101250101",
    "city_name": "长沙"
  },
  {
    "_id": 196,
    "id": 197,
    "pid": 13,
    "city_code": "101251101",
    "city_name": "张家界"
  },
  {
    "_id": 197,
    "id": 198,
    "pid": 13,
    "city_code": "101250601",
    "city_name": "常德"
  },
  {
    "_id": 198,
    "id": 199,
    "pid": 13,
    "city_code": "101250501",
    "city_name": "郴州"
  },
  {
    "_id": 199,
    "id": 200,
    "pid": 13,
    "city_code": "101250401",
    "city_name": "衡阳"
  },
  {
    "_id": 200,
    "id": 201,
    "pid": 13,
    "city_code": "101251201",
    "city_name": "怀化"
  },
  {
    "_id": 201,
    "id": 202,
    "pid": 13,
    "city_code": "101250801",
    "city_name": "娄底"
  },
  {
    "_id": 202,
    "id": 203,
    "pid": 13,
    "city_code": "101250901",
    "city_name": "邵阳"
  },
  {
    "_id": 203,
    "id": 204,
    "pid": 13,
    "city_code": "101250201",
    "city_name": "湘潭"
  },
  {
    "_id": 204,
    "id": 205,
    "pid": 13,
    "city_code": "101251509",
    "city_name": "湘西"
  },
  {
    "_id": 205,
    "id": 206,
    "pid": 13,
    "city_code": "101250700",
    "city_name": "益阳"
  },
  {
    "_id": 206,
    "id": 207,
    "pid": 13,
    "city_code": "101251401",
    "city_name": "永州"
  },
  {
    "_id": 207,
    "id": 208,
    "pid": 13,
    "city_code": "101251001",
    "city_name": "岳阳"
  },
  {
    "_id": 208,
    "id": 209,
    "pid": 13,
    "city_code": "101250301",
    "city_name": "株洲"
  },
  {
    "_id": 209,
    "id": 210,
    "pid": 14,
    "city_code": "101060101",
    "city_name": "长春"
  },
  {
    "_id": 210,
    "id": 211,
    "pid": 14,
    "city_code": "101060201",
    "city_name": "吉林市"
  },
  {
    "_id": 211,
    "id": 212,
    "pid": 14,
    "city_code": "101060601",
    "city_name": "白城"
  },
  {
    "_id": 212,
    "id": 213,
    "pid": 14,
    "city_code": "101060901",
    "city_name": "白山"
  },
  {
    "_id": 213,
    "id": 214,
    "pid": 14,
    "city_code": "101060701",
    "city_name": "辽源"
  },
  {
    "_id": 214,
    "id": 215,
    "pid": 14,
    "city_code": "101060401",
    "city_name": "四平"
  },
  {
    "_id": 215,
    "id": 216,
    "pid": 14,
    "city_code": "101060801",
    "city_name": "松原"
  },
  {
    "_id": 216,
    "id": 217,
    "pid": 14,
    "city_code": "101060501",
    "city_name": "通化"
  },
  {
    "_id": 217,
    "id": 218,
    "pid": 14,
    "city_code": "101060312",
    "city_name": "延边"
  },
  {
    "_id": 218,
    "id": 219,
    "pid": 15,
    "city_code": "101190101",
    "city_name": "南京"
  },
  {
    "_id": 219,
    "id": 220,
    "pid": 15,
    "city_code": "101190401",
    "city_name": "苏州"
  },
  {
    "_id": 220,
    "id": 221,
    "pid": 15,
    "city_code": "101190201",
    "city_name": "无锡"
  },
  {
    "_id": 221,
    "id": 222,
    "pid": 15,
    "city_code": "101191101",
    "city_name": "常州"
  },
  {
    "_id": 222,
    "id": 223,
    "pid": 15,
    "city_code": "101190901",
    "city_name": "淮安"
  },
  {
    "_id": 223,
    "id": 224,
    "pid": 15,
    "city_code": "101191001",
    "city_name": "连云港"
  },
  {
    "_id": 224,
    "id": 225,
    "pid": 15,
    "city_code": "101190501",
    "city_name": "南通"
  },
  {
    "_id": 225,
    "id": 226,
    "pid": 15,
    "city_code": "101191301",
    "city_name": "宿迁"
  },
  {
    "_id": 226,
    "id": 227,
    "pid": 15,
    "city_code": "101191201",
    "city_name": "泰州"
  },
  {
    "_id": 227,
    "id": 228,
    "pid": 15,
    "city_code": "101190801",
    "city_name": "徐州"
  },
  {
    "_id": 228,
    "id": 229,
    "pid": 15,
    "city_code": "101190701",
    "city_name": "盐城"
  },
  {
    "_id": 229,
    "id": 230,
    "pid": 15,
    "city_code": "101190601",
    "city_name": "扬州"
  },
  {
    "_id": 230,
    "id": 231,
    "pid": 15,
    "city_code": "101190301",
    "city_name": "镇江"
  },
  {
    "_id": 231,
    "id": 232,
    "pid": 16,
    "city_code": "101240101",
    "city_name": "南昌"
  },
  {
    "_id": 232,
    "id": 233,
    "pid": 16,
    "city_code": "101240401",
    "city_name": "抚州"
  },
  {
    "_id": 233,
    "id": 234,
    "pid": 16,
    "city_code": "101240701",
    "city_name": "赣州"
  },
  {
    "_id": 234,
    "id": 235,
    "pid": 16,
    "city_code": "101240601",
    "city_name": "吉安"
  },
  {
    "_id": 235,
    "id": 236,
    "pid": 16,
    "city_code": "101240801",
    "city_name": "景德镇"
  },
  {
    "_id": 236,
    "id": 237,
    "pid": 16,
    "city_code": "101240201",
    "city_name": "九江"
  },
  {
    "_id": 237,
    "id": 238,
    "pid": 16,
    "city_code": "101240901",
    "city_name": "萍乡"
  },
  {
    "_id": 238,
    "id": 239,
    "pid": 16,
    "city_code": "101240301",
    "city_name": "上饶"
  },
  {
    "_id": 239,
    "id": 240,
    "pid": 16,
    "city_code": "101241001",
    "city_name": "新余"
  },
  {
    "_id": 240,
    "id": 241,
    "pid": 16,
    "city_code": "101240501",
    "city_name": "宜春"
  },
  {
    "_id": 241,
    "id": 242,
    "pid": 16,
    "city_code": "101241101",
    "city_name": "鹰潭"
  },
  {
    "_id": 242,
    "id": 243,
    "pid": 17,
    "city_code": "101070101",
    "city_name": "沈阳"
  },
  {
    "_id": 243,
    "id": 244,
    "pid": 17,
    "city_code": "101070201",
    "city_name": "大连"
  },
  {
    "_id": 244,
    "id": 245,
    "pid": 17,
    "city_code": "101070301",
    "city_name": "鞍山"
  },
  {
    "_id": 245,
    "id": 246,
    "pid": 17,
    "city_code": "101070501",
    "city_name": "本溪"
  },
  {
    "_id": 246,
    "id": 247,
    "pid": 17,
    "city_code": "101071201",
    "city_name": "朝阳"
  },
  {
    "_id": 247,
    "id": 248,
    "pid": 17,
    "city_code": "101070601",
    "city_name": "丹东"
  },
  {
    "_id": 248,
    "id": 249,
    "pid": 17,
    "city_code": "101070401",
    "city_name": "抚顺"
  },
  {
    "_id": 249,
    "id": 250,
    "pid": 17,
    "city_code": "101070901",
    "city_name": "阜新"
  },
  {
    "_id": 250,
    "id": 251,
    "pid": 17,
    "city_code": "101071401",
    "city_name": "葫芦岛"
  },
  {
    "_id": 251,
    "id": 252,
    "pid": 17,
    "city_code": "101070701",
    "city_name": "锦州"
  },
  {
    "_id": 252,
    "id": 253,
    "pid": 17,
    "city_code": "101071001",
    "city_name": "辽阳"
  },
  {
    "_id": 253,
    "id": 254,
    "pid": 17,
    "city_code": "101071301",
    "city_name": "盘锦"
  },
  {
    "_id": 254,
    "id": 255,
    "pid": 17,
    "city_code": "101071101",
    "city_name": "铁岭"
  },
  {
    "_id": 255,
    "id": 256,
    "pid": 17,
    "city_code": "101070801",
    "city_name": "营口"
  },
  {
    "_id": 256,
    "id": 257,
    "pid": 18,
    "city_code": "101080101",
    "city_name": "呼和浩特"
  },
  {
    "_id": 257,
    "id": 258,
    "pid": 18,
    "city_code": "101081213",
    "city_name": "阿拉善盟"
  },
  {
    "_id": 258,
    "id": 259,
    "pid": 18,
    "city_code": "101080801",
    "city_name": "巴彦淖尔"
  },
  {
    "_id": 259,
    "id": 260,
    "pid": 18,
    "city_code": "101080201",
    "city_name": "包头"
  },
  {
    "_id": 260,
    "id": 261,
    "pid": 18,
    "city_code": "101080601",
    "city_name": "赤峰"
  },
  {
    "_id": 261,
    "id": 262,
    "pid": 18,
    "city_code": "101080701",
    "city_name": "鄂尔多斯"
  },
  {
    "_id": 262,
    "id": 263,
    "pid": 18,
    "city_code": "101081001",
    "city_name": "呼伦贝尔"
  },
  {
    "_id": 263,
    "id": 264,
    "pid": 18,
    "city_code": "101080501",
    "city_name": "通辽"
  },
  {
    "_id": 264,
    "id": 265,
    "pid": 18,
    "city_code": "101080301",
    "city_name": "乌海"
  },
  {
    "_id": 265,
    "id": 266,
    "pid": 18,
    "city_code": "101080405",
    "city_name": "乌兰察布"
  },
  {
    "_id": 266,
    "id": 267,
    "pid": 18,
    "city_code": "101080902",
    "city_name": "锡林郭勒"
  },
  {
    "_id": 267,
    "id": 268,
    "pid": 18,
    "city_code": "101081108",
    "city_name": "兴安盟"
  },
  {
    "_id": 268,
    "id": 269,
    "pid": 19,
    "city_code": "101170101",
    "city_name": "银川"
  },
  {
    "_id": 269,
    "id": 270,
    "pid": 19,
    "city_code": "101170401",
    "city_name": "固原"
  },
  {
    "_id": 270,
    "id": 271,
    "pid": 19,
    "city_code": "101170201",
    "city_name": "石嘴山"
  },
  {
    "_id": 271,
    "id": 272,
    "pid": 19,
    "city_code": "101170301",
    "city_name": "吴忠"
  },
  {
    "_id": 272,
    "id": 273,
    "pid": 19,
    "city_code": "101170501",
    "city_name": "中卫"
  },
  {
    "_id": 273,
    "id": 274,
    "pid": 20,
    "city_code": "101150101",
    "city_name": "西宁"
  },
  {
    "_id": 274,
    "id": 275,
    "pid": 20,
    "city_code": "101150501",
    "city_name": "果洛"
  },
  {
    "_id": 275,
    "id": 276,
    "pid": 20,
    "city_code": "101150801",
    "city_name": "海北"
  },
  {
    "_id": 276,
    "id": 277,
    "pid": 20,
    "city_code": "101150201",
    "city_name": "海东"
  },
  {
    "_id": 277,
    "id": 278,
    "pid": 20,
    "city_code": "101150401",
    "city_name": "海南州"
  },
  {
    "_id": 278,
    "id": 279,
    "pid": 20,
    "city_code": "101150701",
    "city_name": "海西"
  },
  {
    "_id": 279,
    "id": 280,
    "pid": 20,
    "city_code": "101150301",
    "city_name": "黄南"
  },
  {
    "_id": 280,
    "id": 281,
    "pid": 20,
    "city_code": "101150601",
    "city_name": "玉树"
  },
  {
    "_id": 281,
    "id": 282,
    "pid": 21,
    "city_code": "101120101",
    "city_name": "济南"
  },
  {
    "_id": 282,
    "id": 283,
    "pid": 21,
    "city_code": "101120201",
    "city_name": "青岛"
  },
  {
    "_id": 283,
    "id": 284,
    "pid": 21,
    "city_code": "101121101",
    "city_name": "滨州"
  },
  {
    "_id": 284,
    "id": 285,
    "pid": 21,
    "city_code": "101120401",
    "city_name": "德州"
  },
  {
    "_id": 285,
    "id": 286,
    "pid": 21,
    "city_code": "101121201",
    "city_name": "东营"
  },
  {
    "_id": 286,
    "id": 287,
    "pid": 21,
    "city_code": "101121001",
    "city_name": "菏泽"
  },
  {
    "_id": 287,
    "id": 288,
    "pid": 21,
    "city_code": "101120701",
    "city_name": "济宁"
  },
  {
    "_id": 288,
    "id": 289,
    "pid": 21,
    "city_code": "101121601",
    "city_name": "莱芜"
  },
  {
    "_id": 289,
    "id": 290,
    "pid": 21,
    "city_code": "101121701",
    "city_name": "聊城"
  },
  {
    "_id": 290,
    "id": 291,
    "pid": 21,
    "city_code": "101120901",
    "city_name": "临沂"
  },
  {
    "_id": 291,
    "id": 292,
    "pid": 21,
    "city_code": "101121501",
    "city_name": "日照"
  },
  {
    "_id": 292,
    "id": 293,
    "pid": 21,
    "city_code": "101120801",
    "city_name": "泰安"
  },
  {
    "_id": 293,
    "id": 294,
    "pid": 21,
    "city_code": "101121301",
    "city_name": "威海"
  },
  {
    "_id": 294,
    "id": 295,
    "pid": 21,
    "city_code": "101120601",
    "city_name": "潍坊"
  },
  {
    "_id": 295,
    "id": 296,
    "pid": 21,
    "city_code": "101120501",
    "city_name": "烟台"
  },
  {
    "_id": 296,
    "id": 297,
    "pid": 21,
    "city_code": "101121401",
    "city_name": "枣庄"
  },
  {
    "_id": 297,
    "id": 298,
    "pid": 21,
    "city_code": "101120301",
    "city_name": "淄博"
  },
  {
    "_id": 298,
    "id": 299,
    "pid": 22,
    "city_code": "101100101",
    "city_name": "太原"
  },
  {
    "_id": 299,
    "id": 300,
    "pid": 22,
    "city_code": "101100501",
    "city_name": "长治"
  },
  {
    "_id": 300,
    "id": 301,
    "pid": 22,
    "city_code": "101100201",
    "city_name": "大同"
  },
  {
    "_id": 301,
    "id": 302,
    "pid": 22,
    "city_code": "101100601",
    "city_name": "晋城"
  },
  {
    "_id": 302,
    "id": 303,
    "pid": 22,
    "city_code": "101100401",
    "city_name": "晋中"
  },
  {
    "_id": 303,
    "id": 304,
    "pid": 22,
    "city_code": "101100701",
    "city_name": "临汾"
  },
  {
    "_id": 304,
    "id": 305,
    "pid": 22,
    "city_code": "101101100",
    "city_name": "吕梁"
  },
  {
    "_id": 305,
    "id": 306,
    "pid": 22,
    "city_code": "101100901",
    "city_name": "朔州"
  },
  {
    "_id": 306,
    "id": 307,
    "pid": 22,
    "city_code": "101101001",
    "city_name": "忻州"
  },
  {
    "_id": 307,
    "id": 308,
    "pid": 22,
    "city_code": "101100301",
    "city_name": "阳泉"
  },
  {
    "_id": 308,
    "id": 309,
    "pid": 22,
    "city_code": "101100801",
    "city_name": "运城"
  },
  {
    "_id": 309,
    "id": 310,
    "pid": 23,
    "city_code": "101110101",
    "city_name": "西安"
  },
  {
    "_id": 310,
    "id": 311,
    "pid": 23,
    "city_code": "101110701",
    "city_name": "安康"
  },
  {
    "_id": 311,
    "id": 312,
    "pid": 23,
    "city_code": "101110901",
    "city_name": "宝鸡"
  },
  {
    "_id": 312,
    "id": 313,
    "pid": 23,
    "city_code": "101110801",
    "city_name": "汉中"
  },
  {
    "_id": 313,
    "id": 314,
    "pid": 23,
    "city_code": "101110601",
    "city_name": "商洛"
  },
  {
    "_id": 314,
    "id": 315,
    "pid": 23,
    "city_code": "101111001",
    "city_name": "铜川"
  },
  {
    "_id": 315,
    "id": 316,
    "pid": 23,
    "city_code": "101110501",
    "city_name": "渭南"
  },
  {
    "_id": 316,
    "id": 317,
    "pid": 23,
    "city_code": "101110200",
    "city_name": "咸阳"
  },
  {
    "_id": 317,
    "id": 318,
    "pid": 23,
    "city_code": "101110300",
    "city_name": "延安"
  },
  {
    "_id": 318,
    "id": 319,
    "pid": 23,
    "city_code": "101110401",
    "city_name": "榆林"
  },
  {
    "_id": 319,
    "id": 321,
    "pid": 25,
    "city_code": "101270101",
    "city_name": "成都"
  },
  {
    "_id": 320,
    "id": 322,
    "pid": 25,
    "city_code": "101270401",
    "city_name": "绵阳"
  },
  {
    "_id": 321,
    "id": 323,
    "pid": 25,
    "city_code": "101271901",
    "city_name": "阿坝"
  },
  {
    "_id": 322,
    "id": 324,
    "pid": 25,
    "city_code": "101270901",
    "city_name": "巴中"
  },
  {
    "_id": 323,
    "id": 325,
    "pid": 25,
    "city_code": "101270601",
    "city_name": "达州"
  },
  {
    "_id": 324,
    "id": 326,
    "pid": 25,
    "city_code": "101272001",
    "city_name": "德阳"
  },
  {
    "_id": 325,
    "id": 327,
    "pid": 25,
    "city_code": "101271801",
    "city_name": "甘孜"
  },
  {
    "_id": 326,
    "id": 328,
    "pid": 25,
    "city_code": "101270801",
    "city_name": "广安"
  },
  {
    "_id": 327,
    "id": 329,
    "pid": 25,
    "city_code": "101272101",
    "city_name": "广元"
  },
  {
    "_id": 328,
    "id": 330,
    "pid": 25,
    "city_code": "101271401",
    "city_name": "乐山"
  },
  {
    "_id": 329,
    "id": 331,
    "pid": 25,
    "city_code": "101271601",
    "city_name": "凉山"
  },
  {
    "_id": 330,
    "id": 332,
    "pid": 25,
    "city_code": "101271501",
    "city_name": "眉山"
  },
  {
    "_id": 331,
    "id": 333,
    "pid": 25,
    "city_code": "101270501",
    "city_name": "南充"
  },
  {
    "_id": 332,
    "id": 334,
    "pid": 25,
    "city_code": "101271201",
    "city_name": "内江"
  },
  {
    "_id": 333,
    "id": 335,
    "pid": 25,
    "city_code": "101270201",
    "city_name": "攀枝花"
  },
  {
    "_id": 334,
    "id": 336,
    "pid": 25,
    "city_code": "101270701",
    "city_name": "遂宁"
  },
  {
    "_id": 335,
    "id": 337,
    "pid": 25,
    "city_code": "101271701",
    "city_name": "雅安"
  },
  {
    "_id": 336,
    "id": 338,
    "pid": 25,
    "city_code": "101271101",
    "city_name": "宜宾"
  },
  {
    "_id": 337,
    "id": 339,
    "pid": 25,
    "city_code": "101271301",
    "city_name": "资阳"
  },
  {
    "_id": 338,
    "id": 340,
    "pid": 25,
    "city_code": "101270301",
    "city_name": "自贡"
  },
  {
    "_id": 339,
    "id": 341,
    "pid": 25,
    "city_code": "101271001",
    "city_name": "泸州"
  },
  {
    "_id": 340,
    "id": 343,
    "pid": 27,
    "city_code": "101140101",
    "city_name": "拉萨"
  },
  {
    "_id": 341,
    "id": 344,
    "pid": 27,
    "city_code": "101140701",
    "city_name": "阿里"
  },
  {
    "_id": 342,
    "id": 345,
    "pid": 27,
    "city_code": "101140501",
    "city_name": "昌都"
  },
  {
    "_id": 343,
    "id": 346,
    "pid": 27,
    "city_code": "101140401",
    "city_name": "林芝"
  },
  {
    "_id": 344,
    "id": 347,
    "pid": 27,
    "city_code": "101140601",
    "city_name": "那曲"
  },
  {
    "_id": 345,
    "id": 348,
    "pid": 27,
    "city_code": "101140201",
    "city_name": "日喀则"
  },
  {
    "_id": 346,
    "id": 349,
    "pid": 27,
    "city_code": "101140301",
    "city_name": "山南"
  },
  {
    "_id": 347,
    "id": 350,
    "pid": 28,
    "city_code": "101130101",
    "city_name": "乌鲁木齐"
  },
  {
    "_id": 348,
    "id": 351,
    "pid": 28,
    "city_code": "101130801",
    "city_name": "阿克苏"
  },
  {
    "_id": 349,
    "id": 352,
    "pid": 28,
    "city_code": "101130701",
    "city_name": "阿拉尔"
  },
  {
    "_id": 350,
    "id": 353,
    "pid": 28,
    "city_code": "101130609",
    "city_name": "巴音郭楞"
  },
  {
    "_id": 351,
    "id": 354,
    "pid": 28,
    "city_code": "101131604",
    "city_name": "博尔塔拉"
  },
  {
    "_id": 352,
    "id": 355,
    "pid": 28,
    "city_code": "101130401",
    "city_name": "昌吉"
  },
  {
    "_id": 353,
    "id": 356,
    "pid": 28,
    "city_code": "101131201",
    "city_name": "哈密"
  },
  {
    "_id": 354,
    "id": 357,
    "pid": 28,
    "city_code": "101131301",
    "city_name": "和田"
  },
  {
    "_id": 355,
    "id": 358,
    "pid": 28,
    "city_code": "101130901",
    "city_name": "喀什"
  },
  {
    "_id": 356,
    "id": 359,
    "pid": 28,
    "city_code": "101130201",
    "city_name": "克拉玛依"
  },
  {
    "_id": 357,
    "id": 360,
    "pid": 28,
    "city_code": "",
    "city_name": "克孜勒苏"
  },
  {
    "_id": 358,
    "id": 361,
    "pid": 28,
    "city_code": "101130301",
    "city_name": "石河子"
  },
  {
    "_id": 359,
    "id": 362,
    "pid": 28,
    "city_code": "",
    "city_name": "图木舒克"
  },
  {
    "_id": 360,
    "id": 363,
    "pid": 28,
    "city_code": "101130501",
    "city_name": "吐鲁番"
  },
  {
    "_id": 361,
    "id": 364,
    "pid": 28,
    "city_code": "",
    "city_name": "五家渠"
  },
  {
    "_id": 362,
    "id": 365,
    "pid": 28,
    "city_code": "101131012",
    "city_name": "伊犁"
  },
  {
    "_id": 363,
    "id": 366,
    "pid": 29,
    "city_code": "101290101",
    "city_name": "昆明"
  },
  {
    "_id": 364,
    "id": 367,
    "pid": 29,
    "city_code": "101291201",
    "city_name": "怒江"
  },
  {
    "_id": 365,
    "id": 368,
    "pid": 29,
    "city_code": "101290901",
    "city_name": "普洱"
  },
  {
    "_id": 366,
    "id": 369,
    "pid": 29,
    "city_code": "101291401",
    "city_name": "丽江"
  },
  {
    "_id": 367,
    "id": 370,
    "pid": 29,
    "city_code": "101290501",
    "city_name": "保山"
  },
  {
    "_id": 368,
    "id": 371,
    "pid": 29,
    "city_code": "101290801",
    "city_name": "楚雄"
  },
  {
    "_id": 369,
    "id": 372,
    "pid": 29,
    "city_code": "101290201",
    "city_name": "大理"
  },
  {
    "_id": 370,
    "id": 373,
    "pid": 29,
    "city_code": "101291501",
    "city_name": "德宏"
  },
  {
    "_id": 371,
    "id": 374,
    "pid": 29,
    "city_code": "101291305",
    "city_name": "迪庆"
  },
  {
    "_id": 372,
    "id": 375,
    "pid": 29,
    "city_code": "101290301",
    "city_name": "红河"
  },
  {
    "_id": 373,
    "id": 376,
    "pid": 29,
    "city_code": "101291101",
    "city_name": "临沧"
  },
  {
    "_id": 374,
    "id": 377,
    "pid": 29,
    "city_code": "101290401",
    "city_name": "曲靖"
  },
  {
    "_id": 375,
    "id": 378,
    "pid": 29,
    "city_code": "101290601",
    "city_name": "文山"
  },
  {
    "_id": 376,
    "id": 379,
    "pid": 29,
    "city_code": "101291602",
    "city_name": "西双版纳"
  },
  {
    "_id": 377,
    "id": 380,
    "pid": 29,
    "city_code": "101290701",
    "city_name": "玉溪"
  },
  {
    "_id": 378,
    "id": 381,
    "pid": 29,
    "city_code": "101291001",
    "city_name": "昭通"
  },
  {
    "_id": 379,
    "id": 382,
    "pid": 30,
    "city_code": "101210101",
    "city_name": "杭州"
  },
  {
    "_id": 380,
    "id": 383,
    "pid": 30,
    "city_code": "101210201",
    "city_name": "湖州"
  },
  {
    "_id": 381,
    "id": 384,
    "pid": 30,
    "city_code": "101210301",
    "city_name": "嘉兴"
  },
  {
    "_id": 382,
    "id": 385,
    "pid": 30,
    "city_code": "101210901",
    "city_name": "金华"
  },
  {
    "_id": 383,
    "id": 386,
    "pid": 30,
    "city_code": "101210801",
    "city_name": "丽水"
  },
  {
    "_id": 384,
    "id": 387,
    "pid": 30,
    "city_code": "101210401",
    "city_name": "宁波"
  },
  {
    "_id": 385,
    "id": 388,
    "pid": 30,
    "city_code": "101210501",
    "city_name": "绍兴"
  },
  {
    "_id": 386,
    "id": 389,
    "pid": 30,
    "city_code": "101210601",
    "city_name": "台州"
  },
  {
    "_id": 387,
    "id": 390,
    "pid": 30,
    "city_code": "101210701",
    "city_name": "温州"
  },
  {
    "_id": 388,
    "id": 391,
    "pid": 30,
    "city_code": "101211101",
    "city_name": "舟山"
  },
  {
    "_id": 389,
    "id": 392,
    "pid": 30,
    "city_code": "101211001",
    "city_name": "衢州"
  },
  {
    "_id": 390,
    "id": 400,
    "pid": 35,
    "city_code": "101220609",
    "city_name": "桐城市"
  },
  {
    "_id": 391,
    "id": 401,
    "pid": 35,
    "city_code": "101220605",
    "city_name": "怀宁县"
  },
  {
    "_id": 392,
    "id": 402,
    "pid": 47,
    "city_code": "101220602",
    "city_name": "枞阳县"
  },
  {
    "_id": 393,
    "id": 403,
    "pid": 35,
    "city_code": "101220604",
    "city_name": "潜山县"
  },
  {
    "_id": 394,
    "id": 404,
    "pid": 35,
    "city_code": "101220603",
    "city_name": "太湖县"
  },
  {
    "_id": 395,
    "id": 405,
    "pid": 35,
    "city_code": "101220606",
    "city_name": "宿松县"
  },
  {
    "_id": 396,
    "id": 406,
    "pid": 35,
    "city_code": "101220607",
    "city_name": "望江县"
  },
  {
    "_id": 397,
    "id": 407,
    "pid": 35,
    "city_code": "101220608",
    "city_name": "岳西县"
  },
  {
    "_id": 398,
    "id": 412,
    "pid": 36,
    "city_code": "101220202",
    "city_name": "怀远县"
  },
  {
    "_id": 399,
    "id": 413,
    "pid": 36,
    "city_code": "101220204",
    "city_name": "五河县"
  },
  {
    "_id": 400,
    "id": 414,
    "pid": 36,
    "city_code": "101220203",
    "city_name": "固镇县"
  },
  {
    "_id": 401,
    "id": 416,
    "pid": 3400,
    "city_code": "101220106",
    "city_name": "庐江县"
  },
  {
    "_id": 402,
    "id": 417,
    "pid": 48,
    "city_code": "101220305",
    "city_name": "无为县"
  },
  {
    "_id": 403,
    "id": 418,
    "pid": 45,
    "city_code": "101220503",
    "city_name": "含山县"
  },
  {
    "_id": 404,
    "id": 419,
    "pid": 45,
    "city_code": "101220504",
    "city_name": "和县"
  },
  {
    "_id": 405,
    "id": 421,
    "pid": 38,
    "city_code": "101221702",
    "city_name": "东至县"
  },
  {
    "_id": 406,
    "id": 422,
    "pid": 38,
    "city_code": "101221705",
    "city_name": "石台县"
  },
  {
    "_id": 407,
    "id": 423,
    "pid": 38,
    "city_code": "101221703",
    "city_name": "青阳县"
  },
  {
    "_id": 408,
    "id": 426,
    "pid": 39,
    "city_code": "101221107",
    "city_name": "天长市"
  },
  {
    "_id": 409,
    "id": 427,
    "pid": 39,
    "city_code": "101221103",
    "city_name": "明光市"
  },
  {
    "_id": 410,
    "id": 428,
    "pid": 39,
    "city_code": "101221106",
    "city_name": "来安县"
  },
  {
    "_id": 411,
    "id": 429,
    "pid": 39,
    "city_code": "101221105",
    "city_name": "全椒县"
  },
  {
    "_id": 412,
    "id": 430,
    "pid": 39,
    "city_code": "101221104",
    "city_name": "定远县"
  },
  {
    "_id": 413,
    "id": 431,
    "pid": 39,
    "city_code": "101221102",
    "city_name": "凤阳县"
  },
  {
    "_id": 414,
    "id": 439,
    "pid": 40,
    "city_code": "101220805",
    "city_name": "界首市"
  },
  {
    "_id": 415,
    "id": 440,
    "pid": 40,
    "city_code": "101220804",
    "city_name": "临泉县"
  },
  {
    "_id": 416,
    "id": 441,
    "pid": 40,
    "city_code": "101220806",
    "city_name": "太和县"
  },
  {
    "_id": 417,
    "id": 442,
    "pid": 40,
    "city_code": "101220802",
    "city_name": "阜南县"
  },
  {
    "_id": 418,
    "id": 443,
    "pid": 40,
    "city_code": "101220803",
    "city_name": "颍上县"
  },
  {
    "_id": 419,
    "id": 447,
    "pid": 41,
    "city_code": "101221202",
    "city_name": "濉溪县"
  },
  {
    "_id": 420,
    "id": 452,
    "pid": 42,
    "city_code": "101220403",
    "city_name": "潘集区"
  },
  {
    "_id": 421,
    "id": 453,
    "pid": 42,
    "city_code": "101220402",
    "city_name": "凤台县"
  },
  {
    "_id": 422,
    "id": 454,
    "pid": 43,
    "city_code": "101221003",
    "city_name": "屯溪区"
  },
  {
    "_id": 423,
    "id": 455,
    "pid": 43,
    "city_code": "101221002",
    "city_name": "黄山区"
  },
  {
    "_id": 424,
    "id": 457,
    "pid": 43,
    "city_code": "101221006",
    "city_name": "歙县"
  },
  {
    "_id": 425,
    "id": 458,
    "pid": 43,
    "city_code": "101221007",
    "city_name": "休宁县"
  },
  {
    "_id": 426,
    "id": 459,
    "pid": 43,
    "city_code": "101221005",
    "city_name": "黟县"
  },
  {
    "_id": 427,
    "id": 460,
    "pid": 43,
    "city_code": "101221004",
    "city_name": "祁门县"
  },
  {
    "_id": 428,
    "id": 463,
    "pid": 44,
    "city_code": "101221503",
    "city_name": "寿县"
  },
  {
    "_id": 429,
    "id": 464,
    "pid": 44,
    "city_code": "101221502",
    "city_name": "霍邱县"
  },
  {
    "_id": 430,
    "id": 465,
    "pid": 44,
    "city_code": "101221507",
    "city_name": "舒城县"
  },
  {
    "_id": 431,
    "id": 466,
    "pid": 44,
    "city_code": "101221505",
    "city_name": "金寨县"
  },
  {
    "_id": 432,
    "id": 467,
    "pid": 44,
    "city_code": "101221506",
    "city_name": "霍山县"
  },
  {
    "_id": 433,
    "id": 471,
    "pid": 45,
    "city_code": "101220502",
    "city_name": "当涂县"
  },
  {
    "_id": 434,
    "id": 473,
    "pid": 46,
    "city_code": "101220702",
    "city_name": "砀山县"
  },
  {
    "_id": 435,
    "id": 474,
    "pid": 46,
    "city_code": "101220705",
    "city_name": "萧县"
  },
  {
    "_id": 436,
    "id": 475,
    "pid": 46,
    "city_code": "101220703",
    "city_name": "灵璧县"
  },
  {
    "_id": 437,
    "id": 476,
    "pid": 46,
    "city_code": "101220704",
    "city_name": "泗县"
  },
  {
    "_id": 438,
    "id": 480,
    "pid": 47,
    "city_code": "101221301",
    "city_name": "义安区"
  },
  {
    "_id": 439,
    "id": 485,
    "pid": 48,
    "city_code": "101220303",
    "city_name": "芜湖县"
  },
  {
    "_id": 440,
    "id": 486,
    "pid": 48,
    "city_code": "101220302",
    "city_name": "繁昌县"
  },
  {
    "_id": 441,
    "id": 487,
    "pid": 48,
    "city_code": "101220304",
    "city_name": "南陵县"
  },
  {
    "_id": 442,
    "id": 489,
    "pid": 49,
    "city_code": "101221404",
    "city_name": "宁国市"
  },
  {
    "_id": 443,
    "id": 490,
    "pid": 49,
    "city_code": "101221407",
    "city_name": "郎溪县"
  },
  {
    "_id": 444,
    "id": 491,
    "pid": 49,
    "city_code": "101221406",
    "city_name": "广德县"
  },
  {
    "_id": 445,
    "id": 492,
    "pid": 49,
    "city_code": "101221402",
    "city_name": "泾县"
  },
  {
    "_id": 446,
    "id": 493,
    "pid": 49,
    "city_code": "101221405",
    "city_name": "绩溪县"
  },
  {
    "_id": 447,
    "id": 494,
    "pid": 49,
    "city_code": "101221403",
    "city_name": "旌德县"
  },
  {
    "_id": 448,
    "id": 495,
    "pid": 50,
    "city_code": "101220902",
    "city_name": "涡阳县"
  },
  {
    "_id": 449,
    "id": 496,
    "pid": 50,
    "city_code": "101220904",
    "city_name": "蒙城县"
  },
  {
    "_id": 450,
    "id": 497,
    "pid": 50,
    "city_code": "101220903",
    "city_name": "利辛县"
  },
  {
    "_id": 451,
    "id": 501,
    "pid": 1,
    "city_code": "101010200",
    "city_name": "海淀区"
  },
  {
    "_id": 452,
    "id": 502,
    "pid": 1,
    "city_code": "101010300",
    "city_name": "朝阳区"
  },
  {
    "_id": 453,
    "id": 505,
    "pid": 1,
    "city_code": "101010900",
    "city_name": "丰台区"
  },
  {
    "_id": 454,
    "id": 506,
    "pid": 1,
    "city_code": "101011000",
    "city_name": "石景山区"
  },
  {
    "_id": 455,
    "id": 507,
    "pid": 1,
    "city_code": "101011200",
    "city_name": "房山区"
  },
  {
    "_id": 456,
    "id": 508,
    "pid": 1,
    "city_code": "101011400",
    "city_name": "门头沟区"
  },
  {
    "_id": 457,
    "id": 509,
    "pid": 1,
    "city_code": "101010600",
    "city_name": "通州区"
  },
  {
    "_id": 458,
    "id": 510,
    "pid": 1,
    "city_code": "101010400",
    "city_name": "顺义区"
  },
  {
    "_id": 459,
    "id": 511,
    "pid": 1,
    "city_code": "101010700",
    "city_name": "昌平区"
  },
  {
    "_id": 460,
    "id": 512,
    "pid": 1,
    "city_code": "101010500",
    "city_name": "怀柔区"
  },
  {
    "_id": 461,
    "id": 513,
    "pid": 1,
    "city_code": "101011500",
    "city_name": "平谷区"
  },
  {
    "_id": 462,
    "id": 514,
    "pid": 1,
    "city_code": "101011100",
    "city_name": "大兴区"
  },
  {
    "_id": 463,
    "id": 515,
    "pid": 1,
    "city_code": "101011300",
    "city_name": "密云县"
  },
  {
    "_id": 464,
    "id": 516,
    "pid": 1,
    "city_code": "101010800",
    "city_name": "延庆县"
  },
  {
    "_id": 465,
    "id": 522,
    "pid": 52,
    "city_code": "101230111",
    "city_name": "福清市"
  },
  {
    "_id": 466,
    "id": 523,
    "pid": 52,
    "city_code": "101230110",
    "city_name": "长乐市"
  },
  {
    "_id": 467,
    "id": 524,
    "pid": 52,
    "city_code": "101230103",
    "city_name": "闽侯县"
  },
  {
    "_id": 468,
    "id": 525,
    "pid": 52,
    "city_code": "101230105",
    "city_name": "连江县"
  },
  {
    "_id": 469,
    "id": 526,
    "pid": 52,
    "city_code": "101230104",
    "city_name": "罗源县"
  },
  {
    "_id": 470,
    "id": 527,
    "pid": 52,
    "city_code": "101230102",
    "city_name": "闽清县"
  },
  {
    "_id": 471,
    "id": 528,
    "pid": 52,
    "city_code": "101230107",
    "city_name": "永泰县"
  },
  {
    "_id": 472,
    "id": 529,
    "pid": 52,
    "city_code": "101230108",
    "city_name": "平潭县"
  },
  {
    "_id": 473,
    "id": 531,
    "pid": 53,
    "city_code": "101230707",
    "city_name": "漳平市"
  },
  {
    "_id": 474,
    "id": 532,
    "pid": 53,
    "city_code": "101230702",
    "city_name": "长汀县"
  },
  {
    "_id": 475,
    "id": 533,
    "pid": 53,
    "city_code": "101230706",
    "city_name": "永定县"
  },
  {
    "_id": 476,
    "id": 534,
    "pid": 53,
    "city_code": "101230705",
    "city_name": "上杭县"
  },
  {
    "_id": 477,
    "id": 535,
    "pid": 53,
    "city_code": "101230704",
    "city_name": "武平县"
  },
  {
    "_id": 478,
    "id": 536,
    "pid": 53,
    "city_code": "101230703",
    "city_name": "连城县"
  },
  {
    "_id": 479,
    "id": 538,
    "pid": 54,
    "city_code": "101230904",
    "city_name": "邵武市"
  },
  {
    "_id": 480,
    "id": 539,
    "pid": 54,
    "city_code": "101230905",
    "city_name": "武夷山市"
  },
  {
    "_id": 481,
    "id": 540,
    "pid": 54,
    "city_code": "101230910",
    "city_name": "建瓯市"
  },
  {
    "_id": 482,
    "id": 541,
    "pid": 54,
    "city_code": "101230907",
    "city_name": "建阳市"
  },
  {
    "_id": 483,
    "id": 542,
    "pid": 54,
    "city_code": "101230902",
    "city_name": "顺昌县"
  },
  {
    "_id": 484,
    "id": 543,
    "pid": 54,
    "city_code": "101230906",
    "city_name": "浦城县"
  },
  {
    "_id": 485,
    "id": 544,
    "pid": 54,
    "city_code": "101230903",
    "city_name": "光泽县"
  },
  {
    "_id": 486,
    "id": 545,
    "pid": 54,
    "city_code": "101230908",
    "city_name": "松溪县"
  },
  {
    "_id": 487,
    "id": 546,
    "pid": 54,
    "city_code": "101230909",
    "city_name": "政和县"
  },
  {
    "_id": 488,
    "id": 548,
    "pid": 55,
    "city_code": "101230306",
    "city_name": "福安市"
  },
  {
    "_id": 489,
    "id": 549,
    "pid": 55,
    "city_code": "101230308",
    "city_name": "福鼎市"
  },
  {
    "_id": 490,
    "id": 550,
    "pid": 55,
    "city_code": "101230303",
    "city_name": "霞浦县"
  },
  {
    "_id": 491,
    "id": 551,
    "pid": 55,
    "city_code": "101230302",
    "city_name": "古田县"
  },
  {
    "_id": 492,
    "id": 552,
    "pid": 55,
    "city_code": "101230309",
    "city_name": "屏南县"
  },
  {
    "_id": 493,
    "id": 553,
    "pid": 55,
    "city_code": "101230304",
    "city_name": "寿宁县"
  },
  {
    "_id": 494,
    "id": 554,
    "pid": 55,
    "city_code": "101230305",
    "city_name": "周宁县"
  },
  {
    "_id": 495,
    "id": 555,
    "pid": 55,
    "city_code": "101230307",
    "city_name": "柘荣县"
  },
  {
    "_id": 496,
    "id": 556,
    "pid": 56,
    "city_code": "101230407",
    "city_name": "城厢区"
  },
  {
    "_id": 497,
    "id": 557,
    "pid": 56,
    "city_code": "101230404",
    "city_name": "涵江区"
  },
  {
    "_id": 498,
    "id": 558,
    "pid": 56,
    "city_code": "101230406",
    "city_name": "荔城区"
  },
  {
    "_id": 499,
    "id": 559,
    "pid": 56,
    "city_code": "101230405",
    "city_name": "秀屿区"
  },
  {
    "_id": 500,
    "id": 560,
    "pid": 56,
    "city_code": "101230402",
    "city_name": "仙游县"
  },
  {
    "_id": 501,
    "id": 566,
    "pid": 57,
    "city_code": "101230510",
    "city_name": "石狮市"
  },
  {
    "_id": 502,
    "id": 567,
    "pid": 57,
    "city_code": "101230509",
    "city_name": "晋江市"
  },
  {
    "_id": 503,
    "id": 568,
    "pid": 57,
    "city_code": "101230506",
    "city_name": "南安市"
  },
  {
    "_id": 504,
    "id": 569,
    "pid": 57,
    "city_code": "101230508",
    "city_name": "惠安县"
  },
  {
    "_id": 505,
    "id": 570,
    "pid": 57,
    "city_code": "101230502",
    "city_name": "安溪县"
  },
  {
    "_id": 506,
    "id": 571,
    "pid": 57,
    "city_code": "101230504",
    "city_name": "永春县"
  },
  {
    "_id": 507,
    "id": 572,
    "pid": 57,
    "city_code": "101230505",
    "city_name": "德化县"
  },
  {
    "_id": 508,
    "id": 576,
    "pid": 58,
    "city_code": "101230810",
    "city_name": "永安市"
  },
  {
    "_id": 509,
    "id": 577,
    "pid": 58,
    "city_code": "101230807",
    "city_name": "明溪县"
  },
  {
    "_id": 510,
    "id": 578,
    "pid": 58,
    "city_code": "101230803",
    "city_name": "清流县"
  },
  {
    "_id": 511,
    "id": 579,
    "pid": 58,
    "city_code": "101230802",
    "city_name": "宁化县"
  },
  {
    "_id": 512,
    "id": 580,
    "pid": 58,
    "city_code": "101230811",
    "city_name": "大田县"
  },
  {
    "_id": 513,
    "id": 581,
    "pid": 58,
    "city_code": "101230809",
    "city_name": "尤溪县"
  },
  {
    "_id": 514,
    "id": 582,
    "pid": 58,
    "city_code": "101230808",
    "city_name": "沙县"
  },
  {
    "_id": 515,
    "id": 583,
    "pid": 58,
    "city_code": "101230805",
    "city_name": "将乐县"
  },
  {
    "_id": 516,
    "id": 584,
    "pid": 58,
    "city_code": "101230804",
    "city_name": "泰宁县"
  },
  {
    "_id": 517,
    "id": 585,
    "pid": 58,
    "city_code": "101230806",
    "city_name": "建宁县"
  },
  {
    "_id": 518,
    "id": 590,
    "pid": 59,
    "city_code": "101230202",
    "city_name": "同安区"
  },
  {
    "_id": 519,
    "id": 594,
    "pid": 60,
    "city_code": "101230605",
    "city_name": "龙海市"
  },
  {
    "_id": 520,
    "id": 595,
    "pid": 60,
    "city_code": "101230609",
    "city_name": "云霄县"
  },
  {
    "_id": 521,
    "id": 596,
    "pid": 60,
    "city_code": "101230606",
    "city_name": "漳浦县"
  },
  {
    "_id": 522,
    "id": 597,
    "pid": 60,
    "city_code": "101230607",
    "city_name": "诏安县"
  },
  {
    "_id": 523,
    "id": 598,
    "pid": 60,
    "city_code": "101230602",
    "city_name": "长泰县"
  },
  {
    "_id": 524,
    "id": 599,
    "pid": 60,
    "city_code": "101230608",
    "city_name": "东山县"
  },
  {
    "_id": 525,
    "id": 600,
    "pid": 60,
    "city_code": "101230603",
    "city_name": "南靖县"
  },
  {
    "_id": 526,
    "id": 601,
    "pid": 60,
    "city_code": "101230604",
    "city_name": "平和县"
  },
  {
    "_id": 527,
    "id": 602,
    "pid": 60,
    "city_code": "101230610",
    "city_name": "华安县"
  },
  {
    "_id": 528,
    "id": 603,
    "pid": 61,
    "city_code": "101160102",
    "city_name": "皋兰县"
  },
  {
    "_id": 529,
    "id": 609,
    "pid": 61,
    "city_code": "101160103",
    "city_name": "永登县"
  },
  {
    "_id": 530,
    "id": 610,
    "pid": 61,
    "city_code": "101160104",
    "city_name": "榆中县"
  },
  {
    "_id": 531,
    "id": 611,
    "pid": 62,
    "city_code": "101161301",
    "city_name": "白银区"
  },
  {
    "_id": 532,
    "id": 612,
    "pid": 62,
    "city_code": "101161304",
    "city_name": "平川区"
  },
  {
    "_id": 533,
    "id": 613,
    "pid": 62,
    "city_code": "101161303",
    "city_name": "会宁县"
  },
  {
    "_id": 534,
    "id": 614,
    "pid": 62,
    "city_code": "101161305",
    "city_name": "景泰县"
  },
  {
    "_id": 535,
    "id": 615,
    "pid": 62,
    "city_code": "101161302",
    "city_name": "靖远县"
  },
  {
    "_id": 536,
    "id": 616,
    "pid": 63,
    "city_code": "101160205",
    "city_name": "临洮县"
  },
  {
    "_id": 537,
    "id": 617,
    "pid": 63,
    "city_code": "101160203",
    "city_name": "陇西县"
  },
  {
    "_id": 538,
    "id": 618,
    "pid": 63,
    "city_code": "101160202",
    "city_name": "通渭县"
  },
  {
    "_id": 539,
    "id": 619,
    "pid": 63,
    "city_code": "101160204",
    "city_name": "渭源县"
  },
  {
    "_id": 540,
    "id": 620,
    "pid": 63,
    "city_code": "101160206",
    "city_name": "漳县"
  },
  {
    "_id": 541,
    "id": 621,
    "pid": 63,
    "city_code": "101160207",
    "city_name": "岷县"
  },
  {
    "_id": 542,
    "id": 624,
    "pid": 64,
    "city_code": "101161201",
    "city_name": "合作市"
  },
  {
    "_id": 543,
    "id": 625,
    "pid": 64,
    "city_code": "101161202",
    "city_name": "临潭县"
  },
  {
    "_id": 544,
    "id": 626,
    "pid": 64,
    "city_code": "101161203",
    "city_name": "卓尼县"
  },
  {
    "_id": 545,
    "id": 627,
    "pid": 64,
    "city_code": "101161204",
    "city_name": "舟曲县"
  },
  {
    "_id": 546,
    "id": 628,
    "pid": 64,
    "city_code": "101161205",
    "city_name": "迭部县"
  },
  {
    "_id": 547,
    "id": 629,
    "pid": 64,
    "city_code": "101161206",
    "city_name": "玛曲县"
  },
  {
    "_id": 548,
    "id": 630,
    "pid": 64,
    "city_code": "101161207",
    "city_name": "碌曲县"
  },
  {
    "_id": 549,
    "id": 631,
    "pid": 64,
    "city_code": "101161208",
    "city_name": "夏河县"
  },
  {
    "_id": 550,
    "id": 634,
    "pid": 66,
    "city_code": "101160602",
    "city_name": "永昌县"
  },
  {
    "_id": 551,
    "id": 636,
    "pid": 67,
    "city_code": "101160807",
    "city_name": "玉门市"
  },
  {
    "_id": 552,
    "id": 637,
    "pid": 67,
    "city_code": "101160808",
    "city_name": "敦煌市"
  },
  {
    "_id": 553,
    "id": 638,
    "pid": 67,
    "city_code": "101160803",
    "city_name": "金塔县"
  },
  {
    "_id": 554,
    "id": 639,
    "pid": 67,
    "city_code": "101160805",
    "city_name": "瓜州县"
  },
  {
    "_id": 555,
    "id": 640,
    "pid": 67,
    "city_code": "101160806",
    "city_name": "肃北县"
  },
  {
    "_id": 556,
    "id": 641,
    "pid": 67,
    "city_code": "101160804",
    "city_name": "阿克塞"
  },
  {
    "_id": 557,
    "id": 642,
    "pid": 68,
    "city_code": "101161101",
    "city_name": "临夏市"
  },
  {
    "_id": 558,
    "id": 643,
    "pid": 68,
    "city_code": "101161101",
    "city_name": "临夏县"
  },
  {
    "_id": 559,
    "id": 644,
    "pid": 68,
    "city_code": "101161102",
    "city_name": "康乐县"
  },
  {
    "_id": 560,
    "id": 645,
    "pid": 68,
    "city_code": "101161103",
    "city_name": "永靖县"
  },
  {
    "_id": 561,
    "id": 646,
    "pid": 68,
    "city_code": "101161104",
    "city_name": "广河县"
  },
  {
    "_id": 562,
    "id": 647,
    "pid": 68,
    "city_code": "101161105",
    "city_name": "和政县"
  },
  {
    "_id": 563,
    "id": 648,
    "pid": 68,
    "city_code": "101161106",
    "city_name": "东乡族自治县"
  },
  {
    "_id": 564,
    "id": 649,
    "pid": 68,
    "city_code": "101161107",
    "city_name": "积石山"
  },
  {
    "_id": 565,
    "id": 650,
    "pid": 69,
    "city_code": "101161002",
    "city_name": "成县"
  },
  {
    "_id": 566,
    "id": 651,
    "pid": 69,
    "city_code": "101161008",
    "city_name": "徽县"
  },
  {
    "_id": 567,
    "id": 652,
    "pid": 69,
    "city_code": "101161005",
    "city_name": "康县"
  },
  {
    "_id": 568,
    "id": 653,
    "pid": 69,
    "city_code": "101161007",
    "city_name": "礼县"
  },
  {
    "_id": 569,
    "id": 654,
    "pid": 69,
    "city_code": "101161009",
    "city_name": "两当县"
  },
  {
    "_id": 570,
    "id": 655,
    "pid": 69,
    "city_code": "101161003",
    "city_name": "文县"
  },
  {
    "_id": 571,
    "id": 656,
    "pid": 69,
    "city_code": "101161006",
    "city_name": "西和县"
  },
  {
    "_id": 572,
    "id": 657,
    "pid": 69,
    "city_code": "101161004",
    "city_name": "宕昌县"
  },
  {
    "_id": 573,
    "id": 658,
    "pid": 69,
    "city_code": "101161001",
    "city_name": "武都区"
  },
  {
    "_id": 574,
    "id": 659,
    "pid": 70,
    "city_code": "101160304",
    "city_name": "崇信县"
  },
  {
    "_id": 575,
    "id": 660,
    "pid": 70,
    "city_code": "101160305",
    "city_name": "华亭县"
  },
  {
    "_id": 576,
    "id": 661,
    "pid": 70,
    "city_code": "101160307",
    "city_name": "静宁县"
  },
  {
    "_id": 577,
    "id": 662,
    "pid": 70,
    "city_code": "101160303",
    "city_name": "灵台县"
  },
  {
    "_id": 578,
    "id": 663,
    "pid": 70,
    "city_code": "101160308",
    "city_name": "崆峒区"
  },
  {
    "_id": 579,
    "id": 664,
    "pid": 70,
    "city_code": "101160306",
    "city_name": "庄浪县"
  },
  {
    "_id": 580,
    "id": 665,
    "pid": 70,
    "city_code": "101160302",
    "city_name": "泾川县"
  },
  {
    "_id": 581,
    "id": 666,
    "pid": 71,
    "city_code": "101160405",
    "city_name": "合水县"
  },
  {
    "_id": 582,
    "id": 667,
    "pid": 71,
    "city_code": "101160404",
    "city_name": "华池县"
  },
  {
    "_id": 583,
    "id": 668,
    "pid": 71,
    "city_code": "101160403",
    "city_name": "环县"
  },
  {
    "_id": 584,
    "id": 669,
    "pid": 71,
    "city_code": "101160407",
    "city_name": "宁县"
  },
  {
    "_id": 585,
    "id": 670,
    "pid": 71,
    "city_code": "101160409",
    "city_name": "庆城县"
  },
  {
    "_id": 586,
    "id": 671,
    "pid": 71,
    "city_code": "101160402",
    "city_name": "西峰区"
  },
  {
    "_id": 587,
    "id": 672,
    "pid": 71,
    "city_code": "101160408",
    "city_name": "镇原县"
  },
  {
    "_id": 588,
    "id": 673,
    "pid": 71,
    "city_code": "101160406",
    "city_name": "正宁县"
  },
  {
    "_id": 589,
    "id": 674,
    "pid": 72,
    "city_code": "101160905",
    "city_name": "甘谷县"
  },
  {
    "_id": 590,
    "id": 675,
    "pid": 72,
    "city_code": "101160904",
    "city_name": "秦安县"
  },
  {
    "_id": 591,
    "id": 676,
    "pid": 72,
    "city_code": "101160903",
    "city_name": "清水县"
  },
  {
    "_id": 592,
    "id": 678,
    "pid": 72,
    "city_code": "101160908",
    "city_name": "麦积区"
  },
  {
    "_id": 593,
    "id": 679,
    "pid": 72,
    "city_code": "101160906",
    "city_name": "武山县"
  },
  {
    "_id": 594,
    "id": 680,
    "pid": 72,
    "city_code": "101160907",
    "city_name": "张家川"
  },
  {
    "_id": 595,
    "id": 681,
    "pid": 73,
    "city_code": "101160503",
    "city_name": "古浪县"
  },
  {
    "_id": 596,
    "id": 682,
    "pid": 73,
    "city_code": "101160502",
    "city_name": "民勤县"
  },
  {
    "_id": 597,
    "id": 683,
    "pid": 73,
    "city_code": "101160505",
    "city_name": "天祝县"
  },
  {
    "_id": 598,
    "id": 685,
    "pid": 74,
    "city_code": "101160705",
    "city_name": "高台县"
  },
  {
    "_id": 599,
    "id": 686,
    "pid": 74,
    "city_code": "101160704",
    "city_name": "临泽县"
  },
  {
    "_id": 600,
    "id": 687,
    "pid": 74,
    "city_code": "101160703",
    "city_name": "民乐县"
  },
  {
    "_id": 601,
    "id": 688,
    "pid": 74,
    "city_code": "101160706",
    "city_name": "山丹县"
  },
  {
    "_id": 602,
    "id": 689,
    "pid": 74,
    "city_code": "101160702",
    "city_name": "肃南县"
  },
  {
    "_id": 603,
    "id": 691,
    "pid": 75,
    "city_code": "101280103",
    "city_name": "从化区"
  },
  {
    "_id": 604,
    "id": 692,
    "pid": 75,
    "city_code": "101280106",
    "city_name": "天河区"
  },
  {
    "_id": 605,
    "id": 699,
    "pid": 75,
    "city_code": "101280102",
    "city_name": "番禺区"
  },
  {
    "_id": 606,
    "id": 700,
    "pid": 75,
    "city_code": "101280105",
    "city_name": "花都区"
  },
  {
    "_id": 607,
    "id": 701,
    "pid": 75,
    "city_code": "101280104",
    "city_name": "增城区"
  },
  {
    "_id": 608,
    "id": 706,
    "pid": 76,
    "city_code": "101280604",
    "city_name": "南山区"
  },
  {
    "_id": 609,
    "id": 711,
    "pid": 77,
    "city_code": "101281503",
    "city_name": "潮安县"
  },
  {
    "_id": 610,
    "id": 712,
    "pid": 77,
    "city_code": "101281502",
    "city_name": "饶平县"
  },
  {
    "_id": 611,
    "id": 746,
    "pid": 79,
    "city_code": "101280803",
    "city_name": "南海区"
  },
  {
    "_id": 612,
    "id": 747,
    "pid": 79,
    "city_code": "101280801",
    "city_name": "顺德区"
  },
  {
    "_id": 613,
    "id": 748,
    "pid": 79,
    "city_code": "101280802",
    "city_name": "三水区"
  },
  {
    "_id": 614,
    "id": 749,
    "pid": 79,
    "city_code": "101280804",
    "city_name": "高明区"
  },
  {
    "_id": 615,
    "id": 750,
    "pid": 80,
    "city_code": "101281206",
    "city_name": "东源县"
  },
  {
    "_id": 616,
    "id": 751,
    "pid": 80,
    "city_code": "101281204",
    "city_name": "和平县"
  },
  {
    "_id": 617,
    "id": 753,
    "pid": 80,
    "city_code": "101281203",
    "city_name": "连平县"
  },
  {
    "_id": 618,
    "id": 754,
    "pid": 80,
    "city_code": "101281205",
    "city_name": "龙川县"
  },
  {
    "_id": 619,
    "id": 755,
    "pid": 80,
    "city_code": "101281202",
    "city_name": "紫金县"
  },
  {
    "_id": 620,
    "id": 756,
    "pid": 81,
    "city_code": "101280303",
    "city_name": "惠阳区"
  },
  {
    "_id": 621,
    "id": 759,
    "pid": 81,
    "city_code": "101280302",
    "city_name": "博罗县"
  },
  {
    "_id": 622,
    "id": 760,
    "pid": 81,
    "city_code": "101280304",
    "city_name": "惠东县"
  },
  {
    "_id": 623,
    "id": 761,
    "pid": 81,
    "city_code": "101280305",
    "city_name": "龙门县"
  },
  {
    "_id": 624,
    "id": 762,
    "pid": 82,
    "city_code": "101281109",
    "city_name": "江海区"
  },
  {
    "_id": 625,
    "id": 763,
    "pid": 82,
    "city_code": "101281107",
    "city_name": "蓬江区"
  },
  {
    "_id": 626,
    "id": 764,
    "pid": 82,
    "city_code": "101281104",
    "city_name": "新会区"
  },
  {
    "_id": 627,
    "id": 765,
    "pid": 82,
    "city_code": "101281106",
    "city_name": "台山市"
  },
  {
    "_id": 628,
    "id": 766,
    "pid": 82,
    "city_code": "101281103",
    "city_name": "开平市"
  },
  {
    "_id": 629,
    "id": 767,
    "pid": 82,
    "city_code": "101281108",
    "city_name": "鹤山市"
  },
  {
    "_id": 630,
    "id": 768,
    "pid": 82,
    "city_code": "101281105",
    "city_name": "恩平市"
  },
  {
    "_id": 631,
    "id": 770,
    "pid": 83,
    "city_code": "101281903",
    "city_name": "普宁市"
  },
  {
    "_id": 632,
    "id": 771,
    "pid": 83,
    "city_code": "101281905",
    "city_name": "揭东县"
  },
  {
    "_id": 633,
    "id": 772,
    "pid": 83,
    "city_code": "101281902",
    "city_name": "揭西县"
  },
  {
    "_id": 634,
    "id": 773,
    "pid": 83,
    "city_code": "101281904",
    "city_name": "惠来县"
  },
  {
    "_id": 635,
    "id": 775,
    "pid": 84,
    "city_code": "101282006",
    "city_name": "茂港区"
  },
  {
    "_id": 636,
    "id": 776,
    "pid": 84,
    "city_code": "101282002",
    "city_name": "高州市"
  },
  {
    "_id": 637,
    "id": 777,
    "pid": 84,
    "city_code": "101282003",
    "city_name": "化州市"
  },
  {
    "_id": 638,
    "id": 778,
    "pid": 84,
    "city_code": "101282005",
    "city_name": "信宜市"
  },
  {
    "_id": 639,
    "id": 779,
    "pid": 84,
    "city_code": "101282004",
    "city_name": "电白县"
  },
  {
    "_id": 640,
    "id": 780,
    "pid": 85,
    "city_code": "101280409",
    "city_name": "梅县"
  },
  {
    "_id": 641,
    "id": 782,
    "pid": 85,
    "city_code": "101280402",
    "city_name": "兴宁市"
  },
  {
    "_id": 642,
    "id": 783,
    "pid": 85,
    "city_code": "101280404",
    "city_name": "大埔县"
  },
  {
    "_id": 643,
    "id": 784,
    "pid": 85,
    "city_code": "101280406",
    "city_name": "丰顺县"
  },
  {
    "_id": 644,
    "id": 785,
    "pid": 85,
    "city_code": "101280408",
    "city_name": "五华县"
  },
  {
    "_id": 645,
    "id": 786,
    "pid": 85,
    "city_code": "101280407",
    "city_name": "平远县"
  },
  {
    "_id": 646,
    "id": 787,
    "pid": 85,
    "city_code": "101280403",
    "city_name": "蕉岭县"
  },
  {
    "_id": 647,
    "id": 789,
    "pid": 86,
    "city_code": "101281307",
    "city_name": "英德市"
  },
  {
    "_id": 648,
    "id": 790,
    "pid": 86,
    "city_code": "101281303",
    "city_name": "连州市"
  },
  {
    "_id": 649,
    "id": 791,
    "pid": 86,
    "city_code": "101281306",
    "city_name": "佛冈县"
  },
  {
    "_id": 650,
    "id": 792,
    "pid": 86,
    "city_code": "101281305",
    "city_name": "阳山县"
  },
  {
    "_id": 651,
    "id": 793,
    "pid": 86,
    "city_code": "101281308",
    "city_name": "清新县"
  },
  {
    "_id": 652,
    "id": 794,
    "pid": 86,
    "city_code": "101281304",
    "city_name": "连山县"
  },
  {
    "_id": 653,
    "id": 795,
    "pid": 86,
    "city_code": "101281302",
    "city_name": "连南县"
  },
  {
    "_id": 654,
    "id": 796,
    "pid": 87,
    "city_code": "101280504",
    "city_name": "南澳县"
  },
  {
    "_id": 655,
    "id": 797,
    "pid": 87,
    "city_code": "101280502",
    "city_name": "潮阳区"
  },
  {
    "_id": 656,
    "id": 798,
    "pid": 87,
    "city_code": "101280503",
    "city_name": "澄海区"
  },
  {
    "_id": 657,
    "id": 804,
    "pid": 88,
    "city_code": "101282103",
    "city_name": "陆丰市"
  },
  {
    "_id": 658,
    "id": 805,
    "pid": 88,
    "city_code": "101282102",
    "city_name": "海丰县"
  },
  {
    "_id": 659,
    "id": 806,
    "pid": 88,
    "city_code": "101282104",
    "city_name": "陆河县"
  },
  {
    "_id": 660,
    "id": 807,
    "pid": 89,
    "city_code": "101280209",
    "city_name": "曲江区"
  },
  {
    "_id": 661,
    "id": 808,
    "pid": 89,
    "city_code": "101280210",
    "city_name": "浈江区"
  },
  {
    "_id": 662,
    "id": 809,
    "pid": 89,
    "city_code": "101280211",
    "city_name": "武江区"
  },
  {
    "_id": 663,
    "id": 810,
    "pid": 89,
    "city_code": "101280209",
    "city_name": "曲江区"
  },
  {
    "_id": 664,
    "id": 811,
    "pid": 89,
    "city_code": "101280205",
    "city_name": "乐昌市"
  },
  {
    "_id": 665,
    "id": 812,
    "pid": 89,
    "city_code": "101280207",
    "city_name": "南雄市"
  },
  {
    "_id": 666,
    "id": 813,
    "pid": 89,
    "city_code": "101280203",
    "city_name": "始兴县"
  },
  {
    "_id": 667,
    "id": 814,
    "pid": 89,
    "city_code": "101280206",
    "city_name": "仁化县"
  },
  {
    "_id": 668,
    "id": 815,
    "pid": 89,
    "city_code": "101280204",
    "city_name": "翁源县"
  },
  {
    "_id": 669,
    "id": 816,
    "pid": 89,
    "city_code": "101280208",
    "city_name": "新丰县"
  },
  {
    "_id": 670,
    "id": 817,
    "pid": 89,
    "city_code": "101280202",
    "city_name": "乳源县"
  },
  {
    "_id": 671,
    "id": 819,
    "pid": 90,
    "city_code": "101281802",
    "city_name": "阳春市"
  },
  {
    "_id": 672,
    "id": 820,
    "pid": 90,
    "city_code": "101281804",
    "city_name": "阳西县"
  },
  {
    "_id": 673,
    "id": 821,
    "pid": 90,
    "city_code": "101281803",
    "city_name": "阳东县"
  },
  {
    "_id": 674,
    "id": 823,
    "pid": 91,
    "city_code": "101281402",
    "city_name": "罗定市"
  },
  {
    "_id": 675,
    "id": 824,
    "pid": 91,
    "city_code": "101281403",
    "city_name": "新兴县"
  },
  {
    "_id": 676,
    "id": 825,
    "pid": 91,
    "city_code": "101281404",
    "city_name": "郁南县"
  },
  {
    "_id": 677,
    "id": 826,
    "pid": 91,
    "city_code": "101281406",
    "city_name": "云安县"
  },
  {
    "_id": 678,
    "id": 827,
    "pid": 92,
    "city_code": "101281006",
    "city_name": "赤坎区"
  },
  {
    "_id": 679,
    "id": 828,
    "pid": 92,
    "city_code": "101281009",
    "city_name": "霞山区"
  },
  {
    "_id": 680,
    "id": 829,
    "pid": 92,
    "city_code": "101281008",
    "city_name": "坡头区"
  },
  {
    "_id": 681,
    "id": 830,
    "pid": 92,
    "city_code": "101281010",
    "city_name": "麻章区"
  },
  {
    "_id": 682,
    "id": 831,
    "pid": 92,
    "city_code": "101281005",
    "city_name": "廉江市"
  },
  {
    "_id": 683,
    "id": 832,
    "pid": 92,
    "city_code": "101281003",
    "city_name": "雷州市"
  },
  {
    "_id": 684,
    "id": 833,
    "pid": 92,
    "city_code": "101281002",
    "city_name": "吴川市"
  },
  {
    "_id": 685,
    "id": 834,
    "pid": 92,
    "city_code": "101281007",
    "city_name": "遂溪县"
  },
  {
    "_id": 686,
    "id": 835,
    "pid": 92,
    "city_code": "101281004",
    "city_name": "徐闻县"
  },
  {
    "_id": 687,
    "id": 837,
    "pid": 93,
    "city_code": "101280908",
    "city_name": "高要区"
  },
  {
    "_id": 688,
    "id": 838,
    "pid": 93,
    "city_code": "101280903",
    "city_name": "四会市"
  },
  {
    "_id": 689,
    "id": 839,
    "pid": 93,
    "city_code": "101280902",
    "city_name": "广宁县"
  },
  {
    "_id": 690,
    "id": 840,
    "pid": 93,
    "city_code": "101280906",
    "city_name": "怀集县"
  },
  {
    "_id": 691,
    "id": 841,
    "pid": 93,
    "city_code": "101280907",
    "city_name": "封开县"
  },
  {
    "_id": 692,
    "id": 842,
    "pid": 93,
    "city_code": "101280905",
    "city_name": "德庆县"
  },
  {
    "_id": 693,
    "id": 850,
    "pid": 95,
    "city_code": "101280702",
    "city_name": "斗门区"
  },
  {
    "_id": 694,
    "id": 851,
    "pid": 95,
    "city_code": "101280703",
    "city_name": "金湾区"
  },
  {
    "_id": 695,
    "id": 852,
    "pid": 96,
    "city_code": "101300103",
    "city_name": "邕宁区"
  },
  {
    "_id": 696,
    "id": 858,
    "pid": 96,
    "city_code": "101300108",
    "city_name": "武鸣县"
  },
  {
    "_id": 697,
    "id": 859,
    "pid": 96,
    "city_code": "101300105",
    "city_name": "隆安县"
  },
  {
    "_id": 698,
    "id": 860,
    "pid": 96,
    "city_code": "101300106",
    "city_name": "马山县"
  },
  {
    "_id": 699,
    "id": 861,
    "pid": 96,
    "city_code": "101300107",
    "city_name": "上林县"
  },
  {
    "_id": 700,
    "id": 862,
    "pid": 96,
    "city_code": "101300109",
    "city_name": "宾阳县"
  },
  {
    "_id": 701,
    "id": 863,
    "pid": 96,
    "city_code": "101300104",
    "city_name": "横县"
  },
  {
    "_id": 702,
    "id": 869,
    "pid": 97,
    "city_code": "101300510",
    "city_name": "阳朔县"
  },
  {
    "_id": 703,
    "id": 870,
    "pid": 97,
    "city_code": "101300505",
    "city_name": "临桂县"
  },
  {
    "_id": 704,
    "id": 871,
    "pid": 97,
    "city_code": "101300507",
    "city_name": "灵川县"
  },
  {
    "_id": 705,
    "id": 872,
    "pid": 97,
    "city_code": "101300508",
    "city_name": "全州县"
  },
  {
    "_id": 706,
    "id": 873,
    "pid": 97,
    "city_code": "101300512",
    "city_name": "平乐县"
  },
  {
    "_id": 707,
    "id": 874,
    "pid": 97,
    "city_code": "101300506",
    "city_name": "兴安县"
  },
  {
    "_id": 708,
    "id": 875,
    "pid": 97,
    "city_code": "101300509",
    "city_name": "灌阳县"
  },
  {
    "_id": 709,
    "id": 876,
    "pid": 97,
    "city_code": "101300513",
    "city_name": "荔浦县"
  },
  {
    "_id": 710,
    "id": 877,
    "pid": 97,
    "city_code": "101300514",
    "city_name": "资源县"
  },
  {
    "_id": 711,
    "id": 878,
    "pid": 97,
    "city_code": "101300504",
    "city_name": "永福县"
  },
  {
    "_id": 712,
    "id": 879,
    "pid": 97,
    "city_code": "101300503",
    "city_name": "龙胜县"
  },
  {
    "_id": 713,
    "id": 880,
    "pid": 97,
    "city_code": "101300511",
    "city_name": "恭城县"
  },
  {
    "_id": 714,
    "id": 882,
    "pid": 98,
    "city_code": "101301011",
    "city_name": "凌云县"
  },
  {
    "_id": 715,
    "id": 883,
    "pid": 98,
    "city_code": "101301007",
    "city_name": "平果县"
  },
  {
    "_id": 716,
    "id": 884,
    "pid": 98,
    "city_code": "101301009",
    "city_name": "西林县"
  },
  {
    "_id": 717,
    "id": 885,
    "pid": 98,
    "city_code": "101301010",
    "city_name": "乐业县"
  },
  {
    "_id": 718,
    "id": 886,
    "pid": 98,
    "city_code": "101301004",
    "city_name": "德保县"
  },
  {
    "_id": 719,
    "id": 887,
    "pid": 98,
    "city_code": "101301012",
    "city_name": "田林县"
  },
  {
    "_id": 720,
    "id": 888,
    "pid": 98,
    "city_code": "101301003",
    "city_name": "田阳县"
  },
  {
    "_id": 721,
    "id": 889,
    "pid": 98,
    "city_code": "101301005",
    "city_name": "靖西县"
  },
  {
    "_id": 722,
    "id": 890,
    "pid": 98,
    "city_code": "101301006",
    "city_name": "田东县"
  },
  {
    "_id": 723,
    "id": 891,
    "pid": 98,
    "city_code": "101301002",
    "city_name": "那坡县"
  },
  {
    "_id": 724,
    "id": 892,
    "pid": 98,
    "city_code": "101301008",
    "city_name": "隆林县"
  },
  {
    "_id": 725,
    "id": 896,
    "pid": 99,
    "city_code": "101301302",
    "city_name": "合浦县"
  },
  {
    "_id": 726,
    "id": 898,
    "pid": 100,
    "city_code": "101300204",
    "city_name": "凭祥市"
  },
  {
    "_id": 727,
    "id": 899,
    "pid": 100,
    "city_code": "101300207",
    "city_name": "宁明县"
  },
  {
    "_id": 728,
    "id": 900,
    "pid": 100,
    "city_code": "101300206",
    "city_name": "扶绥县"
  },
  {
    "_id": 729,
    "id": 901,
    "pid": 100,
    "city_code": "101300203",
    "city_name": "龙州县"
  },
  {
    "_id": 730,
    "id": 902,
    "pid": 100,
    "city_code": "101300205",
    "city_name": "大新县"
  },
  {
    "_id": 731,
    "id": 903,
    "pid": 100,
    "city_code": "101300202",
    "city_name": "天等县"
  },
  {
    "_id": 732,
    "id": 905,
    "pid": 101,
    "city_code": "101301405",
    "city_name": "防城区"
  },
  {
    "_id": 733,
    "id": 906,
    "pid": 101,
    "city_code": "101301403",
    "city_name": "东兴市"
  },
  {
    "_id": 734,
    "id": 907,
    "pid": 101,
    "city_code": "101301402",
    "city_name": "上思县"
  },
  {
    "_id": 735,
    "id": 911,
    "pid": 102,
    "city_code": "101300802",
    "city_name": "桂平市"
  },
  {
    "_id": 736,
    "id": 912,
    "pid": 102,
    "city_code": "101300803",
    "city_name": "平南县"
  },
  {
    "_id": 737,
    "id": 914,
    "pid": 103,
    "city_code": "101301207",
    "city_name": "宜州市"
  },
  {
    "_id": 738,
    "id": 915,
    "pid": 103,
    "city_code": "101301202",
    "city_name": "天峨县"
  },
  {
    "_id": 739,
    "id": 916,
    "pid": 103,
    "city_code": "101301208",
    "city_name": "凤山县"
  },
  {
    "_id": 740,
    "id": 917,
    "pid": 103,
    "city_code": "101301209",
    "city_name": "南丹县"
  },
  {
    "_id": 741,
    "id": 918,
    "pid": 103,
    "city_code": "101301203",
    "city_name": "东兰县"
  },
  {
    "_id": 742,
    "id": 919,
    "pid": 103,
    "city_code": "101301210",
    "city_name": "都安县"
  },
  {
    "_id": 743,
    "id": 920,
    "pid": 103,
    "city_code": "101301206",
    "city_name": "罗城县"
  },
  {
    "_id": 744,
    "id": 921,
    "pid": 103,
    "city_code": "101301204",
    "city_name": "巴马县"
  },
  {
    "_id": 745,
    "id": 922,
    "pid": 103,
    "city_code": "101301205",
    "city_name": "环江县"
  },
  {
    "_id": 746,
    "id": 923,
    "pid": 103,
    "city_code": "101301211",
    "city_name": "大化县"
  },
  {
    "_id": 747,
    "id": 925,
    "pid": 104,
    "city_code": "101300704",
    "city_name": "钟山县"
  },
  {
    "_id": 748,
    "id": 926,
    "pid": 104,
    "city_code": "101300702",
    "city_name": "昭平县"
  },
  {
    "_id": 749,
    "id": 927,
    "pid": 104,
    "city_code": "101300703",
    "city_name": "富川县"
  },
  {
    "_id": 750,
    "id": 929,
    "pid": 105,
    "city_code": "101300406",
    "city_name": "合山市"
  },
  {
    "_id": 751,
    "id": 930,
    "pid": 105,
    "city_code": "101300404",
    "city_name": "象州县"
  },
  {
    "_id": 752,
    "id": 931,
    "pid": 105,
    "city_code": "101300405",
    "city_name": "武宣县"
  },
  {
    "_id": 753,
    "id": 932,
    "pid": 105,
    "city_code": "101300402",
    "city_name": "忻城县"
  },
  {
    "_id": 754,
    "id": 933,
    "pid": 105,
    "city_code": "101300403",
    "city_name": "金秀县"
  },
  {
    "_id": 755,
    "id": 938,
    "pid": 106,
    "city_code": "101300305",
    "city_name": "柳江县"
  },
  {
    "_id": 756,
    "id": 939,
    "pid": 106,
    "city_code": "101300302",
    "city_name": "柳城县"
  },
  {
    "_id": 757,
    "id": 940,
    "pid": 106,
    "city_code": "101300304",
    "city_name": "鹿寨县"
  },
  {
    "_id": 758,
    "id": 941,
    "pid": 106,
    "city_code": "101300306",
    "city_name": "融安县"
  },
  {
    "_id": 759,
    "id": 942,
    "pid": 106,
    "city_code": "101300307",
    "city_name": "融水县"
  },
  {
    "_id": 760,
    "id": 943,
    "pid": 106,
    "city_code": "101300308",
    "city_name": "三江县"
  },
  {
    "_id": 761,
    "id": 946,
    "pid": 107,
    "city_code": "101301103",
    "city_name": "灵山县"
  },
  {
    "_id": 762,
    "id": 947,
    "pid": 107,
    "city_code": "101301102",
    "city_name": "浦北县"
  },
  {
    "_id": 763,
    "id": 950,
    "pid": 108,
    "city_code": "101300607",
    "city_name": "长洲区"
  },
  {
    "_id": 764,
    "id": 951,
    "pid": 108,
    "city_code": "101300606",
    "city_name": "岑溪市"
  },
  {
    "_id": 765,
    "id": 952,
    "pid": 108,
    "city_code": "101300604",
    "city_name": "苍梧县"
  },
  {
    "_id": 766,
    "id": 953,
    "pid": 108,
    "city_code": "101300602",
    "city_name": "藤县"
  },
  {
    "_id": 767,
    "id": 954,
    "pid": 108,
    "city_code": "101300605",
    "city_name": "蒙山县"
  },
  {
    "_id": 768,
    "id": 956,
    "pid": 109,
    "city_code": "101300903",
    "city_name": "北流市"
  },
  {
    "_id": 769,
    "id": 957,
    "pid": 109,
    "city_code": "101300904",
    "city_name": "容县"
  },
  {
    "_id": 770,
    "id": 958,
    "pid": 109,
    "city_code": "101300905",
    "city_name": "陆川县"
  },
  {
    "_id": 771,
    "id": 959,
    "pid": 109,
    "city_code": "101300902",
    "city_name": "博白县"
  },
  {
    "_id": 772,
    "id": 960,
    "pid": 109,
    "city_code": "101300906",
    "city_name": "兴业县"
  },
  {
    "_id": 773,
    "id": 961,
    "pid": 110,
    "city_code": "101260111",
    "city_name": "南明区"
  },
  {
    "_id": 774,
    "id": 962,
    "pid": 110,
    "city_code": "101260110",
    "city_name": "云岩区"
  },
  {
    "_id": 775,
    "id": 963,
    "pid": 110,
    "city_code": "101260103",
    "city_name": "花溪区"
  },
  {
    "_id": 776,
    "id": 964,
    "pid": 110,
    "city_code": "101260104",
    "city_name": "乌当区"
  },
  {
    "_id": 777,
    "id": 965,
    "pid": 110,
    "city_code": "101260102",
    "city_name": "白云区"
  },
  {
    "_id": 778,
    "id": 966,
    "pid": 110,
    "city_code": "101260109",
    "city_name": "小河区"
  },
  {
    "_id": 779,
    "id": 969,
    "pid": 110,
    "city_code": "101260108",
    "city_name": "清镇市"
  },
  {
    "_id": 780,
    "id": 970,
    "pid": 110,
    "city_code": "101260106",
    "city_name": "开阳县"
  },
  {
    "_id": 781,
    "id": 971,
    "pid": 110,
    "city_code": "101260107",
    "city_name": "修文县"
  },
  {
    "_id": 782,
    "id": 972,
    "pid": 110,
    "city_code": "101260105",
    "city_name": "息烽县"
  },
  {
    "_id": 783,
    "id": 974,
    "pid": 111,
    "city_code": "101260306",
    "city_name": "关岭县"
  },
  {
    "_id": 784,
    "id": 976,
    "pid": 111,
    "city_code": "101260305",
    "city_name": "紫云县"
  },
  {
    "_id": 785,
    "id": 977,
    "pid": 111,
    "city_code": "101260304",
    "city_name": "平坝县"
  },
  {
    "_id": 786,
    "id": 978,
    "pid": 111,
    "city_code": "101260302",
    "city_name": "普定县"
  },
  {
    "_id": 787,
    "id": 980,
    "pid": 112,
    "city_code": "101260705",
    "city_name": "大方县"
  },
  {
    "_id": 788,
    "id": 981,
    "pid": 112,
    "city_code": "101260708",
    "city_name": "黔西县"
  },
  {
    "_id": 789,
    "id": 982,
    "pid": 112,
    "city_code": "101260703",
    "city_name": "金沙县"
  },
  {
    "_id": 790,
    "id": 983,
    "pid": 112,
    "city_code": "101260707",
    "city_name": "织金县"
  },
  {
    "_id": 791,
    "id": 984,
    "pid": 112,
    "city_code": "101260706",
    "city_name": "纳雍县"
  },
  {
    "_id": 792,
    "id": 985,
    "pid": 112,
    "city_code": "101260702",
    "city_name": "赫章县"
  },
  {
    "_id": 793,
    "id": 986,
    "pid": 112,
    "city_code": "101260704",
    "city_name": "威宁县"
  },
  {
    "_id": 794,
    "id": 989,
    "pid": 113,
    "city_code": "101260801",
    "city_name": "水城县"
  },
  {
    "_id": 795,
    "id": 990,
    "pid": 113,
    "city_code": "101260804",
    "city_name": "盘县"
  },
  {
    "_id": 796,
    "id": 991,
    "pid": 114,
    "city_code": "101260501",
    "city_name": "凯里市"
  },
  {
    "_id": 797,
    "id": 992,
    "pid": 114,
    "city_code": "101260505",
    "city_name": "黄平县"
  },
  {
    "_id": 798,
    "id": 993,
    "pid": 114,
    "city_code": "101260503",
    "city_name": "施秉县"
  },
  {
    "_id": 799,
    "id": 994,
    "pid": 114,
    "city_code": "101260509",
    "city_name": "三穗县"
  },
  {
    "_id": 800,
    "id": 995,
    "pid": 114,
    "city_code": "101260504",
    "city_name": "镇远县"
  },
  {
    "_id": 801,
    "id": 996,
    "pid": 114,
    "city_code": "101260502",
    "city_name": "岑巩县"
  },
  {
    "_id": 802,
    "id": 997,
    "pid": 114,
    "city_code": "101260514",
    "city_name": "天柱县"
  },
  {
    "_id": 803,
    "id": 998,
    "pid": 114,
    "city_code": "101260515",
    "city_name": "锦屏县"
  },
  {
    "_id": 804,
    "id": 999,
    "pid": 114,
    "city_code": "101260511",
    "city_name": "剑河县"
  },
  {
    "_id": 805,
    "id": 1000,
    "pid": 114,
    "city_code": "101260510",
    "city_name": "台江县"
  },
  {
    "_id": 806,
    "id": 1001,
    "pid": 114,
    "city_code": "101260513",
    "city_name": "黎平县"
  },
  {
    "_id": 807,
    "id": 1002,
    "pid": 114,
    "city_code": "101260516",
    "city_name": "榕江县"
  },
  {
    "_id": 808,
    "id": 1003,
    "pid": 114,
    "city_code": "101260517",
    "city_name": "从江县"
  },
  {
    "_id": 809,
    "id": 1004,
    "pid": 114,
    "city_code": "101260512",
    "city_name": "雷山县"
  },
  {
    "_id": 810,
    "id": 1005,
    "pid": 114,
    "city_code": "101260507",
    "city_name": "麻江县"
  },
  {
    "_id": 811,
    "id": 1006,
    "pid": 114,
    "city_code": "101260508",
    "city_name": "丹寨县"
  },
  {
    "_id": 812,
    "id": 1007,
    "pid": 115,
    "city_code": "101260401",
    "city_name": "都匀市"
  },
  {
    "_id": 813,
    "id": 1008,
    "pid": 115,
    "city_code": "101260405",
    "city_name": "福泉市"
  },
  {
    "_id": 814,
    "id": 1009,
    "pid": 115,
    "city_code": "101260412",
    "city_name": "荔波县"
  },
  {
    "_id": 815,
    "id": 1010,
    "pid": 115,
    "city_code": "101260402",
    "city_name": "贵定县"
  },
  {
    "_id": 816,
    "id": 1011,
    "pid": 115,
    "city_code": "101260403",
    "city_name": "瓮安县"
  },
  {
    "_id": 817,
    "id": 1012,
    "pid": 115,
    "city_code": "101260410",
    "city_name": "独山县"
  },
  {
    "_id": 818,
    "id": 1013,
    "pid": 115,
    "city_code": "101260409",
    "city_name": "平塘县"
  },
  {
    "_id": 819,
    "id": 1014,
    "pid": 115,
    "city_code": "101260408",
    "city_name": "罗甸县"
  },
  {
    "_id": 820,
    "id": 1015,
    "pid": 115,
    "city_code": "101260404",
    "city_name": "长顺县"
  },
  {
    "_id": 821,
    "id": 1016,
    "pid": 115,
    "city_code": "101260407",
    "city_name": "龙里县"
  },
  {
    "_id": 822,
    "id": 1017,
    "pid": 115,
    "city_code": "101260406",
    "city_name": "惠水县"
  },
  {
    "_id": 823,
    "id": 1018,
    "pid": 115,
    "city_code": "101260411",
    "city_name": "三都县"
  },
  {
    "_id": 824,
    "id": 1019,
    "pid": 116,
    "city_code": "101260906",
    "city_name": "兴义市"
  },
  {
    "_id": 825,
    "id": 1020,
    "pid": 116,
    "city_code": "101260903",
    "city_name": "兴仁县"
  },
  {
    "_id": 826,
    "id": 1021,
    "pid": 116,
    "city_code": "101260909",
    "city_name": "普安县"
  },
  {
    "_id": 827,
    "id": 1022,
    "pid": 116,
    "city_code": "101260902",
    "city_name": "晴隆县"
  },
  {
    "_id": 828,
    "id": 1023,
    "pid": 116,
    "city_code": "101260904",
    "city_name": "贞丰县"
  },
  {
    "_id": 829,
    "id": 1024,
    "pid": 116,
    "city_code": "101260905",
    "city_name": "望谟县"
  },
  {
    "_id": 830,
    "id": 1025,
    "pid": 116,
    "city_code": "101260908",
    "city_name": "册亨县"
  },
  {
    "_id": 831,
    "id": 1026,
    "pid": 116,
    "city_code": "101260907",
    "city_name": "安龙县"
  },
  {
    "_id": 832,
    "id": 1027,
    "pid": 117,
    "city_code": "101260601",
    "city_name": "铜仁市"
  },
  {
    "_id": 833,
    "id": 1028,
    "pid": 117,
    "city_code": "101260602",
    "city_name": "江口县"
  },
  {
    "_id": 834,
    "id": 1029,
    "pid": 117,
    "city_code": "101260608",
    "city_name": "石阡县"
  },
  {
    "_id": 835,
    "id": 1030,
    "pid": 117,
    "city_code": "101260605",
    "city_name": "思南县"
  },
  {
    "_id": 836,
    "id": 1031,
    "pid": 117,
    "city_code": "101260610",
    "city_name": "德江县"
  },
  {
    "_id": 837,
    "id": 1032,
    "pid": 117,
    "city_code": "101260603",
    "city_name": "玉屏县"
  },
  {
    "_id": 838,
    "id": 1033,
    "pid": 117,
    "city_code": "101260607",
    "city_name": "印江县"
  },
  {
    "_id": 839,
    "id": 1034,
    "pid": 117,
    "city_code": "101260609",
    "city_name": "沿河县"
  },
  {
    "_id": 840,
    "id": 1035,
    "pid": 117,
    "city_code": "101260611",
    "city_name": "松桃县"
  },
  {
    "_id": 841,
    "id": 1037,
    "pid": 118,
    "city_code": "101260215",
    "city_name": "红花岗区"
  },
  {
    "_id": 842,
    "id": 1038,
    "pid": 118,
    "city_code": "101260212",
    "city_name": "务川县"
  },
  {
    "_id": 843,
    "id": 1039,
    "pid": 118,
    "city_code": "101260210",
    "city_name": "道真县"
  },
  {
    "_id": 844,
    "id": 1040,
    "pid": 118,
    "city_code": "101260214",
    "city_name": "汇川区"
  },
  {
    "_id": 845,
    "id": 1041,
    "pid": 118,
    "city_code": "101260208",
    "city_name": "赤水市"
  },
  {
    "_id": 846,
    "id": 1042,
    "pid": 118,
    "city_code": "101260203",
    "city_name": "仁怀市"
  },
  {
    "_id": 847,
    "id": 1043,
    "pid": 118,
    "city_code": "101260202",
    "city_name": "遵义县"
  },
  {
    "_id": 848,
    "id": 1044,
    "pid": 118,
    "city_code": "101260207",
    "city_name": "桐梓县"
  },
  {
    "_id": 849,
    "id": 1045,
    "pid": 118,
    "city_code": "101260204",
    "city_name": "绥阳县"
  },
  {
    "_id": 850,
    "id": 1046,
    "pid": 118,
    "city_code": "101260211",
    "city_name": "正安县"
  },
  {
    "_id": 851,
    "id": 1047,
    "pid": 118,
    "city_code": "101260206",
    "city_name": "凤冈县"
  },
  {
    "_id": 852,
    "id": 1048,
    "pid": 118,
    "city_code": "101260205",
    "city_name": "湄潭县"
  },
  {
    "_id": 853,
    "id": 1049,
    "pid": 118,
    "city_code": "101260213",
    "city_name": "余庆县"
  },
  {
    "_id": 854,
    "id": 1050,
    "pid": 118,
    "city_code": "101260209",
    "city_name": "习水县"
  },
  {
    "_id": 855,
    "id": 1055,
    "pid": 119,
    "city_code": "101310102",
    "city_name": "琼山区"
  },
  {
    "_id": 856,
    "id": 1082,
    "pid": 137,
    "city_code": "101090102",
    "city_name": "井陉矿区"
  },
  {
    "_id": 857,
    "id": 1084,
    "pid": 137,
    "city_code": "101090114",
    "city_name": "辛集市"
  },
  {
    "_id": 858,
    "id": 1085,
    "pid": 137,
    "city_code": "101090115",
    "city_name": "藁城市"
  },
  {
    "_id": 859,
    "id": 1086,
    "pid": 137,
    "city_code": "101090116",
    "city_name": "晋州市"
  },
  {
    "_id": 860,
    "id": 1087,
    "pid": 137,
    "city_code": "101090117",
    "city_name": "新乐市"
  },
  {
    "_id": 861,
    "id": 1088,
    "pid": 137,
    "city_code": "101090118",
    "city_name": "鹿泉区"
  },
  {
    "_id": 862,
    "id": 1089,
    "pid": 137,
    "city_code": "101090102",
    "city_name": "井陉县"
  },
  {
    "_id": 863,
    "id": 1090,
    "pid": 137,
    "city_code": "101090103",
    "city_name": "正定县"
  },
  {
    "_id": 864,
    "id": 1091,
    "pid": 137,
    "city_code": "101090104",
    "city_name": "栾城区"
  },
  {
    "_id": 865,
    "id": 1092,
    "pid": 137,
    "city_code": "101090105",
    "city_name": "行唐县"
  },
  {
    "_id": 866,
    "id": 1093,
    "pid": 137,
    "city_code": "101090106",
    "city_name": "灵寿县"
  },
  {
    "_id": 867,
    "id": 1094,
    "pid": 137,
    "city_code": "101090107",
    "city_name": "高邑县"
  },
  {
    "_id": 868,
    "id": 1095,
    "pid": 137,
    "city_code": "101090108",
    "city_name": "深泽县"
  },
  {
    "_id": 869,
    "id": 1096,
    "pid": 137,
    "city_code": "101090109",
    "city_name": "赞皇县"
  },
  {
    "_id": 870,
    "id": 1097,
    "pid": 137,
    "city_code": "101090110",
    "city_name": "无极县"
  },
  {
    "_id": 871,
    "id": 1098,
    "pid": 137,
    "city_code": "101090111",
    "city_name": "平山县"
  },
  {
    "_id": 872,
    "id": 1099,
    "pid": 137,
    "city_code": "101090112",
    "city_name": "元氏县"
  },
  {
    "_id": 873,
    "id": 1100,
    "pid": 137,
    "city_code": "101090113",
    "city_name": "赵县"
  },
  {
    "_id": 874,
    "id": 1104,
    "pid": 138,
    "city_code": "101090218",
    "city_name": "涿州市"
  },
  {
    "_id": 875,
    "id": 1105,
    "pid": 138,
    "city_code": "101090219",
    "city_name": "定州市"
  },
  {
    "_id": 876,
    "id": 1106,
    "pid": 138,
    "city_code": "101090220",
    "city_name": "安国市"
  },
  {
    "_id": 877,
    "id": 1107,
    "pid": 138,
    "city_code": "101090221",
    "city_name": "高碑店市"
  },
  {
    "_id": 878,
    "id": 1108,
    "pid": 138,
    "city_code": "101090202",
    "city_name": "满城县"
  },
  {
    "_id": 879,
    "id": 1109,
    "pid": 138,
    "city_code": "101090224",
    "city_name": "清苑县"
  },
  {
    "_id": 880,
    "id": 1110,
    "pid": 138,
    "city_code": "101090213",
    "city_name": "涞水县"
  },
  {
    "_id": 881,
    "id": 1111,
    "pid": 138,
    "city_code": "101090203",
    "city_name": "阜平县"
  },
  {
    "_id": 882,
    "id": 1112,
    "pid": 138,
    "city_code": "101090204",
    "city_name": "徐水县"
  },
  {
    "_id": 883,
    "id": 1113,
    "pid": 138,
    "city_code": "101090223",
    "city_name": "定兴县"
  },
  {
    "_id": 884,
    "id": 1114,
    "pid": 138,
    "city_code": "101090205",
    "city_name": "唐县"
  },
  {
    "_id": 885,
    "id": 1115,
    "pid": 138,
    "city_code": "101090206",
    "city_name": "高阳县"
  },
  {
    "_id": 886,
    "id": 1116,
    "pid": 138,
    "city_code": "101090207",
    "city_name": "容城县"
  },
  {
    "_id": 887,
    "id": 1117,
    "pid": 138,
    "city_code": "101090209",
    "city_name": "涞源县"
  },
  {
    "_id": 888,
    "id": 1118,
    "pid": 138,
    "city_code": "101090210",
    "city_name": "望都县"
  },
  {
    "_id": 889,
    "id": 1119,
    "pid": 138,
    "city_code": "101090211",
    "city_name": "安新县"
  },
  {
    "_id": 890,
    "id": 1120,
    "pid": 138,
    "city_code": "101090212",
    "city_name": "易县"
  },
  {
    "_id": 891,
    "id": 1121,
    "pid": 138,
    "city_code": "101090214",
    "city_name": "曲阳县"
  },
  {
    "_id": 892,
    "id": 1122,
    "pid": 138,
    "city_code": "101090215",
    "city_name": "蠡县"
  },
  {
    "_id": 893,
    "id": 1123,
    "pid": 138,
    "city_code": "101090216",
    "city_name": "顺平县"
  },
  {
    "_id": 894,
    "id": 1124,
    "pid": 138,
    "city_code": "101090225",
    "city_name": "博野县"
  },
  {
    "_id": 895,
    "id": 1125,
    "pid": 138,
    "city_code": "101090217",
    "city_name": "雄县"
  },
  {
    "_id": 896,
    "id": 1128,
    "pid": 139,
    "city_code": "101090711",
    "city_name": "泊头市"
  },
  {
    "_id": 897,
    "id": 1129,
    "pid": 139,
    "city_code": "101090712",
    "city_name": "任丘市"
  },
  {
    "_id": 898,
    "id": 1130,
    "pid": 139,
    "city_code": "101090713",
    "city_name": "黄骅市"
  },
  {
    "_id": 899,
    "id": 1131,
    "pid": 139,
    "city_code": "101090714",
    "city_name": "河间市"
  },
  {
    "_id": 900,
    "id": 1132,
    "pid": 139,
    "city_code": "101090716",
    "city_name": "沧县"
  },
  {
    "_id": 901,
    "id": 1133,
    "pid": 139,
    "city_code": "101090702",
    "city_name": "青县"
  },
  {
    "_id": 902,
    "id": 1134,
    "pid": 139,
    "city_code": "101090703",
    "city_name": "东光县"
  },
  {
    "_id": 903,
    "id": 1135,
    "pid": 139,
    "city_code": "101090704",
    "city_name": "海兴县"
  },
  {
    "_id": 904,
    "id": 1136,
    "pid": 139,
    "city_code": "101090705",
    "city_name": "盐山县"
  },
  {
    "_id": 905,
    "id": 1137,
    "pid": 139,
    "city_code": "101090706",
    "city_name": "肃宁县"
  },
  {
    "_id": 906,
    "id": 1138,
    "pid": 139,
    "city_code": "101090707",
    "city_name": "南皮县"
  },
  {
    "_id": 907,
    "id": 1139,
    "pid": 139,
    "city_code": "101090708",
    "city_name": "吴桥县"
  },
  {
    "_id": 908,
    "id": 1140,
    "pid": 139,
    "city_code": "101090709",
    "city_name": "献县"
  },
  {
    "_id": 909,
    "id": 1141,
    "pid": 139,
    "city_code": "101090710",
    "city_name": "孟村县"
  },
  {
    "_id": 910,
    "id": 1145,
    "pid": 140,
    "city_code": "101090403",
    "city_name": "承德县"
  },
  {
    "_id": 911,
    "id": 1146,
    "pid": 140,
    "city_code": "101090404",
    "city_name": "兴隆县"
  },
  {
    "_id": 912,
    "id": 1147,
    "pid": 140,
    "city_code": "101090405",
    "city_name": "平泉县"
  },
  {
    "_id": 913,
    "id": 1148,
    "pid": 140,
    "city_code": "101090406",
    "city_name": "滦平县"
  },
  {
    "_id": 914,
    "id": 1149,
    "pid": 140,
    "city_code": "101090407",
    "city_name": "隆化县"
  },
  {
    "_id": 915,
    "id": 1150,
    "pid": 140,
    "city_code": "101090408",
    "city_name": "丰宁县"
  },
  {
    "_id": 916,
    "id": 1151,
    "pid": 140,
    "city_code": "101090409",
    "city_name": "宽城县"
  },
  {
    "_id": 917,
    "id": 1152,
    "pid": 140,
    "city_code": "101090410",
    "city_name": "围场县"
  },
  {
    "_id": 918,
    "id": 1156,
    "pid": 141,
    "city_code": "101091002",
    "city_name": "峰峰矿区"
  },
  {
    "_id": 919,
    "id": 1157,
    "pid": 141,
    "city_code": "101091016",
    "city_name": "武安市"
  },
  {
    "_id": 920,
    "id": 1158,
    "pid": 141,
    "city_code": "101091001",
    "city_name": "邯郸县"
  },
  {
    "_id": 921,
    "id": 1159,
    "pid": 141,
    "city_code": "101091003",
    "city_name": "临漳县"
  },
  {
    "_id": 922,
    "id": 1160,
    "pid": 141,
    "city_code": "101091004",
    "city_name": "成安县"
  },
  {
    "_id": 923,
    "id": 1161,
    "pid": 141,
    "city_code": "101091005",
    "city_name": "大名县"
  },
  {
    "_id": 924,
    "id": 1162,
    "pid": 141,
    "city_code": "101091006",
    "city_name": "涉县"
  },
  {
    "_id": 925,
    "id": 1163,
    "pid": 141,
    "city_code": "101091007",
    "city_name": "磁县"
  },
  {
    "_id": 926,
    "id": 1164,
    "pid": 141,
    "city_code": "101091008",
    "city_name": "肥乡县"
  },
  {
    "_id": 927,
    "id": 1165,
    "pid": 141,
    "city_code": "101091009",
    "city_name": "永年县"
  },
  {
    "_id": 928,
    "id": 1166,
    "pid": 141,
    "city_code": "101091010",
    "city_name": "邱县"
  },
  {
    "_id": 929,
    "id": 1167,
    "pid": 141,
    "city_code": "101091011",
    "city_name": "鸡泽县"
  },
  {
    "_id": 930,
    "id": 1168,
    "pid": 141,
    "city_code": "101091012",
    "city_name": "广平县"
  },
  {
    "_id": 931,
    "id": 1169,
    "pid": 141,
    "city_code": "101091013",
    "city_name": "馆陶县"
  },
  {
    "_id": 932,
    "id": 1170,
    "pid": 141,
    "city_code": "101091014",
    "city_name": "魏县"
  },
  {
    "_id": 933,
    "id": 1171,
    "pid": 141,
    "city_code": "101091015",
    "city_name": "曲周县"
  },
  {
    "_id": 934,
    "id": 1173,
    "pid": 142,
    "city_code": "101090810",
    "city_name": "冀州市"
  },
  {
    "_id": 935,
    "id": 1174,
    "pid": 142,
    "city_code": "101090811",
    "city_name": "深州市"
  },
  {
    "_id": 936,
    "id": 1175,
    "pid": 142,
    "city_code": "101090802",
    "city_name": "枣强县"
  },
  {
    "_id": 937,
    "id": 1176,
    "pid": 142,
    "city_code": "101090803",
    "city_name": "武邑县"
  },
  {
    "_id": 938,
    "id": 1177,
    "pid": 142,
    "city_code": "101090804",
    "city_name": "武强县"
  },
  {
    "_id": 939,
    "id": 1178,
    "pid": 142,
    "city_code": "101090805",
    "city_name": "饶阳县"
  },
  {
    "_id": 940,
    "id": 1179,
    "pid": 142,
    "city_code": "101090806",
    "city_name": "安平县"
  },
  {
    "_id": 941,
    "id": 1180,
    "pid": 142,
    "city_code": "101090807",
    "city_name": "故城县"
  },
  {
    "_id": 942,
    "id": 1181,
    "pid": 142,
    "city_code": "101090808",
    "city_name": "景县"
  },
  {
    "_id": 943,
    "id": 1182,
    "pid": 142,
    "city_code": "101090809",
    "city_name": "阜城县"
  },
  {
    "_id": 944,
    "id": 1185,
    "pid": 143,
    "city_code": "101090608",
    "city_name": "霸州市"
  },
  {
    "_id": 945,
    "id": 1186,
    "pid": 143,
    "city_code": "101090609",
    "city_name": "三河市"
  },
  {
    "_id": 946,
    "id": 1187,
    "pid": 143,
    "city_code": "101090602",
    "city_name": "固安县"
  },
  {
    "_id": 947,
    "id": 1188,
    "pid": 143,
    "city_code": "101090603",
    "city_name": "永清县"
  },
  {
    "_id": 948,
    "id": 1189,
    "pid": 143,
    "city_code": "101090604",
    "city_name": "香河县"
  },
  {
    "_id": 949,
    "id": 1190,
    "pid": 143,
    "city_code": "101090605",
    "city_name": "大城县"
  },
  {
    "_id": 950,
    "id": 1191,
    "pid": 143,
    "city_code": "101090606",
    "city_name": "文安县"
  },
  {
    "_id": 951,
    "id": 1192,
    "pid": 143,
    "city_code": "101090607",
    "city_name": "大厂县"
  },
  {
    "_id": 952,
    "id": 1195,
    "pid": 144,
    "city_code": "101091106",
    "city_name": "北戴河区"
  },
  {
    "_id": 953,
    "id": 1196,
    "pid": 144,
    "city_code": "101091103",
    "city_name": "昌黎县"
  },
  {
    "_id": 954,
    "id": 1197,
    "pid": 144,
    "city_code": "101091104",
    "city_name": "抚宁县"
  },
  {
    "_id": 955,
    "id": 1198,
    "pid": 144,
    "city_code": "101091105",
    "city_name": "卢龙县"
  },
  {
    "_id": 956,
    "id": 1199,
    "pid": 144,
    "city_code": "101091102",
    "city_name": "青龙县"
  },
  {
    "_id": 957,
    "id": 1204,
    "pid": 145,
    "city_code": "101090502",
    "city_name": "丰南区"
  },
  {
    "_id": 958,
    "id": 1205,
    "pid": 145,
    "city_code": "101090503",
    "city_name": "丰润区"
  },
  {
    "_id": 959,
    "id": 1206,
    "pid": 145,
    "city_code": "101090510",
    "city_name": "遵化市"
  },
  {
    "_id": 960,
    "id": 1207,
    "pid": 145,
    "city_code": "101090511",
    "city_name": "迁安市"
  },
  {
    "_id": 961,
    "id": 1208,
    "pid": 145,
    "city_code": "101090504",
    "city_name": "滦县"
  },
  {
    "_id": 962,
    "id": 1209,
    "pid": 145,
    "city_code": "101090505",
    "city_name": "滦南县"
  },
  {
    "_id": 963,
    "id": 1210,
    "pid": 145,
    "city_code": "101090506",
    "city_name": "乐亭县"
  },
  {
    "_id": 964,
    "id": 1211,
    "pid": 145,
    "city_code": "101090507",
    "city_name": "迁西县"
  },
  {
    "_id": 965,
    "id": 1212,
    "pid": 145,
    "city_code": "101090508",
    "city_name": "玉田县"
  },
  {
    "_id": 966,
    "id": 1213,
    "pid": 145,
    "city_code": "101090509",
    "city_name": "唐海县"
  },
  {
    "_id": 967,
    "id": 1216,
    "pid": 146,
    "city_code": "101090916",
    "city_name": "南宫市"
  },
  {
    "_id": 968,
    "id": 1217,
    "pid": 146,
    "city_code": "101090917",
    "city_name": "沙河市"
  },
  {
    "_id": 969,
    "id": 1218,
    "pid": 146,
    "city_code": "101090901",
    "city_name": "邢台县"
  },
  {
    "_id": 970,
    "id": 1219,
    "pid": 146,
    "city_code": "101090902",
    "city_name": "临城县"
  },
  {
    "_id": 971,
    "id": 1220,
    "pid": 146,
    "city_code": "101090904",
    "city_name": "内丘县"
  },
  {
    "_id": 972,
    "id": 1221,
    "pid": 146,
    "city_code": "101090905",
    "city_name": "柏乡县"
  },
  {
    "_id": 973,
    "id": 1222,
    "pid": 146,
    "city_code": "101090906",
    "city_name": "隆尧县"
  },
  {
    "_id": 974,
    "id": 1223,
    "pid": 146,
    "city_code": "101090918",
    "city_name": "任县"
  },
  {
    "_id": 975,
    "id": 1224,
    "pid": 146,
    "city_code": "101090907",
    "city_name": "南和县"
  },
  {
    "_id": 976,
    "id": 1225,
    "pid": 146,
    "city_code": "101090908",
    "city_name": "宁晋县"
  },
  {
    "_id": 977,
    "id": 1226,
    "pid": 146,
    "city_code": "101090909",
    "city_name": "巨鹿县"
  },
  {
    "_id": 978,
    "id": 1227,
    "pid": 146,
    "city_code": "101090910",
    "city_name": "新河县"
  },
  {
    "_id": 979,
    "id": 1228,
    "pid": 146,
    "city_code": "101090911",
    "city_name": "广宗县"
  },
  {
    "_id": 980,
    "id": 1229,
    "pid": 146,
    "city_code": "101090912",
    "city_name": "平乡县"
  },
  {
    "_id": 981,
    "id": 1230,
    "pid": 146,
    "city_code": "101090913",
    "city_name": "威县"
  },
  {
    "_id": 982,
    "id": 1231,
    "pid": 146,
    "city_code": "101090914",
    "city_name": "清河县"
  },
  {
    "_id": 983,
    "id": 1232,
    "pid": 146,
    "city_code": "101090915",
    "city_name": "临西县"
  },
  {
    "_id": 984,
    "id": 1235,
    "pid": 147,
    "city_code": "101090302",
    "city_name": "宣化区"
  },
  {
    "_id": 985,
    "id": 1237,
    "pid": 147,
    "city_code": "101090302",
    "city_name": "宣化县"
  },
  {
    "_id": 986,
    "id": 1238,
    "pid": 147,
    "city_code": "101090303",
    "city_name": "张北县"
  },
  {
    "_id": 987,
    "id": 1239,
    "pid": 147,
    "city_code": "101090304",
    "city_name": "康保县"
  },
  {
    "_id": 988,
    "id": 1240,
    "pid": 147,
    "city_code": "101090305",
    "city_name": "沽源县"
  },
  {
    "_id": 989,
    "id": 1241,
    "pid": 147,
    "city_code": "101090306",
    "city_name": "尚义县"
  },
  {
    "_id": 990,
    "id": 1242,
    "pid": 147,
    "city_code": "101090307",
    "city_name": "蔚县"
  },
  {
    "_id": 991,
    "id": 1243,
    "pid": 147,
    "city_code": "101090308",
    "city_name": "阳原县"
  },
  {
    "_id": 992,
    "id": 1244,
    "pid": 147,
    "city_code": "101090309",
    "city_name": "怀安县"
  },
  {
    "_id": 993,
    "id": 1245,
    "pid": 147,
    "city_code": "101090310",
    "city_name": "万全县"
  },
  {
    "_id": 994,
    "id": 1246,
    "pid": 147,
    "city_code": "101090311",
    "city_name": "怀来县"
  },
  {
    "_id": 995,
    "id": 1247,
    "pid": 147,
    "city_code": "101090312",
    "city_name": "涿鹿县"
  },
  {
    "_id": 996,
    "id": 1248,
    "pid": 147,
    "city_code": "101090313",
    "city_name": "赤城县"
  },
  {
    "_id": 997,
    "id": 1249,
    "pid": 147,
    "city_code": "101090314",
    "city_name": "崇礼县"
  },
  {
    "_id": 998,
    "id": 1255,
    "pid": 148,
    "city_code": "101180108",
    "city_name": "上街区"
  },
  {
    "_id": 999,
    "id": 1261,
    "pid": 148,
    "city_code": "101180102",
    "city_name": "巩义市"
  },
  {
    "_id": 1000,
    "id": 1262,
    "pid": 148,
    "city_code": "101180103",
    "city_name": "荥阳市"
  },
  {
    "_id": 1001,
    "id": 1263,
    "pid": 148,
    "city_code": "101180105",
    "city_name": "新密市"
  },
  {
    "_id": 1002,
    "id": 1264,
    "pid": 148,
    "city_code": "101180106",
    "city_name": "新郑市"
  },
  {
    "_id": 1003,
    "id": 1265,
    "pid": 148,
    "city_code": "101180104",
    "city_name": "登封市"
  },
  {
    "_id": 1004,
    "id": 1266,
    "pid": 148,
    "city_code": "101180107",
    "city_name": "中牟县"
  },
  {
    "_id": 1005,
    "id": 1272,
    "pid": 149,
    "city_code": "101180911",
    "city_name": "吉利区"
  },
  {
    "_id": 1006,
    "id": 1273,
    "pid": 149,
    "city_code": "101180908",
    "city_name": "偃师市"
  },
  {
    "_id": 1007,
    "id": 1274,
    "pid": 149,
    "city_code": "101180903",
    "city_name": "孟津县"
  },
  {
    "_id": 1008,
    "id": 1275,
    "pid": 149,
    "city_code": "101180902",
    "city_name": "新安县"
  },
  {
    "_id": 1009,
    "id": 1276,
    "pid": 149,
    "city_code": "101180909",
    "city_name": "栾川县"
  },
  {
    "_id": 1010,
    "id": 1277,
    "pid": 149,
    "city_code": "101180907",
    "city_name": "嵩县"
  },
  {
    "_id": 1011,
    "id": 1278,
    "pid": 149,
    "city_code": "101180910",
    "city_name": "汝阳县"
  },
  {
    "_id": 1012,
    "id": 1279,
    "pid": 149,
    "city_code": "101180904",
    "city_name": "宜阳县"
  },
  {
    "_id": 1013,
    "id": 1280,
    "pid": 149,
    "city_code": "101180905",
    "city_name": "洛宁县"
  },
  {
    "_id": 1014,
    "id": 1281,
    "pid": 149,
    "city_code": "101180906",
    "city_name": "伊川县"
  },
  {
    "_id": 1015,
    "id": 1287,
    "pid": 150,
    "city_code": "101180802",
    "city_name": "杞县"
  },
  {
    "_id": 1016,
    "id": 1288,
    "pid": 150,
    "city_code": "101180804",
    "city_name": "通许县"
  },
  {
    "_id": 1017,
    "id": 1289,
    "pid": 150,
    "city_code": "101180803",
    "city_name": "尉氏县"
  },
  {
    "_id": 1018,
    "id": 1290,
    "pid": 150,
    "city_code": "101180801",
    "city_name": "开封县"
  },
  {
    "_id": 1019,
    "id": 1291,
    "pid": 150,
    "city_code": "101180805",
    "city_name": "兰考县"
  },
  {
    "_id": 1020,
    "id": 1296,
    "pid": 151,
    "city_code": "101180205",
    "city_name": "林州市"
  },
  {
    "_id": 1021,
    "id": 1297,
    "pid": 151,
    "city_code": "101180201",
    "city_name": "安阳县"
  },
  {
    "_id": 1022,
    "id": 1298,
    "pid": 151,
    "city_code": "101180202",
    "city_name": "汤阴县"
  },
  {
    "_id": 1023,
    "id": 1299,
    "pid": 151,
    "city_code": "101180203",
    "city_name": "滑县"
  },
  {
    "_id": 1024,
    "id": 1300,
    "pid": 151,
    "city_code": "101180204",
    "city_name": "内黄县"
  },
  {
    "_id": 1025,
    "id": 1304,
    "pid": 152,
    "city_code": "101181202",
    "city_name": "浚县"
  },
  {
    "_id": 1026,
    "id": 1305,
    "pid": 152,
    "city_code": "101181203",
    "city_name": "淇县"
  },
  {
    "_id": 1027,
    "id": 1306,
    "pid": 153,
    "city_code": "101181801",
    "city_name": "济源市"
  },
  {
    "_id": 1028,
    "id": 1311,
    "pid": 154,
    "city_code": "101181104",
    "city_name": "沁阳市"
  },
  {
    "_id": 1029,
    "id": 1312,
    "pid": 154,
    "city_code": "101181108",
    "city_name": "孟州市"
  },
  {
    "_id": 1030,
    "id": 1313,
    "pid": 154,
    "city_code": "101181102",
    "city_name": "修武县"
  },
  {
    "_id": 1031,
    "id": 1314,
    "pid": 154,
    "city_code": "101181106",
    "city_name": "博爱县"
  },
  {
    "_id": 1032,
    "id": 1315,
    "pid": 154,
    "city_code": "101181103",
    "city_name": "武陟县"
  },
  {
    "_id": 1033,
    "id": 1316,
    "pid": 154,
    "city_code": "101181107",
    "city_name": "温县"
  },
  {
    "_id": 1034,
    "id": 1319,
    "pid": 155,
    "city_code": "101180711",
    "city_name": "邓州市"
  },
  {
    "_id": 1035,
    "id": 1320,
    "pid": 155,
    "city_code": "101180702",
    "city_name": "南召县"
  },
  {
    "_id": 1036,
    "id": 1321,
    "pid": 155,
    "city_code": "101180703",
    "city_name": "方城县"
  },
  {
    "_id": 1037,
    "id": 1322,
    "pid": 155,
    "city_code": "101180705",
    "city_name": "西峡县"
  },
  {
    "_id": 1038,
    "id": 1323,
    "pid": 155,
    "city_code": "101180707",
    "city_name": "镇平县"
  },
  {
    "_id": 1039,
    "id": 1324,
    "pid": 155,
    "city_code": "101180706",
    "city_name": "内乡县"
  },
  {
    "_id": 1040,
    "id": 1325,
    "pid": 155,
    "city_code": "101180708",
    "city_name": "淅川县"
  },
  {
    "_id": 1041,
    "id": 1326,
    "pid": 155,
    "city_code": "101180704",
    "city_name": "社旗县"
  },
  {
    "_id": 1042,
    "id": 1327,
    "pid": 155,
    "city_code": "101180710",
    "city_name": "唐河县"
  },
  {
    "_id": 1043,
    "id": 1328,
    "pid": 155,
    "city_code": "101180709",
    "city_name": "新野县"
  },
  {
    "_id": 1044,
    "id": 1329,
    "pid": 155,
    "city_code": "101180712",
    "city_name": "桐柏县"
  },
  {
    "_id": 1045,
    "id": 1333,
    "pid": 156,
    "city_code": "101180508",
    "city_name": "石龙区"
  },
  {
    "_id": 1046,
    "id": 1334,
    "pid": 156,
    "city_code": "101180506",
    "city_name": "舞钢市"
  },
  {
    "_id": 1047,
    "id": 1335,
    "pid": 156,
    "city_code": "101180504",
    "city_name": "汝州市"
  },
  {
    "_id": 1048,
    "id": 1336,
    "pid": 156,
    "city_code": "101180503",
    "city_name": "宝丰县"
  },
  {
    "_id": 1049,
    "id": 1337,
    "pid": 156,
    "city_code": "101180505",
    "city_name": "叶县"
  },
  {
    "_id": 1050,
    "id": 1338,
    "pid": 156,
    "city_code": "101180507",
    "city_name": "鲁山县"
  },
  {
    "_id": 1051,
    "id": 1339,
    "pid": 156,
    "city_code": "101180502",
    "city_name": "郏县"
  },
  {
    "_id": 1052,
    "id": 1341,
    "pid": 157,
    "city_code": "101181705",
    "city_name": "义马市"
  },
  {
    "_id": 1053,
    "id": 1342,
    "pid": 157,
    "city_code": "101181702",
    "city_name": "灵宝市"
  },
  {
    "_id": 1054,
    "id": 1343,
    "pid": 157,
    "city_code": "101181703",
    "city_name": "渑池县"
  },
  {
    "_id": 1055,
    "id": 1344,
    "pid": 157,
    "city_code": "101181706",
    "city_name": "陕县"
  },
  {
    "_id": 1056,
    "id": 1345,
    "pid": 157,
    "city_code": "101181704",
    "city_name": "卢氏县"
  },
  {
    "_id": 1057,
    "id": 1347,
    "pid": 158,
    "city_code": "101181002",
    "city_name": "睢阳区"
  },
  {
    "_id": 1058,
    "id": 1348,
    "pid": 158,
    "city_code": "101181009",
    "city_name": "永城市"
  },
  {
    "_id": 1059,
    "id": 1349,
    "pid": 158,
    "city_code": "101181004",
    "city_name": "民权县"
  },
  {
    "_id": 1060,
    "id": 1350,
    "pid": 158,
    "city_code": "101181003",
    "city_name": "睢县"
  },
  {
    "_id": 1061,
    "id": 1351,
    "pid": 158,
    "city_code": "101181007",
    "city_name": "宁陵县"
  },
  {
    "_id": 1062,
    "id": 1352,
    "pid": 158,
    "city_code": "101181005",
    "city_name": "虞城县"
  },
  {
    "_id": 1063,
    "id": 1353,
    "pid": 158,
    "city_code": "101181006",
    "city_name": "柘城县"
  },
  {
    "_id": 1064,
    "id": 1354,
    "pid": 158,
    "city_code": "101181008",
    "city_name": "夏邑县"
  },
  {
    "_id": 1065,
    "id": 1359,
    "pid": 159,
    "city_code": "101180305",
    "city_name": "卫辉市"
  },
  {
    "_id": 1066,
    "id": 1360,
    "pid": 159,
    "city_code": "101180304",
    "city_name": "辉县市"
  },
  {
    "_id": 1067,
    "id": 1361,
    "pid": 159,
    "city_code": "101180301",
    "city_name": "新乡县"
  },
  {
    "_id": 1068,
    "id": 1362,
    "pid": 159,
    "city_code": "101180302",
    "city_name": "获嘉县"
  },
  {
    "_id": 1069,
    "id": 1363,
    "pid": 159,
    "city_code": "101180303",
    "city_name": "原阳县"
  },
  {
    "_id": 1070,
    "id": 1364,
    "pid": 159,
    "city_code": "101180306",
    "city_name": "延津县"
  },
  {
    "_id": 1071,
    "id": 1365,
    "pid": 159,
    "city_code": "101180307",
    "city_name": "封丘县"
  },
  {
    "_id": 1072,
    "id": 1366,
    "pid": 159,
    "city_code": "101180308",
    "city_name": "长垣县"
  },
  {
    "_id": 1073,
    "id": 1369,
    "pid": 160,
    "city_code": "101180603",
    "city_name": "罗山县"
  },
  {
    "_id": 1074,
    "id": 1370,
    "pid": 160,
    "city_code": "101180604",
    "city_name": "光山县"
  },
  {
    "_id": 1075,
    "id": 1371,
    "pid": 160,
    "city_code": "101180605",
    "city_name": "新县"
  },
  {
    "_id": 1076,
    "id": 1372,
    "pid": 160,
    "city_code": "101180609",
    "city_name": "商城县"
  },
  {
    "_id": 1077,
    "id": 1373,
    "pid": 160,
    "city_code": "101180608",
    "city_name": "固始县"
  },
  {
    "_id": 1078,
    "id": 1374,
    "pid": 160,
    "city_code": "101180607",
    "city_name": "潢川县"
  },
  {
    "_id": 1079,
    "id": 1375,
    "pid": 160,
    "city_code": "101180606",
    "city_name": "淮滨县"
  },
  {
    "_id": 1080,
    "id": 1376,
    "pid": 160,
    "city_code": "101180602",
    "city_name": "息县"
  },
  {
    "_id": 1081,
    "id": 1378,
    "pid": 161,
    "city_code": "101180405",
    "city_name": "禹州市"
  },
  {
    "_id": 1082,
    "id": 1379,
    "pid": 161,
    "city_code": "101180404",
    "city_name": "长葛市"
  },
  {
    "_id": 1083,
    "id": 1380,
    "pid": 161,
    "city_code": "101180401",
    "city_name": "许昌县"
  },
  {
    "_id": 1084,
    "id": 1381,
    "pid": 161,
    "city_code": "101180402",
    "city_name": "鄢陵县"
  },
  {
    "_id": 1085,
    "id": 1382,
    "pid": 161,
    "city_code": "101180403",
    "city_name": "襄城县"
  },
  {
    "_id": 1086,
    "id": 1384,
    "pid": 162,
    "city_code": "101181407",
    "city_name": "项城市"
  },
  {
    "_id": 1087,
    "id": 1385,
    "pid": 162,
    "city_code": "101181402",
    "city_name": "扶沟县"
  },
  {
    "_id": 1088,
    "id": 1386,
    "pid": 162,
    "city_code": "101181405",
    "city_name": "西华县"
  },
  {
    "_id": 1089,
    "id": 1387,
    "pid": 162,
    "city_code": "101181406",
    "city_name": "商水县"
  },
  {
    "_id": 1090,
    "id": 1388,
    "pid": 162,
    "city_code": "101181410",
    "city_name": "沈丘县"
  },
  {
    "_id": 1091,
    "id": 1389,
    "pid": 162,
    "city_code": "101181408",
    "city_name": "郸城县"
  },
  {
    "_id": 1092,
    "id": 1390,
    "pid": 162,
    "city_code": "101181404",
    "city_name": "淮阳县"
  },
  {
    "_id": 1093,
    "id": 1391,
    "pid": 162,
    "city_code": "101181403",
    "city_name": "太康县"
  },
  {
    "_id": 1094,
    "id": 1392,
    "pid": 162,
    "city_code": "101181409",
    "city_name": "鹿邑县"
  },
  {
    "_id": 1095,
    "id": 1394,
    "pid": 163,
    "city_code": "101181602",
    "city_name": "西平县"
  },
  {
    "_id": 1096,
    "id": 1395,
    "pid": 163,
    "city_code": "101181604",
    "city_name": "上蔡县"
  },
  {
    "_id": 1097,
    "id": 1396,
    "pid": 163,
    "city_code": "101181607",
    "city_name": "平舆县"
  },
  {
    "_id": 1098,
    "id": 1397,
    "pid": 163,
    "city_code": "101181610",
    "city_name": "正阳县"
  },
  {
    "_id": 1099,
    "id": 1398,
    "pid": 163,
    "city_code": "101181609",
    "city_name": "确山县"
  },
  {
    "_id": 1100,
    "id": 1399,
    "pid": 163,
    "city_code": "101181606",
    "city_name": "泌阳县"
  },
  {
    "_id": 1101,
    "id": 1400,
    "pid": 163,
    "city_code": "101181605",
    "city_name": "汝南县"
  },
  {
    "_id": 1102,
    "id": 1401,
    "pid": 163,
    "city_code": "101181603",
    "city_name": "遂平县"
  },
  {
    "_id": 1103,
    "id": 1402,
    "pid": 163,
    "city_code": "101181608",
    "city_name": "新蔡县"
  },
  {
    "_id": 1104,
    "id": 1406,
    "pid": 164,
    "city_code": "101181503",
    "city_name": "舞阳县"
  },
  {
    "_id": 1105,
    "id": 1407,
    "pid": 164,
    "city_code": "101181502",
    "city_name": "临颍县"
  },
  {
    "_id": 1106,
    "id": 1409,
    "pid": 165,
    "city_code": "101181304",
    "city_name": "清丰县"
  },
  {
    "_id": 1107,
    "id": 1410,
    "pid": 165,
    "city_code": "101181303",
    "city_name": "南乐县"
  },
  {
    "_id": 1108,
    "id": 1411,
    "pid": 165,
    "city_code": "101181305",
    "city_name": "范县"
  },
  {
    "_id": 1109,
    "id": 1412,
    "pid": 165,
    "city_code": "101181302",
    "city_name": "台前县"
  },
  {
    "_id": 1110,
    "id": 1413,
    "pid": 165,
    "city_code": "101181301",
    "city_name": "濮阳县"
  },
  {
    "_id": 1111,
    "id": 1421,
    "pid": 166,
    "city_code": "101050104",
    "city_name": "阿城区"
  },
  {
    "_id": 1112,
    "id": 1422,
    "pid": 166,
    "city_code": "101050103",
    "city_name": "呼兰区"
  },
  {
    "_id": 1113,
    "id": 1424,
    "pid": 166,
    "city_code": "101050111",
    "city_name": "尚志市"
  },
  {
    "_id": 1114,
    "id": 1425,
    "pid": 166,
    "city_code": "101050102",
    "city_name": "双城市"
  },
  {
    "_id": 1115,
    "id": 1426,
    "pid": 166,
    "city_code": "101050112",
    "city_name": "五常市"
  },
  {
    "_id": 1116,
    "id": 1427,
    "pid": 166,
    "city_code": "101050109",
    "city_name": "方正县"
  },
  {
    "_id": 1117,
    "id": 1428,
    "pid": 166,
    "city_code": "101050105",
    "city_name": "宾县"
  },
  {
    "_id": 1118,
    "id": 1429,
    "pid": 166,
    "city_code": "101050106",
    "city_name": "依兰县"
  },
  {
    "_id": 1119,
    "id": 1430,
    "pid": 166,
    "city_code": "101050107",
    "city_name": "巴彦县"
  },
  {
    "_id": 1120,
    "id": 1431,
    "pid": 166,
    "city_code": "101050108",
    "city_name": "通河县"
  },
  {
    "_id": 1121,
    "id": 1432,
    "pid": 166,
    "city_code": "101050113",
    "city_name": "木兰县"
  },
  {
    "_id": 1122,
    "id": 1433,
    "pid": 166,
    "city_code": "101050110",
    "city_name": "延寿县"
  },
  {
    "_id": 1123,
    "id": 1439,
    "pid": 167,
    "city_code": "101050903",
    "city_name": "肇州县"
  },
  {
    "_id": 1124,
    "id": 1440,
    "pid": 167,
    "city_code": "101050904",
    "city_name": "肇源县"
  },
  {
    "_id": 1125,
    "id": 1441,
    "pid": 167,
    "city_code": "101050902",
    "city_name": "林甸县"
  },
  {
    "_id": 1126,
    "id": 1442,
    "pid": 167,
    "city_code": "101050905",
    "city_name": "杜尔伯特"
  },
  {
    "_id": 1127,
    "id": 1443,
    "pid": 168,
    "city_code": "101050704",
    "city_name": "呼玛县"
  },
  {
    "_id": 1128,
    "id": 1444,
    "pid": 168,
    "city_code": "101050703",
    "city_name": "漠河县"
  },
  {
    "_id": 1129,
    "id": 1445,
    "pid": 168,
    "city_code": "101050702",
    "city_name": "塔河县"
  },
  {
    "_id": 1130,
    "id": 1448,
    "pid": 169,
    "city_code": "101051206",
    "city_name": "南山区"
  },
  {
    "_id": 1131,
    "id": 1452,
    "pid": 169,
    "city_code": "101051203",
    "city_name": "萝北县"
  },
  {
    "_id": 1132,
    "id": 1453,
    "pid": 169,
    "city_code": "101051202",
    "city_name": "绥滨县"
  },
  {
    "_id": 1133,
    "id": 1455,
    "pid": 170,
    "city_code": "101050605",
    "city_name": "五大连池市"
  },
  {
    "_id": 1134,
    "id": 1456,
    "pid": 170,
    "city_code": "101050606",
    "city_name": "北安市"
  },
  {
    "_id": 1135,
    "id": 1457,
    "pid": 170,
    "city_code": "101050602",
    "city_name": "嫩江县"
  },
  {
    "_id": 1136,
    "id": 1458,
    "pid": 170,
    "city_code": "101050604",
    "city_name": "逊克县"
  },
  {
    "_id": 1137,
    "id": 1459,
    "pid": 170,
    "city_code": "101050603",
    "city_name": "孙吴县"
  },
  {
    "_id": 1138,
    "id": 1465,
    "pid": 171,
    "city_code": "101051102",
    "city_name": "虎林市"
  },
  {
    "_id": 1139,
    "id": 1466,
    "pid": 171,
    "city_code": "101051103",
    "city_name": "密山市"
  },
  {
    "_id": 1140,
    "id": 1467,
    "pid": 171,
    "city_code": "101051104",
    "city_name": "鸡东县"
  },
  {
    "_id": 1141,
    "id": 1472,
    "pid": 172,
    "city_code": "101050406",
    "city_name": "同江市"
  },
  {
    "_id": 1142,
    "id": 1473,
    "pid": 172,
    "city_code": "101050407",
    "city_name": "富锦市"
  },
  {
    "_id": 1143,
    "id": 1474,
    "pid": 172,
    "city_code": "101050405",
    "city_name": "桦南县"
  },
  {
    "_id": 1144,
    "id": 1475,
    "pid": 172,
    "city_code": "101050404",
    "city_name": "桦川县"
  },
  {
    "_id": 1145,
    "id": 1476,
    "pid": 172,
    "city_code": "101050402",
    "city_name": "汤原县"
  },
  {
    "_id": 1146,
    "id": 1477,
    "pid": 172,
    "city_code": "101050403",
    "city_name": "抚远县"
  },
  {
    "_id": 1147,
    "id": 1482,
    "pid": 173,
    "city_code": "101050305",
    "city_name": "绥芬河市"
  },
  {
    "_id": 1148,
    "id": 1483,
    "pid": 173,
    "city_code": "101050302",
    "city_name": "海林市"
  },
  {
    "_id": 1149,
    "id": 1484,
    "pid": 173,
    "city_code": "101050306",
    "city_name": "宁安市"
  },
  {
    "_id": 1150,
    "id": 1485,
    "pid": 173,
    "city_code": "101050303",
    "city_name": "穆棱市"
  },
  {
    "_id": 1151,
    "id": 1486,
    "pid": 173,
    "city_code": "101050307",
    "city_name": "东宁县"
  },
  {
    "_id": 1152,
    "id": 1487,
    "pid": 173,
    "city_code": "101050304",
    "city_name": "林口县"
  },
  {
    "_id": 1153,
    "id": 1491,
    "pid": 174,
    "city_code": "101051002",
    "city_name": "勃利县"
  },
  {
    "_id": 1154,
    "id": 1499,
    "pid": 175,
    "city_code": "101050202",
    "city_name": "讷河市"
  },
  {
    "_id": 1155,
    "id": 1500,
    "pid": 175,
    "city_code": "101050203",
    "city_name": "龙江县"
  },
  {
    "_id": 1156,
    "id": 1501,
    "pid": 175,
    "city_code": "101050206",
    "city_name": "依安县"
  },
  {
    "_id": 1157,
    "id": 1502,
    "pid": 175,
    "city_code": "101050210",
    "city_name": "泰来县"
  },
  {
    "_id": 1158,
    "id": 1503,
    "pid": 175,
    "city_code": "101050204",
    "city_name": "甘南县"
  },
  {
    "_id": 1159,
    "id": 1504,
    "pid": 175,
    "city_code": "101050205",
    "city_name": "富裕县"
  },
  {
    "_id": 1160,
    "id": 1505,
    "pid": 175,
    "city_code": "101050208",
    "city_name": "克山县"
  },
  {
    "_id": 1161,
    "id": 1506,
    "pid": 175,
    "city_code": "101050209",
    "city_name": "克东县"
  },
  {
    "_id": 1162,
    "id": 1507,
    "pid": 175,
    "city_code": "101050207",
    "city_name": "拜泉县"
  },
  {
    "_id": 1163,
    "id": 1512,
    "pid": 176,
    "city_code": "101051302",
    "city_name": "集贤县"
  },
  {
    "_id": 1164,
    "id": 1513,
    "pid": 176,
    "city_code": "101051305",
    "city_name": "友谊县"
  },
  {
    "_id": 1165,
    "id": 1514,
    "pid": 176,
    "city_code": "101051303",
    "city_name": "宝清县"
  },
  {
    "_id": 1166,
    "id": 1515,
    "pid": 176,
    "city_code": "101051304",
    "city_name": "饶河县"
  },
  {
    "_id": 1167,
    "id": 1517,
    "pid": 177,
    "city_code": "101050503",
    "city_name": "安达市"
  },
  {
    "_id": 1168,
    "id": 1518,
    "pid": 177,
    "city_code": "101050502",
    "city_name": "肇东市"
  },
  {
    "_id": 1169,
    "id": 1519,
    "pid": 177,
    "city_code": "101050504",
    "city_name": "海伦市"
  },
  {
    "_id": 1170,
    "id": 1520,
    "pid": 177,
    "city_code": "101050506",
    "city_name": "望奎县"
  },
  {
    "_id": 1171,
    "id": 1521,
    "pid": 177,
    "city_code": "101050507",
    "city_name": "兰西县"
  },
  {
    "_id": 1172,
    "id": 1522,
    "pid": 177,
    "city_code": "101050508",
    "city_name": "青冈县"
  },
  {
    "_id": 1173,
    "id": 1523,
    "pid": 177,
    "city_code": "101050509",
    "city_name": "庆安县"
  },
  {
    "_id": 1174,
    "id": 1524,
    "pid": 177,
    "city_code": "101050505",
    "city_name": "明水县"
  },
  {
    "_id": 1175,
    "id": 1525,
    "pid": 177,
    "city_code": "101050510",
    "city_name": "绥棱县"
  },
  {
    "_id": 1176,
    "id": 1526,
    "pid": 178,
    "city_code": "101050801",
    "city_name": "伊春区"
  },
  {
    "_id": 1177,
    "id": 1536,
    "pid": 178,
    "city_code": "101050803",
    "city_name": "五营区"
  },
  {
    "_id": 1178,
    "id": 1540,
    "pid": 178,
    "city_code": "101050802",
    "city_name": "乌伊岭区"
  },
  {
    "_id": 1179,
    "id": 1541,
    "pid": 178,
    "city_code": "101050804",
    "city_name": "铁力市"
  },
  {
    "_id": 1180,
    "id": 1542,
    "pid": 178,
    "city_code": "101050805",
    "city_name": "嘉荫县"
  },
  {
    "_id": 1181,
    "id": 1550,
    "pid": 179,
    "city_code": "101200106",
    "city_name": "东西湖区"
  },
  {
    "_id": 1182,
    "id": 1552,
    "pid": 179,
    "city_code": "101200102",
    "city_name": "蔡甸区"
  },
  {
    "_id": 1183,
    "id": 1553,
    "pid": 179,
    "city_code": "101200105",
    "city_name": "江夏区"
  },
  {
    "_id": 1184,
    "id": 1554,
    "pid": 179,
    "city_code": "101200103",
    "city_name": "黄陂区"
  },
  {
    "_id": 1185,
    "id": 1555,
    "pid": 179,
    "city_code": "101200104",
    "city_name": "新洲区"
  },
  {
    "_id": 1186,
    "id": 1560,
    "pid": 181,
    "city_code": "101200302",
    "city_name": "梁子湖区"
  },
  {
    "_id": 1187,
    "id": 1562,
    "pid": 182,
    "city_code": "101200503",
    "city_name": "麻城市"
  },
  {
    "_id": 1188,
    "id": 1563,
    "pid": 182,
    "city_code": "101200509",
    "city_name": "武穴市"
  },
  {
    "_id": 1189,
    "id": 1564,
    "pid": 182,
    "city_code": "101200510",
    "city_name": "团风县"
  },
  {
    "_id": 1190,
    "id": 1565,
    "pid": 182,
    "city_code": "101200502",
    "city_name": "红安县"
  },
  {
    "_id": 1191,
    "id": 1566,
    "pid": 182,
    "city_code": "101200504",
    "city_name": "罗田县"
  },
  {
    "_id": 1192,
    "id": 1567,
    "pid": 182,
    "city_code": "101200505",
    "city_name": "英山县"
  },
  {
    "_id": 1193,
    "id": 1568,
    "pid": 182,
    "city_code": "101200506",
    "city_name": "浠水县"
  },
  {
    "_id": 1194,
    "id": 1569,
    "pid": 182,
    "city_code": "101200507",
    "city_name": "蕲春县"
  },
  {
    "_id": 1195,
    "id": 1570,
    "pid": 182,
    "city_code": "101200508",
    "city_name": "黄梅县"
  },
  {
    "_id": 1196,
    "id": 1572,
    "pid": 183,
    "city_code": "101200606",
    "city_name": "西塞山区"
  },
  {
    "_id": 1197,
    "id": 1573,
    "pid": 183,
    "city_code": "101200605",
    "city_name": "下陆区"
  },
  {
    "_id": 1198,
    "id": 1574,
    "pid": 183,
    "city_code": "101200604",
    "city_name": "铁山区"
  },
  {
    "_id": 1199,
    "id": 1575,
    "pid": 183,
    "city_code": "101200602",
    "city_name": "大冶市"
  },
  {
    "_id": 1200,
    "id": 1576,
    "pid": 183,
    "city_code": "101200603",
    "city_name": "阳新县"
  },
  {
    "_id": 1201,
    "id": 1578,
    "pid": 184,
    "city_code": "101201404",
    "city_name": "掇刀区"
  },
  {
    "_id": 1202,
    "id": 1579,
    "pid": 184,
    "city_code": "101201402",
    "city_name": "钟祥市"
  },
  {
    "_id": 1203,
    "id": 1580,
    "pid": 184,
    "city_code": "101201403",
    "city_name": "京山县"
  },
  {
    "_id": 1204,
    "id": 1581,
    "pid": 184,
    "city_code": "101201405",
    "city_name": "沙洋县"
  },
  {
    "_id": 1205,
    "id": 1583,
    "pid": 185,
    "city_code": "101200801",
    "city_name": "荆州区"
  },
  {
    "_id": 1206,
    "id": 1584,
    "pid": 185,
    "city_code": "101200804",
    "city_name": "石首市"
  },
  {
    "_id": 1207,
    "id": 1585,
    "pid": 185,
    "city_code": "101200806",
    "city_name": "洪湖市"
  },
  {
    "_id": 1208,
    "id": 1586,
    "pid": 185,
    "city_code": "101200807",
    "city_name": "松滋市"
  },
  {
    "_id": 1209,
    "id": 1587,
    "pid": 185,
    "city_code": "101200803",
    "city_name": "公安县"
  },
  {
    "_id": 1210,
    "id": 1588,
    "pid": 185,
    "city_code": "101200805",
    "city_name": "监利县"
  },
  {
    "_id": 1211,
    "id": 1589,
    "pid": 185,
    "city_code": "101200802",
    "city_name": "江陵县"
  },
  {
    "_id": 1212,
    "id": 1590,
    "pid": 186,
    "city_code": "101201701",
    "city_name": "潜江市"
  },
  {
    "_id": 1213,
    "id": 1592,
    "pid": 188,
    "city_code": "101201109",
    "city_name": "张湾区"
  },
  {
    "_id": 1214,
    "id": 1593,
    "pid": 188,
    "city_code": "101201108",
    "city_name": "茅箭区"
  },
  {
    "_id": 1215,
    "id": 1594,
    "pid": 188,
    "city_code": "101201107",
    "city_name": "丹江口市"
  },
  {
    "_id": 1216,
    "id": 1595,
    "pid": 188,
    "city_code": "101201104",
    "city_name": "郧县"
  },
  {
    "_id": 1217,
    "id": 1596,
    "pid": 188,
    "city_code": "101201103",
    "city_name": "郧西县"
  },
  {
    "_id": 1218,
    "id": 1597,
    "pid": 188,
    "city_code": "101201105",
    "city_name": "竹山县"
  },
  {
    "_id": 1219,
    "id": 1598,
    "pid": 188,
    "city_code": "101201102",
    "city_name": "竹溪县"
  },
  {
    "_id": 1220,
    "id": 1599,
    "pid": 188,
    "city_code": "101201106",
    "city_name": "房县"
  },
  {
    "_id": 1221,
    "id": 1601,
    "pid": 189,
    "city_code": "101201302",
    "city_name": "广水市"
  },
  {
    "_id": 1222,
    "id": 1602,
    "pid": 190,
    "city_code": "101201501",
    "city_name": "天门市"
  },
  {
    "_id": 1223,
    "id": 1604,
    "pid": 191,
    "city_code": "101200702",
    "city_name": "赤壁市"
  },
  {
    "_id": 1224,
    "id": 1605,
    "pid": 191,
    "city_code": "101200703",
    "city_name": "嘉鱼县"
  },
  {
    "_id": 1225,
    "id": 1606,
    "pid": 191,
    "city_code": "101200705",
    "city_name": "通城县"
  },
  {
    "_id": 1226,
    "id": 1607,
    "pid": 191,
    "city_code": "101200704",
    "city_name": "崇阳县"
  },
  {
    "_id": 1227,
    "id": 1608,
    "pid": 191,
    "city_code": "101200706",
    "city_name": "通山县"
  },
  {
    "_id": 1228,
    "id": 1611,
    "pid": 192,
    "city_code": "101200202",
    "city_name": "襄州区"
  },
  {
    "_id": 1229,
    "id": 1612,
    "pid": 192,
    "city_code": "101200206",
    "city_name": "老河口市"
  },
  {
    "_id": 1230,
    "id": 1613,
    "pid": 192,
    "city_code": "101200208",
    "city_name": "枣阳市"
  },
  {
    "_id": 1231,
    "id": 1614,
    "pid": 192,
    "city_code": "101200205",
    "city_name": "宜城市"
  },
  {
    "_id": 1232,
    "id": 1615,
    "pid": 192,
    "city_code": "101200204",
    "city_name": "南漳县"
  },
  {
    "_id": 1233,
    "id": 1616,
    "pid": 192,
    "city_code": "101200207",
    "city_name": "谷城县"
  },
  {
    "_id": 1234,
    "id": 1617,
    "pid": 192,
    "city_code": "101200203",
    "city_name": "保康县"
  },
  {
    "_id": 1235,
    "id": 1619,
    "pid": 193,
    "city_code": "101200405",
    "city_name": "应城市"
  },
  {
    "_id": 1236,
    "id": 1620,
    "pid": 193,
    "city_code": "101200402",
    "city_name": "安陆市"
  },
  {
    "_id": 1237,
    "id": 1621,
    "pid": 193,
    "city_code": "101200406",
    "city_name": "汉川市"
  },
  {
    "_id": 1238,
    "id": 1622,
    "pid": 193,
    "city_code": "101200407",
    "city_name": "孝昌县"
  },
  {
    "_id": 1239,
    "id": 1623,
    "pid": 193,
    "city_code": "101200404",
    "city_name": "大悟县"
  },
  {
    "_id": 1240,
    "id": 1624,
    "pid": 193,
    "city_code": "101200403",
    "city_name": "云梦县"
  },
  {
    "_id": 1241,
    "id": 1625,
    "pid": 194,
    "city_code": "101200908",
    "city_name": "长阳县"
  },
  {
    "_id": 1242,
    "id": 1626,
    "pid": 194,
    "city_code": "101200906",
    "city_name": "五峰县"
  },
  {
    "_id": 1243,
    "id": 1631,
    "pid": 194,
    "city_code": "101200912",
    "city_name": "夷陵区"
  },
  {
    "_id": 1244,
    "id": 1632,
    "pid": 194,
    "city_code": "101200909",
    "city_name": "宜都市"
  },
  {
    "_id": 1245,
    "id": 1633,
    "pid": 194,
    "city_code": "101200907",
    "city_name": "当阳市"
  },
  {
    "_id": 1246,
    "id": 1634,
    "pid": 194,
    "city_code": "101200910",
    "city_name": "枝江市"
  },
  {
    "_id": 1247,
    "id": 1635,
    "pid": 194,
    "city_code": "101200902",
    "city_name": "远安县"
  },
  {
    "_id": 1248,
    "id": 1636,
    "pid": 194,
    "city_code": "101200904",
    "city_name": "兴山县"
  },
  {
    "_id": 1249,
    "id": 1637,
    "pid": 194,
    "city_code": "101200903",
    "city_name": "秭归县"
  },
  {
    "_id": 1250,
    "id": 1638,
    "pid": 195,
    "city_code": "101201001",
    "city_name": "恩施市"
  },
  {
    "_id": 1251,
    "id": 1639,
    "pid": 195,
    "city_code": "101201002",
    "city_name": "利川市"
  },
  {
    "_id": 1252,
    "id": 1640,
    "pid": 195,
    "city_code": "101201003",
    "city_name": "建始县"
  },
  {
    "_id": 1253,
    "id": 1641,
    "pid": 195,
    "city_code": "101201008",
    "city_name": "巴东县"
  },
  {
    "_id": 1254,
    "id": 1642,
    "pid": 195,
    "city_code": "101201005",
    "city_name": "宣恩县"
  },
  {
    "_id": 1255,
    "id": 1643,
    "pid": 195,
    "city_code": "101201004",
    "city_name": "咸丰县"
  },
  {
    "_id": 1256,
    "id": 1644,
    "pid": 195,
    "city_code": "101201007",
    "city_name": "来凤县"
  },
  {
    "_id": 1257,
    "id": 1645,
    "pid": 195,
    "city_code": "101201006",
    "city_name": "鹤峰县"
  },
  {
    "_id": 1258,
    "id": 1652,
    "pid": 196,
    "city_code": "101250103",
    "city_name": "浏阳市"
  },
  {
    "_id": 1259,
    "id": 1653,
    "pid": 196,
    "city_code": "101250101",
    "city_name": "长沙县"
  },
  {
    "_id": 1260,
    "id": 1654,
    "pid": 196,
    "city_code": "101250105",
    "city_name": "望城县"
  },
  {
    "_id": 1261,
    "id": 1655,
    "pid": 196,
    "city_code": "101250102",
    "city_name": "宁乡县"
  },
  {
    "_id": 1262,
    "id": 1657,
    "pid": 197,
    "city_code": "101251104",
    "city_name": "武陵源区"
  },
  {
    "_id": 1263,
    "id": 1658,
    "pid": 197,
    "city_code": "101251103",
    "city_name": "慈利县"
  },
  {
    "_id": 1264,
    "id": 1659,
    "pid": 197,
    "city_code": "101251102",
    "city_name": "桑植县"
  },
  {
    "_id": 1265,
    "id": 1662,
    "pid": 198,
    "city_code": "101250608",
    "city_name": "津市市"
  },
  {
    "_id": 1266,
    "id": 1663,
    "pid": 198,
    "city_code": "101250602",
    "city_name": "安乡县"
  },
  {
    "_id": 1267,
    "id": 1664,
    "pid": 198,
    "city_code": "101250604",
    "city_name": "汉寿县"
  },
  {
    "_id": 1268,
    "id": 1665,
    "pid": 198,
    "city_code": "101250605",
    "city_name": "澧县"
  },
  {
    "_id": 1269,
    "id": 1666,
    "pid": 198,
    "city_code": "101250606",
    "city_name": "临澧县"
  },
  {
    "_id": 1270,
    "id": 1667,
    "pid": 198,
    "city_code": "101250603",
    "city_name": "桃源县"
  },
  {
    "_id": 1271,
    "id": 1668,
    "pid": 198,
    "city_code": "101250607",
    "city_name": "石门县"
  },
  {
    "_id": 1272,
    "id": 1670,
    "pid": 199,
    "city_code": "101250512",
    "city_name": "苏仙区"
  },
  {
    "_id": 1273,
    "id": 1671,
    "pid": 199,
    "city_code": "101250507",
    "city_name": "资兴市"
  },
  {
    "_id": 1274,
    "id": 1672,
    "pid": 199,
    "city_code": "101250502",
    "city_name": "桂阳县"
  },
  {
    "_id": 1275,
    "id": 1673,
    "pid": 199,
    "city_code": "101250504",
    "city_name": "宜章县"
  },
  {
    "_id": 1276,
    "id": 1674,
    "pid": 199,
    "city_code": "101250510",
    "city_name": "永兴县"
  },
  {
    "_id": 1277,
    "id": 1675,
    "pid": 199,
    "city_code": "101250503",
    "city_name": "嘉禾县"
  },
  {
    "_id": 1278,
    "id": 1676,
    "pid": 199,
    "city_code": "101250505",
    "city_name": "临武县"
  },
  {
    "_id": 1279,
    "id": 1677,
    "pid": 199,
    "city_code": "101250508",
    "city_name": "汝城县"
  },
  {
    "_id": 1280,
    "id": 1678,
    "pid": 199,
    "city_code": "101250511",
    "city_name": "桂东县"
  },
  {
    "_id": 1281,
    "id": 1679,
    "pid": 199,
    "city_code": "101250509",
    "city_name": "安仁县"
  },
  {
    "_id": 1282,
    "id": 1684,
    "pid": 200,
    "city_code": "101250409",
    "city_name": "南岳区"
  },
  {
    "_id": 1283,
    "id": 1685,
    "pid": 200,
    "city_code": "101250408",
    "city_name": "耒阳市"
  },
  {
    "_id": 1284,
    "id": 1686,
    "pid": 200,
    "city_code": "101250406",
    "city_name": "常宁市"
  },
  {
    "_id": 1285,
    "id": 1687,
    "pid": 200,
    "city_code": "101250405",
    "city_name": "衡阳县"
  },
  {
    "_id": 1286,
    "id": 1688,
    "pid": 200,
    "city_code": "101250407",
    "city_name": "衡南县"
  },
  {
    "_id": 1287,
    "id": 1689,
    "pid": 200,
    "city_code": "101250402",
    "city_name": "衡山县"
  },
  {
    "_id": 1288,
    "id": 1690,
    "pid": 200,
    "city_code": "101250403",
    "city_name": "衡东县"
  },
  {
    "_id": 1289,
    "id": 1691,
    "pid": 200,
    "city_code": "101250404",
    "city_name": "祁东县"
  },
  {
    "_id": 1290,
    "id": 1692,
    "pid": 201,
    "city_code": "101251202",
    "city_name": "鹤城区"
  },
  {
    "_id": 1291,
    "id": 1693,
    "pid": 201,
    "city_code": "101251205",
    "city_name": "靖州县"
  },
  {
    "_id": 1292,
    "id": 1694,
    "pid": 201,
    "city_code": "101251208",
    "city_name": "麻阳县"
  },
  {
    "_id": 1293,
    "id": 1695,
    "pid": 201,
    "city_code": "101251207",
    "city_name": "通道县"
  },
  {
    "_id": 1294,
    "id": 1696,
    "pid": 201,
    "city_code": "101251209",
    "city_name": "新晃县"
  },
  {
    "_id": 1295,
    "id": 1697,
    "pid": 201,
    "city_code": "101251210",
    "city_name": "芷江县"
  },
  {
    "_id": 1296,
    "id": 1698,
    "pid": 201,
    "city_code": "101251203",
    "city_name": "沅陵县"
  },
  {
    "_id": 1297,
    "id": 1699,
    "pid": 201,
    "city_code": "101251204",
    "city_name": "辰溪县"
  },
  {
    "_id": 1298,
    "id": 1700,
    "pid": 201,
    "city_code": "101251211",
    "city_name": "溆浦县"
  },
  {
    "_id": 1299,
    "id": 1701,
    "pid": 201,
    "city_code": "101251212",
    "city_name": "中方县"
  },
  {
    "_id": 1300,
    "id": 1702,
    "pid": 201,
    "city_code": "101251206",
    "city_name": "会同县"
  },
  {
    "_id": 1301,
    "id": 1703,
    "pid": 201,
    "city_code": "101251213",
    "city_name": "洪江市"
  },
  {
    "_id": 1302,
    "id": 1705,
    "pid": 202,
    "city_code": "101250803",
    "city_name": "冷水江市"
  },
  {
    "_id": 1303,
    "id": 1706,
    "pid": 202,
    "city_code": "101250806",
    "city_name": "涟源市"
  },
  {
    "_id": 1304,
    "id": 1707,
    "pid": 202,
    "city_code": "101250802",
    "city_name": "双峰县"
  },
  {
    "_id": 1305,
    "id": 1708,
    "pid": 202,
    "city_code": "101250805",
    "city_name": "新化县"
  },
  {
    "_id": 1306,
    "id": 1709,
    "pid": 203,
    "city_code": "101250909",
    "city_name": "城步县"
  },
  {
    "_id": 1307,
    "id": 1713,
    "pid": 203,
    "city_code": "101250908",
    "city_name": "武冈市"
  },
  {
    "_id": 1308,
    "id": 1714,
    "pid": 203,
    "city_code": "101250905",
    "city_name": "邵东县"
  },
  {
    "_id": 1309,
    "id": 1715,
    "pid": 203,
    "city_code": "101250904",
    "city_name": "新邵县"
  },
  {
    "_id": 1310,
    "id": 1716,
    "pid": 203,
    "city_code": "101250910",
    "city_name": "邵阳县"
  },
  {
    "_id": 1311,
    "id": 1717,
    "pid": 203,
    "city_code": "101250902",
    "city_name": "隆回县"
  },
  {
    "_id": 1312,
    "id": 1718,
    "pid": 203,
    "city_code": "101250903",
    "city_name": "洞口县"
  },
  {
    "_id": 1313,
    "id": 1719,
    "pid": 203,
    "city_code": "101250906",
    "city_name": "绥宁县"
  },
  {
    "_id": 1314,
    "id": 1720,
    "pid": 203,
    "city_code": "101250907",
    "city_name": "新宁县"
  },
  {
    "_id": 1315,
    "id": 1723,
    "pid": 204,
    "city_code": "101250203",
    "city_name": "湘乡市"
  },
  {
    "_id": 1316,
    "id": 1724,
    "pid": 204,
    "city_code": "101250202",
    "city_name": "韶山市"
  },
  {
    "_id": 1317,
    "id": 1725,
    "pid": 204,
    "city_code": "101250201",
    "city_name": "湘潭县"
  },
  {
    "_id": 1318,
    "id": 1726,
    "pid": 205,
    "city_code": "101251501",
    "city_name": "吉首市"
  },
  {
    "_id": 1319,
    "id": 1727,
    "pid": 205,
    "city_code": "101251506",
    "city_name": "泸溪县"
  },
  {
    "_id": 1320,
    "id": 1728,
    "pid": 205,
    "city_code": "101251505",
    "city_name": "凤凰县"
  },
  {
    "_id": 1321,
    "id": 1729,
    "pid": 205,
    "city_code": "101251508",
    "city_name": "花垣县"
  },
  {
    "_id": 1322,
    "id": 1730,
    "pid": 205,
    "city_code": "101251502",
    "city_name": "保靖县"
  },
  {
    "_id": 1323,
    "id": 1731,
    "pid": 205,
    "city_code": "101251504",
    "city_name": "古丈县"
  },
  {
    "_id": 1324,
    "id": 1732,
    "pid": 205,
    "city_code": "101251503",
    "city_name": "永顺县"
  },
  {
    "_id": 1325,
    "id": 1733,
    "pid": 205,
    "city_code": "101251507",
    "city_name": "龙山县"
  },
  {
    "_id": 1326,
    "id": 1734,
    "pid": 206,
    "city_code": "101250701",
    "city_name": "赫山区"
  },
  {
    "_id": 1327,
    "id": 1736,
    "pid": 206,
    "city_code": "101250705",
    "city_name": "沅江市"
  },
  {
    "_id": 1328,
    "id": 1737,
    "pid": 206,
    "city_code": "101250702",
    "city_name": "南县"
  },
  {
    "_id": 1329,
    "id": 1738,
    "pid": 206,
    "city_code": "101250703",
    "city_name": "桃江县"
  },
  {
    "_id": 1330,
    "id": 1739,
    "pid": 206,
    "city_code": "101250704",
    "city_name": "安化县"
  },
  {
    "_id": 1331,
    "id": 1740,
    "pid": 207,
    "city_code": "101251410",
    "city_name": "江华县"
  },
  {
    "_id": 1332,
    "id": 1743,
    "pid": 207,
    "city_code": "101251402",
    "city_name": "祁阳县"
  },
  {
    "_id": 1333,
    "id": 1744,
    "pid": 207,
    "city_code": "101251403",
    "city_name": "东安县"
  },
  {
    "_id": 1334,
    "id": 1745,
    "pid": 207,
    "city_code": "101251404",
    "city_name": "双牌县"
  },
  {
    "_id": 1335,
    "id": 1746,
    "pid": 207,
    "city_code": "101251405",
    "city_name": "道县"
  },
  {
    "_id": 1336,
    "id": 1747,
    "pid": 207,
    "city_code": "101251407",
    "city_name": "江永县"
  },
  {
    "_id": 1337,
    "id": 1748,
    "pid": 207,
    "city_code": "101251406",
    "city_name": "宁远县"
  },
  {
    "_id": 1338,
    "id": 1749,
    "pid": 207,
    "city_code": "101251408",
    "city_name": "蓝山县"
  },
  {
    "_id": 1339,
    "id": 1750,
    "pid": 207,
    "city_code": "101251409",
    "city_name": "新田县"
  },
  {
    "_id": 1340,
    "id": 1754,
    "pid": 208,
    "city_code": "101251004",
    "city_name": "汨罗市"
  },
  {
    "_id": 1341,
    "id": 1755,
    "pid": 208,
    "city_code": "101251006",
    "city_name": "临湘市"
  },
  {
    "_id": 1342,
    "id": 1756,
    "pid": 208,
    "city_code": "101251001",
    "city_name": "岳阳县"
  },
  {
    "_id": 1343,
    "id": 1757,
    "pid": 208,
    "city_code": "101251002",
    "city_name": "华容县"
  },
  {
    "_id": 1344,
    "id": 1758,
    "pid": 208,
    "city_code": "101251003",
    "city_name": "湘阴县"
  },
  {
    "_id": 1345,
    "id": 1759,
    "pid": 208,
    "city_code": "101251005",
    "city_name": "平江县"
  },
  {
    "_id": 1346,
    "id": 1764,
    "pid": 209,
    "city_code": "101250303",
    "city_name": "醴陵市"
  },
  {
    "_id": 1347,
    "id": 1765,
    "pid": 209,
    "city_code": "101250304",
    "city_name": "株洲县"
  },
  {
    "_id": 1348,
    "id": 1766,
    "pid": 209,
    "city_code": "101250302",
    "city_name": "攸县"
  },
  {
    "_id": 1349,
    "id": 1767,
    "pid": 209,
    "city_code": "101250305",
    "city_name": "茶陵县"
  },
  {
    "_id": 1350,
    "id": 1768,
    "pid": 209,
    "city_code": "101250306",
    "city_name": "炎陵县"
  },
  {
    "_id": 1351,
    "id": 1774,
    "pid": 210,
    "city_code": "101060106",
    "city_name": "双阳区"
  },
  {
    "_id": 1352,
    "id": 1779,
    "pid": 210,
    "city_code": "101060103",
    "city_name": "德惠市"
  },
  {
    "_id": 1353,
    "id": 1780,
    "pid": 210,
    "city_code": "101060104",
    "city_name": "九台市"
  },
  {
    "_id": 1354,
    "id": 1781,
    "pid": 210,
    "city_code": "101060105",
    "city_name": "榆树市"
  },
  {
    "_id": 1355,
    "id": 1782,
    "pid": 210,
    "city_code": "101060102",
    "city_name": "农安县"
  },
  {
    "_id": 1356,
    "id": 1787,
    "pid": 211,
    "city_code": "101060204",
    "city_name": "蛟河市"
  },
  {
    "_id": 1357,
    "id": 1788,
    "pid": 211,
    "city_code": "101060206",
    "city_name": "桦甸市"
  },
  {
    "_id": 1358,
    "id": 1789,
    "pid": 211,
    "city_code": "101060202",
    "city_name": "舒兰市"
  },
  {
    "_id": 1359,
    "id": 1790,
    "pid": 211,
    "city_code": "101060205",
    "city_name": "磐石市"
  },
  {
    "_id": 1360,
    "id": 1791,
    "pid": 211,
    "city_code": "101060203",
    "city_name": "永吉县"
  },
  {
    "_id": 1361,
    "id": 1793,
    "pid": 212,
    "city_code": "101060602",
    "city_name": "洮南市"
  },
  {
    "_id": 1362,
    "id": 1794,
    "pid": 212,
    "city_code": "101060603",
    "city_name": "大安市"
  },
  {
    "_id": 1363,
    "id": 1795,
    "pid": 212,
    "city_code": "101060604",
    "city_name": "镇赉县"
  },
  {
    "_id": 1364,
    "id": 1796,
    "pid": 212,
    "city_code": "101060605",
    "city_name": "通榆县"
  },
  {
    "_id": 1365,
    "id": 1797,
    "pid": 213,
    "city_code": "101060907",
    "city_name": "江源区"
  },
  {
    "_id": 1366,
    "id": 1799,
    "pid": 213,
    "city_code": "101060905",
    "city_name": "长白县"
  },
  {
    "_id": 1367,
    "id": 1800,
    "pid": 213,
    "city_code": "101060903",
    "city_name": "临江市"
  },
  {
    "_id": 1368,
    "id": 1801,
    "pid": 213,
    "city_code": "101060906",
    "city_name": "抚松县"
  },
  {
    "_id": 1369,
    "id": 1802,
    "pid": 213,
    "city_code": "101060902",
    "city_name": "靖宇县"
  },
  {
    "_id": 1370,
    "id": 1805,
    "pid": 214,
    "city_code": "101060702",
    "city_name": "东丰县"
  },
  {
    "_id": 1371,
    "id": 1806,
    "pid": 214,
    "city_code": "101060703",
    "city_name": "东辽县"
  },
  {
    "_id": 1372,
    "id": 1809,
    "pid": 215,
    "city_code": "101060405",
    "city_name": "伊通县"
  },
  {
    "_id": 1373,
    "id": 1810,
    "pid": 215,
    "city_code": "101060404",
    "city_name": "公主岭市"
  },
  {
    "_id": 1374,
    "id": 1811,
    "pid": 215,
    "city_code": "101060402",
    "city_name": "双辽市"
  },
  {
    "_id": 1375,
    "id": 1812,
    "pid": 215,
    "city_code": "101060403",
    "city_name": "梨树县"
  },
  {
    "_id": 1376,
    "id": 1813,
    "pid": 216,
    "city_code": "101060803",
    "city_name": "前郭尔罗斯"
  },
  {
    "_id": 1377,
    "id": 1815,
    "pid": 216,
    "city_code": "101060804",
    "city_name": "长岭县"
  },
  {
    "_id": 1378,
    "id": 1816,
    "pid": 216,
    "city_code": "101060802",
    "city_name": "乾安县"
  },
  {
    "_id": 1379,
    "id": 1817,
    "pid": 216,
    "city_code": "101060805",
    "city_name": "扶余市"
  },
  {
    "_id": 1380,
    "id": 1820,
    "pid": 217,
    "city_code": "101060502",
    "city_name": "梅河口市"
  },
  {
    "_id": 1381,
    "id": 1821,
    "pid": 217,
    "city_code": "101060505",
    "city_name": "集安市"
  },
  {
    "_id": 1382,
    "id": 1822,
    "pid": 217,
    "city_code": "101060506",
    "city_name": "通化县"
  },
  {
    "_id": 1383,
    "id": 1823,
    "pid": 217,
    "city_code": "101060504",
    "city_name": "辉南县"
  },
  {
    "_id": 1384,
    "id": 1824,
    "pid": 217,
    "city_code": "101060503",
    "city_name": "柳河县"
  },
  {
    "_id": 1385,
    "id": 1825,
    "pid": 218,
    "city_code": "101060301",
    "city_name": "延吉市"
  },
  {
    "_id": 1386,
    "id": 1826,
    "pid": 218,
    "city_code": "101060309",
    "city_name": "图们市"
  },
  {
    "_id": 1387,
    "id": 1827,
    "pid": 218,
    "city_code": "101060302",
    "city_name": "敦化市"
  },
  {
    "_id": 1388,
    "id": 1828,
    "pid": 218,
    "city_code": "101060308",
    "city_name": "珲春市"
  },
  {
    "_id": 1389,
    "id": 1829,
    "pid": 218,
    "city_code": "101060307",
    "city_name": "龙井市"
  },
  {
    "_id": 1390,
    "id": 1830,
    "pid": 218,
    "city_code": "101060305",
    "city_name": "和龙市"
  },
  {
    "_id": 1391,
    "id": 1831,
    "pid": 218,
    "city_code": "101060303",
    "city_name": "安图县"
  },
  {
    "_id": 1392,
    "id": 1832,
    "pid": 218,
    "city_code": "101060304",
    "city_name": "汪清县"
  },
  {
    "_id": 1393,
    "id": 1841,
    "pid": 219,
    "city_code": "101190107",
    "city_name": "浦口区"
  },
  {
    "_id": 1394,
    "id": 1842,
    "pid": 219,
    "city_code": "101190104",
    "city_name": "江宁区"
  },
  {
    "_id": 1395,
    "id": 1843,
    "pid": 219,
    "city_code": "101190105",
    "city_name": "六合区"
  },
  {
    "_id": 1396,
    "id": 1844,
    "pid": 219,
    "city_code": "101190102",
    "city_name": "溧水区"
  },
  {
    "_id": 1397,
    "id": 1845,
    "pid": 219,
    "city_code": "101190103",
    "city_name": "高淳县"
  },
  {
    "_id": 1398,
    "id": 1850,
    "pid": 220,
    "city_code": "101190405",
    "city_name": "吴中区"
  },
  {
    "_id": 1399,
    "id": 1853,
    "pid": 220,
    "city_code": "101190404",
    "city_name": "昆山市"
  },
  {
    "_id": 1400,
    "id": 1854,
    "pid": 220,
    "city_code": "101190402",
    "city_name": "常熟市"
  },
  {
    "_id": 1401,
    "id": 1855,
    "pid": 220,
    "city_code": "101190403",
    "city_name": "张家港市"
  },
  {
    "_id": 1402,
    "id": 1867,
    "pid": 220,
    "city_code": "101190407",
    "city_name": "吴江区"
  },
  {
    "_id": 1403,
    "id": 1868,
    "pid": 220,
    "city_code": "101190408",
    "city_name": "太仓市"
  },
  {
    "_id": 1404,
    "id": 1872,
    "pid": 221,
    "city_code": "101190204",
    "city_name": "锡山区"
  },
  {
    "_id": 1405,
    "id": 1876,
    "pid": 221,
    "city_code": "101190202",
    "city_name": "江阴市"
  },
  {
    "_id": 1406,
    "id": 1877,
    "pid": 221,
    "city_code": "101190203",
    "city_name": "宜兴市"
  },
  {
    "_id": 1407,
    "id": 1883,
    "pid": 222,
    "city_code": "101191104",
    "city_name": "武进区"
  },
  {
    "_id": 1408,
    "id": 1884,
    "pid": 222,
    "city_code": "101191102",
    "city_name": "溧阳市"
  },
  {
    "_id": 1409,
    "id": 1885,
    "pid": 222,
    "city_code": "101191103",
    "city_name": "金坛区"
  },
  {
    "_id": 1410,
    "id": 1888,
    "pid": 223,
    "city_code": "101190908",
    "city_name": "楚州区"
  },
  {
    "_id": 1411,
    "id": 1889,
    "pid": 223,
    "city_code": "101190907",
    "city_name": "淮阴区"
  },
  {
    "_id": 1412,
    "id": 1890,
    "pid": 223,
    "city_code": "101190905",
    "city_name": "涟水县"
  },
  {
    "_id": 1413,
    "id": 1891,
    "pid": 223,
    "city_code": "101190904",
    "city_name": "洪泽县"
  },
  {
    "_id": 1414,
    "id": 1892,
    "pid": 223,
    "city_code": "101190903",
    "city_name": "盱眙县"
  },
  {
    "_id": 1415,
    "id": 1893,
    "pid": 223,
    "city_code": "101190902",
    "city_name": "金湖县"
  },
  {
    "_id": 1416,
    "id": 1897,
    "pid": 224,
    "city_code": "101191003",
    "city_name": "赣榆县"
  },
  {
    "_id": 1417,
    "id": 1898,
    "pid": 224,
    "city_code": "101191002",
    "city_name": "东海县"
  },
  {
    "_id": 1418,
    "id": 1899,
    "pid": 224,
    "city_code": "101191004",
    "city_name": "灌云县"
  },
  {
    "_id": 1419,
    "id": 1900,
    "pid": 224,
    "city_code": "101191005",
    "city_name": "灌南县"
  },
  {
    "_id": 1420,
    "id": 1904,
    "pid": 225,
    "city_code": "101190507",
    "city_name": "启东市"
  },
  {
    "_id": 1421,
    "id": 1905,
    "pid": 225,
    "city_code": "101190503",
    "city_name": "如皋市"
  },
  {
    "_id": 1422,
    "id": 1906,
    "pid": 225,
    "city_code": "101190509",
    "city_name": "通州区"
  },
  {
    "_id": 1423,
    "id": 1907,
    "pid": 225,
    "city_code": "101190508",
    "city_name": "海门市"
  },
  {
    "_id": 1424,
    "id": 1908,
    "pid": 225,
    "city_code": "101190502",
    "city_name": "海安县"
  },
  {
    "_id": 1425,
    "id": 1909,
    "pid": 225,
    "city_code": "101190504",
    "city_name": "如东县"
  },
  {
    "_id": 1426,
    "id": 1911,
    "pid": 226,
    "city_code": "101191305",
    "city_name": "宿豫区"
  },
  {
    "_id": 1427,
    "id": 1912,
    "pid": 226,
    "city_code": "101191305",
    "city_name": "宿豫县"
  },
  {
    "_id": 1428,
    "id": 1913,
    "pid": 226,
    "city_code": "101191302",
    "city_name": "沭阳县"
  },
  {
    "_id": 1429,
    "id": 1914,
    "pid": 226,
    "city_code": "101191303",
    "city_name": "泗阳县"
  },
  {
    "_id": 1430,
    "id": 1915,
    "pid": 226,
    "city_code": "101191304",
    "city_name": "泗洪县"
  },
  {
    "_id": 1431,
    "id": 1918,
    "pid": 227,
    "city_code": "101191202",
    "city_name": "兴化市"
  },
  {
    "_id": 1432,
    "id": 1919,
    "pid": 227,
    "city_code": "101191205",
    "city_name": "靖江市"
  },
  {
    "_id": 1433,
    "id": 1920,
    "pid": 227,
    "city_code": "101191203",
    "city_name": "泰兴市"
  },
  {
    "_id": 1434,
    "id": 1921,
    "pid": 227,
    "city_code": "101191204",
    "city_name": "姜堰区"
  },
  {
    "_id": 1435,
    "id": 1927,
    "pid": 228,
    "city_code": "101190807",
    "city_name": "新沂市"
  },
  {
    "_id": 1436,
    "id": 1928,
    "pid": 228,
    "city_code": "101190805",
    "city_name": "邳州市"
  },
  {
    "_id": 1437,
    "id": 1929,
    "pid": 228,
    "city_code": "101190803",
    "city_name": "丰县"
  },
  {
    "_id": 1438,
    "id": 1930,
    "pid": 228,
    "city_code": "101190804",
    "city_name": "沛县"
  },
  {
    "_id": 1439,
    "id": 1931,
    "pid": 228,
    "city_code": "101190802",
    "city_name": "铜山区"
  },
  {
    "_id": 1440,
    "id": 1932,
    "pid": 228,
    "city_code": "101190806",
    "city_name": "睢宁县"
  },
  {
    "_id": 1441,
    "id": 1935,
    "pid": 229,
    "city_code": "101190709",
    "city_name": "盐都区"
  },
  {
    "_id": 1442,
    "id": 1937,
    "pid": 229,
    "city_code": "101190707",
    "city_name": "东台市"
  },
  {
    "_id": 1443,
    "id": 1938,
    "pid": 229,
    "city_code": "101190708",
    "city_name": "大丰区"
  },
  {
    "_id": 1444,
    "id": 1939,
    "pid": 229,
    "city_code": "101190702",
    "city_name": "响水县"
  },
  {
    "_id": 1445,
    "id": 1940,
    "pid": 229,
    "city_code": "101190703",
    "city_name": "滨海县"
  },
  {
    "_id": 1446,
    "id": 1941,
    "pid": 229,
    "city_code": "101190704",
    "city_name": "阜宁县"
  },
  {
    "_id": 1447,
    "id": 1942,
    "pid": 229,
    "city_code": "101190705",
    "city_name": "射阳县"
  },
  {
    "_id": 1448,
    "id": 1943,
    "pid": 229,
    "city_code": "101190706",
    "city_name": "建湖县"
  },
  {
    "_id": 1449,
    "id": 1946,
    "pid": 230,
    "city_code": "101190606",
    "city_name": "邗江区"
  },
  {
    "_id": 1450,
    "id": 1947,
    "pid": 230,
    "city_code": "101190603",
    "city_name": "仪征市"
  },
  {
    "_id": 1451,
    "id": 1948,
    "pid": 230,
    "city_code": "101190604",
    "city_name": "高邮市"
  },
  {
    "_id": 1452,
    "id": 1949,
    "pid": 230,
    "city_code": "101190605",
    "city_name": "江都市"
  },
  {
    "_id": 1453,
    "id": 1950,
    "pid": 230,
    "city_code": "101190602",
    "city_name": "宝应县"
  },
  {
    "_id": 1454,
    "id": 1953,
    "pid": 231,
    "city_code": "101190305",
    "city_name": "丹徒区"
  },
  {
    "_id": 1455,
    "id": 1954,
    "pid": 231,
    "city_code": "101190302",
    "city_name": "丹阳市"
  },
  {
    "_id": 1456,
    "id": 1955,
    "pid": 231,
    "city_code": "101190303",
    "city_name": "扬中市"
  },
  {
    "_id": 1457,
    "id": 1956,
    "pid": 231,
    "city_code": "101190304",
    "city_name": "句容市"
  },
  {
    "_id": 1458,
    "id": 1965,
    "pid": 232,
    "city_code": "101240103",
    "city_name": "南昌县"
  },
  {
    "_id": 1459,
    "id": 1966,
    "pid": 232,
    "city_code": "101240102",
    "city_name": "新建县"
  },
  {
    "_id": 1460,
    "id": 1967,
    "pid": 232,
    "city_code": "101240104",
    "city_name": "安义县"
  },
  {
    "_id": 1461,
    "id": 1968,
    "pid": 232,
    "city_code": "101240105",
    "city_name": "进贤县"
  },
  {
    "_id": 1462,
    "id": 1970,
    "pid": 233,
    "city_code": "101240408",
    "city_name": "南城县"
  },
  {
    "_id": 1463,
    "id": 1971,
    "pid": 233,
    "city_code": "101240410",
    "city_name": "黎川县"
  },
  {
    "_id": 1464,
    "id": 1972,
    "pid": 233,
    "city_code": "101240409",
    "city_name": "南丰县"
  },
  {
    "_id": 1465,
    "id": 1973,
    "pid": 233,
    "city_code": "101240404",
    "city_name": "崇仁县"
  },
  {
    "_id": 1466,
    "id": 1974,
    "pid": 233,
    "city_code": "101240403",
    "city_name": "乐安县"
  },
  {
    "_id": 1467,
    "id": 1975,
    "pid": 233,
    "city_code": "101240407",
    "city_name": "宜黄县"
  },
  {
    "_id": 1468,
    "id": 1976,
    "pid": 233,
    "city_code": "101240405",
    "city_name": "金溪县"
  },
  {
    "_id": 1469,
    "id": 1977,
    "pid": 233,
    "city_code": "101240406",
    "city_name": "资溪县"
  },
  {
    "_id": 1470,
    "id": 1978,
    "pid": 233,
    "city_code": "101240411",
    "city_name": "东乡县"
  },
  {
    "_id": 1471,
    "id": 1979,
    "pid": 233,
    "city_code": "101240402",
    "city_name": "广昌县"
  },
  {
    "_id": 1472,
    "id": 1981,
    "pid": 234,
    "city_code": "101240710",
    "city_name": "于都县"
  },
  {
    "_id": 1473,
    "id": 1982,
    "pid": 234,
    "city_code": "101240709",
    "city_name": "瑞金市"
  },
  {
    "_id": 1474,
    "id": 1983,
    "pid": 234,
    "city_code": "101240704",
    "city_name": "南康市"
  },
  {
    "_id": 1475,
    "id": 1984,
    "pid": 234,
    "city_code": "101240718",
    "city_name": "赣县"
  },
  {
    "_id": 1476,
    "id": 1985,
    "pid": 234,
    "city_code": "101240706",
    "city_name": "信丰县"
  },
  {
    "_id": 1477,
    "id": 1986,
    "pid": 234,
    "city_code": "101240705",
    "city_name": "大余县"
  },
  {
    "_id": 1478,
    "id": 1987,
    "pid": 234,
    "city_code": "101240703",
    "city_name": "上犹县"
  },
  {
    "_id": 1479,
    "id": 1988,
    "pid": 234,
    "city_code": "101240702",
    "city_name": "崇义县"
  },
  {
    "_id": 1480,
    "id": 1989,
    "pid": 234,
    "city_code": "101240712",
    "city_name": "安远县"
  },
  {
    "_id": 1481,
    "id": 1990,
    "pid": 234,
    "city_code": "101240714",
    "city_name": "龙南县"
  },
  {
    "_id": 1482,
    "id": 1991,
    "pid": 234,
    "city_code": "101240715",
    "city_name": "定南县"
  },
  {
    "_id": 1483,
    "id": 1992,
    "pid": 234,
    "city_code": "101240713",
    "city_name": "全南县"
  },
  {
    "_id": 1484,
    "id": 1993,
    "pid": 234,
    "city_code": "101240707",
    "city_name": "宁都县"
  },
  {
    "_id": 1485,
    "id": 1994,
    "pid": 234,
    "city_code": "101240717",
    "city_name": "兴国县"
  },
  {
    "_id": 1486,
    "id": 1995,
    "pid": 234,
    "city_code": "101240711",
    "city_name": "会昌县"
  },
  {
    "_id": 1487,
    "id": 1996,
    "pid": 234,
    "city_code": "101240716",
    "city_name": "寻乌县"
  },
  {
    "_id": 1488,
    "id": 1997,
    "pid": 234,
    "city_code": "101240708",
    "city_name": "石城县"
  },
  {
    "_id": 1489,
    "id": 1998,
    "pid": 235,
    "city_code": "101240612",
    "city_name": "安福县"
  },
  {
    "_id": 1490,
    "id": 2001,
    "pid": 235,
    "city_code": "101240608",
    "city_name": "井冈山市"
  },
  {
    "_id": 1491,
    "id": 2002,
    "pid": 235,
    "city_code": "101240602",
    "city_name": "吉安县"
  },
  {
    "_id": 1492,
    "id": 2003,
    "pid": 235,
    "city_code": "101240603",
    "city_name": "吉水县"
  },
  {
    "_id": 1493,
    "id": 2004,
    "pid": 235,
    "city_code": "101240605",
    "city_name": "峡江县"
  },
  {
    "_id": 1494,
    "id": 2005,
    "pid": 235,
    "city_code": "101240604",
    "city_name": "新干县"
  },
  {
    "_id": 1495,
    "id": 2006,
    "pid": 235,
    "city_code": "101240606",
    "city_name": "永丰县"
  },
  {
    "_id": 1496,
    "id": 2007,
    "pid": 235,
    "city_code": "101240611",
    "city_name": "泰和县"
  },
  {
    "_id": 1497,
    "id": 2008,
    "pid": 235,
    "city_code": "101240610",
    "city_name": "遂川县"
  },
  {
    "_id": 1498,
    "id": 2009,
    "pid": 235,
    "city_code": "101240609",
    "city_name": "万安县"
  },
  {
    "_id": 1499,
    "id": 2010,
    "pid": 235,
    "city_code": "101240607",
    "city_name": "永新县"
  },
  {
    "_id": 1500,
    "id": 2013,
    "pid": 236,
    "city_code": "101240802",
    "city_name": "乐平市"
  },
  {
    "_id": 1501,
    "id": 2014,
    "pid": 236,
    "city_code": "101240803",
    "city_name": "浮梁县"
  },
  {
    "_id": 1502,
    "id": 2016,
    "pid": 237,
    "city_code": "101240203",
    "city_name": "庐山区"
  },
  {
    "_id": 1503,
    "id": 2017,
    "pid": 237,
    "city_code": "101240202",
    "city_name": "瑞昌市"
  },
  {
    "_id": 1504,
    "id": 2018,
    "pid": 237,
    "city_code": "101240201",
    "city_name": "九江县"
  },
  {
    "_id": 1505,
    "id": 2019,
    "pid": 237,
    "city_code": "101240204",
    "city_name": "武宁县"
  },
  {
    "_id": 1506,
    "id": 2020,
    "pid": 237,
    "city_code": "101240212",
    "city_name": "修水县"
  },
  {
    "_id": 1507,
    "id": 2021,
    "pid": 237,
    "city_code": "101240206",
    "city_name": "永修县"
  },
  {
    "_id": 1508,
    "id": 2022,
    "pid": 237,
    "city_code": "101240205",
    "city_name": "德安县"
  },
  {
    "_id": 1509,
    "id": 2023,
    "pid": 237,
    "city_code": "101240209",
    "city_name": "星子县"
  },
  {
    "_id": 1510,
    "id": 2024,
    "pid": 237,
    "city_code": "101240210",
    "city_name": "都昌县"
  },
  {
    "_id": 1511,
    "id": 2025,
    "pid": 237,
    "city_code": "101240207",
    "city_name": "湖口县"
  },
  {
    "_id": 1512,
    "id": 2026,
    "pid": 237,
    "city_code": "101240208",
    "city_name": "彭泽县"
  },
  {
    "_id": 1513,
    "id": 2027,
    "pid": 238,
    "city_code": "101240904",
    "city_name": "安源区"
  },
  {
    "_id": 1514,
    "id": 2028,
    "pid": 238,
    "city_code": "101240906",
    "city_name": "湘东区"
  },
  {
    "_id": 1515,
    "id": 2029,
    "pid": 238,
    "city_code": "101240902",
    "city_name": "莲花县"
  },
  {
    "_id": 1516,
    "id": 2030,
    "pid": 238,
    "city_code": "101240905",
    "city_name": "芦溪县"
  },
  {
    "_id": 1517,
    "id": 2031,
    "pid": 238,
    "city_code": "101240903",
    "city_name": "上栗县"
  },
  {
    "_id": 1518,
    "id": 2033,
    "pid": 239,
    "city_code": "101240307",
    "city_name": "德兴市"
  },
  {
    "_id": 1519,
    "id": 2034,
    "pid": 239,
    "city_code": "101240308",
    "city_name": "上饶县"
  },
  {
    "_id": 1520,
    "id": 2035,
    "pid": 239,
    "city_code": "101240313",
    "city_name": "广丰县"
  },
  {
    "_id": 1521,
    "id": 2036,
    "pid": 239,
    "city_code": "101240312",
    "city_name": "玉山县"
  },
  {
    "_id": 1522,
    "id": 2037,
    "pid": 239,
    "city_code": "101240311",
    "city_name": "铅山县"
  },
  {
    "_id": 1523,
    "id": 2038,
    "pid": 239,
    "city_code": "101240310",
    "city_name": "横峰县"
  },
  {
    "_id": 1524,
    "id": 2039,
    "pid": 239,
    "city_code": "101240309",
    "city_name": "弋阳县"
  },
  {
    "_id": 1525,
    "id": 2040,
    "pid": 239,
    "city_code": "101240305",
    "city_name": "余干县"
  },
  {
    "_id": 1526,
    "id": 2041,
    "pid": 239,
    "city_code": "101240302",
    "city_name": "鄱阳县"
  },
  {
    "_id": 1527,
    "id": 2042,
    "pid": 239,
    "city_code": "101240306",
    "city_name": "万年县"
  },
  {
    "_id": 1528,
    "id": 2043,
    "pid": 239,
    "city_code": "101240303",
    "city_name": "婺源县"
  },
  {
    "_id": 1529,
    "id": 2045,
    "pid": 240,
    "city_code": "101241002",
    "city_name": "分宜县"
  },
  {
    "_id": 1530,
    "id": 2047,
    "pid": 241,
    "city_code": "101240510",
    "city_name": "丰城市"
  },
  {
    "_id": 1531,
    "id": 2048,
    "pid": 241,
    "city_code": "101240509",
    "city_name": "樟树市"
  },
  {
    "_id": 1532,
    "id": 2049,
    "pid": 241,
    "city_code": "101240508",
    "city_name": "高安市"
  },
  {
    "_id": 1533,
    "id": 2050,
    "pid": 241,
    "city_code": "101240507",
    "city_name": "奉新县"
  },
  {
    "_id": 1534,
    "id": 2051,
    "pid": 241,
    "city_code": "101240504",
    "city_name": "万载县"
  },
  {
    "_id": 1535,
    "id": 2052,
    "pid": 241,
    "city_code": "101240505",
    "city_name": "上高县"
  },
  {
    "_id": 1536,
    "id": 2053,
    "pid": 241,
    "city_code": "101240503",
    "city_name": "宜丰县"
  },
  {
    "_id": 1537,
    "id": 2054,
    "pid": 241,
    "city_code": "101240506",
    "city_name": "靖安县"
  },
  {
    "_id": 1538,
    "id": 2055,
    "pid": 241,
    "city_code": "101240502",
    "city_name": "铜鼓县"
  },
  {
    "_id": 1539,
    "id": 2057,
    "pid": 242,
    "city_code": "101241103",
    "city_name": "贵溪市"
  },
  {
    "_id": 1540,
    "id": 2058,
    "pid": 242,
    "city_code": "101241102",
    "city_name": "余江县"
  },
  {
    "_id": 1541,
    "id": 2064,
    "pid": 243,
    "city_code": "101070102",
    "city_name": "苏家屯区"
  },
  {
    "_id": 1542,
    "id": 2067,
    "pid": 243,
    "city_code": "101070107",
    "city_name": "于洪区"
  },
  {
    "_id": 1543,
    "id": 2069,
    "pid": 243,
    "city_code": "101070106",
    "city_name": "新民市"
  },
  {
    "_id": 1544,
    "id": 2070,
    "pid": 243,
    "city_code": "101070103",
    "city_name": "辽中县"
  },
  {
    "_id": 1545,
    "id": 2071,
    "pid": 243,
    "city_code": "101070104",
    "city_name": "康平县"
  },
  {
    "_id": 1546,
    "id": 2072,
    "pid": 243,
    "city_code": "101070105",
    "city_name": "法库县"
  },
  {
    "_id": 1547,
    "id": 2077,
    "pid": 244,
    "city_code": "101070205",
    "city_name": "旅顺口区"
  },
  {
    "_id": 1548,
    "id": 2078,
    "pid": 244,
    "city_code": "101070203",
    "city_name": "金州区"
  },
  {
    "_id": 1549,
    "id": 2080,
    "pid": 244,
    "city_code": "101070202",
    "city_name": "瓦房店市"
  },
  {
    "_id": 1550,
    "id": 2081,
    "pid": 244,
    "city_code": "101070204",
    "city_name": "普兰店市"
  },
  {
    "_id": 1551,
    "id": 2082,
    "pid": 244,
    "city_code": "101070207",
    "city_name": "庄河市"
  },
  {
    "_id": 1552,
    "id": 2083,
    "pid": 244,
    "city_code": "101070206",
    "city_name": "长海县"
  },
  {
    "_id": 1553,
    "id": 2088,
    "pid": 245,
    "city_code": "101070303",
    "city_name": "岫岩县"
  },
  {
    "_id": 1554,
    "id": 2089,
    "pid": 245,
    "city_code": "101070304",
    "city_name": "海城市"
  },
  {
    "_id": 1555,
    "id": 2090,
    "pid": 245,
    "city_code": "101070302",
    "city_name": "台安县"
  },
  {
    "_id": 1556,
    "id": 2091,
    "pid": 246,
    "city_code": "101070502",
    "city_name": "本溪县"
  },
  {
    "_id": 1557,
    "id": 2096,
    "pid": 246,
    "city_code": "101070504",
    "city_name": "桓仁县"
  },
  {
    "_id": 1558,
    "id": 2099,
    "pid": 247,
    "city_code": "101071204",
    "city_name": "喀喇沁左翼蒙古族自治县"
  },
  {
    "_id": 1559,
    "id": 2100,
    "pid": 247,
    "city_code": "101071205",
    "city_name": "北票市"
  },
  {
    "_id": 1560,
    "id": 2101,
    "pid": 247,
    "city_code": "101071203",
    "city_name": "凌源市"
  },
  {
    "_id": 1561,
    "id": 2103,
    "pid": 247,
    "city_code": "101071207",
    "city_name": "建平县"
  },
  {
    "_id": 1562,
    "id": 2107,
    "pid": 248,
    "city_code": "101070603",
    "city_name": "宽甸县"
  },
  {
    "_id": 1563,
    "id": 2108,
    "pid": 248,
    "city_code": "101070604",
    "city_name": "东港市"
  },
  {
    "_id": 1564,
    "id": 2109,
    "pid": 248,
    "city_code": "101070602",
    "city_name": "凤城市"
  },
  {
    "_id": 1565,
    "id": 2114,
    "pid": 249,
    "city_code": "101070403",
    "city_name": "清原县"
  },
  {
    "_id": 1566,
    "id": 2115,
    "pid": 249,
    "city_code": "101070402",
    "city_name": "新宾县"
  },
  {
    "_id": 1567,
    "id": 2116,
    "pid": 249,
    "city_code": "101070401",
    "city_name": "抚顺县"
  },
  {
    "_id": 1568,
    "id": 2123,
    "pid": 250,
    "city_code": "101070902",
    "city_name": "彰武县"
  },
  {
    "_id": 1569,
    "id": 2127,
    "pid": 251,
    "city_code": "101071404",
    "city_name": "兴城市"
  },
  {
    "_id": 1570,
    "id": 2128,
    "pid": 251,
    "city_code": "101071403",
    "city_name": "绥中县"
  },
  {
    "_id": 1571,
    "id": 2129,
    "pid": 251,
    "city_code": "101071402",
    "city_name": "建昌县"
  },
  {
    "_id": 1572,
    "id": 2133,
    "pid": 252,
    "city_code": "101070702",
    "city_name": "凌海市"
  },
  {
    "_id": 1573,
    "id": 2134,
    "pid": 252,
    "city_code": "101070706",
    "city_name": "北镇市"
  },
  {
    "_id": 1574,
    "id": 2135,
    "pid": 252,
    "city_code": "101070705",
    "city_name": "黑山县"
  },
  {
    "_id": 1575,
    "id": 2136,
    "pid": 252,
    "city_code": "101070704",
    "city_name": "义县"
  },
  {
    "_id": 1576,
    "id": 2141,
    "pid": 253,
    "city_code": "101071004",
    "city_name": "弓长岭区"
  },
  {
    "_id": 1577,
    "id": 2142,
    "pid": 253,
    "city_code": "101071003",
    "city_name": "灯塔市"
  },
  {
    "_id": 1578,
    "id": 2143,
    "pid": 253,
    "city_code": "101071002",
    "city_name": "辽阳县"
  },
  {
    "_id": 1579,
    "id": 2146,
    "pid": 254,
    "city_code": "101071302",
    "city_name": "大洼县"
  },
  {
    "_id": 1580,
    "id": 2147,
    "pid": 254,
    "city_code": "101071303",
    "city_name": "盘山县"
  },
  {
    "_id": 1581,
    "id": 2150,
    "pid": 255,
    "city_code": "101071105",
    "city_name": "调兵山市"
  },
  {
    "_id": 1582,
    "id": 2151,
    "pid": 255,
    "city_code": "101071102",
    "city_name": "开原市"
  },
  {
    "_id": 1583,
    "id": 2152,
    "pid": 255,
    "city_code": "101071101",
    "city_name": "铁岭县"
  },
  {
    "_id": 1584,
    "id": 2153,
    "pid": 255,
    "city_code": "101071104",
    "city_name": "西丰县"
  },
  {
    "_id": 1585,
    "id": 2154,
    "pid": 255,
    "city_code": "101071103",
    "city_name": "昌图县"
  },
  {
    "_id": 1586,
    "id": 2159,
    "pid": 256,
    "city_code": "101070803",
    "city_name": "盖州市"
  },
  {
    "_id": 1587,
    "id": 2160,
    "pid": 256,
    "city_code": "101070802",
    "city_name": "大石桥市"
  },
  {
    "_id": 1588,
    "id": 2165,
    "pid": 257,
    "city_code": "101080105",
    "city_name": "清水河县"
  },
  {
    "_id": 1589,
    "id": 2166,
    "pid": 257,
    "city_code": "101080102",
    "city_name": "土默特左旗"
  },
  {
    "_id": 1590,
    "id": 2167,
    "pid": 257,
    "city_code": "101080103",
    "city_name": "托克托县"
  },
  {
    "_id": 1591,
    "id": 2168,
    "pid": 257,
    "city_code": "101080104",
    "city_name": "和林格尔县"
  },
  {
    "_id": 1592,
    "id": 2169,
    "pid": 257,
    "city_code": "101080107",
    "city_name": "武川县"
  },
  {
    "_id": 1593,
    "id": 2170,
    "pid": 258,
    "city_code": "101081201",
    "city_name": "阿拉善左旗"
  },
  {
    "_id": 1594,
    "id": 2171,
    "pid": 258,
    "city_code": "101081202",
    "city_name": "阿拉善右旗"
  },
  {
    "_id": 1595,
    "id": 2172,
    "pid": 258,
    "city_code": "101081203",
    "city_name": "额济纳旗"
  },
  {
    "_id": 1596,
    "id": 2173,
    "pid": 259,
    "city_code": "101080801",
    "city_name": "临河区"
  },
  {
    "_id": 1597,
    "id": 2174,
    "pid": 259,
    "city_code": "101080802",
    "city_name": "五原县"
  },
  {
    "_id": 1598,
    "id": 2175,
    "pid": 259,
    "city_code": "101080803",
    "city_name": "磴口县"
  },
  {
    "_id": 1599,
    "id": 2176,
    "pid": 259,
    "city_code": "101080804",
    "city_name": "乌拉特前旗"
  },
  {
    "_id": 1600,
    "id": 2177,
    "pid": 259,
    "city_code": "101080806",
    "city_name": "乌拉特中旗"
  },
  {
    "_id": 1601,
    "id": 2178,
    "pid": 259,
    "city_code": "101080807",
    "city_name": "乌拉特后旗"
  },
  {
    "_id": 1602,
    "id": 2179,
    "pid": 259,
    "city_code": "101080810",
    "city_name": "杭锦后旗"
  },
  {
    "_id": 1603,
    "id": 2184,
    "pid": 260,
    "city_code": "101080207",
    "city_name": "石拐区"
  },
  {
    "_id": 1604,
    "id": 2185,
    "pid": 260,
    "city_code": "101080202",
    "city_name": "白云鄂博"
  },
  {
    "_id": 1605,
    "id": 2186,
    "pid": 260,
    "city_code": "101080204",
    "city_name": "土默特右旗"
  },
  {
    "_id": 1606,
    "id": 2187,
    "pid": 260,
    "city_code": "101080205",
    "city_name": "固阳县"
  },
  {
    "_id": 1607,
    "id": 2188,
    "pid": 260,
    "city_code": "101080206",
    "city_name": "达尔罕茂明安联合旗"
  },
  {
    "_id": 1608,
    "id": 2192,
    "pid": 261,
    "city_code": "101080603",
    "city_name": "阿鲁科尔沁旗"
  },
  {
    "_id": 1609,
    "id": 2193,
    "pid": 261,
    "city_code": "101080605",
    "city_name": "巴林左旗"
  },
  {
    "_id": 1610,
    "id": 2194,
    "pid": 261,
    "city_code": "101080606",
    "city_name": "巴林右旗"
  },
  {
    "_id": 1611,
    "id": 2195,
    "pid": 261,
    "city_code": "101080607",
    "city_name": "林西县"
  },
  {
    "_id": 1612,
    "id": 2196,
    "pid": 261,
    "city_code": "101080608",
    "city_name": "克什克腾旗"
  },
  {
    "_id": 1613,
    "id": 2197,
    "pid": 261,
    "city_code": "101080609",
    "city_name": "翁牛特旗"
  },
  {
    "_id": 1614,
    "id": 2198,
    "pid": 261,
    "city_code": "101080611",
    "city_name": "喀喇沁旗"
  },
  {
    "_id": 1615,
    "id": 2199,
    "pid": 261,
    "city_code": "101080613",
    "city_name": "宁城县"
  },
  {
    "_id": 1616,
    "id": 2200,
    "pid": 261,
    "city_code": "101080614",
    "city_name": "敖汉旗"
  },
  {
    "_id": 1617,
    "id": 2201,
    "pid": 262,
    "city_code": "101080713",
    "city_name": "东胜区"
  },
  {
    "_id": 1618,
    "id": 2202,
    "pid": 262,
    "city_code": "101080703",
    "city_name": "达拉特旗"
  },
  {
    "_id": 1619,
    "id": 2203,
    "pid": 262,
    "city_code": "101080704",
    "city_name": "准格尔旗"
  },
  {
    "_id": 1620,
    "id": 2204,
    "pid": 262,
    "city_code": "101080705",
    "city_name": "鄂托克前旗"
  },
  {
    "_id": 1621,
    "id": 2205,
    "pid": 262,
    "city_code": "101080708",
    "city_name": "鄂托克旗"
  },
  {
    "_id": 1622,
    "id": 2206,
    "pid": 262,
    "city_code": "101080709",
    "city_name": "杭锦旗"
  },
  {
    "_id": 1623,
    "id": 2207,
    "pid": 262,
    "city_code": "101080710",
    "city_name": "乌审旗"
  },
  {
    "_id": 1624,
    "id": 2208,
    "pid": 262,
    "city_code": "101080711",
    "city_name": "伊金霍洛旗"
  },
  {
    "_id": 1625,
    "id": 2209,
    "pid": 263,
    "city_code": "101081001",
    "city_name": "海拉尔区"
  },
  {
    "_id": 1626,
    "id": 2210,
    "pid": 263,
    "city_code": "101081004",
    "city_name": "莫力达瓦"
  },
  {
    "_id": 1627,
    "id": 2211,
    "pid": 263,
    "city_code": "101081010",
    "city_name": "满洲里市"
  },
  {
    "_id": 1628,
    "id": 2212,
    "pid": 263,
    "city_code": "101081011",
    "city_name": "牙克石市"
  },
  {
    "_id": 1629,
    "id": 2213,
    "pid": 263,
    "city_code": "101081012",
    "city_name": "扎兰屯市"
  },
  {
    "_id": 1630,
    "id": 2214,
    "pid": 263,
    "city_code": "101081014",
    "city_name": "额尔古纳市"
  },
  {
    "_id": 1631,
    "id": 2215,
    "pid": 263,
    "city_code": "101081015",
    "city_name": "根河市"
  },
  {
    "_id": 1632,
    "id": 2216,
    "pid": 263,
    "city_code": "101081003",
    "city_name": "阿荣旗"
  },
  {
    "_id": 1633,
    "id": 2217,
    "pid": 263,
    "city_code": "101081005",
    "city_name": "鄂伦春自治旗"
  },
  {
    "_id": 1634,
    "id": 2218,
    "pid": 263,
    "city_code": "101081006",
    "city_name": "鄂温克族自治旗"
  },
  {
    "_id": 1635,
    "id": 2219,
    "pid": 263,
    "city_code": "101081007",
    "city_name": "陈巴尔虎旗"
  },
  {
    "_id": 1636,
    "id": 2220,
    "pid": 263,
    "city_code": "101081008",
    "city_name": "新巴尔虎左旗"
  },
  {
    "_id": 1637,
    "id": 2221,
    "pid": 263,
    "city_code": "101081009",
    "city_name": "新巴尔虎右旗"
  },
  {
    "_id": 1638,
    "id": 2223,
    "pid": 264,
    "city_code": "101080512",
    "city_name": "霍林郭勒市"
  },
  {
    "_id": 1639,
    "id": 2224,
    "pid": 264,
    "city_code": "101080503",
    "city_name": "科尔沁左翼中旗"
  },
  {
    "_id": 1640,
    "id": 2225,
    "pid": 264,
    "city_code": "101080504",
    "city_name": "科尔沁左翼后旗"
  },
  {
    "_id": 1641,
    "id": 2226,
    "pid": 264,
    "city_code": "101080506",
    "city_name": "开鲁县"
  },
  {
    "_id": 1642,
    "id": 2227,
    "pid": 264,
    "city_code": "101080507",
    "city_name": "库伦旗"
  },
  {
    "_id": 1643,
    "id": 2228,
    "pid": 264,
    "city_code": "101080508",
    "city_name": "奈曼旗"
  },
  {
    "_id": 1644,
    "id": 2229,
    "pid": 264,
    "city_code": "101080509",
    "city_name": "扎鲁特旗"
  },
  {
    "_id": 1645,
    "id": 2233,
    "pid": 266,
    "city_code": "101080403",
    "city_name": "化德县"
  },
  {
    "_id": 1646,
    "id": 2234,
    "pid": 266,
    "city_code": "101080401",
    "city_name": "集宁区"
  },
  {
    "_id": 1647,
    "id": 2235,
    "pid": 266,
    "city_code": "101080412",
    "city_name": "丰镇市"
  },
  {
    "_id": 1648,
    "id": 2236,
    "pid": 266,
    "city_code": "101080402",
    "city_name": "卓资县"
  },
  {
    "_id": 1649,
    "id": 2237,
    "pid": 266,
    "city_code": "101080404",
    "city_name": "商都县"
  },
  {
    "_id": 1650,
    "id": 2238,
    "pid": 266,
    "city_code": "101080406",
    "city_name": "兴和县"
  },
  {
    "_id": 1651,
    "id": 2239,
    "pid": 266,
    "city_code": "101080407",
    "city_name": "凉城县"
  },
  {
    "_id": 1652,
    "id": 2240,
    "pid": 266,
    "city_code": "101080408",
    "city_name": "察哈尔右翼前旗"
  },
  {
    "_id": 1653,
    "id": 2241,
    "pid": 266,
    "city_code": "101080409",
    "city_name": "察哈尔右翼中旗"
  },
  {
    "_id": 1654,
    "id": 2242,
    "pid": 266,
    "city_code": "101080410",
    "city_name": "察哈尔右翼后旗"
  },
  {
    "_id": 1655,
    "id": 2243,
    "pid": 266,
    "city_code": "101080411",
    "city_name": "四子王旗"
  },
  {
    "_id": 1656,
    "id": 2244,
    "pid": 267,
    "city_code": "101080903",
    "city_name": "二连浩特市"
  },
  {
    "_id": 1657,
    "id": 2245,
    "pid": 267,
    "city_code": "101080901",
    "city_name": "锡林浩特市"
  },
  {
    "_id": 1658,
    "id": 2246,
    "pid": 267,
    "city_code": "101080904",
    "city_name": "阿巴嘎旗"
  },
  {
    "_id": 1659,
    "id": 2247,
    "pid": 267,
    "city_code": "101080906",
    "city_name": "苏尼特左旗"
  },
  {
    "_id": 1660,
    "id": 2248,
    "pid": 267,
    "city_code": "101080907",
    "city_name": "苏尼特右旗"
  },
  {
    "_id": 1661,
    "id": 2249,
    "pid": 267,
    "city_code": "101080909",
    "city_name": "东乌珠穆沁旗"
  },
  {
    "_id": 1662,
    "id": 2250,
    "pid": 267,
    "city_code": "101080910",
    "city_name": "西乌珠穆沁旗"
  },
  {
    "_id": 1663,
    "id": 2251,
    "pid": 267,
    "city_code": "101080911",
    "city_name": "太仆寺旗"
  },
  {
    "_id": 1664,
    "id": 2252,
    "pid": 267,
    "city_code": "101080912",
    "city_name": "镶黄旗"
  },
  {
    "_id": 1665,
    "id": 2253,
    "pid": 267,
    "city_code": "101080913",
    "city_name": "正镶白旗"
  },
  {
    "_id": 1666,
    "id": 2255,
    "pid": 267,
    "city_code": "101080915",
    "city_name": "多伦县"
  },
  {
    "_id": 1667,
    "id": 2256,
    "pid": 268,
    "city_code": "101081101",
    "city_name": "乌兰浩特市"
  },
  {
    "_id": 1668,
    "id": 2257,
    "pid": 268,
    "city_code": "101081102",
    "city_name": "阿尔山市"
  },
  {
    "_id": 1669,
    "id": 2258,
    "pid": 268,
    "city_code": "101081109",
    "city_name": "科尔沁右翼前旗"
  },
  {
    "_id": 1670,
    "id": 2259,
    "pid": 268,
    "city_code": "101081103",
    "city_name": "科尔沁右翼中旗"
  },
  {
    "_id": 1671,
    "id": 2260,
    "pid": 268,
    "city_code": "101081105",
    "city_name": "扎赉特旗"
  },
  {
    "_id": 1672,
    "id": 2261,
    "pid": 268,
    "city_code": "101081107",
    "city_name": "突泉县"
  },
  {
    "_id": 1673,
    "id": 2265,
    "pid": 269,
    "city_code": "101170103",
    "city_name": "灵武市"
  },
  {
    "_id": 1674,
    "id": 2266,
    "pid": 269,
    "city_code": "101170102",
    "city_name": "永宁县"
  },
  {
    "_id": 1675,
    "id": 2267,
    "pid": 269,
    "city_code": "101170104",
    "city_name": "贺兰县"
  },
  {
    "_id": 1676,
    "id": 2270,
    "pid": 270,
    "city_code": "101170402",
    "city_name": "西吉县"
  },
  {
    "_id": 1677,
    "id": 2271,
    "pid": 270,
    "city_code": "101170403",
    "city_name": "隆德县"
  },
  {
    "_id": 1678,
    "id": 2272,
    "pid": 270,
    "city_code": "101170404",
    "city_name": "泾源县"
  },
  {
    "_id": 1679,
    "id": 2273,
    "pid": 270,
    "city_code": "101170406",
    "city_name": "彭阳县"
  },
  {
    "_id": 1680,
    "id": 2274,
    "pid": 271,
    "city_code": "101170202",
    "city_name": "惠农区"
  },
  {
    "_id": 1681,
    "id": 2275,
    "pid": 271,
    "city_code": "101170206",
    "city_name": "大武口区"
  },
  {
    "_id": 1682,
    "id": 2276,
    "pid": 271,
    "city_code": "101170202",
    "city_name": "惠农区"
  },
  {
    "_id": 1683,
    "id": 2277,
    "pid": 271,
    "city_code": "101170204",
    "city_name": "陶乐县"
  },
  {
    "_id": 1684,
    "id": 2278,
    "pid": 271,
    "city_code": "101170203",
    "city_name": "平罗县"
  },
  {
    "_id": 1685,
    "id": 2281,
    "pid": 272,
    "city_code": "101170306",
    "city_name": "青铜峡市"
  },
  {
    "_id": 1686,
    "id": 2283,
    "pid": 272,
    "city_code": "101170303",
    "city_name": "盐池县"
  },
  {
    "_id": 1687,
    "id": 2284,
    "pid": 272,
    "city_code": "101170302",
    "city_name": "同心县"
  },
  {
    "_id": 1688,
    "id": 2286,
    "pid": 273,
    "city_code": "101170504",
    "city_name": "海原县"
  },
  {
    "_id": 1689,
    "id": 2287,
    "pid": 273,
    "city_code": "101170502",
    "city_name": "中宁县"
  },
  {
    "_id": 1690,
    "id": 2292,
    "pid": 274,
    "city_code": "101150104",
    "city_name": "湟中县"
  },
  {
    "_id": 1691,
    "id": 2293,
    "pid": 274,
    "city_code": "101150103",
    "city_name": "湟源县"
  },
  {
    "_id": 1692,
    "id": 2294,
    "pid": 274,
    "city_code": "101150102",
    "city_name": "大通县"
  },
  {
    "_id": 1693,
    "id": 2295,
    "pid": 275,
    "city_code": "101150508",
    "city_name": "玛沁县"
  },
  {
    "_id": 1694,
    "id": 2296,
    "pid": 275,
    "city_code": "101150502",
    "city_name": "班玛县"
  },
  {
    "_id": 1695,
    "id": 2297,
    "pid": 275,
    "city_code": "101150503",
    "city_name": "甘德县"
  },
  {
    "_id": 1696,
    "id": 2298,
    "pid": 275,
    "city_code": "101150504",
    "city_name": "达日县"
  },
  {
    "_id": 1697,
    "id": 2299,
    "pid": 275,
    "city_code": "101150505",
    "city_name": "久治县"
  },
  {
    "_id": 1698,
    "id": 2300,
    "pid": 275,
    "city_code": "101150506",
    "city_name": "玛多县"
  },
  {
    "_id": 1699,
    "id": 2301,
    "pid": 276,
    "city_code": "101150804",
    "city_name": "海晏县"
  },
  {
    "_id": 1700,
    "id": 2302,
    "pid": 276,
    "city_code": "101150803",
    "city_name": "祁连县"
  },
  {
    "_id": 1701,
    "id": 2303,
    "pid": 276,
    "city_code": "101150806",
    "city_name": "刚察县"
  },
  {
    "_id": 1702,
    "id": 2304,
    "pid": 276,
    "city_code": "101150802",
    "city_name": "门源县"
  },
  {
    "_id": 1703,
    "id": 2305,
    "pid": 277,
    "city_code": "101150208",
    "city_name": "平安县"
  },
  {
    "_id": 1704,
    "id": 2306,
    "pid": 277,
    "city_code": "101150202",
    "city_name": "乐都县"
  },
  {
    "_id": 1705,
    "id": 2307,
    "pid": 277,
    "city_code": "101150203",
    "city_name": "民和县"
  },
  {
    "_id": 1706,
    "id": 2308,
    "pid": 277,
    "city_code": "101150204",
    "city_name": "互助县"
  },
  {
    "_id": 1707,
    "id": 2309,
    "pid": 277,
    "city_code": "101150205",
    "city_name": "化隆县"
  },
  {
    "_id": 1708,
    "id": 2310,
    "pid": 277,
    "city_code": "101150206",
    "city_name": "循化县"
  },
  {
    "_id": 1709,
    "id": 2311,
    "pid": 278,
    "city_code": "101150409",
    "city_name": "共和县"
  },
  {
    "_id": 1710,
    "id": 2312,
    "pid": 278,
    "city_code": "101150408",
    "city_name": "同德县"
  },
  {
    "_id": 1711,
    "id": 2313,
    "pid": 278,
    "city_code": "101150404",
    "city_name": "贵德县"
  },
  {
    "_id": 1712,
    "id": 2314,
    "pid": 278,
    "city_code": "101150406",
    "city_name": "兴海县"
  },
  {
    "_id": 1713,
    "id": 2315,
    "pid": 278,
    "city_code": "101150407",
    "city_name": "贵南县"
  },
  {
    "_id": 1714,
    "id": 2316,
    "pid": 279,
    "city_code": "101150716",
    "city_name": "德令哈市"
  },
  {
    "_id": 1715,
    "id": 2317,
    "pid": 279,
    "city_code": "101150702",
    "city_name": "格尔木市"
  },
  {
    "_id": 1716,
    "id": 2318,
    "pid": 279,
    "city_code": "101150709",
    "city_name": "乌兰县"
  },
  {
    "_id": 1717,
    "id": 2319,
    "pid": 279,
    "city_code": "101150710",
    "city_name": "都兰县"
  },
  {
    "_id": 1718,
    "id": 2320,
    "pid": 279,
    "city_code": "101150708",
    "city_name": "天峻县"
  },
  {
    "_id": 1719,
    "id": 2321,
    "pid": 280,
    "city_code": "101150305",
    "city_name": "同仁县"
  },
  {
    "_id": 1720,
    "id": 2322,
    "pid": 280,
    "city_code": "101150302",
    "city_name": "尖扎县"
  },
  {
    "_id": 1721,
    "id": 2323,
    "pid": 280,
    "city_code": "101150303",
    "city_name": "泽库县"
  },
  {
    "_id": 1722,
    "id": 2324,
    "pid": 280,
    "city_code": "101150304",
    "city_name": "河南蒙古族自治县"
  },
  {
    "_id": 1723,
    "id": 2325,
    "pid": 281,
    "city_code": "101150601",
    "city_name": "玉树县"
  },
  {
    "_id": 1724,
    "id": 2326,
    "pid": 281,
    "city_code": "101150604",
    "city_name": "杂多县"
  },
  {
    "_id": 1725,
    "id": 2327,
    "pid": 281,
    "city_code": "101150602",
    "city_name": "称多县"
  },
  {
    "_id": 1726,
    "id": 2328,
    "pid": 281,
    "city_code": "101150603",
    "city_name": "治多县"
  },
  {
    "_id": 1727,
    "id": 2329,
    "pid": 281,
    "city_code": "101150605",
    "city_name": "囊谦县"
  },
  {
    "_id": 1728,
    "id": 2330,
    "pid": 281,
    "city_code": "101150606",
    "city_name": "曲麻莱县"
  },
  {
    "_id": 1729,
    "id": 2336,
    "pid": 282,
    "city_code": "101120102",
    "city_name": "长清区"
  },
  {
    "_id": 1730,
    "id": 2337,
    "pid": 282,
    "city_code": "101120104",
    "city_name": "章丘市"
  },
  {
    "_id": 1731,
    "id": 2338,
    "pid": 282,
    "city_code": "101120105",
    "city_name": "平阴县"
  },
  {
    "_id": 1732,
    "id": 2339,
    "pid": 282,
    "city_code": "101120106",
    "city_name": "济阳县"
  },
  {
    "_id": 1733,
    "id": 2340,
    "pid": 282,
    "city_code": "101120103",
    "city_name": "商河县"
  },
  {
    "_id": 1734,
    "id": 2347,
    "pid": 283,
    "city_code": "101120202",
    "city_name": "崂山区"
  },
  {
    "_id": 1735,
    "id": 2348,
    "pid": 283,
    "city_code": "101120205",
    "city_name": "胶州市"
  },
  {
    "_id": 1736,
    "id": 2349,
    "pid": 283,
    "city_code": "101120204",
    "city_name": "即墨市"
  },
  {
    "_id": 1737,
    "id": 2350,
    "pid": 283,
    "city_code": "101120208",
    "city_name": "平度市"
  },
  {
    "_id": 1738,
    "id": 2351,
    "pid": 283,
    "city_code": "101120206",
    "city_name": "胶南市"
  },
  {
    "_id": 1739,
    "id": 2352,
    "pid": 283,
    "city_code": "101120207",
    "city_name": "莱西市"
  },
  {
    "_id": 1740,
    "id": 2354,
    "pid": 284,
    "city_code": "101121105",
    "city_name": "惠民县"
  },
  {
    "_id": 1741,
    "id": 2355,
    "pid": 284,
    "city_code": "101121104",
    "city_name": "阳信县"
  },
  {
    "_id": 1742,
    "id": 2356,
    "pid": 284,
    "city_code": "101121103",
    "city_name": "无棣县"
  },
  {
    "_id": 1743,
    "id": 2357,
    "pid": 284,
    "city_code": "101121106",
    "city_name": "沾化县"
  },
  {
    "_id": 1744,
    "id": 2358,
    "pid": 284,
    "city_code": "101121102",
    "city_name": "博兴县"
  },
  {
    "_id": 1745,
    "id": 2359,
    "pid": 284,
    "city_code": "101121107",
    "city_name": "邹平县"
  },
  {
    "_id": 1746,
    "id": 2361,
    "pid": 285,
    "city_code": "101120404",
    "city_name": "陵县"
  },
  {
    "_id": 1747,
    "id": 2362,
    "pid": 285,
    "city_code": "101120406",
    "city_name": "乐陵市"
  },
  {
    "_id": 1748,
    "id": 2363,
    "pid": 285,
    "city_code": "101120411",
    "city_name": "禹城市"
  },
  {
    "_id": 1749,
    "id": 2364,
    "pid": 285,
    "city_code": "101120409",
    "city_name": "宁津县"
  },
  {
    "_id": 1750,
    "id": 2365,
    "pid": 285,
    "city_code": "101120407",
    "city_name": "庆云县"
  },
  {
    "_id": 1751,
    "id": 2366,
    "pid": 285,
    "city_code": "101120403",
    "city_name": "临邑县"
  },
  {
    "_id": 1752,
    "id": 2367,
    "pid": 285,
    "city_code": "101120405",
    "city_name": "齐河县"
  },
  {
    "_id": 1753,
    "id": 2368,
    "pid": 285,
    "city_code": "101120408",
    "city_name": "平原县"
  },
  {
    "_id": 1754,
    "id": 2369,
    "pid": 285,
    "city_code": "101120410",
    "city_name": "夏津县"
  },
  {
    "_id": 1755,
    "id": 2370,
    "pid": 285,
    "city_code": "101120402",
    "city_name": "武城县"
  },
  {
    "_id": 1756,
    "id": 2371,
    "pid": 286,
    "city_code": "101121201",
    "city_name": "东营区"
  },
  {
    "_id": 1757,
    "id": 2372,
    "pid": 286,
    "city_code": "101121202",
    "city_name": "河口区"
  },
  {
    "_id": 1758,
    "id": 2373,
    "pid": 286,
    "city_code": "101121203",
    "city_name": "垦利县"
  },
  {
    "_id": 1759,
    "id": 2374,
    "pid": 286,
    "city_code": "101121204",
    "city_name": "利津县"
  },
  {
    "_id": 1760,
    "id": 2375,
    "pid": 286,
    "city_code": "101121205",
    "city_name": "广饶县"
  },
  {
    "_id": 1761,
    "id": 2377,
    "pid": 287,
    "city_code": "101121007",
    "city_name": "曹县"
  },
  {
    "_id": 1762,
    "id": 2378,
    "pid": 287,
    "city_code": "101121009",
    "city_name": "单县"
  },
  {
    "_id": 1763,
    "id": 2379,
    "pid": 287,
    "city_code": "101121008",
    "city_name": "成武县"
  },
  {
    "_id": 1764,
    "id": 2380,
    "pid": 287,
    "city_code": "101121006",
    "city_name": "巨野县"
  },
  {
    "_id": 1765,
    "id": 2381,
    "pid": 287,
    "city_code": "101121003",
    "city_name": "郓城县"
  },
  {
    "_id": 1766,
    "id": 2382,
    "pid": 287,
    "city_code": "101121002",
    "city_name": "鄄城县"
  },
  {
    "_id": 1767,
    "id": 2383,
    "pid": 287,
    "city_code": "101121005",
    "city_name": "定陶县"
  },
  {
    "_id": 1768,
    "id": 2384,
    "pid": 287,
    "city_code": "101121004",
    "city_name": "东明县"
  },
  {
    "_id": 1769,
    "id": 2387,
    "pid": 288,
    "city_code": "101120710",
    "city_name": "曲阜市"
  },
  {
    "_id": 1770,
    "id": 2388,
    "pid": 288,
    "city_code": "101120705",
    "city_name": "兖州市"
  },
  {
    "_id": 1771,
    "id": 2389,
    "pid": 288,
    "city_code": "101120711",
    "city_name": "邹城市"
  },
  {
    "_id": 1772,
    "id": 2390,
    "pid": 288,
    "city_code": "101120703",
    "city_name": "微山县"
  },
  {
    "_id": 1773,
    "id": 2391,
    "pid": 288,
    "city_code": "101120704",
    "city_name": "鱼台县"
  },
  {
    "_id": 1774,
    "id": 2392,
    "pid": 288,
    "city_code": "101120706",
    "city_name": "金乡县"
  },
  {
    "_id": 1775,
    "id": 2393,
    "pid": 288,
    "city_code": "101120702",
    "city_name": "嘉祥县"
  },
  {
    "_id": 1776,
    "id": 2394,
    "pid": 288,
    "city_code": "101120707",
    "city_name": "汶上县"
  },
  {
    "_id": 1777,
    "id": 2395,
    "pid": 288,
    "city_code": "101120708",
    "city_name": "泗水县"
  },
  {
    "_id": 1778,
    "id": 2396,
    "pid": 288,
    "city_code": "101120709",
    "city_name": "梁山县"
  },
  {
    "_id": 1779,
    "id": 2400,
    "pid": 290,
    "city_code": "101121707",
    "city_name": "临清市"
  },
  {
    "_id": 1780,
    "id": 2401,
    "pid": 290,
    "city_code": "101121703",
    "city_name": "阳谷县"
  },
  {
    "_id": 1781,
    "id": 2402,
    "pid": 290,
    "city_code": "101121709",
    "city_name": "莘县"
  },
  {
    "_id": 1782,
    "id": 2403,
    "pid": 290,
    "city_code": "101121705",
    "city_name": "茌平县"
  },
  {
    "_id": 1783,
    "id": 2404,
    "pid": 290,
    "city_code": "101121706",
    "city_name": "东阿县"
  },
  {
    "_id": 1784,
    "id": 2405,
    "pid": 290,
    "city_code": "101121702",
    "city_name": "冠县"
  },
  {
    "_id": 1785,
    "id": 2406,
    "pid": 290,
    "city_code": "101121704",
    "city_name": "高唐县"
  },
  {
    "_id": 1786,
    "id": 2410,
    "pid": 291,
    "city_code": "101120903",
    "city_name": "沂南县"
  },
  {
    "_id": 1787,
    "id": 2411,
    "pid": 291,
    "city_code": "101120906",
    "city_name": "郯城县"
  },
  {
    "_id": 1788,
    "id": 2412,
    "pid": 291,
    "city_code": "101120910",
    "city_name": "沂水县"
  },
  {
    "_id": 1789,
    "id": 2413,
    "pid": 291,
    "city_code": "101120904",
    "city_name": "兰陵县"
  },
  {
    "_id": 1790,
    "id": 2414,
    "pid": 291,
    "city_code": "101120909",
    "city_name": "费县"
  },
  {
    "_id": 1791,
    "id": 2415,
    "pid": 291,
    "city_code": "101120908",
    "city_name": "平邑县"
  },
  {
    "_id": 1792,
    "id": 2416,
    "pid": 291,
    "city_code": "101120902",
    "city_name": "莒南县"
  },
  {
    "_id": 1793,
    "id": 2417,
    "pid": 291,
    "city_code": "101120907",
    "city_name": "蒙阴县"
  },
  {
    "_id": 1794,
    "id": 2418,
    "pid": 291,
    "city_code": "101120905",
    "city_name": "临沭县"
  },
  {
    "_id": 1795,
    "id": 2421,
    "pid": 292,
    "city_code": "101121502",
    "city_name": "五莲县"
  },
  {
    "_id": 1796,
    "id": 2422,
    "pid": 292,
    "city_code": "101121503",
    "city_name": "莒县"
  },
  {
    "_id": 1797,
    "id": 2423,
    "pid": 293,
    "city_code": "101120803",
    "city_name": "泰山区"
  },
  {
    "_id": 1798,
    "id": 2425,
    "pid": 293,
    "city_code": "101120802",
    "city_name": "新泰市"
  },
  {
    "_id": 1799,
    "id": 2426,
    "pid": 293,
    "city_code": "101120804",
    "city_name": "肥城市"
  },
  {
    "_id": 1800,
    "id": 2427,
    "pid": 293,
    "city_code": "101120806",
    "city_name": "宁阳县"
  },
  {
    "_id": 1801,
    "id": 2428,
    "pid": 293,
    "city_code": "101120805",
    "city_name": "东平县"
  },
  {
    "_id": 1802,
    "id": 2429,
    "pid": 294,
    "city_code": "101121303",
    "city_name": "荣成市"
  },
  {
    "_id": 1803,
    "id": 2430,
    "pid": 294,
    "city_code": "101121304",
    "city_name": "乳山市"
  },
  {
    "_id": 1804,
    "id": 2432,
    "pid": 294,
    "city_code": "101121302",
    "city_name": "文登市"
  },
  {
    "_id": 1805,
    "id": 2437,
    "pid": 295,
    "city_code": "101120602",
    "city_name": "青州市"
  },
  {
    "_id": 1806,
    "id": 2438,
    "pid": 295,
    "city_code": "101120609",
    "city_name": "诸城市"
  },
  {
    "_id": 1807,
    "id": 2439,
    "pid": 295,
    "city_code": "101120603",
    "city_name": "寿光市"
  },
  {
    "_id": 1808,
    "id": 2440,
    "pid": 295,
    "city_code": "101120607",
    "city_name": "安丘市"
  },
  {
    "_id": 1809,
    "id": 2441,
    "pid": 295,
    "city_code": "101120608",
    "city_name": "高密市"
  },
  {
    "_id": 1810,
    "id": 2442,
    "pid": 295,
    "city_code": "101120606",
    "city_name": "昌邑市"
  },
  {
    "_id": 1811,
    "id": 2443,
    "pid": 295,
    "city_code": "101120604",
    "city_name": "临朐县"
  },
  {
    "_id": 1812,
    "id": 2444,
    "pid": 295,
    "city_code": "101120605",
    "city_name": "昌乐县"
  },
  {
    "_id": 1813,
    "id": 2446,
    "pid": 296,
    "city_code": "101120508",
    "city_name": "福山区"
  },
  {
    "_id": 1814,
    "id": 2447,
    "pid": 296,
    "city_code": "101120509",
    "city_name": "牟平区"
  },
  {
    "_id": 1815,
    "id": 2450,
    "pid": 296,
    "city_code": "101120505",
    "city_name": "龙口市"
  },
  {
    "_id": 1816,
    "id": 2451,
    "pid": 296,
    "city_code": "101120510",
    "city_name": "莱阳市"
  },
  {
    "_id": 1817,
    "id": 2452,
    "pid": 296,
    "city_code": "101120502",
    "city_name": "莱州市"
  },
  {
    "_id": 1818,
    "id": 2453,
    "pid": 296,
    "city_code": "101120504",
    "city_name": "蓬莱市"
  },
  {
    "_id": 1819,
    "id": 2454,
    "pid": 296,
    "city_code": "101120506",
    "city_name": "招远市"
  },
  {
    "_id": 1820,
    "id": 2455,
    "pid": 296,
    "city_code": "101120507",
    "city_name": "栖霞市"
  },
  {
    "_id": 1821,
    "id": 2456,
    "pid": 296,
    "city_code": "101120511",
    "city_name": "海阳市"
  },
  {
    "_id": 1822,
    "id": 2457,
    "pid": 296,
    "city_code": "101120503",
    "city_name": "长岛县"
  },
  {
    "_id": 1823,
    "id": 2460,
    "pid": 297,
    "city_code": "101121403",
    "city_name": "峄城区"
  },
  {
    "_id": 1824,
    "id": 2461,
    "pid": 297,
    "city_code": "101121404",
    "city_name": "台儿庄区"
  },
  {
    "_id": 1825,
    "id": 2462,
    "pid": 297,
    "city_code": "101121402",
    "city_name": "薛城区"
  },
  {
    "_id": 1826,
    "id": 2463,
    "pid": 297,
    "city_code": "101121405",
    "city_name": "滕州市"
  },
  {
    "_id": 1827,
    "id": 2465,
    "pid": 298,
    "city_code": "101120308",
    "city_name": "临淄区"
  },
  {
    "_id": 1828,
    "id": 2466,
    "pid": 298,
    "city_code": "101120302",
    "city_name": "淄川区"
  },
  {
    "_id": 1829,
    "id": 2467,
    "pid": 298,
    "city_code": "101120303",
    "city_name": "博山区"
  },
  {
    "_id": 1830,
    "id": 2468,
    "pid": 298,
    "city_code": "101120305",
    "city_name": "周村区"
  },
  {
    "_id": 1831,
    "id": 2469,
    "pid": 298,
    "city_code": "101120307",
    "city_name": "桓台县"
  },
  {
    "_id": 1832,
    "id": 2470,
    "pid": 298,
    "city_code": "101120304",
    "city_name": "高青县"
  },
  {
    "_id": 1833,
    "id": 2471,
    "pid": 298,
    "city_code": "101120306",
    "city_name": "沂源县"
  },
  {
    "_id": 1834,
    "id": 2481,
    "pid": 299,
    "city_code": "101100102",
    "city_name": "清徐县"
  },
  {
    "_id": 1835,
    "id": 2482,
    "pid": 299,
    "city_code": "101100103",
    "city_name": "阳曲县"
  },
  {
    "_id": 1836,
    "id": 2483,
    "pid": 299,
    "city_code": "101100104",
    "city_name": "娄烦县"
  },
  {
    "_id": 1837,
    "id": 2484,
    "pid": 299,
    "city_code": "101100105",
    "city_name": "古交市"
  },
  {
    "_id": 1838,
    "id": 2487,
    "pid": 300,
    "city_code": "101100508",
    "city_name": "沁县"
  },
  {
    "_id": 1839,
    "id": 2488,
    "pid": 300,
    "city_code": "101100504",
    "city_name": "潞城市"
  },
  {
    "_id": 1840,
    "id": 2489,
    "pid": 300,
    "city_code": "101100501",
    "city_name": "长治县"
  },
  {
    "_id": 1841,
    "id": 2490,
    "pid": 300,
    "city_code": "101100505",
    "city_name": "襄垣县"
  },
  {
    "_id": 1842,
    "id": 2491,
    "pid": 300,
    "city_code": "101100503",
    "city_name": "屯留县"
  },
  {
    "_id": 1843,
    "id": 2492,
    "pid": 300,
    "city_code": "101100506",
    "city_name": "平顺县"
  },
  {
    "_id": 1844,
    "id": 2493,
    "pid": 300,
    "city_code": "101100502",
    "city_name": "黎城县"
  },
  {
    "_id": 1845,
    "id": 2494,
    "pid": 300,
    "city_code": "101100511",
    "city_name": "壶关县"
  },
  {
    "_id": 1846,
    "id": 2495,
    "pid": 300,
    "city_code": "101100509",
    "city_name": "长子县"
  },
  {
    "_id": 1847,
    "id": 2496,
    "pid": 300,
    "city_code": "101100507",
    "city_name": "武乡县"
  },
  {
    "_id": 1848,
    "id": 2497,
    "pid": 300,
    "city_code": "101100510",
    "city_name": "沁源县"
  },
  {
    "_id": 1849,
    "id": 2502,
    "pid": 301,
    "city_code": "101100202",
    "city_name": "阳高县"
  },
  {
    "_id": 1850,
    "id": 2503,
    "pid": 301,
    "city_code": "101100204",
    "city_name": "天镇县"
  },
  {
    "_id": 1851,
    "id": 2504,
    "pid": 301,
    "city_code": "101100205",
    "city_name": "广灵县"
  },
  {
    "_id": 1852,
    "id": 2505,
    "pid": 301,
    "city_code": "101100206",
    "city_name": "灵丘县"
  },
  {
    "_id": 1853,
    "id": 2506,
    "pid": 301,
    "city_code": "101100207",
    "city_name": "浑源县"
  },
  {
    "_id": 1854,
    "id": 2507,
    "pid": 301,
    "city_code": "101100208",
    "city_name": "左云县"
  },
  {
    "_id": 1855,
    "id": 2508,
    "pid": 301,
    "city_code": "101100203",
    "city_name": "大同县"
  },
  {
    "_id": 1856,
    "id": 2510,
    "pid": 302,
    "city_code": "101100605",
    "city_name": "高平市"
  },
  {
    "_id": 1857,
    "id": 2511,
    "pid": 302,
    "city_code": "101100602",
    "city_name": "沁水县"
  },
  {
    "_id": 1858,
    "id": 2512,
    "pid": 302,
    "city_code": "101100603",
    "city_name": "阳城县"
  },
  {
    "_id": 1859,
    "id": 2513,
    "pid": 302,
    "city_code": "101100604",
    "city_name": "陵川县"
  },
  {
    "_id": 1860,
    "id": 2514,
    "pid": 302,
    "city_code": "101100606",
    "city_name": "泽州县"
  },
  {
    "_id": 1861,
    "id": 2515,
    "pid": 303,
    "city_code": "101100402",
    "city_name": "榆次区"
  },
  {
    "_id": 1862,
    "id": 2516,
    "pid": 303,
    "city_code": "101100412",
    "city_name": "介休市"
  },
  {
    "_id": 1863,
    "id": 2517,
    "pid": 303,
    "city_code": "101100403",
    "city_name": "榆社县"
  },
  {
    "_id": 1864,
    "id": 2518,
    "pid": 303,
    "city_code": "101100404",
    "city_name": "左权县"
  },
  {
    "_id": 1865,
    "id": 2519,
    "pid": 303,
    "city_code": "101100405",
    "city_name": "和顺县"
  },
  {
    "_id": 1866,
    "id": 2520,
    "pid": 303,
    "city_code": "101100406",
    "city_name": "昔阳县"
  },
  {
    "_id": 1867,
    "id": 2521,
    "pid": 303,
    "city_code": "101100407",
    "city_name": "寿阳县"
  },
  {
    "_id": 1868,
    "id": 2522,
    "pid": 303,
    "city_code": "101100408",
    "city_name": "太谷县"
  },
  {
    "_id": 1869,
    "id": 2523,
    "pid": 303,
    "city_code": "101100409",
    "city_name": "祁县"
  },
  {
    "_id": 1870,
    "id": 2524,
    "pid": 303,
    "city_code": "101100410",
    "city_name": "平遥县"
  },
  {
    "_id": 1871,
    "id": 2525,
    "pid": 303,
    "city_code": "101100411",
    "city_name": "灵石县"
  },
  {
    "_id": 1872,
    "id": 2527,
    "pid": 304,
    "city_code": "101100714",
    "city_name": "侯马市"
  },
  {
    "_id": 1873,
    "id": 2528,
    "pid": 304,
    "city_code": "101100711",
    "city_name": "霍州市"
  },
  {
    "_id": 1874,
    "id": 2529,
    "pid": 304,
    "city_code": "101100702",
    "city_name": "曲沃县"
  },
  {
    "_id": 1875,
    "id": 2530,
    "pid": 304,
    "city_code": "101100713",
    "city_name": "翼城县"
  },
  {
    "_id": 1876,
    "id": 2531,
    "pid": 304,
    "city_code": "101100707",
    "city_name": "襄汾县"
  },
  {
    "_id": 1877,
    "id": 2532,
    "pid": 304,
    "city_code": "101100710",
    "city_name": "洪洞县"
  },
  {
    "_id": 1878,
    "id": 2533,
    "pid": 304,
    "city_code": "101100706",
    "city_name": "吉县"
  },
  {
    "_id": 1879,
    "id": 2534,
    "pid": 304,
    "city_code": "101100716",
    "city_name": "安泽县"
  },
  {
    "_id": 1880,
    "id": 2535,
    "pid": 304,
    "city_code": "101100715",
    "city_name": "浮山县"
  },
  {
    "_id": 1881,
    "id": 2536,
    "pid": 304,
    "city_code": "101100717",
    "city_name": "古县"
  },
  {
    "_id": 1882,
    "id": 2537,
    "pid": 304,
    "city_code": "101100712",
    "city_name": "乡宁县"
  },
  {
    "_id": 1883,
    "id": 2538,
    "pid": 304,
    "city_code": "101100705",
    "city_name": "大宁县"
  },
  {
    "_id": 1884,
    "id": 2539,
    "pid": 304,
    "city_code": "101100704",
    "city_name": "隰县"
  },
  {
    "_id": 1885,
    "id": 2540,
    "pid": 304,
    "city_code": "101100703",
    "city_name": "永和县"
  },
  {
    "_id": 1886,
    "id": 2541,
    "pid": 304,
    "city_code": "101100708",
    "city_name": "蒲县"
  },
  {
    "_id": 1887,
    "id": 2542,
    "pid": 304,
    "city_code": "101100709",
    "city_name": "汾西县"
  },
  {
    "_id": 1888,
    "id": 2543,
    "pid": 305,
    "city_code": "101101101",
    "city_name": "离石市"
  },
  {
    "_id": 1889,
    "id": 2544,
    "pid": 305,
    "city_code": "101101101",
    "city_name": "离石区"
  },
  {
    "_id": 1890,
    "id": 2545,
    "pid": 305,
    "city_code": "101101110",
    "city_name": "孝义市"
  },
  {
    "_id": 1891,
    "id": 2546,
    "pid": 305,
    "city_code": "101101111",
    "city_name": "汾阳市"
  },
  {
    "_id": 1892,
    "id": 2547,
    "pid": 305,
    "city_code": "101101112",
    "city_name": "文水县"
  },
  {
    "_id": 1893,
    "id": 2548,
    "pid": 305,
    "city_code": "101101113",
    "city_name": "交城县"
  },
  {
    "_id": 1894,
    "id": 2549,
    "pid": 305,
    "city_code": "101101103",
    "city_name": "兴县"
  },
  {
    "_id": 1895,
    "id": 2550,
    "pid": 305,
    "city_code": "101101102",
    "city_name": "临县"
  },
  {
    "_id": 1896,
    "id": 2551,
    "pid": 305,
    "city_code": "101101105",
    "city_name": "柳林县"
  },
  {
    "_id": 1897,
    "id": 2552,
    "pid": 305,
    "city_code": "101101106",
    "city_name": "石楼县"
  },
  {
    "_id": 1898,
    "id": 2553,
    "pid": 305,
    "city_code": "101101104",
    "city_name": "岚县"
  },
  {
    "_id": 1899,
    "id": 2554,
    "pid": 305,
    "city_code": "101101107",
    "city_name": "方山县"
  },
  {
    "_id": 1900,
    "id": 2555,
    "pid": 305,
    "city_code": "101101109",
    "city_name": "中阳县"
  },
  {
    "_id": 1901,
    "id": 2556,
    "pid": 305,
    "city_code": "101101108",
    "city_name": "交口县"
  },
  {
    "_id": 1902,
    "id": 2558,
    "pid": 306,
    "city_code": "101100902",
    "city_name": "平鲁区"
  },
  {
    "_id": 1903,
    "id": 2559,
    "pid": 306,
    "city_code": "101100903",
    "city_name": "山阴县"
  },
  {
    "_id": 1904,
    "id": 2560,
    "pid": 306,
    "city_code": "101100905",
    "city_name": "应县"
  },
  {
    "_id": 1905,
    "id": 2561,
    "pid": 306,
    "city_code": "101100904",
    "city_name": "右玉县"
  },
  {
    "_id": 1906,
    "id": 2562,
    "pid": 306,
    "city_code": "101100906",
    "city_name": "怀仁县"
  },
  {
    "_id": 1907,
    "id": 2564,
    "pid": 307,
    "city_code": "101101015",
    "city_name": "原平市"
  },
  {
    "_id": 1908,
    "id": 2565,
    "pid": 307,
    "city_code": "101101002",
    "city_name": "定襄县"
  },
  {
    "_id": 1909,
    "id": 2566,
    "pid": 307,
    "city_code": "101101003",
    "city_name": "五台县"
  },
  {
    "_id": 1910,
    "id": 2567,
    "pid": 307,
    "city_code": "101101008",
    "city_name": "代县"
  },
  {
    "_id": 1911,
    "id": 2568,
    "pid": 307,
    "city_code": "101101009",
    "city_name": "繁峙县"
  },
  {
    "_id": 1912,
    "id": 2569,
    "pid": 307,
    "city_code": "101101007",
    "city_name": "宁武县"
  },
  {
    "_id": 1913,
    "id": 2570,
    "pid": 307,
    "city_code": "101101012",
    "city_name": "静乐县"
  },
  {
    "_id": 1914,
    "id": 2571,
    "pid": 307,
    "city_code": "101101006",
    "city_name": "神池县"
  },
  {
    "_id": 1915,
    "id": 2572,
    "pid": 307,
    "city_code": "101101014",
    "city_name": "五寨县"
  },
  {
    "_id": 1916,
    "id": 2573,
    "pid": 307,
    "city_code": "101101013",
    "city_name": "岢岚县"
  },
  {
    "_id": 1917,
    "id": 2574,
    "pid": 307,
    "city_code": "101101004",
    "city_name": "河曲县"
  },
  {
    "_id": 1918,
    "id": 2575,
    "pid": 307,
    "city_code": "101101011",
    "city_name": "保德县"
  },
  {
    "_id": 1919,
    "id": 2576,
    "pid": 307,
    "city_code": "101101005",
    "city_name": "偏关县"
  },
  {
    "_id": 1920,
    "id": 2580,
    "pid": 308,
    "city_code": "101100303",
    "city_name": "平定县"
  },
  {
    "_id": 1921,
    "id": 2581,
    "pid": 308,
    "city_code": "101100302",
    "city_name": "盂县"
  },
  {
    "_id": 1922,
    "id": 2583,
    "pid": 309,
    "city_code": "101100810",
    "city_name": "永济市"
  },
  {
    "_id": 1923,
    "id": 2584,
    "pid": 309,
    "city_code": "101100805",
    "city_name": "河津市"
  },
  {
    "_id": 1924,
    "id": 2585,
    "pid": 309,
    "city_code": "101100802",
    "city_name": "临猗县"
  },
  {
    "_id": 1925,
    "id": 2586,
    "pid": 309,
    "city_code": "101100804",
    "city_name": "万荣县"
  },
  {
    "_id": 1926,
    "id": 2587,
    "pid": 309,
    "city_code": "101100808",
    "city_name": "闻喜县"
  },
  {
    "_id": 1927,
    "id": 2588,
    "pid": 309,
    "city_code": "101100803",
    "city_name": "稷山县"
  },
  {
    "_id": 1928,
    "id": 2589,
    "pid": 309,
    "city_code": "101100806",
    "city_name": "新绛县"
  },
  {
    "_id": 1929,
    "id": 2590,
    "pid": 309,
    "city_code": "101100807",
    "city_name": "绛县"
  },
  {
    "_id": 1930,
    "id": 2591,
    "pid": 309,
    "city_code": "101100809",
    "city_name": "垣曲县"
  },
  {
    "_id": 1931,
    "id": 2592,
    "pid": 309,
    "city_code": "101100812",
    "city_name": "夏县"
  },
  {
    "_id": 1932,
    "id": 2593,
    "pid": 309,
    "city_code": "101100813",
    "city_name": "平陆县"
  },
  {
    "_id": 1933,
    "id": 2594,
    "pid": 309,
    "city_code": "101100811",
    "city_name": "芮城县"
  },
  {
    "_id": 1934,
    "id": 2602,
    "pid": 310,
    "city_code": "101110103",
    "city_name": "临潼区"
  },
  {
    "_id": 1935,
    "id": 2603,
    "pid": 310,
    "city_code": "101110102",
    "city_name": "长安区"
  },
  {
    "_id": 1936,
    "id": 2604,
    "pid": 310,
    "city_code": "101110104",
    "city_name": "蓝田县"
  },
  {
    "_id": 1937,
    "id": 2605,
    "pid": 310,
    "city_code": "101110105",
    "city_name": "周至县"
  },
  {
    "_id": 1938,
    "id": 2606,
    "pid": 310,
    "city_code": "101110106",
    "city_name": "户县"
  },
  {
    "_id": 1939,
    "id": 2607,
    "pid": 310,
    "city_code": "101110107",
    "city_name": "高陵县"
  },
  {
    "_id": 1940,
    "id": 2609,
    "pid": 311,
    "city_code": "101110704",
    "city_name": "汉阴县"
  },
  {
    "_id": 1941,
    "id": 2610,
    "pid": 311,
    "city_code": "101110703",
    "city_name": "石泉县"
  },
  {
    "_id": 1942,
    "id": 2611,
    "pid": 311,
    "city_code": "101110710",
    "city_name": "宁陕县"
  },
  {
    "_id": 1943,
    "id": 2612,
    "pid": 311,
    "city_code": "101110702",
    "city_name": "紫阳县"
  },
  {
    "_id": 1944,
    "id": 2613,
    "pid": 311,
    "city_code": "101110706",
    "city_name": "岚皋县"
  },
  {
    "_id": 1945,
    "id": 2614,
    "pid": 311,
    "city_code": "101110707",
    "city_name": "平利县"
  },
  {
    "_id": 1946,
    "id": 2615,
    "pid": 311,
    "city_code": "101110709",
    "city_name": "镇坪县"
  },
  {
    "_id": 1947,
    "id": 2616,
    "pid": 311,
    "city_code": "101110705",
    "city_name": "旬阳县"
  },
  {
    "_id": 1948,
    "id": 2617,
    "pid": 311,
    "city_code": "101110708",
    "city_name": "白河县"
  },
  {
    "_id": 1949,
    "id": 2618,
    "pid": 312,
    "city_code": "101110912",
    "city_name": "陈仓区"
  },
  {
    "_id": 1950,
    "id": 2621,
    "pid": 312,
    "city_code": "101110906",
    "city_name": "凤翔县"
  },
  {
    "_id": 1951,
    "id": 2622,
    "pid": 312,
    "city_code": "101110905",
    "city_name": "岐山县"
  },
  {
    "_id": 1952,
    "id": 2623,
    "pid": 312,
    "city_code": "101110907",
    "city_name": "扶风县"
  },
  {
    "_id": 1953,
    "id": 2624,
    "pid": 312,
    "city_code": "101110908",
    "city_name": "眉县"
  },
  {
    "_id": 1954,
    "id": 2625,
    "pid": 312,
    "city_code": "101110911",
    "city_name": "陇县"
  },
  {
    "_id": 1955,
    "id": 2626,
    "pid": 312,
    "city_code": "101110903",
    "city_name": "千阳县"
  },
  {
    "_id": 1956,
    "id": 2627,
    "pid": 312,
    "city_code": "101110904",
    "city_name": "麟游县"
  },
  {
    "_id": 1957,
    "id": 2628,
    "pid": 312,
    "city_code": "101110910",
    "city_name": "凤县"
  },
  {
    "_id": 1958,
    "id": 2629,
    "pid": 312,
    "city_code": "101110909",
    "city_name": "太白县"
  },
  {
    "_id": 1959,
    "id": 2631,
    "pid": 313,
    "city_code": "101110810",
    "city_name": "南郑县"
  },
  {
    "_id": 1960,
    "id": 2632,
    "pid": 313,
    "city_code": "101110806",
    "city_name": "城固县"
  },
  {
    "_id": 1961,
    "id": 2633,
    "pid": 313,
    "city_code": "101110805",
    "city_name": "洋县"
  },
  {
    "_id": 1962,
    "id": 2634,
    "pid": 313,
    "city_code": "101110807",
    "city_name": "西乡县"
  },
  {
    "_id": 1963,
    "id": 2635,
    "pid": 313,
    "city_code": "101110803",
    "city_name": "勉县"
  },
  {
    "_id": 1964,
    "id": 2636,
    "pid": 313,
    "city_code": "101110809",
    "city_name": "宁强县"
  },
  {
    "_id": 1965,
    "id": 2637,
    "pid": 313,
    "city_code": "101110802",
    "city_name": "略阳县"
  },
  {
    "_id": 1966,
    "id": 2638,
    "pid": 313,
    "city_code": "101110811",
    "city_name": "镇巴县"
  },
  {
    "_id": 1967,
    "id": 2639,
    "pid": 313,
    "city_code": "101110804",
    "city_name": "留坝县"
  },
  {
    "_id": 1968,
    "id": 2640,
    "pid": 313,
    "city_code": "101110808",
    "city_name": "佛坪县"
  },
  {
    "_id": 1969,
    "id": 2641,
    "pid": 314,
    "city_code": "101110604",
    "city_name": "商州区"
  },
  {
    "_id": 1970,
    "id": 2642,
    "pid": 314,
    "city_code": "101110602",
    "city_name": "洛南县"
  },
  {
    "_id": 1971,
    "id": 2643,
    "pid": 314,
    "city_code": "101110606",
    "city_name": "丹凤县"
  },
  {
    "_id": 1972,
    "id": 2644,
    "pid": 314,
    "city_code": "101110607",
    "city_name": "商南县"
  },
  {
    "_id": 1973,
    "id": 2645,
    "pid": 314,
    "city_code": "101110608",
    "city_name": "山阳县"
  },
  {
    "_id": 1974,
    "id": 2646,
    "pid": 314,
    "city_code": "101110605",
    "city_name": "镇安县"
  },
  {
    "_id": 1975,
    "id": 2647,
    "pid": 314,
    "city_code": "101110603",
    "city_name": "柞水县"
  },
  {
    "_id": 1976,
    "id": 2648,
    "pid": 315,
    "city_code": "101111004",
    "city_name": "耀州区"
  },
  {
    "_id": 1977,
    "id": 2651,
    "pid": 315,
    "city_code": "101111003",
    "city_name": "宜君县"
  },
  {
    "_id": 1978,
    "id": 2653,
    "pid": 316,
    "city_code": "101110510",
    "city_name": "韩城市"
  },
  {
    "_id": 1979,
    "id": 2654,
    "pid": 316,
    "city_code": "101110511",
    "city_name": "华阴市"
  },
  {
    "_id": 1980,
    "id": 2655,
    "pid": 316,
    "city_code": "101110502",
    "city_name": "华县"
  },
  {
    "_id": 1981,
    "id": 2656,
    "pid": 316,
    "city_code": "101110503",
    "city_name": "潼关县"
  },
  {
    "_id": 1982,
    "id": 2657,
    "pid": 316,
    "city_code": "101110504",
    "city_name": "大荔县"
  },
  {
    "_id": 1983,
    "id": 2658,
    "pid": 316,
    "city_code": "101110509",
    "city_name": "合阳县"
  },
  {
    "_id": 1984,
    "id": 2659,
    "pid": 316,
    "city_code": "101110508",
    "city_name": "澄城县"
  },
  {
    "_id": 1985,
    "id": 2660,
    "pid": 316,
    "city_code": "101110507",
    "city_name": "蒲城县"
  },
  {
    "_id": 1986,
    "id": 2661,
    "pid": 316,
    "city_code": "101110505",
    "city_name": "白水县"
  },
  {
    "_id": 1987,
    "id": 2662,
    "pid": 316,
    "city_code": "101110506",
    "city_name": "富平县"
  },
  {
    "_id": 1988,
    "id": 2666,
    "pid": 317,
    "city_code": "101110211",
    "city_name": "兴平市"
  },
  {
    "_id": 1989,
    "id": 2667,
    "pid": 317,
    "city_code": "101110201",
    "city_name": "三原县"
  },
  {
    "_id": 1990,
    "id": 2668,
    "pid": 317,
    "city_code": "101110205",
    "city_name": "泾阳县"
  },
  {
    "_id": 1991,
    "id": 2669,
    "pid": 317,
    "city_code": "101110207",
    "city_name": "乾县"
  },
  {
    "_id": 1992,
    "id": 2670,
    "pid": 317,
    "city_code": "101110202",
    "city_name": "礼泉县"
  },
  {
    "_id": 1993,
    "id": 2671,
    "pid": 317,
    "city_code": "101110203",
    "city_name": "永寿县"
  },
  {
    "_id": 1994,
    "id": 2672,
    "pid": 317,
    "city_code": "101110208",
    "city_name": "彬县"
  },
  {
    "_id": 1995,
    "id": 2673,
    "pid": 317,
    "city_code": "101110209",
    "city_name": "长武县"
  },
  {
    "_id": 1996,
    "id": 2674,
    "pid": 317,
    "city_code": "101110210",
    "city_name": "旬邑县"
  },
  {
    "_id": 1997,
    "id": 2675,
    "pid": 317,
    "city_code": "101110204",
    "city_name": "淳化县"
  },
  {
    "_id": 1998,
    "id": 2676,
    "pid": 317,
    "city_code": "101110206",
    "city_name": "武功县"
  },
  {
    "_id": 1999,
    "id": 2677,
    "pid": 318,
    "city_code": "101110312",
    "city_name": "吴起县"
  },
  {
    "_id": 2000,
    "id": 2679,
    "pid": 318,
    "city_code": "101110301",
    "city_name": "延长县"
  },
  {
    "_id": 2001,
    "id": 2680,
    "pid": 318,
    "city_code": "101110302",
    "city_name": "延川县"
  },
  {
    "_id": 2002,
    "id": 2681,
    "pid": 318,
    "city_code": "101110303",
    "city_name": "子长县"
  },
  {
    "_id": 2003,
    "id": 2682,
    "pid": 318,
    "city_code": "101110307",
    "city_name": "安塞县"
  },
  {
    "_id": 2004,
    "id": 2683,
    "pid": 318,
    "city_code": "101110306",
    "city_name": "志丹县"
  },
  {
    "_id": 2005,
    "id": 2684,
    "pid": 318,
    "city_code": "101110308",
    "city_name": "甘泉县"
  },
  {
    "_id": 2006,
    "id": 2685,
    "pid": 318,
    "city_code": "101110305",
    "city_name": "富县"
  },
  {
    "_id": 2007,
    "id": 2686,
    "pid": 318,
    "city_code": "101110309",
    "city_name": "洛川县"
  },
  {
    "_id": 2008,
    "id": 2687,
    "pid": 318,
    "city_code": "101110304",
    "city_name": "宜川县"
  },
  {
    "_id": 2009,
    "id": 2688,
    "pid": 318,
    "city_code": "101110311",
    "city_name": "黄龙县"
  },
  {
    "_id": 2010,
    "id": 2689,
    "pid": 318,
    "city_code": "101110310",
    "city_name": "黄陵县"
  },
  {
    "_id": 2011,
    "id": 2690,
    "pid": 319,
    "city_code": "101110413",
    "city_name": "榆阳区"
  },
  {
    "_id": 2012,
    "id": 2691,
    "pid": 319,
    "city_code": "101110403",
    "city_name": "神木县"
  },
  {
    "_id": 2013,
    "id": 2692,
    "pid": 319,
    "city_code": "101110402",
    "city_name": "府谷县"
  },
  {
    "_id": 2014,
    "id": 2693,
    "pid": 319,
    "city_code": "101110407",
    "city_name": "横山县"
  },
  {
    "_id": 2015,
    "id": 2694,
    "pid": 319,
    "city_code": "101110406",
    "city_name": "靖边县"
  },
  {
    "_id": 2016,
    "id": 2695,
    "pid": 319,
    "city_code": "101110405",
    "city_name": "定边县"
  },
  {
    "_id": 2017,
    "id": 2696,
    "pid": 319,
    "city_code": "101110410",
    "city_name": "绥德县"
  },
  {
    "_id": 2018,
    "id": 2697,
    "pid": 319,
    "city_code": "101110408",
    "city_name": "米脂县"
  },
  {
    "_id": 2019,
    "id": 2698,
    "pid": 319,
    "city_code": "101110404",
    "city_name": "佳县"
  },
  {
    "_id": 2020,
    "id": 2699,
    "pid": 319,
    "city_code": "101110411",
    "city_name": "吴堡县"
  },
  {
    "_id": 2021,
    "id": 2700,
    "pid": 319,
    "city_code": "101110412",
    "city_name": "清涧县"
  },
  {
    "_id": 2022,
    "id": 2701,
    "pid": 319,
    "city_code": "101110409",
    "city_name": "子洲县"
  },
  {
    "_id": 2023,
    "id": 2704,
    "pid": 24,
    "city_code": "101020200",
    "city_name": "闵行区"
  },
  {
    "_id": 2024,
    "id": 2706,
    "pid": 24,
    "city_code": "101021300",
    "city_name": "浦东新区"
  },
  {
    "_id": 2025,
    "id": 2714,
    "pid": 24,
    "city_code": "101020900",
    "city_name": "松江区"
  },
  {
    "_id": 2026,
    "id": 2715,
    "pid": 24,
    "city_code": "101020500",
    "city_name": "嘉定区"
  },
  {
    "_id": 2027,
    "id": 2716,
    "pid": 24,
    "city_code": "101020300",
    "city_name": "宝山区"
  },
  {
    "_id": 2028,
    "id": 2717,
    "pid": 24,
    "city_code": "101020800",
    "city_name": "青浦区"
  },
  {
    "_id": 2029,
    "id": 2718,
    "pid": 24,
    "city_code": "101020700",
    "city_name": "金山区"
  },
  {
    "_id": 2030,
    "id": 2719,
    "pid": 24,
    "city_code": "101021000",
    "city_name": "奉贤区"
  },
  {
    "_id": 2031,
    "id": 2720,
    "pid": 24,
    "city_code": "101021100",
    "city_name": "崇明区"
  },
  {
    "_id": 2032,
    "id": 2726,
    "pid": 321,
    "city_code": "101270102",
    "city_name": "龙泉驿区"
  },
  {
    "_id": 2033,
    "id": 2727,
    "pid": 321,
    "city_code": "101270115",
    "city_name": "青白江区"
  },
  {
    "_id": 2034,
    "id": 2728,
    "pid": 321,
    "city_code": "101270103",
    "city_name": "新都区"
  },
  {
    "_id": 2035,
    "id": 2729,
    "pid": 321,
    "city_code": "101270104",
    "city_name": "温江区"
  },
  {
    "_id": 2036,
    "id": 2732,
    "pid": 321,
    "city_code": "101270111",
    "city_name": "都江堰市"
  },
  {
    "_id": 2037,
    "id": 2733,
    "pid": 321,
    "city_code": "101270112",
    "city_name": "彭州市"
  },
  {
    "_id": 2038,
    "id": 2734,
    "pid": 321,
    "city_code": "101270113",
    "city_name": "邛崃市"
  },
  {
    "_id": 2039,
    "id": 2735,
    "pid": 321,
    "city_code": "101270114",
    "city_name": "崇州市"
  },
  {
    "_id": 2040,
    "id": 2736,
    "pid": 321,
    "city_code": "101270105",
    "city_name": "金堂县"
  },
  {
    "_id": 2041,
    "id": 2737,
    "pid": 321,
    "city_code": "101270106",
    "city_name": "双流县"
  },
  {
    "_id": 2042,
    "id": 2738,
    "pid": 321,
    "city_code": "101270107",
    "city_name": "郫县"
  },
  {
    "_id": 2043,
    "id": 2739,
    "pid": 321,
    "city_code": "101270108",
    "city_name": "大邑县"
  },
  {
    "_id": 2044,
    "id": 2740,
    "pid": 321,
    "city_code": "101270109",
    "city_name": "蒲江县"
  },
  {
    "_id": 2045,
    "id": 2741,
    "pid": 321,
    "city_code": "101270110",
    "city_name": "新津县"
  },
  {
    "_id": 2046,
    "id": 2754,
    "pid": 322,
    "city_code": "101270408",
    "city_name": "江油市"
  },
  {
    "_id": 2047,
    "id": 2755,
    "pid": 322,
    "city_code": "101270403",
    "city_name": "盐亭县"
  },
  {
    "_id": 2048,
    "id": 2756,
    "pid": 322,
    "city_code": "101270402",
    "city_name": "三台县"
  },
  {
    "_id": 2049,
    "id": 2757,
    "pid": 322,
    "city_code": "101270407",
    "city_name": "平武县"
  },
  {
    "_id": 2050,
    "id": 2758,
    "pid": 322,
    "city_code": "101270404",
    "city_name": "安县"
  },
  {
    "_id": 2051,
    "id": 2759,
    "pid": 322,
    "city_code": "101270405",
    "city_name": "梓潼县"
  },
  {
    "_id": 2052,
    "id": 2760,
    "pid": 322,
    "city_code": "101270406",
    "city_name": "北川县"
  },
  {
    "_id": 2053,
    "id": 2761,
    "pid": 323,
    "city_code": "101271910",
    "city_name": "马尔康县"
  },
  {
    "_id": 2054,
    "id": 2762,
    "pid": 323,
    "city_code": "101271902",
    "city_name": "汶川县"
  },
  {
    "_id": 2055,
    "id": 2763,
    "pid": 323,
    "city_code": "101271903",
    "city_name": "理县"
  },
  {
    "_id": 2056,
    "id": 2764,
    "pid": 323,
    "city_code": "101271904",
    "city_name": "茂县"
  },
  {
    "_id": 2057,
    "id": 2765,
    "pid": 323,
    "city_code": "101271905",
    "city_name": "松潘县"
  },
  {
    "_id": 2058,
    "id": 2766,
    "pid": 323,
    "city_code": "101271906",
    "city_name": "九寨沟县"
  },
  {
    "_id": 2059,
    "id": 2767,
    "pid": 323,
    "city_code": "101271907",
    "city_name": "金川县"
  },
  {
    "_id": 2060,
    "id": 2768,
    "pid": 323,
    "city_code": "101271908",
    "city_name": "小金县"
  },
  {
    "_id": 2061,
    "id": 2769,
    "pid": 323,
    "city_code": "101271909",
    "city_name": "黑水县"
  },
  {
    "_id": 2062,
    "id": 2770,
    "pid": 323,
    "city_code": "101271911",
    "city_name": "壤塘县"
  },
  {
    "_id": 2063,
    "id": 2771,
    "pid": 323,
    "city_code": "101271901",
    "city_name": "阿坝县"
  },
  {
    "_id": 2064,
    "id": 2772,
    "pid": 323,
    "city_code": "101271912",
    "city_name": "若尔盖县"
  },
  {
    "_id": 2065,
    "id": 2773,
    "pid": 323,
    "city_code": "101271913",
    "city_name": "红原县"
  },
  {
    "_id": 2066,
    "id": 2775,
    "pid": 324,
    "city_code": "101270902",
    "city_name": "通江县"
  },
  {
    "_id": 2067,
    "id": 2776,
    "pid": 324,
    "city_code": "101270903",
    "city_name": "南江县"
  },
  {
    "_id": 2068,
    "id": 2777,
    "pid": 324,
    "city_code": "101270904",
    "city_name": "平昌县"
  },
  {
    "_id": 2069,
    "id": 2779,
    "pid": 325,
    "city_code": "101270606",
    "city_name": "万源市"
  },
  {
    "_id": 2070,
    "id": 2780,
    "pid": 325,
    "city_code": "101270608",
    "city_name": "达川区"
  },
  {
    "_id": 2071,
    "id": 2781,
    "pid": 325,
    "city_code": "101270602",
    "city_name": "宣汉县"
  },
  {
    "_id": 2072,
    "id": 2782,
    "pid": 325,
    "city_code": "101270603",
    "city_name": "开江县"
  },
  {
    "_id": 2073,
    "id": 2783,
    "pid": 325,
    "city_code": "101270604",
    "city_name": "大竹县"
  },
  {
    "_id": 2074,
    "id": 2784,
    "pid": 325,
    "city_code": "101270605",
    "city_name": "渠县"
  },
  {
    "_id": 2075,
    "id": 2786,
    "pid": 326,
    "city_code": "101272003",
    "city_name": "广汉市"
  },
  {
    "_id": 2076,
    "id": 2787,
    "pid": 326,
    "city_code": "101272004",
    "city_name": "什邡市"
  },
  {
    "_id": 2077,
    "id": 2788,
    "pid": 326,
    "city_code": "101272005",
    "city_name": "绵竹市"
  },
  {
    "_id": 2078,
    "id": 2789,
    "pid": 326,
    "city_code": "101272006",
    "city_name": "罗江县"
  },
  {
    "_id": 2079,
    "id": 2790,
    "pid": 326,
    "city_code": "101272002",
    "city_name": "中江县"
  },
  {
    "_id": 2080,
    "id": 2791,
    "pid": 327,
    "city_code": "101271802",
    "city_name": "康定县"
  },
  {
    "_id": 2081,
    "id": 2792,
    "pid": 327,
    "city_code": "101271804",
    "city_name": "丹巴县"
  },
  {
    "_id": 2082,
    "id": 2793,
    "pid": 327,
    "city_code": "101271803",
    "city_name": "泸定县"
  },
  {
    "_id": 2083,
    "id": 2794,
    "pid": 327,
    "city_code": "101271808",
    "city_name": "炉霍县"
  },
  {
    "_id": 2084,
    "id": 2795,
    "pid": 327,
    "city_code": "101271805",
    "city_name": "九龙县"
  },
  {
    "_id": 2085,
    "id": 2796,
    "pid": 327,
    "city_code": "101271801",
    "city_name": "甘孜县"
  },
  {
    "_id": 2086,
    "id": 2797,
    "pid": 327,
    "city_code": "101271806",
    "city_name": "雅江县"
  },
  {
    "_id": 2087,
    "id": 2798,
    "pid": 327,
    "city_code": "101271809",
    "city_name": "新龙县"
  },
  {
    "_id": 2088,
    "id": 2799,
    "pid": 327,
    "city_code": "101271807",
    "city_name": "道孚县"
  },
  {
    "_id": 2089,
    "id": 2800,
    "pid": 327,
    "city_code": "101271811",
    "city_name": "白玉县"
  },
  {
    "_id": 2090,
    "id": 2801,
    "pid": 327,
    "city_code": "101271814",
    "city_name": "理塘县"
  },
  {
    "_id": 2091,
    "id": 2802,
    "pid": 327,
    "city_code": "101271810",
    "city_name": "德格县"
  },
  {
    "_id": 2092,
    "id": 2803,
    "pid": 327,
    "city_code": "101271816",
    "city_name": "乡城县"
  },
  {
    "_id": 2093,
    "id": 2804,
    "pid": 327,
    "city_code": "101271812",
    "city_name": "石渠县"
  },
  {
    "_id": 2094,
    "id": 2805,
    "pid": 327,
    "city_code": "101271817",
    "city_name": "稻城县"
  },
  {
    "_id": 2095,
    "id": 2806,
    "pid": 327,
    "city_code": "101271813",
    "city_name": "色达县"
  },
  {
    "_id": 2096,
    "id": 2807,
    "pid": 327,
    "city_code": "101271815",
    "city_name": "巴塘县"
  },
  {
    "_id": 2097,
    "id": 2808,
    "pid": 327,
    "city_code": "101271818",
    "city_name": "得荣县"
  },
  {
    "_id": 2098,
    "id": 2809,
    "pid": 328,
    "city_code": "101270801",
    "city_name": "广安区"
  },
  {
    "_id": 2099,
    "id": 2810,
    "pid": 328,
    "city_code": "101270805",
    "city_name": "华蓥市"
  },
  {
    "_id": 2100,
    "id": 2811,
    "pid": 328,
    "city_code": "101270802",
    "city_name": "岳池县"
  },
  {
    "_id": 2101,
    "id": 2812,
    "pid": 328,
    "city_code": "101270803",
    "city_name": "武胜县"
  },
  {
    "_id": 2102,
    "id": 2813,
    "pid": 328,
    "city_code": "101270804",
    "city_name": "邻水县"
  },
  {
    "_id": 2103,
    "id": 2817,
    "pid": 329,
    "city_code": "101272102",
    "city_name": "旺苍县"
  },
  {
    "_id": 2104,
    "id": 2818,
    "pid": 329,
    "city_code": "101272103",
    "city_name": "青川县"
  },
  {
    "_id": 2105,
    "id": 2819,
    "pid": 329,
    "city_code": "101272104",
    "city_name": "剑阁县"
  },
  {
    "_id": 2106,
    "id": 2820,
    "pid": 329,
    "city_code": "101272105",
    "city_name": "苍溪县"
  },
  {
    "_id": 2107,
    "id": 2821,
    "pid": 330,
    "city_code": "101271409",
    "city_name": "峨眉山市"
  },
  {
    "_id": 2108,
    "id": 2823,
    "pid": 330,
    "city_code": "101271402",
    "city_name": "犍为县"
  },
  {
    "_id": 2109,
    "id": 2824,
    "pid": 330,
    "city_code": "101271403",
    "city_name": "井研县"
  },
  {
    "_id": 2110,
    "id": 2825,
    "pid": 330,
    "city_code": "101271404",
    "city_name": "夹江县"
  },
  {
    "_id": 2111,
    "id": 2826,
    "pid": 330,
    "city_code": "101271405",
    "city_name": "沐川县"
  },
  {
    "_id": 2112,
    "id": 2827,
    "pid": 330,
    "city_code": "101271406",
    "city_name": "峨边县"
  },
  {
    "_id": 2113,
    "id": 2828,
    "pid": 330,
    "city_code": "101271407",
    "city_name": "马边县"
  },
  {
    "_id": 2114,
    "id": 2829,
    "pid": 331,
    "city_code": "101271610",
    "city_name": "西昌市"
  },
  {
    "_id": 2115,
    "id": 2830,
    "pid": 331,
    "city_code": "101271604",
    "city_name": "盐源县"
  },
  {
    "_id": 2116,
    "id": 2831,
    "pid": 331,
    "city_code": "101271605",
    "city_name": "德昌县"
  },
  {
    "_id": 2117,
    "id": 2832,
    "pid": 331,
    "city_code": "101271606",
    "city_name": "会理县"
  },
  {
    "_id": 2118,
    "id": 2833,
    "pid": 331,
    "city_code": "101271607",
    "city_name": "会东县"
  },
  {
    "_id": 2119,
    "id": 2834,
    "pid": 331,
    "city_code": "101271608",
    "city_name": "宁南县"
  },
  {
    "_id": 2120,
    "id": 2835,
    "pid": 331,
    "city_code": "101271609",
    "city_name": "普格县"
  },
  {
    "_id": 2121,
    "id": 2836,
    "pid": 331,
    "city_code": "101271619",
    "city_name": "布拖县"
  },
  {
    "_id": 2122,
    "id": 2837,
    "pid": 331,
    "city_code": "101271611",
    "city_name": "金阳县"
  },
  {
    "_id": 2123,
    "id": 2838,
    "pid": 331,
    "city_code": "101271612",
    "city_name": "昭觉县"
  },
  {
    "_id": 2124,
    "id": 2839,
    "pid": 331,
    "city_code": "101271613",
    "city_name": "喜德县"
  },
  {
    "_id": 2125,
    "id": 2840,
    "pid": 331,
    "city_code": "101271614",
    "city_name": "冕宁县"
  },
  {
    "_id": 2126,
    "id": 2841,
    "pid": 331,
    "city_code": "101271615",
    "city_name": "越西县"
  },
  {
    "_id": 2127,
    "id": 2842,
    "pid": 331,
    "city_code": "101271616",
    "city_name": "甘洛县"
  },
  {
    "_id": 2128,
    "id": 2843,
    "pid": 331,
    "city_code": "101271618",
    "city_name": "美姑县"
  },
  {
    "_id": 2129,
    "id": 2844,
    "pid": 331,
    "city_code": "101271617",
    "city_name": "雷波县"
  },
  {
    "_id": 2130,
    "id": 2845,
    "pid": 331,
    "city_code": "101271603",
    "city_name": "木里县"
  },
  {
    "_id": 2131,
    "id": 2847,
    "pid": 332,
    "city_code": "101271502",
    "city_name": "仁寿县"
  },
  {
    "_id": 2132,
    "id": 2848,
    "pid": 332,
    "city_code": "101271503",
    "city_name": "彭山县"
  },
  {
    "_id": 2133,
    "id": 2849,
    "pid": 332,
    "city_code": "101271504",
    "city_name": "洪雅县"
  },
  {
    "_id": 2134,
    "id": 2850,
    "pid": 332,
    "city_code": "101271505",
    "city_name": "丹棱县"
  },
  {
    "_id": 2135,
    "id": 2851,
    "pid": 332,
    "city_code": "101271506",
    "city_name": "青神县"
  },
  {
    "_id": 2136,
    "id": 2852,
    "pid": 333,
    "city_code": "101270507",
    "city_name": "阆中市"
  },
  {
    "_id": 2137,
    "id": 2853,
    "pid": 333,
    "city_code": "101270502",
    "city_name": "南部县"
  },
  {
    "_id": 2138,
    "id": 2854,
    "pid": 333,
    "city_code": "101270503",
    "city_name": "营山县"
  },
  {
    "_id": 2139,
    "id": 2855,
    "pid": 333,
    "city_code": "101270504",
    "city_name": "蓬安县"
  },
  {
    "_id": 2140,
    "id": 2856,
    "pid": 333,
    "city_code": "101270505",
    "city_name": "仪陇县"
  },
  {
    "_id": 2141,
    "id": 2860,
    "pid": 333,
    "city_code": "101270506",
    "city_name": "西充县"
  },
  {
    "_id": 2142,
    "id": 2862,
    "pid": 334,
    "city_code": "101271202",
    "city_name": "东兴区"
  },
  {
    "_id": 2143,
    "id": 2863,
    "pid": 334,
    "city_code": "101271203",
    "city_name": "威远县"
  },
  {
    "_id": 2144,
    "id": 2864,
    "pid": 334,
    "city_code": "101271204",
    "city_name": "资中县"
  },
  {
    "_id": 2145,
    "id": 2865,
    "pid": 334,
    "city_code": "101271205",
    "city_name": "隆昌县"
  },
  {
    "_id": 2146,
    "id": 2868,
    "pid": 335,
    "city_code": "101270202",
    "city_name": "仁和区"
  },
  {
    "_id": 2147,
    "id": 2869,
    "pid": 335,
    "city_code": "101270203",
    "city_name": "米易县"
  },
  {
    "_id": 2148,
    "id": 2870,
    "pid": 335,
    "city_code": "101270204",
    "city_name": "盐边县"
  },
  {
    "_id": 2149,
    "id": 2873,
    "pid": 336,
    "city_code": "101270702",
    "city_name": "蓬溪县"
  },
  {
    "_id": 2150,
    "id": 2874,
    "pid": 336,
    "city_code": "101270703",
    "city_name": "射洪县"
  },
  {
    "_id": 2151,
    "id": 2877,
    "pid": 337,
    "city_code": "101271702",
    "city_name": "名山县"
  },
  {
    "_id": 2152,
    "id": 2878,
    "pid": 337,
    "city_code": "101271703",
    "city_name": "荥经县"
  },
  {
    "_id": 2153,
    "id": 2879,
    "pid": 337,
    "city_code": "101271704",
    "city_name": "汉源县"
  },
  {
    "_id": 2154,
    "id": 2880,
    "pid": 337,
    "city_code": "101271705",
    "city_name": "石棉县"
  },
  {
    "_id": 2155,
    "id": 2881,
    "pid": 337,
    "city_code": "101271706",
    "city_name": "天全县"
  },
  {
    "_id": 2156,
    "id": 2882,
    "pid": 337,
    "city_code": "101271707",
    "city_name": "芦山县"
  },
  {
    "_id": 2157,
    "id": 2883,
    "pid": 337,
    "city_code": "101271708",
    "city_name": "宝兴县"
  },
  {
    "_id": 2158,
    "id": 2885,
    "pid": 338,
    "city_code": "101271103",
    "city_name": "宜宾县"
  },
  {
    "_id": 2159,
    "id": 2886,
    "pid": 338,
    "city_code": "101271104",
    "city_name": "南溪县"
  },
  {
    "_id": 2160,
    "id": 2887,
    "pid": 338,
    "city_code": "101271105",
    "city_name": "江安县"
  },
  {
    "_id": 2161,
    "id": 2888,
    "pid": 338,
    "city_code": "101271106",
    "city_name": "长宁县"
  },
  {
    "_id": 2162,
    "id": 2889,
    "pid": 338,
    "city_code": "101271107",
    "city_name": "高县"
  },
  {
    "_id": 2163,
    "id": 2890,
    "pid": 338,
    "city_code": "101271108",
    "city_name": "珙县"
  },
  {
    "_id": 2164,
    "id": 2891,
    "pid": 338,
    "city_code": "101271109",
    "city_name": "筠连县"
  },
  {
    "_id": 2165,
    "id": 2892,
    "pid": 338,
    "city_code": "101271110",
    "city_name": "兴文县"
  },
  {
    "_id": 2166,
    "id": 2893,
    "pid": 338,
    "city_code": "101271111",
    "city_name": "屏山县"
  },
  {
    "_id": 2167,
    "id": 2895,
    "pid": 321,
    "city_code": "101271304",
    "city_name": "简阳市"
  },
  {
    "_id": 2168,
    "id": 2896,
    "pid": 339,
    "city_code": "101271302",
    "city_name": "安岳县"
  },
  {
    "_id": 2169,
    "id": 2897,
    "pid": 339,
    "city_code": "101271303",
    "city_name": "乐至县"
  },
  {
    "_id": 2170,
    "id": 2902,
    "pid": 340,
    "city_code": "101270303",
    "city_name": "荣县"
  },
  {
    "_id": 2171,
    "id": 2903,
    "pid": 340,
    "city_code": "101270302",
    "city_name": "富顺县"
  },
  {
    "_id": 2172,
    "id": 2905,
    "pid": 341,
    "city_code": "101271007",
    "city_name": "纳溪区"
  },
  {
    "_id": 2173,
    "id": 2907,
    "pid": 341,
    "city_code": "101271003",
    "city_name": "泸县"
  },
  {
    "_id": 2174,
    "id": 2908,
    "pid": 341,
    "city_code": "101271004",
    "city_name": "合江县"
  },
  {
    "_id": 2175,
    "id": 2909,
    "pid": 341,
    "city_code": "101271005",
    "city_name": "叙永县"
  },
  {
    "_id": 2176,
    "id": 2910,
    "pid": 341,
    "city_code": "101271006",
    "city_name": "古蔺县"
  },
  {
    "_id": 2177,
    "id": 2917,
    "pid": 26,
    "city_code": "101030400",
    "city_name": "东丽区"
  },
  {
    "_id": 2178,
    "id": 2918,
    "pid": 26,
    "city_code": "101031000",
    "city_name": "津南区"
  },
  {
    "_id": 2179,
    "id": 2919,
    "pid": 26,
    "city_code": "101030500",
    "city_name": "西青区"
  },
  {
    "_id": 2180,
    "id": 2920,
    "pid": 26,
    "city_code": "101030600",
    "city_name": "北辰区"
  },
  {
    "_id": 2181,
    "id": 2921,
    "pid": 26,
    "city_code": "101031100",
    "city_name": "塘沽区"
  },
  {
    "_id": 2182,
    "id": 2922,
    "pid": 26,
    "city_code": "101030800",
    "city_name": "汉沽区"
  },
  {
    "_id": 2183,
    "id": 2923,
    "pid": 26,
    "city_code": "101031200",
    "city_name": "大港区"
  },
  {
    "_id": 2184,
    "id": 2924,
    "pid": 26,
    "city_code": "101030200",
    "city_name": "武清区"
  },
  {
    "_id": 2185,
    "id": 2925,
    "pid": 26,
    "city_code": "101030300",
    "city_name": "宝坻区"
  },
  {
    "_id": 2186,
    "id": 2927,
    "pid": 26,
    "city_code": "101030700",
    "city_name": "宁河区"
  },
  {
    "_id": 2187,
    "id": 2928,
    "pid": 26,
    "city_code": "101030900",
    "city_name": "静海区"
  },
  {
    "_id": 2188,
    "id": 2929,
    "pid": 26,
    "city_code": "101031400",
    "city_name": "蓟州区"
  },
  {
    "_id": 2189,
    "id": 2931,
    "pid": 343,
    "city_code": "101140104",
    "city_name": "林周县"
  },
  {
    "_id": 2190,
    "id": 2932,
    "pid": 343,
    "city_code": "101140102",
    "city_name": "当雄县"
  },
  {
    "_id": 2191,
    "id": 2933,
    "pid": 343,
    "city_code": "101140103",
    "city_name": "尼木县"
  },
  {
    "_id": 2192,
    "id": 2934,
    "pid": 343,
    "city_code": "101140106",
    "city_name": "曲水县"
  },
  {
    "_id": 2193,
    "id": 2935,
    "pid": 343,
    "city_code": "101140105",
    "city_name": "堆龙德庆县"
  },
  {
    "_id": 2194,
    "id": 2936,
    "pid": 343,
    "city_code": "101140107",
    "city_name": "达孜县"
  },
  {
    "_id": 2195,
    "id": 2937,
    "pid": 343,
    "city_code": "101140108",
    "city_name": "墨竹工卡县"
  },
  {
    "_id": 2196,
    "id": 2938,
    "pid": 344,
    "city_code": "101140707",
    "city_name": "噶尔县"
  },
  {
    "_id": 2197,
    "id": 2939,
    "pid": 344,
    "city_code": "101140705",
    "city_name": "普兰县"
  },
  {
    "_id": 2198,
    "id": 2940,
    "pid": 344,
    "city_code": "101140706",
    "city_name": "札达县"
  },
  {
    "_id": 2199,
    "id": 2941,
    "pid": 344,
    "city_code": "101140708",
    "city_name": "日土县"
  },
  {
    "_id": 2200,
    "id": 2942,
    "pid": 344,
    "city_code": "101140709",
    "city_name": "革吉县"
  },
  {
    "_id": 2201,
    "id": 2943,
    "pid": 344,
    "city_code": "101140702",
    "city_name": "改则县"
  },
  {
    "_id": 2202,
    "id": 2944,
    "pid": 344,
    "city_code": "101140710",
    "city_name": "措勤县"
  },
  {
    "_id": 2203,
    "id": 2945,
    "pid": 345,
    "city_code": "101140501",
    "city_name": "昌都县"
  },
  {
    "_id": 2204,
    "id": 2946,
    "pid": 345,
    "city_code": "101140509",
    "city_name": "江达县"
  },
  {
    "_id": 2205,
    "id": 2947,
    "pid": 345,
    "city_code": "101140511",
    "city_name": "贡觉县"
  },
  {
    "_id": 2206,
    "id": 2948,
    "pid": 345,
    "city_code": "101140503",
    "city_name": "类乌齐县"
  },
  {
    "_id": 2207,
    "id": 2949,
    "pid": 345,
    "city_code": "101140502",
    "city_name": "丁青县"
  },
  {
    "_id": 2208,
    "id": 2950,
    "pid": 345,
    "city_code": "101140510",
    "city_name": "察雅县"
  },
  {
    "_id": 2209,
    "id": 2951,
    "pid": 345,
    "city_code": "101140507",
    "city_name": "八宿县"
  },
  {
    "_id": 2210,
    "id": 2952,
    "pid": 345,
    "city_code": "101140505",
    "city_name": "左贡县"
  },
  {
    "_id": 2211,
    "id": 2953,
    "pid": 345,
    "city_code": "101140506",
    "city_name": "芒康县"
  },
  {
    "_id": 2212,
    "id": 2954,
    "pid": 345,
    "city_code": "101140504",
    "city_name": "洛隆县"
  },
  {
    "_id": 2213,
    "id": 2955,
    "pid": 345,
    "city_code": "101140503",
    "city_name": "边坝县"
  },
  {
    "_id": 2214,
    "id": 2956,
    "pid": 346,
    "city_code": "101140401",
    "city_name": "林芝县"
  },
  {
    "_id": 2215,
    "id": 2957,
    "pid": 346,
    "city_code": "101140405",
    "city_name": "工布江达县"
  },
  {
    "_id": 2216,
    "id": 2958,
    "pid": 346,
    "city_code": "101140403",
    "city_name": "米林县"
  },
  {
    "_id": 2217,
    "id": 2959,
    "pid": 346,
    "city_code": "101140407",
    "city_name": "墨脱县"
  },
  {
    "_id": 2218,
    "id": 2960,
    "pid": 346,
    "city_code": "101140402",
    "city_name": "波密县"
  },
  {
    "_id": 2219,
    "id": 2961,
    "pid": 346,
    "city_code": "101140404",
    "city_name": "察隅县"
  },
  {
    "_id": 2220,
    "id": 2962,
    "pid": 346,
    "city_code": "101140406",
    "city_name": "朗县"
  },
  {
    "_id": 2221,
    "id": 2963,
    "pid": 347,
    "city_code": "101140601",
    "city_name": "那曲县"
  },
  {
    "_id": 2222,
    "id": 2964,
    "pid": 347,
    "city_code": "101140603",
    "city_name": "嘉黎县"
  },
  {
    "_id": 2223,
    "id": 2965,
    "pid": 347,
    "city_code": "101140607",
    "city_name": "比如县"
  },
  {
    "_id": 2224,
    "id": 2966,
    "pid": 347,
    "city_code": "101140607",
    "city_name": "聂荣县"
  },
  {
    "_id": 2225,
    "id": 2967,
    "pid": 347,
    "city_code": "101140605",
    "city_name": "安多县"
  },
  {
    "_id": 2226,
    "id": 2968,
    "pid": 347,
    "city_code": "101140703",
    "city_name": "申扎县"
  },
  {
    "_id": 2227,
    "id": 2969,
    "pid": 347,
    "city_code": "101140606",
    "city_name": "索县"
  },
  {
    "_id": 2228,
    "id": 2970,
    "pid": 347,
    "city_code": "101140604",
    "city_name": "班戈县"
  },
  {
    "_id": 2229,
    "id": 2971,
    "pid": 347,
    "city_code": "101140608",
    "city_name": "巴青县"
  },
  {
    "_id": 2230,
    "id": 2972,
    "pid": 347,
    "city_code": "101140602",
    "city_name": "尼玛县"
  },
  {
    "_id": 2231,
    "id": 2973,
    "pid": 348,
    "city_code": "101140201",
    "city_name": "日喀则市"
  },
  {
    "_id": 2232,
    "id": 2974,
    "pid": 348,
    "city_code": "101140203",
    "city_name": "南木林县"
  },
  {
    "_id": 2233,
    "id": 2975,
    "pid": 348,
    "city_code": "101140206",
    "city_name": "江孜县"
  },
  {
    "_id": 2234,
    "id": 2976,
    "pid": 348,
    "city_code": "101140205",
    "city_name": "定日县"
  },
  {
    "_id": 2235,
    "id": 2977,
    "pid": 348,
    "city_code": "101140213",
    "city_name": "萨迦县"
  },
  {
    "_id": 2236,
    "id": 2978,
    "pid": 348,
    "city_code": "101140202",
    "city_name": "拉孜县"
  },
  {
    "_id": 2237,
    "id": 2979,
    "pid": 348,
    "city_code": "101140211",
    "city_name": "昂仁县"
  },
  {
    "_id": 2238,
    "id": 2980,
    "pid": 348,
    "city_code": "101140214",
    "city_name": "谢通门县"
  },
  {
    "_id": 2239,
    "id": 2981,
    "pid": 348,
    "city_code": "101140217",
    "city_name": "白朗县"
  },
  {
    "_id": 2240,
    "id": 2982,
    "pid": 348,
    "city_code": "101140220",
    "city_name": "仁布县"
  },
  {
    "_id": 2241,
    "id": 2983,
    "pid": 348,
    "city_code": "101140219",
    "city_name": "康马县"
  },
  {
    "_id": 2242,
    "id": 2984,
    "pid": 348,
    "city_code": "101140212",
    "city_name": "定结县"
  },
  {
    "_id": 2243,
    "id": 2985,
    "pid": 348,
    "city_code": "101140208",
    "city_name": "仲巴县"
  },
  {
    "_id": 2244,
    "id": 2986,
    "pid": 348,
    "city_code": "101140218",
    "city_name": "亚东县"
  },
  {
    "_id": 2245,
    "id": 2987,
    "pid": 348,
    "city_code": "101140210",
    "city_name": "吉隆县"
  },
  {
    "_id": 2246,
    "id": 2988,
    "pid": 348,
    "city_code": "101140204",
    "city_name": "聂拉木县"
  },
  {
    "_id": 2247,
    "id": 2989,
    "pid": 348,
    "city_code": "101140209",
    "city_name": "萨嘎县"
  },
  {
    "_id": 2248,
    "id": 2990,
    "pid": 348,
    "city_code": "101140216",
    "city_name": "岗巴县"
  },
  {
    "_id": 2249,
    "id": 2991,
    "pid": 349,
    "city_code": "101140309",
    "city_name": "乃东县"
  },
  {
    "_id": 2250,
    "id": 2992,
    "pid": 349,
    "city_code": "101140303",
    "city_name": "扎囊县"
  },
  {
    "_id": 2251,
    "id": 2993,
    "pid": 349,
    "city_code": "101140302",
    "city_name": "贡嘎县"
  },
  {
    "_id": 2252,
    "id": 2994,
    "pid": 349,
    "city_code": "101140310",
    "city_name": "桑日县"
  },
  {
    "_id": 2253,
    "id": 2995,
    "pid": 349,
    "city_code": "101140303",
    "city_name": "琼结县"
  },
  {
    "_id": 2254,
    "id": 2996,
    "pid": 349,
    "city_code": "101140314",
    "city_name": "曲松县"
  },
  {
    "_id": 2255,
    "id": 2997,
    "pid": 349,
    "city_code": "101140312",
    "city_name": "措美县"
  },
  {
    "_id": 2256,
    "id": 2998,
    "pid": 349,
    "city_code": "101140311",
    "city_name": "洛扎县"
  },
  {
    "_id": 2257,
    "id": 2999,
    "pid": 349,
    "city_code": "101140304",
    "city_name": "加查县"
  },
  {
    "_id": 2258,
    "id": 3000,
    "pid": 349,
    "city_code": "101140307",
    "city_name": "隆子县"
  },
  {
    "_id": 2259,
    "id": 3001,
    "pid": 349,
    "city_code": "101140306",
    "city_name": "错那县"
  },
  {
    "_id": 2260,
    "id": 3002,
    "pid": 349,
    "city_code": "101140305",
    "city_name": "浪卡子县"
  },
  {
    "_id": 2261,
    "id": 3008,
    "pid": 350,
    "city_code": "101130105",
    "city_name": "达坂城区"
  },
  {
    "_id": 2262,
    "id": 3010,
    "pid": 350,
    "city_code": "101130101",
    "city_name": "乌鲁木齐县"
  },
  {
    "_id": 2263,
    "id": 3011,
    "pid": 351,
    "city_code": "101130801",
    "city_name": "阿克苏市"
  },
  {
    "_id": 2264,
    "id": 3012,
    "pid": 351,
    "city_code": "101130803",
    "city_name": "温宿县"
  },
  {
    "_id": 2265,
    "id": 3013,
    "pid": 351,
    "city_code": "101130807",
    "city_name": "库车县"
  },
  {
    "_id": 2266,
    "id": 3014,
    "pid": 351,
    "city_code": "101130806",
    "city_name": "沙雅县"
  },
  {
    "_id": 2267,
    "id": 3015,
    "pid": 351,
    "city_code": "101130805",
    "city_name": "新和县"
  },
  {
    "_id": 2268,
    "id": 3016,
    "pid": 351,
    "city_code": "101130804",
    "city_name": "拜城县"
  },
  {
    "_id": 2269,
    "id": 3017,
    "pid": 351,
    "city_code": "101130802",
    "city_name": "乌什县"
  },
  {
    "_id": 2270,
    "id": 3018,
    "pid": 351,
    "city_code": "101130809",
    "city_name": "阿瓦提县"
  },
  {
    "_id": 2271,
    "id": 3019,
    "pid": 351,
    "city_code": "101130808",
    "city_name": "柯坪县"
  },
  {
    "_id": 2272,
    "id": 3020,
    "pid": 352,
    "city_code": "101130701",
    "city_name": "阿拉尔市"
  },
  {
    "_id": 2273,
    "id": 3021,
    "pid": 353,
    "city_code": "101130601",
    "city_name": "库尔勒"
  },
  {
    "_id": 2274,
    "id": 3022,
    "pid": 353,
    "city_code": "101130602",
    "city_name": "轮台县"
  },
  {
    "_id": 2275,
    "id": 3023,
    "pid": 353,
    "city_code": "101130603",
    "city_name": "尉犁县"
  },
  {
    "_id": 2276,
    "id": 3024,
    "pid": 353,
    "city_code": "101130604",
    "city_name": "若羌县"
  },
  {
    "_id": 2277,
    "id": 3025,
    "pid": 353,
    "city_code": "101130605",
    "city_name": "且末县"
  },
  {
    "_id": 2278,
    "id": 3026,
    "pid": 353,
    "city_code": "101130607",
    "city_name": "焉耆县"
  },
  {
    "_id": 2279,
    "id": 3027,
    "pid": 353,
    "city_code": "101130606",
    "city_name": "和静县"
  },
  {
    "_id": 2280,
    "id": 3028,
    "pid": 353,
    "city_code": "101130608",
    "city_name": "和硕县"
  },
  {
    "_id": 2281,
    "id": 3029,
    "pid": 353,
    "city_code": "101130612",
    "city_name": "博湖县"
  },
  {
    "_id": 2282,
    "id": 3030,
    "pid": 354,
    "city_code": "101131601",
    "city_name": "博乐市"
  },
  {
    "_id": 2283,
    "id": 3031,
    "pid": 354,
    "city_code": "101131603",
    "city_name": "精河县"
  },
  {
    "_id": 2284,
    "id": 3032,
    "pid": 354,
    "city_code": "101131602",
    "city_name": "温泉县"
  },
  {
    "_id": 2285,
    "id": 3033,
    "pid": 355,
    "city_code": "101130402",
    "city_name": "呼图壁县"
  },
  {
    "_id": 2286,
    "id": 3034,
    "pid": 355,
    "city_code": "101130403",
    "city_name": "米泉市"
  },
  {
    "_id": 2287,
    "id": 3035,
    "pid": 355,
    "city_code": "101130401",
    "city_name": "昌吉市"
  },
  {
    "_id": 2288,
    "id": 3036,
    "pid": 355,
    "city_code": "101130404",
    "city_name": "阜康市"
  },
  {
    "_id": 2289,
    "id": 3037,
    "pid": 355,
    "city_code": "101130407",
    "city_name": "玛纳斯县"
  },
  {
    "_id": 2290,
    "id": 3038,
    "pid": 355,
    "city_code": "101130406",
    "city_name": "奇台县"
  },
  {
    "_id": 2291,
    "id": 3039,
    "pid": 355,
    "city_code": "101130405",
    "city_name": "吉木萨尔县"
  },
  {
    "_id": 2292,
    "id": 3040,
    "pid": 355,
    "city_code": "101130408",
    "city_name": "木垒县"
  },
  {
    "_id": 2293,
    "id": 3041,
    "pid": 356,
    "city_code": "101131201",
    "city_name": "哈密市"
  },
  {
    "_id": 2294,
    "id": 3042,
    "pid": 356,
    "city_code": "101131204",
    "city_name": "伊吾县"
  },
  {
    "_id": 2295,
    "id": 3043,
    "pid": 356,
    "city_code": "101131203",
    "city_name": "巴里坤"
  },
  {
    "_id": 2296,
    "id": 3044,
    "pid": 357,
    "city_code": "101131301",
    "city_name": "和田市"
  },
  {
    "_id": 2297,
    "id": 3045,
    "pid": 357,
    "city_code": "101131301",
    "city_name": "和田县"
  },
  {
    "_id": 2298,
    "id": 3046,
    "pid": 357,
    "city_code": "101131304",
    "city_name": "墨玉县"
  },
  {
    "_id": 2299,
    "id": 3047,
    "pid": 357,
    "city_code": "101131302",
    "city_name": "皮山县"
  },
  {
    "_id": 2300,
    "id": 3048,
    "pid": 357,
    "city_code": "101131305",
    "city_name": "洛浦县"
  },
  {
    "_id": 2301,
    "id": 3049,
    "pid": 357,
    "city_code": "101131303",
    "city_name": "策勒县"
  },
  {
    "_id": 2302,
    "id": 3050,
    "pid": 357,
    "city_code": "101131307",
    "city_name": "于田县"
  },
  {
    "_id": 2303,
    "id": 3051,
    "pid": 357,
    "city_code": "101131306",
    "city_name": "民丰县"
  },
  {
    "_id": 2304,
    "id": 3052,
    "pid": 358,
    "city_code": "101130901",
    "city_name": "喀什市"
  },
  {
    "_id": 2305,
    "id": 3053,
    "pid": 358,
    "city_code": "101130911",
    "city_name": "疏附县"
  },
  {
    "_id": 2306,
    "id": 3054,
    "pid": 358,
    "city_code": "101130912",
    "city_name": "疏勒县"
  },
  {
    "_id": 2307,
    "id": 3055,
    "pid": 358,
    "city_code": "101130902",
    "city_name": "英吉沙县"
  },
  {
    "_id": 2308,
    "id": 3056,
    "pid": 358,
    "city_code": "101130907",
    "city_name": "泽普县"
  },
  {
    "_id": 2309,
    "id": 3057,
    "pid": 358,
    "city_code": "101130905",
    "city_name": "莎车县"
  },
  {
    "_id": 2310,
    "id": 3058,
    "pid": 358,
    "city_code": "101130906",
    "city_name": "叶城县"
  },
  {
    "_id": 2311,
    "id": 3059,
    "pid": 358,
    "city_code": "101130904",
    "city_name": "麦盖提县"
  },
  {
    "_id": 2312,
    "id": 3060,
    "pid": 358,
    "city_code": "101130909",
    "city_name": "岳普湖县"
  },
  {
    "_id": 2313,
    "id": 3061,
    "pid": 358,
    "city_code": "101130910",
    "city_name": "伽师县"
  },
  {
    "_id": 2314,
    "id": 3062,
    "pid": 358,
    "city_code": "101130908",
    "city_name": "巴楚县"
  },
  {
    "_id": 2315,
    "id": 3063,
    "pid": 358,
    "city_code": "101130903",
    "city_name": "塔什库尔干"
  },
  {
    "_id": 2316,
    "id": 3064,
    "pid": 359,
    "city_code": "101130201",
    "city_name": "克拉玛依市"
  },
  {
    "_id": 2317,
    "id": 3065,
    "pid": 360,
    "city_code": "101131501",
    "city_name": "阿图什市"
  },
  {
    "_id": 2318,
    "id": 3066,
    "pid": 360,
    "city_code": "101131503",
    "city_name": "阿克陶县"
  },
  {
    "_id": 2319,
    "id": 3067,
    "pid": 360,
    "city_code": "101131504",
    "city_name": "阿合奇县"
  },
  {
    "_id": 2320,
    "id": 3068,
    "pid": 360,
    "city_code": "101131502",
    "city_name": "乌恰县"
  },
  {
    "_id": 2321,
    "id": 3069,
    "pid": 361,
    "city_code": "101130301",
    "city_name": "石河子市"
  },
  {
    "_id": 2322,
    "id": 3071,
    "pid": 363,
    "city_code": "101130501",
    "city_name": "吐鲁番市"
  },
  {
    "_id": 2323,
    "id": 3072,
    "pid": 363,
    "city_code": "101130504",
    "city_name": "鄯善县"
  },
  {
    "_id": 2324,
    "id": 3073,
    "pid": 363,
    "city_code": "101130502",
    "city_name": "托克逊县"
  },
  {
    "_id": 2325,
    "id": 3075,
    "pid": 365,
    "city_code": "101131401",
    "city_name": "阿勒泰"
  },
  {
    "_id": 2326,
    "id": 3076,
    "pid": 365,
    "city_code": "101131104",
    "city_name": "和布克赛尔"
  },
  {
    "_id": 2327,
    "id": 3077,
    "pid": 365,
    "city_code": "101131001",
    "city_name": "伊宁市"
  },
  {
    "_id": 2328,
    "id": 3078,
    "pid": 365,
    "city_code": "101131406",
    "city_name": "布尔津县"
  },
  {
    "_id": 2329,
    "id": 3079,
    "pid": 365,
    "city_code": "101131011",
    "city_name": "奎屯市"
  },
  {
    "_id": 2330,
    "id": 3080,
    "pid": 365,
    "city_code": "101131106",
    "city_name": "乌苏市"
  },
  {
    "_id": 2331,
    "id": 3081,
    "pid": 365,
    "city_code": "101131103",
    "city_name": "额敏县"
  },
  {
    "_id": 2332,
    "id": 3082,
    "pid": 365,
    "city_code": "101131408",
    "city_name": "富蕴县"
  },
  {
    "_id": 2333,
    "id": 3083,
    "pid": 365,
    "city_code": "101131004",
    "city_name": "伊宁县"
  },
  {
    "_id": 2334,
    "id": 3084,
    "pid": 365,
    "city_code": "101131407",
    "city_name": "福海县"
  },
  {
    "_id": 2335,
    "id": 3085,
    "pid": 365,
    "city_code": "101131009",
    "city_name": "霍城县"
  },
  {
    "_id": 2336,
    "id": 3086,
    "pid": 365,
    "city_code": "101131107",
    "city_name": "沙湾县"
  },
  {
    "_id": 2337,
    "id": 3087,
    "pid": 365,
    "city_code": "101131005",
    "city_name": "巩留县"
  },
  {
    "_id": 2338,
    "id": 3088,
    "pid": 365,
    "city_code": "101131402",
    "city_name": "哈巴河县"
  },
  {
    "_id": 2339,
    "id": 3089,
    "pid": 365,
    "city_code": "101131105",
    "city_name": "托里县"
  },
  {
    "_id": 2340,
    "id": 3090,
    "pid": 365,
    "city_code": "101131409",
    "city_name": "青河县"
  },
  {
    "_id": 2341,
    "id": 3091,
    "pid": 365,
    "city_code": "101131006",
    "city_name": "新源县"
  },
  {
    "_id": 2342,
    "id": 3092,
    "pid": 365,
    "city_code": "101131102",
    "city_name": "裕民县"
  },
  {
    "_id": 2343,
    "id": 3094,
    "pid": 365,
    "city_code": "101131405",
    "city_name": "吉木乃县"
  },
  {
    "_id": 2344,
    "id": 3095,
    "pid": 365,
    "city_code": "101131007",
    "city_name": "昭苏县"
  },
  {
    "_id": 2345,
    "id": 3096,
    "pid": 365,
    "city_code": "101131008",
    "city_name": "特克斯县"
  },
  {
    "_id": 2346,
    "id": 3097,
    "pid": 365,
    "city_code": "101131003",
    "city_name": "尼勒克县"
  },
  {
    "_id": 2347,
    "id": 3098,
    "pid": 365,
    "city_code": "101131002",
    "city_name": "察布查尔"
  },
  {
    "_id": 2348,
    "id": 3103,
    "pid": 366,
    "city_code": "101290103",
    "city_name": "东川区"
  },
  {
    "_id": 2349,
    "id": 3104,
    "pid": 366,
    "city_code": "101290112",
    "city_name": "安宁市"
  },
  {
    "_id": 2350,
    "id": 3105,
    "pid": 366,
    "city_code": "101290108",
    "city_name": "呈贡县"
  },
  {
    "_id": 2351,
    "id": 3106,
    "pid": 366,
    "city_code": "101290105",
    "city_name": "晋宁县"
  },
  {
    "_id": 2352,
    "id": 3107,
    "pid": 366,
    "city_code": "101290109",
    "city_name": "富民县"
  },
  {
    "_id": 2353,
    "id": 3108,
    "pid": 366,
    "city_code": "101290106",
    "city_name": "宜良县"
  },
  {
    "_id": 2354,
    "id": 3109,
    "pid": 366,
    "city_code": "101290110",
    "city_name": "嵩明县"
  },
  {
    "_id": 2355,
    "id": 3110,
    "pid": 366,
    "city_code": "101290107",
    "city_name": "石林县"
  },
  {
    "_id": 2356,
    "id": 3111,
    "pid": 366,
    "city_code": "101290111",
    "city_name": "禄劝县"
  },
  {
    "_id": 2357,
    "id": 3112,
    "pid": 366,
    "city_code": "101290104",
    "city_name": "寻甸县"
  },
  {
    "_id": 2358,
    "id": 3113,
    "pid": 367,
    "city_code": "101291204",
    "city_name": "兰坪县"
  },
  {
    "_id": 2359,
    "id": 3114,
    "pid": 367,
    "city_code": "101291205",
    "city_name": "泸水县"
  },
  {
    "_id": 2360,
    "id": 3115,
    "pid": 367,
    "city_code": "101291203",
    "city_name": "福贡县"
  },
  {
    "_id": 2361,
    "id": 3116,
    "pid": 367,
    "city_code": "101291207",
    "city_name": "贡山县"
  },
  {
    "_id": 2362,
    "id": 3117,
    "pid": 368,
    "city_code": "101290912",
    "city_name": "宁洱县"
  },
  {
    "_id": 2363,
    "id": 3118,
    "pid": 368,
    "city_code": "101290901",
    "city_name": "思茅区"
  },
  {
    "_id": 2364,
    "id": 3119,
    "pid": 368,
    "city_code": "101290906",
    "city_name": "墨江县"
  },
  {
    "_id": 2365,
    "id": 3120,
    "pid": 368,
    "city_code": "101290903",
    "city_name": "景东县"
  },
  {
    "_id": 2366,
    "id": 3121,
    "pid": 368,
    "city_code": "101290902",
    "city_name": "景谷县"
  },
  {
    "_id": 2367,
    "id": 3122,
    "pid": 368,
    "city_code": "101290911",
    "city_name": "镇沅县"
  },
  {
    "_id": 2368,
    "id": 3123,
    "pid": 368,
    "city_code": "101290907",
    "city_name": "江城县"
  },
  {
    "_id": 2369,
    "id": 3124,
    "pid": 368,
    "city_code": "101290908",
    "city_name": "孟连县"
  },
  {
    "_id": 2370,
    "id": 3125,
    "pid": 368,
    "city_code": "101290904",
    "city_name": "澜沧县"
  },
  {
    "_id": 2371,
    "id": 3126,
    "pid": 368,
    "city_code": "101290909",
    "city_name": "西盟县"
  },
  {
    "_id": 2372,
    "id": 3128,
    "pid": 369,
    "city_code": "101291404",
    "city_name": "宁蒗县"
  },
  {
    "_id": 2373,
    "id": 3130,
    "pid": 369,
    "city_code": "101291402",
    "city_name": "永胜县"
  },
  {
    "_id": 2374,
    "id": 3131,
    "pid": 369,
    "city_code": "101291403",
    "city_name": "华坪县"
  },
  {
    "_id": 2375,
    "id": 3133,
    "pid": 370,
    "city_code": "101290504",
    "city_name": "施甸县"
  },
  {
    "_id": 2376,
    "id": 3134,
    "pid": 370,
    "city_code": "101290506",
    "city_name": "腾冲县"
  },
  {
    "_id": 2377,
    "id": 3135,
    "pid": 370,
    "city_code": "101290503",
    "city_name": "龙陵县"
  },
  {
    "_id": 2378,
    "id": 3136,
    "pid": 370,
    "city_code": "101290505",
    "city_name": "昌宁县"
  },
  {
    "_id": 2379,
    "id": 3137,
    "pid": 371,
    "city_code": "101290801",
    "city_name": "楚雄市"
  },
  {
    "_id": 2380,
    "id": 3138,
    "pid": 371,
    "city_code": "101290809",
    "city_name": "双柏县"
  },
  {
    "_id": 2381,
    "id": 3139,
    "pid": 371,
    "city_code": "101290805",
    "city_name": "牟定县"
  },
  {
    "_id": 2382,
    "id": 3140,
    "pid": 371,
    "city_code": "101290806",
    "city_name": "南华县"
  },
  {
    "_id": 2383,
    "id": 3141,
    "pid": 371,
    "city_code": "101290804",
    "city_name": "姚安县"
  },
  {
    "_id": 2384,
    "id": 3142,
    "pid": 371,
    "city_code": "101290802",
    "city_name": "大姚县"
  },
  {
    "_id": 2385,
    "id": 3143,
    "pid": 371,
    "city_code": "101290810",
    "city_name": "永仁县"
  },
  {
    "_id": 2386,
    "id": 3144,
    "pid": 371,
    "city_code": "101290803",
    "city_name": "元谋县"
  },
  {
    "_id": 2387,
    "id": 3145,
    "pid": 371,
    "city_code": "101290807",
    "city_name": "武定县"
  },
  {
    "_id": 2388,
    "id": 3146,
    "pid": 371,
    "city_code": "101290808",
    "city_name": "禄丰县"
  },
  {
    "_id": 2389,
    "id": 3147,
    "pid": 372,
    "city_code": "101290201",
    "city_name": "大理市"
  },
  {
    "_id": 2390,
    "id": 3148,
    "pid": 372,
    "city_code": "101290207",
    "city_name": "祥云县"
  },
  {
    "_id": 2391,
    "id": 3149,
    "pid": 372,
    "city_code": "101290205",
    "city_name": "宾川县"
  },
  {
    "_id": 2392,
    "id": 3150,
    "pid": 372,
    "city_code": "101290206",
    "city_name": "弥渡县"
  },
  {
    "_id": 2393,
    "id": 3151,
    "pid": 372,
    "city_code": "101290204",
    "city_name": "永平县"
  },
  {
    "_id": 2394,
    "id": 3152,
    "pid": 372,
    "city_code": "101290202",
    "city_name": "云龙县"
  },
  {
    "_id": 2395,
    "id": 3153,
    "pid": 372,
    "city_code": "101290210",
    "city_name": "洱源县"
  },
  {
    "_id": 2396,
    "id": 3154,
    "pid": 372,
    "city_code": "101290209",
    "city_name": "剑川县"
  },
  {
    "_id": 2397,
    "id": 3155,
    "pid": 372,
    "city_code": "101290211",
    "city_name": "鹤庆县"
  },
  {
    "_id": 2398,
    "id": 3156,
    "pid": 372,
    "city_code": "101290203",
    "city_name": "漾濞县"
  },
  {
    "_id": 2399,
    "id": 3157,
    "pid": 372,
    "city_code": "101290212",
    "city_name": "南涧县"
  },
  {
    "_id": 2400,
    "id": 3158,
    "pid": 372,
    "city_code": "101290208",
    "city_name": "巍山县"
  },
  {
    "_id": 2401,
    "id": 3159,
    "pid": 373,
    "city_code": "101291508",
    "city_name": "潞西市"
  },
  {
    "_id": 2402,
    "id": 3160,
    "pid": 373,
    "city_code": "101291506",
    "city_name": "瑞丽市"
  },
  {
    "_id": 2403,
    "id": 3161,
    "pid": 373,
    "city_code": "101291507",
    "city_name": "梁河县"
  },
  {
    "_id": 2404,
    "id": 3162,
    "pid": 373,
    "city_code": "101291504",
    "city_name": "盈江县"
  },
  {
    "_id": 2405,
    "id": 3163,
    "pid": 373,
    "city_code": "101291503",
    "city_name": "陇川县"
  },
  {
    "_id": 2406,
    "id": 3164,
    "pid": 374,
    "city_code": "101291301",
    "city_name": "香格里拉县"
  },
  {
    "_id": 2407,
    "id": 3165,
    "pid": 374,
    "city_code": "101291302",
    "city_name": "德钦县"
  },
  {
    "_id": 2408,
    "id": 3166,
    "pid": 374,
    "city_code": "101291303",
    "city_name": "维西县"
  },
  {
    "_id": 2409,
    "id": 3167,
    "pid": 375,
    "city_code": "101290311",
    "city_name": "泸西县"
  },
  {
    "_id": 2410,
    "id": 3168,
    "pid": 375,
    "city_code": "101290309",
    "city_name": "蒙自市"
  },
  {
    "_id": 2411,
    "id": 3169,
    "pid": 375,
    "city_code": "101290308",
    "city_name": "个旧市"
  },
  {
    "_id": 2412,
    "id": 3170,
    "pid": 375,
    "city_code": "101290307",
    "city_name": "开远市"
  },
  {
    "_id": 2413,
    "id": 3171,
    "pid": 375,
    "city_code": "101290306",
    "city_name": "绿春县"
  },
  {
    "_id": 2414,
    "id": 3172,
    "pid": 375,
    "city_code": "101290303",
    "city_name": "建水县"
  },
  {
    "_id": 2415,
    "id": 3173,
    "pid": 375,
    "city_code": "101290302",
    "city_name": "石屏县"
  },
  {
    "_id": 2416,
    "id": 3174,
    "pid": 375,
    "city_code": "101290304",
    "city_name": "弥勒县"
  },
  {
    "_id": 2417,
    "id": 3175,
    "pid": 375,
    "city_code": "101290305",
    "city_name": "元阳县"
  },
  {
    "_id": 2418,
    "id": 3176,
    "pid": 375,
    "city_code": "101290301",
    "city_name": "红河县"
  },
  {
    "_id": 2419,
    "id": 3177,
    "pid": 375,
    "city_code": "101290312",
    "city_name": "金平县"
  },
  {
    "_id": 2420,
    "id": 3178,
    "pid": 375,
    "city_code": "101290313",
    "city_name": "河口县"
  },
  {
    "_id": 2421,
    "id": 3179,
    "pid": 375,
    "city_code": "101290310",
    "city_name": "屏边县"
  },
  {
    "_id": 2422,
    "id": 3181,
    "pid": 376,
    "city_code": "101291105",
    "city_name": "凤庆县"
  },
  {
    "_id": 2423,
    "id": 3182,
    "pid": 376,
    "city_code": "101291107",
    "city_name": "云县"
  },
  {
    "_id": 2424,
    "id": 3183,
    "pid": 376,
    "city_code": "101291106",
    "city_name": "永德县"
  },
  {
    "_id": 2425,
    "id": 3184,
    "pid": 376,
    "city_code": "101291108",
    "city_name": "镇康县"
  },
  {
    "_id": 2426,
    "id": 3185,
    "pid": 376,
    "city_code": "101291104",
    "city_name": "双江县"
  },
  {
    "_id": 2427,
    "id": 3186,
    "pid": 376,
    "city_code": "101291103",
    "city_name": "耿马县"
  },
  {
    "_id": 2428,
    "id": 3187,
    "pid": 376,
    "city_code": "101291102",
    "city_name": "沧源县"
  },
  {
    "_id": 2429,
    "id": 3189,
    "pid": 377,
    "city_code": "101290409",
    "city_name": "宣威市"
  },
  {
    "_id": 2430,
    "id": 3190,
    "pid": 377,
    "city_code": "101290405",
    "city_name": "马龙县"
  },
  {
    "_id": 2431,
    "id": 3191,
    "pid": 377,
    "city_code": "101290403",
    "city_name": "陆良县"
  },
  {
    "_id": 2432,
    "id": 3192,
    "pid": 377,
    "city_code": "101290406",
    "city_name": "师宗县"
  },
  {
    "_id": 2433,
    "id": 3193,
    "pid": 377,
    "city_code": "101290407",
    "city_name": "罗平县"
  },
  {
    "_id": 2434,
    "id": 3194,
    "pid": 377,
    "city_code": "101290404",
    "city_name": "富源县"
  },
  {
    "_id": 2435,
    "id": 3195,
    "pid": 377,
    "city_code": "101290408",
    "city_name": "会泽县"
  },
  {
    "_id": 2436,
    "id": 3196,
    "pid": 377,
    "city_code": "101290402",
    "city_name": "沾益县"
  },
  {
    "_id": 2437,
    "id": 3197,
    "pid": 378,
    "city_code": "101290601",
    "city_name": "文山县"
  },
  {
    "_id": 2438,
    "id": 3198,
    "pid": 378,
    "city_code": "101290605",
    "city_name": "砚山县"
  },
  {
    "_id": 2439,
    "id": 3199,
    "pid": 378,
    "city_code": "101290602",
    "city_name": "西畴县"
  },
  {
    "_id": 2440,
    "id": 3200,
    "pid": 378,
    "city_code": "101290604",
    "city_name": "麻栗坡县"
  },
  {
    "_id": 2441,
    "id": 3201,
    "pid": 378,
    "city_code": "101290603",
    "city_name": "马关县"
  },
  {
    "_id": 2442,
    "id": 3202,
    "pid": 378,
    "city_code": "101290606",
    "city_name": "丘北县"
  },
  {
    "_id": 2443,
    "id": 3203,
    "pid": 378,
    "city_code": "101290607",
    "city_name": "广南县"
  },
  {
    "_id": 2444,
    "id": 3204,
    "pid": 378,
    "city_code": "101290608",
    "city_name": "富宁县"
  },
  {
    "_id": 2445,
    "id": 3205,
    "pid": 379,
    "city_code": "101291601",
    "city_name": "景洪市"
  },
  {
    "_id": 2446,
    "id": 3206,
    "pid": 379,
    "city_code": "101291603",
    "city_name": "勐海县"
  },
  {
    "_id": 2447,
    "id": 3207,
    "pid": 379,
    "city_code": "101291605",
    "city_name": "勐腊县"
  },
  {
    "_id": 2448,
    "id": 3209,
    "pid": 380,
    "city_code": "101290703",
    "city_name": "江川县"
  },
  {
    "_id": 2449,
    "id": 3210,
    "pid": 380,
    "city_code": "101290702",
    "city_name": "澄江县"
  },
  {
    "_id": 2450,
    "id": 3211,
    "pid": 380,
    "city_code": "101290704",
    "city_name": "通海县"
  },
  {
    "_id": 2451,
    "id": 3212,
    "pid": 380,
    "city_code": "101290705",
    "city_name": "华宁县"
  },
  {
    "_id": 2452,
    "id": 3213,
    "pid": 380,
    "city_code": "101290707",
    "city_name": "易门县"
  },
  {
    "_id": 2453,
    "id": 3214,
    "pid": 380,
    "city_code": "101290708",
    "city_name": "峨山县"
  },
  {
    "_id": 2454,
    "id": 3215,
    "pid": 380,
    "city_code": "101290706",
    "city_name": "新平县"
  },
  {
    "_id": 2455,
    "id": 3216,
    "pid": 380,
    "city_code": "101290709",
    "city_name": "元江县"
  },
  {
    "_id": 2456,
    "id": 3218,
    "pid": 381,
    "city_code": "101291002",
    "city_name": "鲁甸县"
  },
  {
    "_id": 2457,
    "id": 3219,
    "pid": 381,
    "city_code": "101291006",
    "city_name": "巧家县"
  },
  {
    "_id": 2458,
    "id": 3220,
    "pid": 381,
    "city_code": "101291009",
    "city_name": "盐津县"
  },
  {
    "_id": 2459,
    "id": 3221,
    "pid": 381,
    "city_code": "101291010",
    "city_name": "大关县"
  },
  {
    "_id": 2460,
    "id": 3222,
    "pid": 381,
    "city_code": "101291008",
    "city_name": "永善县"
  },
  {
    "_id": 2461,
    "id": 3223,
    "pid": 381,
    "city_code": "101291007",
    "city_name": "绥江县"
  },
  {
    "_id": 2462,
    "id": 3224,
    "pid": 381,
    "city_code": "101291004",
    "city_name": "镇雄县"
  },
  {
    "_id": 2463,
    "id": 3225,
    "pid": 381,
    "city_code": "101291003",
    "city_name": "彝良县"
  },
  {
    "_id": 2464,
    "id": 3226,
    "pid": 381,
    "city_code": "101291005",
    "city_name": "威信县"
  },
  {
    "_id": 2465,
    "id": 3227,
    "pid": 381,
    "city_code": "101291011",
    "city_name": "水富县"
  },
  {
    "_id": 2466,
    "id": 3234,
    "pid": 382,
    "city_code": "101210102",
    "city_name": "萧山区"
  },
  {
    "_id": 2467,
    "id": 3235,
    "pid": 382,
    "city_code": "101210106",
    "city_name": "余杭区"
  },
  {
    "_id": 2468,
    "id": 3237,
    "pid": 382,
    "city_code": "101210105",
    "city_name": "建德市"
  },
  {
    "_id": 2469,
    "id": 3238,
    "pid": 382,
    "city_code": "101210108",
    "city_name": "富阳区"
  },
  {
    "_id": 2470,
    "id": 3239,
    "pid": 382,
    "city_code": "101210107",
    "city_name": "临安市"
  },
  {
    "_id": 2471,
    "id": 3240,
    "pid": 382,
    "city_code": "101210103",
    "city_name": "桐庐县"
  },
  {
    "_id": 2472,
    "id": 3241,
    "pid": 382,
    "city_code": "101210104",
    "city_name": "淳安县"
  },
  {
    "_id": 2473,
    "id": 3244,
    "pid": 383,
    "city_code": "101210204",
    "city_name": "德清县"
  },
  {
    "_id": 2474,
    "id": 3245,
    "pid": 383,
    "city_code": "101210202",
    "city_name": "长兴县"
  },
  {
    "_id": 2475,
    "id": 3246,
    "pid": 383,
    "city_code": "101210203",
    "city_name": "安吉县"
  },
  {
    "_id": 2476,
    "id": 3249,
    "pid": 384,
    "city_code": "101210303",
    "city_name": "海宁市"
  },
  {
    "_id": 2477,
    "id": 3250,
    "pid": 384,
    "city_code": "101210302",
    "city_name": "嘉善县"
  },
  {
    "_id": 2478,
    "id": 3251,
    "pid": 384,
    "city_code": "101210305",
    "city_name": "平湖市"
  },
  {
    "_id": 2479,
    "id": 3252,
    "pid": 384,
    "city_code": "101210304",
    "city_name": "桐乡市"
  },
  {
    "_id": 2480,
    "id": 3253,
    "pid": 384,
    "city_code": "101210306",
    "city_name": "海盐县"
  },
  {
    "_id": 2481,
    "id": 3256,
    "pid": 385,
    "city_code": "101210903",
    "city_name": "兰溪市"
  },
  {
    "_id": 2482,
    "id": 3257,
    "pid": 385,
    "city_code": "101210904",
    "city_name": "义乌市"
  },
  {
    "_id": 2483,
    "id": 3264,
    "pid": 385,
    "city_code": "101210905",
    "city_name": "东阳市"
  },
  {
    "_id": 2484,
    "id": 3265,
    "pid": 385,
    "city_code": "101210907",
    "city_name": "永康市"
  },
  {
    "_id": 2485,
    "id": 3266,
    "pid": 385,
    "city_code": "101210906",
    "city_name": "武义县"
  },
  {
    "_id": 2486,
    "id": 3267,
    "pid": 385,
    "city_code": "101210902",
    "city_name": "浦江县"
  },
  {
    "_id": 2487,
    "id": 3268,
    "pid": 385,
    "city_code": "101210908",
    "city_name": "磐安县"
  },
  {
    "_id": 2488,
    "id": 3270,
    "pid": 386,
    "city_code": "101210803",
    "city_name": "龙泉市"
  },
  {
    "_id": 2489,
    "id": 3271,
    "pid": 386,
    "city_code": "101210805",
    "city_name": "青田县"
  },
  {
    "_id": 2490,
    "id": 3272,
    "pid": 386,
    "city_code": "101210804",
    "city_name": "缙云县"
  },
  {
    "_id": 2491,
    "id": 3273,
    "pid": 386,
    "city_code": "101210802",
    "city_name": "遂昌县"
  },
  {
    "_id": 2492,
    "id": 3274,
    "pid": 386,
    "city_code": "101210808",
    "city_name": "松阳县"
  },
  {
    "_id": 2493,
    "id": 3275,
    "pid": 386,
    "city_code": "101210806",
    "city_name": "云和县"
  },
  {
    "_id": 2494,
    "id": 3276,
    "pid": 386,
    "city_code": "101210807",
    "city_name": "庆元县"
  },
  {
    "_id": 2495,
    "id": 3277,
    "pid": 386,
    "city_code": "101210809",
    "city_name": "景宁县"
  },
  {
    "_id": 2496,
    "id": 3281,
    "pid": 387,
    "city_code": "101210412",
    "city_name": "镇海区"
  },
  {
    "_id": 2497,
    "id": 3282,
    "pid": 387,
    "city_code": "101210410",
    "city_name": "北仑区"
  },
  {
    "_id": 2498,
    "id": 3283,
    "pid": 387,
    "city_code": "101210411",
    "city_name": "鄞州区"
  },
  {
    "_id": 2499,
    "id": 3284,
    "pid": 387,
    "city_code": "101210404",
    "city_name": "余姚市"
  },
  {
    "_id": 2500,
    "id": 3285,
    "pid": 387,
    "city_code": "101210403",
    "city_name": "慈溪市"
  },
  {
    "_id": 2501,
    "id": 3286,
    "pid": 387,
    "city_code": "101210405",
    "city_name": "奉化区"
  },
  {
    "_id": 2502,
    "id": 3287,
    "pid": 387,
    "city_code": "101210406",
    "city_name": "象山县"
  },
  {
    "_id": 2503,
    "id": 3288,
    "pid": 387,
    "city_code": "101210408",
    "city_name": "宁海县"
  },
  {
    "_id": 2504,
    "id": 3290,
    "pid": 388,
    "city_code": "101210503",
    "city_name": "上虞区"
  },
  {
    "_id": 2505,
    "id": 3291,
    "pid": 388,
    "city_code": "101210505",
    "city_name": "嵊州市"
  },
  {
    "_id": 2506,
    "id": 3292,
    "pid": 388,
    "city_code": "101210501",
    "city_name": "绍兴县"
  },
  {
    "_id": 2507,
    "id": 3293,
    "pid": 388,
    "city_code": "101210504",
    "city_name": "新昌县"
  },
  {
    "_id": 2508,
    "id": 3294,
    "pid": 388,
    "city_code": "101210502",
    "city_name": "诸暨市"
  },
  {
    "_id": 2509,
    "id": 3295,
    "pid": 389,
    "city_code": "101210611",
    "city_name": "椒江区"
  },
  {
    "_id": 2510,
    "id": 3296,
    "pid": 389,
    "city_code": "101210612",
    "city_name": "黄岩区"
  },
  {
    "_id": 2511,
    "id": 3297,
    "pid": 389,
    "city_code": "101210613",
    "city_name": "路桥区"
  },
  {
    "_id": 2512,
    "id": 3298,
    "pid": 389,
    "city_code": "101210607",
    "city_name": "温岭市"
  },
  {
    "_id": 2513,
    "id": 3299,
    "pid": 389,
    "city_code": "101210610",
    "city_name": "临海市"
  },
  {
    "_id": 2514,
    "id": 3300,
    "pid": 389,
    "city_code": "101210603",
    "city_name": "玉环县"
  },
  {
    "_id": 2515,
    "id": 3301,
    "pid": 389,
    "city_code": "101210604",
    "city_name": "三门县"
  },
  {
    "_id": 2516,
    "id": 3302,
    "pid": 389,
    "city_code": "101210605",
    "city_name": "天台县"
  },
  {
    "_id": 2517,
    "id": 3303,
    "pid": 389,
    "city_code": "101210606",
    "city_name": "仙居县"
  },
  {
    "_id": 2518,
    "id": 3307,
    "pid": 390,
    "city_code": "101210705",
    "city_name": "瑞安市"
  },
  {
    "_id": 2519,
    "id": 3308,
    "pid": 390,
    "city_code": "101210707",
    "city_name": "乐清市"
  },
  {
    "_id": 2520,
    "id": 3309,
    "pid": 390,
    "city_code": "101210706",
    "city_name": "洞头区"
  },
  {
    "_id": 2521,
    "id": 3310,
    "pid": 390,
    "city_code": "101210708",
    "city_name": "永嘉县"
  },
  {
    "_id": 2522,
    "id": 3311,
    "pid": 390,
    "city_code": "101210704",
    "city_name": "平阳县"
  },
  {
    "_id": 2523,
    "id": 3312,
    "pid": 390,
    "city_code": "101210709",
    "city_name": "苍南县"
  },
  {
    "_id": 2524,
    "id": 3313,
    "pid": 390,
    "city_code": "101210703",
    "city_name": "文成县"
  },
  {
    "_id": 2525,
    "id": 3314,
    "pid": 390,
    "city_code": "101210702",
    "city_name": "泰顺县"
  },
  {
    "_id": 2526,
    "id": 3315,
    "pid": 391,
    "city_code": "101211106",
    "city_name": "定海区"
  },
  {
    "_id": 2527,
    "id": 3316,
    "pid": 391,
    "city_code": "101211105",
    "city_name": "普陀区"
  },
  {
    "_id": 2528,
    "id": 3317,
    "pid": 391,
    "city_code": "101211104",
    "city_name": "岱山县"
  },
  {
    "_id": 2529,
    "id": 3318,
    "pid": 391,
    "city_code": "101211102",
    "city_name": "嵊泗县"
  },
  {
    "_id": 2530,
    "id": 3319,
    "pid": 392,
    "city_code": "101211006",
    "city_name": "衢江区"
  },
  {
    "_id": 2531,
    "id": 3320,
    "pid": 392,
    "city_code": "101211005",
    "city_name": "江山市"
  },
  {
    "_id": 2532,
    "id": 3321,
    "pid": 392,
    "city_code": "101211002",
    "city_name": "常山县"
  },
  {
    "_id": 2533,
    "id": 3322,
    "pid": 392,
    "city_code": "101211003",
    "city_name": "开化县"
  },
  {
    "_id": 2534,
    "id": 3323,
    "pid": 392,
    "city_code": "101211004",
    "city_name": "龙游县"
  },
  {
    "_id": 2535,
    "id": 3324,
    "pid": 31,
    "city_code": "101040300",
    "city_name": "合川区"
  },
  {
    "_id": 2536,
    "id": 3325,
    "pid": 31,
    "city_code": "101040500",
    "city_name": "江津区"
  },
  {
    "_id": 2537,
    "id": 3326,
    "pid": 31,
    "city_code": "101040400",
    "city_name": "南川区"
  },
  {
    "_id": 2538,
    "id": 3327,
    "pid": 31,
    "city_code": "101040200",
    "city_name": "永川区"
  },
  {
    "_id": 2539,
    "id": 3329,
    "pid": 31,
    "city_code": "101040700",
    "city_name": "渝北区"
  },
  {
    "_id": 2540,
    "id": 3330,
    "pid": 31,
    "city_code": "101040600",
    "city_name": "万盛区"
  },
  {
    "_id": 2541,
    "id": 3332,
    "pid": 31,
    "city_code": "101041300",
    "city_name": "万州区"
  },
  {
    "_id": 2542,
    "id": 3333,
    "pid": 31,
    "city_code": "101040800",
    "city_name": "北碚区"
  },
  {
    "_id": 2543,
    "id": 3334,
    "pid": 31,
    "city_code": "101043700",
    "city_name": "沙坪坝区"
  },
  {
    "_id": 2544,
    "id": 3335,
    "pid": 31,
    "city_code": "101040900",
    "city_name": "巴南区"
  },
  {
    "_id": 2545,
    "id": 3336,
    "pid": 31,
    "city_code": "101041400",
    "city_name": "涪陵区"
  },
  {
    "_id": 2546,
    "id": 3340,
    "pid": 31,
    "city_code": "101041100",
    "city_name": "黔江区"
  },
  {
    "_id": 2547,
    "id": 3341,
    "pid": 31,
    "city_code": "101041000",
    "city_name": "长寿区"
  },
  {
    "_id": 2548,
    "id": 3343,
    "pid": 31,
    "city_code": "101043300",
    "city_name": "綦江区"
  },
  {
    "_id": 2549,
    "id": 3344,
    "pid": 31,
    "city_code": "101042100",
    "city_name": "潼南区"
  },
  {
    "_id": 2550,
    "id": 3345,
    "pid": 31,
    "city_code": "101042800",
    "city_name": "铜梁区"
  },
  {
    "_id": 2551,
    "id": 3346,
    "pid": 31,
    "city_code": "101042600",
    "city_name": "大足县"
  },
  {
    "_id": 2552,
    "id": 3347,
    "pid": 31,
    "city_code": "101042700",
    "city_name": "荣昌区"
  },
  {
    "_id": 2553,
    "id": 3348,
    "pid": 31,
    "city_code": "101042900",
    "city_name": "璧山区"
  },
  {
    "_id": 2554,
    "id": 3349,
    "pid": 31,
    "city_code": "101042200",
    "city_name": "垫江县"
  },
  {
    "_id": 2555,
    "id": 3350,
    "pid": 31,
    "city_code": "101043100",
    "city_name": "武隆县"
  },
  {
    "_id": 2556,
    "id": 3351,
    "pid": 31,
    "city_code": "101043000",
    "city_name": "丰都县"
  },
  {
    "_id": 2557,
    "id": 3352,
    "pid": 31,
    "city_code": "101041600",
    "city_name": "城口县"
  },
  {
    "_id": 2558,
    "id": 3353,
    "pid": 31,
    "city_code": "101042300",
    "city_name": "梁平县"
  },
  {
    "_id": 2559,
    "id": 3354,
    "pid": 31,
    "city_code": "101041500",
    "city_name": "开县"
  },
  {
    "_id": 2560,
    "id": 3355,
    "pid": 31,
    "city_code": "101041800",
    "city_name": "巫溪县"
  },
  {
    "_id": 2561,
    "id": 3356,
    "pid": 31,
    "city_code": "101042000",
    "city_name": "巫山县"
  },
  {
    "_id": 2562,
    "id": 3357,
    "pid": 31,
    "city_code": "101041900",
    "city_name": "奉节县"
  },
  {
    "_id": 2563,
    "id": 3358,
    "pid": 31,
    "city_code": "101041700",
    "city_name": "云阳县"
  },
  {
    "_id": 2564,
    "id": 3359,
    "pid": 31,
    "city_code": "101042400",
    "city_name": "忠县"
  },
  {
    "_id": 2565,
    "id": 3360,
    "pid": 31,
    "city_code": "101042500",
    "city_name": "石柱县"
  },
  {
    "_id": 2566,
    "id": 3361,
    "pid": 31,
    "city_code": "101043200",
    "city_name": "彭水县"
  },
  {
    "_id": 2567,
    "id": 3362,
    "pid": 31,
    "city_code": "101043400",
    "city_name": "酉阳县"
  },
  {
    "_id": 2568,
    "id": 3363,
    "pid": 31,
    "city_code": "101043600",
    "city_name": "秀山县"
  },
  {
    "_id": 2569,
    "id": 3368,
    "pid": 32,
    "city_code": "101320102",
    "city_name": "九龙城区"
  },
  {
    "_id": 2570,
    "id": 3383,
    "pid": 34,
    "city_code": "101340101",
    "city_name": "台北"
  },
  {
    "_id": 2571,
    "id": 3384,
    "pid": 34,
    "city_code": "101340201",
    "city_name": "高雄"
  },
  {
    "_id": 2572,
    "id": 3385,
    "pid": 34,
    "city_code": "CHTW0006",
    "city_name": "基隆"
  },
  {
    "_id": 2573,
    "id": 3386,
    "pid": 34,
    "city_code": "101340401",
    "city_name": "台中"
  },
  {
    "_id": 2574,
    "id": 3387,
    "pid": 34,
    "city_code": "101340301",
    "city_name": "台南"
  },
  {
    "_id": 2575,
    "id": 3388,
    "pid": 34,
    "city_code": "101340103",
    "city_name": "新竹"
  },
  {
    "_id": 2576,
    "id": 3389,
    "pid": 34,
    "city_code": "101340901",
    "city_name": "嘉义"
  },
  {
    "_id": 2577,
    "id": 3390,
    "pid": 34,
    "city_code": "101340701",
    "city_name": "宜兰县"
  },
  {
    "_id": 2578,
    "id": 3391,
    "pid": 34,
    "city_code": "101340102",
    "city_name": "桃园县"
  },
  {
    "_id": 2579,
    "id": 3392,
    "pid": 34,
    "city_code": "CHTW0016",
    "city_name": "苗栗县"
  },
  {
    "_id": 2580,
    "id": 3393,
    "pid": 34,
    "city_code": "CHTW0017",
    "city_name": "彰化县"
  },
  {
    "_id": 2581,
    "id": 3394,
    "pid": 34,
    "city_code": "101340404",
    "city_name": "南投县"
  },
  {
    "_id": 2582,
    "id": 3395,
    "pid": 34,
    "city_code": "101340406",
    "city_name": "云林县"
  },
  {
    "_id": 2583,
    "id": 3396,
    "pid": 34,
    "city_code": "101340205",
    "city_name": "屏东县"
  },
  {
    "_id": 2584,
    "id": 3397,
    "pid": 34,
    "city_code": "101341101",
    "city_name": "台东县"
  },
  {
    "_id": 2585,
    "id": 3398,
    "pid": 34,
    "city_code": "101340405",
    "city_name": "花莲县"
  },
  {
    "_id": 2586,
    "id": 3400,
    "pid": 2,
    "city_code": "101220101",
    "city_name": "合肥"
  },
  {
    "_id": 2587,
    "id": 3405,
    "pid": 3400,
    "city_code": "101220102",
    "city_name": "长丰县"
  },
  {
    "_id": 2588,
    "id": 3406,
    "pid": 3400,
    "city_code": "101220103",
    "city_name": "肥东县"
  },
  {
    "_id": 2589,
    "id": 3407,
    "pid": 3400,
    "city_code": "101220104",
    "city_name": "肥西县"
  },
  {
    "_id": 2590,
    "id": 3259,
    "pid": 168,
    "city_code": "101050708",
    "city_name": "加格达奇区"
  },
  {
    "_id": 2591,
    "id": 3261,
    "pid": 168,
    "city_code": "101050706",
    "city_name": "新林区"
  },
  {
    "_id": 2592,
    "id": 3262,
    "pid": 168,
    "city_code": "101050705",
    "city_name": "呼中区"
  },
  {
    "_id": 2593,
    "id": 1856,
    "pid": 365,
    "city_code": "101131101",
    "city_name": "塔城市"
  },
  {
    "_id": 2594,
    "id": 3657,
    "pid": 28,
    "city_code": "",
    "city_name": "北屯"
  },
  {
    "_id": 2595,
    "id": 3661,
    "pid": 8,
    "city_code": "",
    "city_name": "三沙"
  }
]

 ]]

local json = require "cjson"
local 城市列表=json.decode(城市) 



function 天气接口2(城市名称)
local 城市编号=""
local 匹配成功=false
for i=1, #城市列表 do
 if string.sub(城市列表[i]["city_name"],1,#城市名称) == 城市名称 && 城市列表[i]["city_code"]!="" then
   城市名称=城市列表[i]["city_name"]
   匹配成功=true
   local 云内容="http://wthrcdn.etouch.cn/WeatherApi?city="..城市名称
   Http.get(云内容,nil,"utf8",nil,function(a,b)
    if a==200 then 
      b=b:gsub("\n","【br】")
      local m,n,当前温度,当前风力,当前湿度,高温,低温,类型,风向,风力,穿衣指数,紫外线强度,户外指数,污染指数=b:find(".-<wendu>(.-)</wendu>.-CDATA%[(.-)%].-<shidu>(.-)</shidu>.-weather.-<high>(.-)</high>.-<low>(.-)</low>.-<type>(.-)</type>.-<fengxiang>(.-)</fengxiang>.-CDATA%[(.-)%].-穿衣指数.-<detail>(.-)</detail>.-紫外线强度.-<detail>(.-)</detail>.-户外指数.-<detail>(.-)</detail>.-污染指数.-<detail>(.-)</detail>")
      service.addCompositions({string.format("【"..城市名称.."🏝】%s\n▂▂▂▂▂▂▂▂▂▂▂\n☁实时天气: ☀温度%s🎏风力%s💦湿度%s\n❄️️%s 🔥️%s💨️%s%s\n️👕穿衣指数:%s\n🌳️污染指数:%s\n🏄户外指数:%s",类型,当前温度,当前风力,当前湿度,低温,高温,风向,风力,穿衣指数,污染指数,户外指数)})
      
      return
     else
      print("网络似乎出了问题")
     end
    end)

 end
end--for结束语
if 匹配成功==false then print(城市名称.." 相关城市天气信息不存在") end
end



function 天气接口1(城市名称)
local 城市编号=""
local 匹配成功=false
for i=1, #城市列表 do
 if string.sub(城市列表[i]["city_name"],1,#城市名称) == 城市名称 && 城市列表[i]["city_code"]!="" then
   城市名称=城市列表[i]["city_name"]
   匹配成功=true
   local 云内容="http://wthrcdn.etouch.cn/weather_mini?city="..城市名称
   Http.get(云内容,nil,"utf8",nil,function(a,b)
    if a==200 then 
      local d=cjson.decode(b).data.forecast[1]
      if d==nil return end
      --service.addCompositions({string.format("【"..城市名称.."🏝】%s\n▂▂▂▂▂▂▂▂▂▂▂\n❄️️%s 🔥️%s\n💨️%s%s\n🌳️注意事项:%s",d.type,d.low,d.high,d.fengxiang,string.sub(d.fengli,9,-3),cjson.decode(b).data.ganmao)})
      service.addCompositions({string.format("【"..城市名称.."🏝】%s\n▂▂▂▂▂▂▂▂▂▂▂\n❄️️%s 🔥️%s\n💨️%s%s",d.type,d.low,d.high,d.fengxiang,string.sub(d.fengli,9,-3))})
      return
     else
      print("网络似乎出了问题")
     end
    end)

 end
end--for结束语
if 匹配成功==false then print(城市名称.." 相关城市天气信息不存在") end
end




function 天气信息(城市名称)
local 城市编号=""
local 匹配成功=false
for i=1, #城市列表 do
 if string.sub(城市列表[i]["city_name"],1,#城市名称) == 城市名称 && 城市列表[i]["city_code"]!="" then
   城市名称=城市列表[i]["city_name"]
   匹配成功=true
   城市编号=城市列表[i]["city_code"]
   local 云内容="http://t.weather.sojson.com/api/weather/city/"..城市编号
   Http.get(云内容,nil,"utf8",nil,function(a,b)
    if a==200 then 
      local d=cjson.decode(b).data.forecast[1]
      if d==nil return end
      service.addCompositions({string.format("【"..城市名称.."🏝】%s\n▂▂▂▂▂▂▂▂▂▂▂\n❄️️%s 🔥️%s\n💨️%s%s\n🌳️空气质量:%s",d.type,d.low,d.high,d.fx,d.fl,d.aqi)})
      service.addCompositions(b)
      return
     else
      --print("网络似乎出了问题")
      天气接口2(城市名称)--使用第二信息接口
     end
    end)

 end
end--for结束语
if 匹配成功==false then print(城市名称.." 相关城市天气信息不存在") end
end




--自定义短语键盘(键盘名称,单个键盘短语数,默认宽度,默认高度,按键组,参数,脚本相对路径,数据文件)
function 自定义天气短语键盘(键盘名称,单个键盘短语数,默认宽度,默认高度,参数,脚本相对路径,数据文件)

import "android.content.pm.PackageManager"
local 版本号 = service.getPackageManager().getPackageInfo(service.getPackageName(), 0).versionName
local 版本号1=tonumber(string.sub(版本号,-8))

if 版本号1<20200526 then
 print("说明: 中文输入法版本号低于20200526,请升级到以上版本,否则无法运行该脚本")
 return
end

local 编号=1
local 短语组1={}
local 按键组={}




if 参数=="《《编辑数据》》" then
 service.editFile(数据文件) 
 return
end


if File(数据文件).exists()==false then
 io.open(数据文件,"w"):write("无数据,请编辑文件"):close()
end


短语组1[#短语组1+1]="查候选"
for c in io.lines(数据文件) do
 if c!="" && string.sub(c,1,1)!="#" then
  c=c:gsub("<br>","\n")
  c=c:gsub("\\#","#")
  短语组1[#短语组1+1]=c 
 end
end--for



if 参数=="《《返回首页》》" || 参数=="《《导出数据_取消》》" || 参数=="《《导入数据_取消》》" then  编号=1 end


--跳转位置
if string.find(参数,"<<")!=nil && string.find(参数,">>")!=nil then
 编号=tonumber(string.sub(参数,string.find(参数,"<<")+2,string.find(参数,">>")-1))
 --print(编号)
end

--命令行模式
local 命令行模式=false
if string.find(参数,"《《命令行》》")!=nil then
  命令行模式=true
  local 城市=string.sub(参数,string.find(参数,"【【")+6,string.find(参数,"】】")-1)
  天气信息(城市)
  return --退出
end

--命令行模式_查当前候选
local 命令行模式=false
if string.find(参数,"《《命令行&&查当前候选》》")!=nil then
  命令行模式=true
  if Rime.RimeGetInput()==nil  || Rime.RimeGetInput()=="" then
   print("无候选,请确认")
   return --退出
  end
  天气信息(Rime.getComposingText())
  return --退出
end


--上屏数据
if string.find(参数,"【【")!=nil && string.find(参数,"】】")!=nil then
 local 位置=tonumber(string.sub(参数,string.find(参数,"【【")+6,string.find(参数,"】】")-1))
 if 短语组1[位置]=="查候选" then
  if Rime.RimeGetInput()==nil  || Rime.RimeGetInput()=="" then
   print("无候选,请确认")
   return --退出
  end
  天气信息(Rime.getComposingText())
 else
  天气信息(短语组1[位置])
 end
 
end


if 编号==1 then
 if #短语组1<单个键盘短语数 then
  for i=1,#短语组1 do
    local 按键={}
    local 位置=i
    按键["label"]=短语组1[位置]
    按键["click"]={label="◀", send="function",command= 脚本相对路径,option= "【【"..位置.."】】<<"..编号..">>"}
    按键组[#按键组+1]=按键
  end--
  local 按键={}
  按键["width"]=默认宽度
  for i=1,单个键盘短语数-#短语组1 do
   按键组[#按键组+1]=按键
  end--for
  
  local 按键={}
  按键["width"]=33
  按键["click"]={label="编辑", send="function",command= 脚本相对路径,option= "《《编辑数据》》"}
  按键组[#按键组+1]=按键
  local 按键={}
  按键["width"]=33
  按键["click"]={label="⌫", repeatable="true", send= "BackSpace"}
  按键组[#按键组+1]=按键
  local 按键=主键盘()
  按键["width"]=34
  按键组[#按键组+1]=按键
 else
  
 按键组[#按键组+1]=按键2
  for i=1,单个键盘短语数 do
   local 子编号=i
   if #短语组1>子编号-1 then
    local 按键={}
    local 位置=子编号
    按键["label"]=短语组1[位置]
    按键["click"]={label="◀", send="function",command= 脚本相对路径,option= "【【"..位置.."】】<<"..编号..">>"}
    按键组[#按键组+1]=按键
   end--if
  end--for
 local 按键={}
 按键["width"]=25
 按键["click"]={label="编辑", send="function",command= 脚本相对路径,option= "《《编辑数据》》"}
 按键组[#按键组+1]=按键
 local 按键={}
 按键["width"]=25
 按键["click"]={label="下一页", send="function",command= 脚本相对路径,option= "<<"..(编号+1)..">>"}
 按键组[#按键组+1]=按键
  local 按键={}
  按键["width"]=25
  按键["click"]={label="⌫", repeatable="true", send= "BackSpace"}
  按键组[#按键组+1]=按键
 local 按键=主键盘()
 按键["width"]=25
 按键组[#按键组+1]=按键


 end--if #短语组1<25
end--if 编号==1

if 编号>1 then
if #短语组1<编号*单个键盘短语数 then
  for i=1,#短语组1-(编号-1)*单个键盘短语数 do
    local 按键={}
    local 位置=i+(编号-1)*单个键盘短语数
    按键["label"]=短语组1[位置]
    按键["click"]={label="◀", send="function",command= 脚本相对路径,option= "【【"..位置.."】】<<"..编号..">>"}
    按键组[#按键组+1]=按键
  end--for
  local 按键={}
  按键["width"]=默认宽度
  for i=1,单个键盘短语数*编号-#短语组1 do
   按键组[#按键组+1]=按键
  end--for
  local 按键={}
  按键["width"]=33
  按键["click"]={label="上一页", send="function",command= 脚本相对路径,option= "<<"..(编号-1)..">>"}
 按键组[#按键组+1]=按键
 local 按键={}
  按键["width"]=33
  按键["click"]={label="⌫", repeatable="true", send= "BackSpace"}
  按键组[#按键组+1]=按键
 local 按键=主键盘()
 按键["width"]=34
 按键组[#按键组+1]=按键

else
  for i=1,单个键盘短语数 do
   local 子编号=i
   if #短语组1>子编号-1 then
    local 按键={}
    local 位置=子编号+(编号-1)*单个键盘短语数
    按键["label"]=短语组1[位置]
    按键["click"]={label="◀", send="function",command= 脚本相对路径,option= "【【"..位置.."】】<<"..编号..">>"}
    按键组[#按键组+1]=按键
   end--if
  end--for
  local 按键={}
  按键["width"]=25
 按键["click"]={label="上一页", send="function",command= 脚本相对路径,option= "<<"..(编号-1)..">>"}
 按键组[#按键组+1]=按键
 local 按键={}
 按键["width"]=25
 按键["click"]={label="下一页", send="function",command= 脚本相对路径,option= "<<"..(编号+1)..">>"}
 按键组[#按键组+1]=按键
 local 按键={}
  按键["width"]=25
  按键["click"]={label="⌫", repeatable="true", send= "BackSpace"}
  按键组[#按键组+1]=按键
 local 按键=主键盘()
 按键["width"]=25
 按键组[#按键组+1]=按键
end--if #短语组1>编号*22
end--if 编号>1 

if 命令行模式==false then
 service.setKeyboard{
  name=键盘名称,
  ascii_mode=0,
  width=默认宽度,
  height=默认高度,
  keys=按键组
  }
end--if

end--function 自定义短语键盘








local 参数=(...)


local 脚本目录=tostring(service.getLuaExtDir("script"))
local 脚本名=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径

local 脚本相对路径=string.sub(脚本名,#脚本目录+1)
local 纯脚本名=File(脚本名).getName()
local 数据文件=string.sub(脚本名,1,#脚本名-4)..".txt"




local 短语数=25--单个键盘的短语数量
local 默认宽度=20
local 默认高度=28.5


 自定义天气短语键盘(string.sub(纯脚本名,1,#纯脚本名-4),短语数,默认宽度,默认高度,参数,脚本相对路径,数据文件)


