--!native 
function _G.main()
local x = _G.lit_0
_G.mov4_4(x, _G.lit_1)

while() do
_G.mov4_4(x, _G.lit_2)
_G.mov4_4(x, _G.add4_4(x, _G.lit_3))
end
return x
end
wait() --linkage:
_G.lit_3 = _G.push4(1)
_G.lit_2 = _G.push4(0)
_G.lit_1 = _G.push4(1)
_G.lit_0 = _G.push4(0)
print("started")
local out = _G.main()
print("ended")
local num = 0
num = _G.getnum4(out)print(num)
