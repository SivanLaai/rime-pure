-- 機甲名字生成器

function 数组去重复(数组)
        local exist = {}
        --把相同的元素覆盖掉
        for v, k in pairs(数组) do
            exist[k] = true
        end
        --重新排序表
        local newTable = {}
        for v, k in pairs(exist) do
            table.insert(newTable, v)
        end
        return newTable
end


function getName() 
  
  local num1 = {"1","2","3","4","5","6","7","8","9"}
  local num2 = {"0","1","2","3","4","5","6","7","8","9"}

  local num01 = num1[math.random(1,#num1)];-- 首位数字
  local num02 = num2[math.random(1,#num2)]-- 次位数字
  local num03 = num2[math.random(1,#num2)]-- 3位数字
  local num04 = num2[math.random(1,#num2)]-- 4位数字
 
  local name = num01..num02..num03..num04
  return name;
end --function getName() 
 
local 组={}

-- 测试上述函数，生成十个随机姓名
for i=1,10 do
 组[i]=getName()
end

组=数组去重复(组)
task(100,function() service.addCompositions(组) end)
