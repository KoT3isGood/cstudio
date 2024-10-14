--!native 
wait() -- code:
function _G.main()
local x = _G.lit_0
_G.mov(x, _G.lit_1, 4, 4)
while(_G.getnum(x, 4)~=0) do
_G.mov(x, _G.sub(x, _G.lit_2, 4, 4), 4, 4)
end
return x

end
wait() -- data:
_G.lit_2 = _G.push(1,4)
_G.lit_1 = _G.push(1000000,4)
_G.lit_0 = _G.push(0,4)
print("started")
local out = _G.main()
print("ended")
local num = 0
for i=0, 4-1 do
num=num+_G.mem[out+i]*math.pow(256,i)
end
print(num)
