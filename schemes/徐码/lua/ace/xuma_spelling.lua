-- xuma_spelling.lua

--[[
单字的字根拆分三重注解直接利用 simplifier 通过预制的 OpenCC 词库查到。
问题：这个方法，词组只能显示每个单字的注解，需要进行简化合并处理，仅显示词组编
码和对应字根。
计划：用 Lua 处理词组注解。

实现障碍：simplifier 返回的类型，无法修改其注释。
   https://github.com/hchunhui/librime-lua/issues/16
一个思路：show_in_commet: false
   然后读取 cand.text 修改后作为注释显示，问题是无法直接将 cand.text 改回。
   理论上只能用 Candidate() 生成简单类型候选。

现在的方案：完全弃用 simplifier + OpenCC，单字和词组都用 Lua 处理。

注解数据来源与 OpenCC 方法相同，编成伪方案的伪词典，通过写入主方案的
schema/dependencies 来让 rime 编译为反查库 *.reverse.bin，最后通过 Lua 的反查
函数查询。

Handle multibye string in Lua:
  https://stackoverflow.com/questions/9003747/splitting-a-multibyte-string-in-lua

lua_filter 如何判断 cand 是否来自反查或当前是否处于反查状态？
  https://github.com/hchunhui/librime-lua/issues/18
--]]

local basic = require 'ace/lib/basic'
local map = basic.map
local utf8chars = basic.utf8chars
local rime = require 'ace/lib/rime'
local config = {}
config.encode_rules = {
  { length_equal = 2, formula = 'AaAbBaBb' }
, { length_equal = 3, formula = 'AaBaCaCb' }
, { length_in_range = {4, 10}, formula = 'AaBaCaZa' }
}
-- 注意借用编码规则有局限性：取码索引不一定对应取根索引，尤其是从末尾倒数时。
local spelling_rules = rime.encoder.load_settings(config.encode_rules)


local function xform(s)
  -- input format: "[spelling,code_code...,pinyin_pinyin...]"
  -- output format: "〔 spelling · code code ... · pinyin pinyin ... 〕"
  return s == '' and s or s:gsub('%[', '〔 ')
                           :gsub('%]', ' 〕')
                           :gsub('{', '<')
                           :gsub('}', '>')
                           :gsub('_', ' ')
                           :gsub(',', ' · ')
end


local function parse_spll(str)
  -- Handle spellings like "{于下}{四点}丶"(for 求) where some radicals are
  -- represented by characters in braces.
  local radicals = {}
  for seg in str:gsub('%b{}', ' %0 '):gmatch('%S+') do
    if seg:find('^{.+}$') then
      table.insert(radicals, seg)
    else
      for pos, code in utf8.codes(seg) do
        table.insert(radicals, utf8.char(code))
      end
    end
  end
  return radicals
end


local function parse_raw_tricomment(str)
  return str:gsub(',.*', ''):gsub('^%[', '')
end


local function spell_phrase(s, spll_rvdb)
  local chars = utf8chars(s)
  local rule = spelling_rules[#chars]
  if not rule then return end
  local radicals = {}
  for i, coord in ipairs(rule) do
    local char_idx = coord[1] > 0 and coord[1] or #chars + 1 + coord[1]
    local raw = spll_rvdb:lookup(chars[char_idx])
    if not raw then return end  -- 若任一取码单字没有注解数据，则不对词组作注。
    local char_radicals = parse_spll(parse_raw_tricomment(raw))
    local code_idx = coord[2] > 0 and coord[2] or #char_radicals + 1 + coord[2]
    radicals[i] = char_radicals[code_idx] or '◇'
  end
  return table.concat(radicals)
end


local function get_tricomment(cand, env)
  local text = cand.text
  if utf8.len(text) == 1 then
    local raw_spelling = env.spll_rvdb:lookup(text)
    if raw_spelling == '' then return end
    return env.engine.context:get_option("xmsp_hide_pinyin")
      and xform(raw_spelling:gsub('%[(.-,.-),.+%]', '[%1]'))
      or xform(raw_spelling)
  elseif utf8.len(text) > 1 then
    local spelling = spell_phrase(text, env.spll_rvdb)
    if not spelling then return end
    spelling = spelling:gsub('{(.-)}', '<%1>')
    local code = env.code_rvdb:lookup(text)
    if code ~= '' then  -- 按长度排列多个编码。
      local codes = {}
      for m in code:gmatch('%S+') do codes[#codes + 1] = m end
      table.sort(codes, function(i, j) return i:len() < j:len() end)
      return ('〔 %s · %s 〕'):format(spelling, table.concat(codes, ' '))
    else  -- 以括号类型区分非本词典之固有词
      return ('〈 %s 〉'):format(spelling)
      -- Todo: 如果要为此类词组添加编码注释，其中的单字存在一字多码的情况，需先
      -- 通过比较来确定全码，再提取词组编码。注意特殊单字：八个八卦名，要排除其
      -- 特殊符号编码 'dl?g'.
    end
  end
end


local function filter(input, env)
  if not env.engine.context:get_option("xuma_spelling") then
    for cand in input:iter() do yield(cand) end
    return
  end
  for cand in input:iter() do
    --[[
    用户有时需要通过拼音反查简化字并显示三重注解，但 luna_pinyin 的简化字排序不
    合理且靠后。用户可开启 simplification 来解决，但是 simplifier 会强制覆盖注
    释，为了避免三重注解被覆盖，只能生成一个简单类型候选来代替原候选。
    Todo: 测试在 <simplifier>/tips: none 的条件下，用 cand.text 和
    cand:get_genuine().text 分别读到什么值。若分别读到转换前后的候选，则可以仅
    修改 comment 而不用生成简单类型候选来代替原始候选。这样做的问题是关闭
    xuma_spelling 时就不显示 tips 了。
    --]]
    if cand.type == 'simplified' and env.name_space == 'xmsp_for_rvlk' then
      local comment = (get_tricomment(cand, env) or '') .. cand.comment
      cand = Candidate("simp_rvlk", cand.start, cand._end, cand.text, comment)
    else
      local add_comment = cand.type == 'punct'
        and env.code_rvdb:lookup(cand.text)
        or cand.type ~= 'sentence'
        and get_tricomment(cand, env)
      if add_comment and add_comment ~= '' then
        -- 混输和反查中的非 completion 类型，原注释为空或主词典的编码。
        -- 为免重复冗长，直接以新增注释替换之。前提是后者非空。
        cand.comment = cand.type ~= 'completion'
          and ((env.name_space == 'xmsp' and env.is_mixtyping)
            or (env.name_space == 'xmsp_for_rvlk'))
          and add_comment
          or add_comment .. cand.comment
      end
    end
    yield(cand)
  end
end


local function init(env)
  local config = env.engine.schema.config
  local spll_rvdb = config:get_string('lua_reverse_db/spelling')
  local code_rvdb = config:get_string('lua_reverse_db/code')
  local abc_extags_size = config:get_list_size('abc_segmentor/extra_tags')
  env.spll_rvdb = ReverseDb('build/' .. spll_rvdb .. '.reverse.bin')
  env.code_rvdb = ReverseDb('build/' .. code_rvdb .. '.reverse.bin')
  env.is_mixtyping = abc_extags_size > 0
end


return { init = init, func = filter }
