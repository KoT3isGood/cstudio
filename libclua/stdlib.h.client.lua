--!native

local c = {}

_G.CMemory = _G.CMemory or {}

function c.malloc(size)
    _G.CMemory[#_G.CMemory+1] = table.create(size)
    return #_G.CMemory
end
function c.free(ptr)
    _G.CMemory[ptr] = nil
end
function c.realloc(ptr, size)
    _G.CMemory[ptr] = table.create(size)
    return #_G.CMemory
end
function c.calloc(size)
    _G.CMemory[#_G.CMemory+1] = table.create(size)
    return #_G.CMemory
end
function c.memset(ptr, value, size)
    for i = 1, size do
        _G.CMemory[ptr][i] = value
    end
end
function c.memcpy(dest, src, size)
    for i = 1, size do
        _G.CMemory[dest][i] = _G.CMemory[src][i]
    end
end
function c.memmove(dest, src, size)
    for i = 1, size do
        _G.CMemory[dest][i] = _G.CMemory[src][i]
    end
end
function c.memcmp(ptr1, ptr2, size)
    for i = 1, size do
        if _G.CMemory[ptr1][i] ~= _G.CMemory[ptr2][i] then
            return false
        end
    end
    return true
end
function c.memchr(ptr, value, size)
    for i = 1, size do
        if _G.CMemory[ptr][i] == value then
            return true
        end
    end
    return false
end

return c
