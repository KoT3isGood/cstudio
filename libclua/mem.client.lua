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

function _G.add1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa+numb)
	return _G_accumulator
end
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
function _G.sub1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa-numb)
	return _G_accumulator
end
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

-- mul functions
function _G.mul1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa*numb)
	return _G_accumulator
end
function _G.mul2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa*numb)
	return _G_accumulator
end
function _G.mul1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa*numb)
	return _G_accumulator
end

function _G.mul2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa*numb)
	return _G_accumulator
end

function _G.mul4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(numa*numb)
return _G_accumulator
end

function _G.mul4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(numa*numb)
return _G_accumulator
end

function _G.mul1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa*numb)
return _G_accumulator
end

function _G.mul2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa*numb)
return _G_accumulator
end

function _G.mul4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa*numb)
return _G_accumulator
end

-- div functions
function _G.div1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa/numb)
	return _G_accumulator
end
function _G.div2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa/numb)
	return _G_accumulator
end
function _G.div1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa/numb)
	return _G_accumulator
end

function _G.div2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa/numb)
	return _G_accumulator
end

function _G.div4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(numa/numb)
return _G_accumulator
end

function _G.div4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(numa/numb)
return _G_accumulator
end

function _G.div1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa/numb)
return _G_accumulator
end

function _G.div2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa/numb)
return _G_accumulator
end

function _G.div4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa/numb)
return _G_accumulator
end

-- and functions
function _G.band1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(bit32.band(numa, numb))
	return _G_accumulator
end
function _G.band2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(bit32.band(numa, numb))
	return _G_accumulator
end
function _G.band1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(bit32.band(numa, numb))
	return _G_accumulator
end

function _G.band2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(bit32.band(numa, numb))
	return _G_accumulator
end

function _G.band4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(bit32.band(numa, numb))
return _G_accumulator
end

function _G.band4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(bit32.band(numa, numb))
return _G_accumulator
end

function _G.band1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(bit32.band(numa, numb))
return _G_accumulator
end

function _G.band2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(bit32.band(numa, numb))
return _G_accumulator
end

function _G.band4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(bit32.band(numa, numb))
return _G_accumulator
end

-- or functions
function _G.bor1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(bit32.bor(numa, numb))
	return _G_accumulator
end
function _G.bor2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(bit32.bor(numa, numb))
	return _G_accumulator
end
function _G.bor1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(bit32.bor(numa, numb))
	return _G_accumulator
end

function _G.bor2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(bit32.bor(numa, numb))
	return _G_accumulator
end

function _G.bor4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(bit32.bor(numa, numb))
return _G_accumulator
end

function _G.bor4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(bit32.bor(numa, numb))
return _G_accumulator
end

function _G.bor1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(bit32.bor(numa, numb))
return _G_accumulator
end

function _G.bor2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(bit32.bor(numa, numb))
return _G_accumulator
end

function _G.bor4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(bit32.bor(numa, numb))
return _G_accumulator
end

-- bxor functions
function _G.bxor1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(bit32.bxor(numa, numb))
	return _G_accumulator
end
function _G.bxor2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(bit32.bxor(numa, numb))
	return _G_accumulator
end
function _G.bxor1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(bit32.bxor(numa, numb))
	return _G_accumulator
end

function _G.bxor2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(bit32.bxor(numa, numb))
	return _G_accumulator
end

function _G.bxor4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(bit32.bxor(numa, numb))
return _G_accumulator
end

function _G.bxor4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(bit32.bxor(numa, numb))
return _G_accumulator
end

function _G.bxor1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(bit32.bxor(numa, numb))
return _G_accumulator
end

function _G.bxor2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(bit32.bxor(numa, numb))
return _G_accumulator
end

function _G.bxor4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(bit32.bxor(numa, numb))
return _G_accumulator
end

-- leq functions
function _G.leq1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa==numb and 1 or 0)
	return _G_accumulator
end
function _G.leq2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa==numb and 1 or 0)
	return _G_accumulator
end
function _G.leq1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa==numb and 1 or 0)
	return _G_accumulator
end

function _G.leq2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa==numb and 1 or 0)
	return _G_accumulator
end

function _G.leq4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(numa==numb and 1 or 0)
return _G_accumulator
end

function _G.leq4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(numa==numb and 1 or 0)
return _G_accumulator
end

function _G.leq1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa==numb and 1 or 0)
return _G_accumulator
end

function _G.leq2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa==numb and 1 or 0)
return _G_accumulator
end

function _G.leq4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa==numb and 1 or 0)
return _G_accumulator
end

