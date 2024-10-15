--!native

-- optimizations
local math_pow = math.pow
local math_floor = math.floor

_G_mem = buffer.create(1000000)

_G.stackptr = 1000
_G_stackptr = _G.stackptr
_G.accumulator = 0
_G_accumulator = _G.accumulator

local power = 1
local numa = 0
local numb = 0


function _G.push1(num)
  buffer.writeu8(_G_mem,_G.stackptr,num)
  _G.stackptr=_G.stackptr+1
  return _G.stackptr-1
end

function _G.push2(num)
  buffer.writeu16(_G_mem,_G.stackptr,num)
  _G.stackptr=_G.stackptr+2
  return _G.stackptr-2
end

function _G.push4(num)
  buffer.writeu32(_G_mem,_G.stackptr,num)
  _G.stackptr=_G.stackptr+4
  return _G.stackptr-4
end

function _G.push8(num)
  buffer.writeu32(_G_mem,_G.stackptr,num)
  _G.stackptr=_G.stackptr+4
  return _G.stackptr-4
end

function _G.pop(bytes)
  local num = 0;
  for i=0, bytes-1 do
    num=_G_mem[_G_stackptr]+256*i
    _G.stackptr=_G.stackptr-1
  end
  return num
end




function _G.addr(b)
  buffer.writeu32(_G_mem,_G.accumulator,b)
	return _G_accumulator
end

function _G.deref(b)
	return _G_mem.readu32(b)
end

function _G.getnum1(b)
  return buffer.readu8(_G_mem,b)
end
function _G.getnum2(b)
  return buffer.readu16(_G_mem,b)
end
function _G.getnum4(b)
  return buffer.readu32(_G_mem,b)
end
function _G.getnum8(b)
  return buffer.readu32(_G_mem,b)
end


function _G.mov1_1(a, b)
  numb = buffer.readu8(_G_mem,b)
  buffer.writeu8(_G_mem,a,numb)
	return a
end

function _G.mov2_1(a, b)
  numb = buffer.readu8(_G_mem,b)
  buffer.writeu16(_G_mem,a,numb)
	return a
end

function _G.mov1_2(a, b)
  numb = buffer.readu16(_G_mem,b)
  buffer.writeu8(_G_mem,a,numb)
	return a
end

function _G.mov2_2(a, b)
  numb = buffer.readu16(_G_mem,b)
  buffer.writeu16(_G_mem,a,numb)
	return a
end


function _G.mov4_1(a, b)
  numb = buffer.readu32(_G_mem,b)
  buffer.writeu8(_G_mem,a,numb)
	return a
end

function _G.mov4_2(a, b)
  numb = buffer.readu32(_G_mem,b)
  buffer.writeu16(_G_mem,a,numb)
	return a
end

function _G.mov1_4(a, b)
  numb = buffer.readu8(_G_mem,b)
  buffer.writeu32(_G_mem,a,numb)
	return a
end

function _G.mov2_4(a, b)
  numb = buffer.readu16(_G_mem,b)
  buffer.writeu32(_G_mem,a,numb)
	return a
end

function _G.mov4_4(a, b)
  numb = buffer.readu32(_G_mem,b)
  buffer.writeu32(_G_mem,a,numb)
	return a
end

-- add functions

function _G.add2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa+numb)
	return _G_accumulator
end
function _G.add1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa+numb)
	return _G_accumulator
end

function _G.add2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa+numb)
	return _G_accumulator
end

function _G.add4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(numa+numb)
return _G_accumulator
end

function _G.add4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(numa+numb)
return _G_accumulator
end

function _G.add1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa+numb)
return _G_accumulator
end

function _G.add2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa+numb)
return _G_accumulator
end

function _G.add4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa+numb)
return _G_accumulator
end

-- sub functions

function _G.sub2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa-numb)
	return _G_accumulator
end
function _G.sub1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa-numb)
	return _G_accumulator
end

function _G.sub2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa-numb)
	return _G_accumulator
end

function _G.sub4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(numa-numb)
return _G_accumulator
end

function _G.sub4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(numa-numb)
return _G_accumulator
end

function _G.sub1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa-numb)
return _G_accumulator
end

function _G.sub2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa-numb)
return _G_accumulator
end

function _G.sub4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa-numb)
return _G_accumulator
end

_G_addr=_G.addr
