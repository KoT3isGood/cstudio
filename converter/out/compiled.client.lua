--!native 
function _G.isalnum(c)
end
_G_isalnum=_G.isalnum
function _G.isalpha(c)
end
_G_isalpha=_G.isalpha
function _G.iscntrl(c)
end
_G_iscntrl=_G.iscntrl
function _G.isdigit(c)
end
_G_isdigit=_G.isdigit
function _G.isgraph(c)
end
_G_isgraph=_G.isgraph
function _G.islower(c)
end
_G_islower=_G.islower
function _G.isprint(c)
end
_G_isprint=_G.isprint
function _G.ispunct(c)
end
_G_ispunct=_G.ispunct
function _G.isspace(c)
end
_G_isspace=_G.isspace
function _G.isupper(c)
end
_G_isupper=_G.isupper
function _G.isxdigit(c)
end
_G_isxdigit=_G.isxdigit
function _G.tolower(c)
end
_G_tolower=_G.tolower
function _G.toupper(c)
end
_G_toupper=_G.toupper
function _G.main()
local x = _G_lit_0
_G_mov(x, _G_lit_1, 4, 4)
while(_G_getnum(x, 4)~=0) do
_G_mov(x, _G_sub(x, _G_lit_2, 4, 4), 4, 4)
end
return x
end
_G_main=_G.main
wait() --linkage:
_G_push=_G.push
_G_lit_2 = _G_push(1,4)
_G_lit_1 = _G_push(1000,4)
_G_lit_0 = _G_push(0,4)
_G_pop=_G.pop
_G_mov=_G.mov
_G_addr=_G.addr
_G_deref=_G.deref
_G_getnum=_G.getnum
_G_sub=_G.sub
_G_add=_G.add
_G_mul=_G.mul
_G_div=_G.div
print("started")
local out = _G.main()
print("ended")
local num = 0
for i=0, 4-1 do
num=num+_G.mem[out+i]*math.pow(256,i)
end
print(num)
