-- xuma_52p_precand.lua
-- 在 preedit 中显示编码的两个分段所对应的两个（组）候选


local basic = require('ace/lib/basic')
local map = basic.map


local function lookup(db)
  return function (str)
    return db:lookup(str)
  end
end


local function get_seg_cands(input, detailed, env)
  local cand1
  if input:len() < 3 then
    if not detailed then return end
    local codes = { input .. '_1', input .. '_2', input .. '_3' }
    return map(codes, lookup(env.code_to_text_rvdb))
  else
    local seg1 = input:sub(1, 2)
    local seg2 = input:sub(3)
    cand1 = env.code_to_text_rvdb:lookup(seg1 .. '_1')
    local codes = { seg2 .. '_1', seg2 .. '_2', seg2 .. '_3' }
    return cand1, map(codes, lookup(env.code_to_text_rvdb))
  end
end


-- Todo: 把这个冗长的函数写得更优雅些。Update: 分解并精炼，做得差不多了。
local function yield_with_precand(input, context, env)
  local sel_inp = context.caret_pos == 0
    and context.input
    or context.input:sub(1, context.caret_pos)
  if sel_inp:find('%l$') then  -- 一定要加这个判断，否则会影响符号键的功能
    sel_inp = sel_inp:match('%l+$')  -- 去掉前置标点部分
  end
  local detailed = context:get_option("detailed_x52_precand")
  -- 这是以候选迭代为基础的，因此要求无空码。
  for cand in input:iter() do
    local cand1, cand2 = get_seg_cands(sel_inp, detailed, env)
    -- 本方案中分号引导用于实现其他多个功能
    local rep = context.input:find('^;')
      and cand.text
      or not cand1  -- means sel_inp:len() < 3 and not detailed
      and cand.text
      or not cand2  -- means sel_inp:len() < 3 and detailed
      and (cand1[1] == cand.text
        and table.concat(cand1, '|')
        or ('%s>%s'):format(table.concat(cand1, '|'), cand.text)
        )
      or detailed
      and ('%s+%s=%s'):format(cand1, table.concat(cand2, '|'), cand.text)
      or ('%s%s'):format(cand1, cand2[1])
    cand.preedit = cand.preedit:find('\t')
      and cand.preedit:gsub('.+\t', rep .. '\t')
      or rep .. '\t'
    -- simplifier 的候选无法这样修改 preedit，只能用 Candidate() 生成再修改。
    yield(cand)
  end
end


local function filter(input, env)
  local context = env.engine.context
  if context:get_option("xuma_52p_precand")
      and (context.input:find('%l$')
        or context.input:find('^;')) then
    yield_with_precand(input, context, env)
  else
    for cand in input:iter() do yield(cand) end
  end
end


local function init(env)
  local config = env.engine.schema.config
  local code_to_text_rvdb = config:get_string('lua_reverse_db/code_to_text')
  env.code_to_text_rvdb = ReverseDb('build/' .. code_to_text_rvdb .. '.reverse.bin')
end


return { init = init, func = filter }
