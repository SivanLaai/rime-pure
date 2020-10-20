
--倒找字符串,返回字符串位置
function 倒找字符串(str, k)
 local ts = string.reverse(str)--反转字符串str
 local i = string.find(ts, k) --获取k在反转后的str字符串ts的位置
 local m = string.len(ts) - i + 1 --获取k在字符串str中的位置
 return m 
end

function 字符串_倒找(str, k)
 local ts = string.reverse(str)--反转字符串str
 local i = string.find(ts, k) --获取k在反转后的str字符串ts的位置
 local m = string.len(ts) - i + 1 --获取k在字符串str中的位置
 return m 
end
