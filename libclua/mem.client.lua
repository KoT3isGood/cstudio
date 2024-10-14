--!native

-- optimizations
math_pow = math.pow
math_floor = math.floor

_G.mem = table.create(10000000, 0);
_G.stackptr = 1000
_G.heaptr = 1000000

function _G.push(num, bytes)
	for i=0, bytes-1 do
    _G.mem[_G.stackptr]=num%256
    num=math_floor(num/256)
    _G.stackptr=_G.stackptr+1
  end
  return _G.stackptr-bytes
end

function _G.pop(bytes)
  local num = 0;
  for i=0, bytes-1 do
    num=_G.mem[_G.stackptr]+256*i
    _G.stackptr=_G.stackptr-1
  end
  return num
end


function _G.mov(a,b, sa, sb)

  local power = 1
  local num = 0;
  for i=0, sb-1 do
    num=num+_G.mem[b+i]*power
    power=power*256
  end
	for i=0, sa-1 do
		_G.mem[a+i]=num%256
		num=math_floor(num/256)
	end
	return a
end

_G.accumulator = _G.push(0,8)
function _G.addr(b)
  local num = b;
	for i=0, 8-1 do
		_G.mem[_G.accumulator+i]=num%256
		num=math_floor(num/256)
	end
	return _G.accumulator
end

function _G.deref(b)
  local power = 1
  local numptr = 0;
  for i=0, 8-1 do
    numptr=numptr+_G.mem[b+i]*power
    power=power*256
  end

	return numptr
end

function _G.getnum(b, sb)
  local power = 1
	local numptr = 0;
	for i=0, sb-1 do
		numptr=numptr+_G.mem[b+i]*power
    power=power*256
	end

	return numptr
end


function _G.add(a, b, sa, sb)
  local power = 1
	local numa = 0;
  for i=0, sa-1 do
    numa=numa+_G.mem[a+i]*power
    power=power*256
  end
  power=1
	local numb = 0;
  for i=0, sb-1 do
    numb=numb+_G.mem[b+i]*power
    power=power*256
	end
  _G.addr(numa+numb)
	return _G.accumulator
end

function _G.sub(a, b, sa, sb)
  local power = 1
	local numa = 0;
  for i=0, sa-1 do
    numa=numa+_G.mem[a+i]*power
    power=power*256
  end
  power=1
	local numb = 0;
  for i=0, sb-1 do
    numb=numb+_G.mem[b+i]*power
    power=power*256
	end
  _G.addr(numa-numb)
	return _G.accumulator
end

function _G.mul(a, b, sa, sb)
  local power = 1
	local numa = 0;
  for i=0, sa-1 do
    numa=numa+_G.mem[a+i]*power
    power=power*256
  end
  power=1
	local numb = 0;
  for i=0, sb-1 do
    numb=numb+_G.mem[b+i]*power
    power=power*256
	end
  _G.addr(numa*numb)
	return _G.accumulator
end

function _G.div(a, b, sa, sb)
  local power = 1
	local numa = 0;
  for i=0, sa-1 do
    numa=numa+_G.mem[a+i]*power
    power=power*256
  end
  power=1
	local numb = 0;
  for i=0, sb-1 do
    numb=numb+_G.mem[b+i]*power
    power=power*256
	end
  _G.addr(numa/numb)
	return _G.accumulator
end
