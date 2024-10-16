--!native 
function _G.main()
local a = _G.lit_0
_G.mov1_1(a, _G.lit_1)
local out2 = _G.lit_2
_G.mov4_4(out2, _G.isupper(a))
return out2
end
function _G.isalnum(c)
end
function _G.isalpha(c)
end
function _G.iscntrl(c)
end
function _G.isdigit(c)
end
function _G.isgraph(c)
end
function _G.islower(c)
return _G.band4_4(_G.lge4_4(c, _G.lit_3), _G.lle4_4(c, _G.lit_4))
end
function _G.isprint(c)
end
function _G.ispunct(c)
end
function _G.isspace(c)
end
function _G.isupper(c)
return _G.band4_4(_G.lge4_4(c, _G.lit_5), _G.lle4_4(c, _G.lit_6))
end
function _G.isxdigit(c)
end
function _G.tolower(c)
end
function _G.toupper(c)
end
wait() --linkage:
_G.lit_6 = _G.push4(90)
_G.lit_5 = _G.push4(65)
_G.lit_4 = _G.push4(122)
_G.lit_3 = _G.push4(97)
_G.lit_2 = _G.push4(0)
_G.lit_1 = _G.push4(65)
_G.lit_0 = _G.push1(0)
print("started")
local out = _G.main()
print("ended")
local num = 0
num = _G.getnum4(out)print(num)
