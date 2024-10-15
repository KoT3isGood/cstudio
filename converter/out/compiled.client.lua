--!native 
function _G.main()
local x = _G.lit_0
_G.mov4_4(x, _G.lit_1)
while(_G.getnum4(_G.sub4_4(x, _G.lit_2))~=0) do
_G.mov4_4(x, _G.sub4_4(x, _G.lit_3))
end
return _G.lit_4
end
wait() --linkage:
_G.lit_4 = _G.push4(10)
_G.lit_3 = _G.push4(1)
_G.lit_2 = _G.push4(100)
_G.lit_1 = _G.push4(10000)
_G.lit_0 = _G.push4(0)
print("started")
local out = _G.main()
print("ended")
local num = 0
num = _G.getnum4(out)print(num)