-- lne functions
function _G.lne1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa~=numb and 1 or 0)
	return _G_accumulator
end
function _G.lne2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa~=numb and 1 or 0)
	return _G_accumulator
end
function _G.lne1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa~=numb and 1 or 0)
	return _G_accumulator
end

function _G.lne2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa~=numb and 1 or 0)
	return _G_accumulator
end

function _G.lne4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(numa~=numb and 1 or 0)
return _G_accumulator
end

function _G.lne4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(numa~=numb and 1 or 0)
return _G_accumulator
end

function _G.lne1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa~=numb and 1 or 0)
return _G_accumulator
end

function _G.lne2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa~=numb and 1 or 0)
return _G_accumulator
end

function _G.lne4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)
_G_addr((numa~=numb) and 1 or 0)
return _G_accumulator
end


-- llt functions
function _G.llt1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa<numb and 1 or 0)
	return _G_accumulator
end
function _G.llt2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa<numb and 1 or 0)
	return _G_accumulator
end
function _G.llt1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa<numb and 1 or 0)
	return _G_accumulator
end

function _G.llt2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa<numb and 1 or 0)
	return _G_accumulator
end

function _G.llt4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(numa<numb and 1 or 0)
return _G_accumulator
end

function _G.llt4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(numa<numb and 1 or 0)
return _G_accumulator
end

function _G.llt1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa<numb and 1 or 0)
return _G_accumulator
end

function _G.llt2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa<numb and 1 or 0)
return _G_accumulator
end

function _G.llt4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa<numb and 1 or 0)
return _G_accumulator
end

-- lgt functions
function _G.lgt1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa>numb and 1 or 0)
	return _G_accumulator
end
function _G.lgt2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa>numb and 1 or 0)
	return _G_accumulator
end
function _G.lgt1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa>numb and 1 or 0)
	return _G_accumulator
end

function _G.lgt2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa>numb and 1 or 0)
	return _G_accumulator
end

function _G.lgt4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(numa>numb and 1 or 0)
return _G_accumulator
end

function _G.lgt4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(numa>numb and 1 or 0)
return _G_accumulator
end

function _G.lgt1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa>numb and 1 or 0)
return _G_accumulator
end

function _G.lgt2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa>numb and 1 or 0)
return _G_accumulator
end

function _G.lgt4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa>numb and 1 or 0)
return _G_accumulator
end

-- lle functions
function _G.lle1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa<=numb and 1 or 0)
	return _G_accumulator
end
function _G.lle2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa<=numb and 1 or 0)
	return _G_accumulator
end
function _G.lle1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa<=numb and 1 or 0)
	return _G_accumulator
end

function _G.lle2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa<=numb and 1 or 0)
	return _G_accumulator
end

function _G.lle4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(numa<=numb and 1 or 0)
return _G_accumulator
end

function _G.lle4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(numa<=numb and 1 or 0)
return _G_accumulator
end

function _G.lle1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa<=numb and 1 or 0)
return _G_accumulator
end

function _G.lle2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa<=numb and 1 or 0)
return _G_accumulator
end

function _G.lle4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa<=numb and 1 or 0)
return _G_accumulator
end

-- lge functions
function _G.lge1_1(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa>=numb and 1 or 0)
	return _G_accumulator
end
function _G.lge2_1(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu8(_G_mem, b)

  _G_addr(numa>=numb and 1 or 0)
	return _G_accumulator
end
function _G.lge1_2(a, b)
  numa = buffer.readu8(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa>=numb and 1 or 0)
	return _G_accumulator
end

function _G.lge2_2(a, b)
  numa = buffer.readu16(_G_mem,a)
  numb = buffer.readu16(_G_mem,b)

  _G_addr(numa>=numb and 1 or 0)
	return _G_accumulator
end

function _G.lge4_1(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu8(_G_mem,b)

_G_addr(numa>=numb and 1 or 0)
return _G_accumulator
end

function _G.lge4_2(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu16(_G_mem,b)

_G_addr(numa>=numb and 1 or 0)
return _G_accumulator
end

function _G.lge1_4(a, b)
numa = buffer.readu8(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa>=numb and 1 or 0)
return _G_accumulator
end

function _G.lge2_4(a, b)
numa = buffer.readu16(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa>=numb and 1 or 0)
return _G_accumulator
end

function _G.lge4_4(a, b)
numa = buffer.readu32(_G_mem,a)
numb = buffer.readu32(_G_mem,b)

_G_addr(numa>=numb and 1 or 0)
return _G_accumulator
end


_G_addr=_G.addr
