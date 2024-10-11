--!native 
if not _G.fopen then
function _G.fopen(filename, mode)

end
end
if not _G.fwrite then
function _G.fwrite(buffer, size, count, stream)

end
end
if not _G.main then
function _G.main()
local yes = _G.fopen("Workspace/Value", "w")

local text = "123"
_G.fwrite(text, 1, 3, yes)
return 65
end
end
