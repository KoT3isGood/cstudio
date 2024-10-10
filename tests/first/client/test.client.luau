--!native 
local module = {}
function module.fopen(filename, mode)

end
function module.fwrite(buffer, size, count, stream)

end
function module.main()
local yes = fopen("Workspace/Value", "w")

local text = "123"
fwrite(text, 1, 3, yes)
return 65
end
return module
