-- basic.lua


local basic = {}
package.loaded[...] = basic


-- The found index can be both interger and string.
function basic.index(table, item)
  for k, v in pairs(table) do
    if v == item then return k end
  end
end


-- The found index is an interger.
function basic.last_index(table, item)
  for k = #table, 1, -1 do
    if table[k] == item then return k end
  end
end


-- Create a dict from a list using the i_k-th item (converted to string) of
-- every list item as the key of a dict item and the i_v-th item of the same
-- list item as the value of the dict item. i_k and i_v are defaulted to 1 and
-- 2.
function basic.list2dict(l, i_k, i_v)
  i_k = i_k or 1
  i_v = i_v or 2
  t = {}
  for _, v in ipairs(l) do
    t[tostring(v[i_k])] = v[i_v]
  end
  return t
end


function basic.map(table, func)
  local t = {}
  for k, v in pairs(table) do
    t[k] = func(v)
  end
  return t
end

-- Bad name for feature, unused for new scripts.
function basic.matchstr(str, pat)
  local t = {}
  for i in str:gmatch(pat) do
    t[#t + 1] = i
  end
  return t
end


-- Returns a pseudo-random integer in ranges.
-- The ranges must be given as { start, end } where end >= start.
function basic.random_in_ranges(table, ...)
  local ranges = { table, ... }
  local milestone = {1}
  for k, t in pairs(ranges) do
    milestone[k+1] = milestone[k] + t[2] - t[1] + 1
  end
  local r = math.random(milestone[#milestone] - milestone[1])
  for k, t in ipairs(milestone) do
    if r < milestone[k+1] then return ranges[k][1] + r - milestone[k] end
  end
end


function basic.utf8chars(str)
  local chars = {}
  for pos, code in utf8.codes(str) do
    chars[#chars + 1] = utf8.char(code)
  end
  return chars
end


function basic.utf8sub(str, first, last)
  if not last or last > utf8.len(str) then
    last = utf8.len(str)
  elseif last < 0 then
    last = utf8.len(str) + 1 + last
  end
  local fstoff = utf8.offset(str, first)
  local lstoff = utf8.offset(str, last + 1)
  if not fstoff then fstoff = 1 end
  if lstoff then lstoff = lstoff - 1 end
  return string.sub(str, fstoff, lstoff)
end
