--!native

-- optimizations
local math_pow = math.pow
local math_floor = math.floor

_G.mem = table.create(10000000, 0);
_G_mem = _G.mem

_G.stackptr = 1000
_G_stackptr = _G.stackptr
_G.accumulator = 0
_G_accumulator = _G.accumulator

local power = 1
local numa = 0
local numb = 0


function _G.push(num, bytes)
	for i=0, bytes-1 do
    _G_mem[_G_stackptr]=num%256
    num=math_floor(num*0.00390625)
    _G_stackptr=_G_stackptr+1
  end
  return _G_stackptr-bytes
end

function _G.pop(bytes)
  local num = 0;
  for i=0, bytes-1 do
    num=_G_mem[_G_stackptr]+256*i
    _G_stackptr=_G_stackptr-1
  end
  return num
end


function _G.mov(a,b, sa, sb)

  power = 1
  numa = 0;
  for i=0, sb-1 do
    numa=numa+_G_mem[b+i]*power
    power=power*256
  end
	for i=0, sa-1 do
		_G_mem[a+i]=numa%256
		numa=math_floor(numa*0.00390625)
	end
	return a
end

function _G.addr(b)
  numa = b;
	for i=0, 8-1 do
		_G_mem[_G.accumulator+i]=numa%256
		numa=math_floor(numa*0.00390625)
	end
	return _G_accumulator
end

function _G.deref(b)
  power = 1
  numa = 0;
  for i=0, 8-1 do
    numa=numa+_G_mem[b+i]*power
    power=power*256
  end

	return numa
end

function _G.getnum(b, sb)
  power = 1
	numa = 0;
	for i=0, sb-1 do
		numa=numa+_G_mem[b+i]*power
    power=power*256
	end

	return numa
end


function _G.add(a, b, sa, sb)
  power = 1
	numa = 0;
  for i=0, sa-1 do
    numa=numa+_G_mem[a+i]*power
    power=power*256
  end
  power=1
	numb = 0;
  for i=0, sb-1 do
    numb=numb+_G_mem[b+i]*power
    power=power*256
	end
  _G_addr(numa+numb)
	return _G_accumulator
end

function _G.sub(a, b, sa, sb)
  power = 1
	numa = 0;
  for i=0, sa-1 do
    numa=numa+_G_mem[a+i]*power
    power=power*256
  end
  power=1
	numb = 0;
  for i=0, sb-1 do
    numb=numb+_G_mem[b+i]*power
    power=power*256
	end
  _G_addr(numa-numb)
	return _G_accumulator
end

function _G.mul(a, b, sa, sb)
  power = 1
	numa = 0;
  for i=0, sa-1 do
    numa=numa+_G_mem[a+i]*power
    power=power*256
  end
  power=1
	numb = 0;
  for i=0, sb-1 do
    numb=numb+_G_mem[b+i]*power
    power=power*256
	end
  _G_addr(numa*numb)
	return _G.accumulator
end

function _G.div(a, b, sa, sb)
  power = 1
	numa = 0;
  for i=0, sa-1 do
    numa=numa+_G_mem[a+i]*power
    power=power*256
  end
  power=1
	numb = 0;
  for i=0, sb-1 do
    numb=numb+_G_mem[b+i]*power
    power=power*256
	end
  _G_addr(numa/numb)
	return _G.accumulator
end

function _G.andn(a, b, sa, sb)
  power = 1
	numa = 0;
  for i=0, sa-1 do
    numa=numa+_G_mem[a+i]*power
    power=power*256
  end
  power=1
	numb = 0;
  for i=0, sb-1 do
    numb=numb+_G_mem[b+i]*power
    power=power*256
	end
  _G_addr(numa*numb)
	return _G.accumulator
end
_G_addr=_G.addr
