
--!native

function _G.fopen(filename, mode)
  local segments=filename:split("/")
  local current=game --location to search
  for i,v in pairs(segments) do
    if not current:FindFirstChild(v) then
      if i==#segments then
        if (mode=="r" or mode=="r+") then
          return nil
        end
        local instance = Instance.new("StringValue")
        instance.Name = v
        instance.Parent = current
      else 
        return nil
      end
    end
    current=current[v]
  end


  local buf = ""
  if (mode=="a" or mode=="a+") then
    buf = current.Value
  end

  return {current, buf, mode}
end

function _G.fwrite(buf,size,count, stream)
  if (stream[3]=="r" or stream[3]=="r+") then
    return
  end
  local mode = 0
  if (stream[3]=="w" or stream[3]=="w+") then
    mode = 1
  end
  if mode==1 then
	stream[2] = ""
  end

  for i = 1, size*count do
		stream[2]=stream[2]..string.sub(buf, i, i)
  end
end

function _G.fflush(stream)
  stream[1].Value = stream[2]
end

function _G.fclose(stream)
  _G.fflush(stream)
  stream[1] = nil
  stream[2] = nil
end




