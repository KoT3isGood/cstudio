
function _G._assert(expr, file, line, func)
  if (_G.memgetint(expr)==0) then
    local funcstr = ""
    local filestr = ""
    local i = 0;
    local a = _G.memgetbyte(file);

    while(a~=0) do
			filestr=filestr..string.char(a)
			i=i+1
      a=_G.memgetbyte(file+i)
    end

    i=0
    a = _G.memgetbyte(func);
    while(a~=0) do
			funcstr=funcstr..string.char(a)
			i=i+1
      a=_G.memgetbyte(func+i)
    end

  print("Assert in "..funcstr.."() at line ".._G.memgetint(line).." in "..filestr)
  end
end

