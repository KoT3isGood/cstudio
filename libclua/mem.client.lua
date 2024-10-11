--!native
-- real memory manager
-- locals may save only pointers
_G.mem = _G.mem or {}


_G.stack = 1000

-- we should use better allocation
_G.heap = 1000000



function _G.memgetbyte(ptr)
  return _G.mem[ptr]
end
function _G.memgetshort(ptr)
  return _G.mem[ptr+1]*256+_G.mem[ptr]
end
function _G.memgetint(ptr)
  return  _G.mem[ptr+3]*16777216+_G.mem[ptr+2]*65536+_G.mem[ptr+1]*256+_G.mem[ptr]
end

-- set pointers
function _G.membyte(ptr, val)
	_G.mem[ptr]=val%256
	return _G.stack
end

function _G.memshort(ptr, val)
	_G.mem[ptr]=val%256
	_G.mem[ptr+1]=math.floor(val/256)%256
	return _G.stack
end

function _G.memint(ptr, val)
	_G.mem[ptr]=val%256
	_G.mem[ptr+1]=math.floor(val/256)%256
	_G.mem[ptr+2]=math.floor(val/65536)%256
	_G.mem[ptr+3]=math.floor(val/16777216)%256
	return _G.stack
end


-- static memory
function _G.smembyte(val)
	_G.mem[_G.stack]=val%256
	_G.stack=_G.stack+1
	return _G.stack
end
function _G.smemshort(val)
	_G.mem[_G.stack]=val%256
	_G.mem[_G.stack+1]=math.floor(val/256)%256
	_G.stack=_G.stack+2
	return _G.stack-2
end
function _G.smemint(val)
	_G.mem[_G.stack]=val%256
	_G.mem[_G.stack+1]=math.floor(val/256)%256
	_G.mem[_G.stack+2]=math.floor(val/65536)%256
	_G.mem[_G.stack+3]=math.floor(val/16777216)%256
	_G.stack=_G.stack+4
	return _G.stack-4
end


function _G.smemstring(str)
  local len = str:len()
  for i=1, len do
		_G.mem[_G.stack+i-1]=string.byte(string.sub(str,i,i))
  end
	_G.stack=_G.stack+len+1
	_G.mem[_G.stack-1]=0
	return _G.stack-len-1
end

function _G.kalloc(size)
	for i = 0, size do
		_G.mem[_G.heap+i+1]=0
	end
  _G.mem[_G.heap] = size
	_G.heap=_G.heap+size+1;
  return _G.heap-size
end

function _G.kfree(ptr)
  local allocsize = _G.mem[ptr-1]
  for i=0, allocsize do
    _G[ptr-1+i] = nil
  end
end

function _G.getfunc(ptr)
  return _G.mem[ptr]
end
