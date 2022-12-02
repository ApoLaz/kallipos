
function Note(el)
  stringify = pandoc.utils.stringify
  if #el.content == 1 then
    local ft = stringify(el.content[1]) 
    if string.sub(ft,1,4) == "fig:" then
        local fn = string.sub(ft,5)
        --print(fn)
        local f = io.open("figures/" .. fn .. ".md", 'r')
        local doc = pandoc.read(f:read('*a'))
        f:close()
        local title=pandoc.utils.stringify(doc.meta.title) or "Title has not been set"
        local license_text=pandoc.utils.stringify(doc.meta.license_text) or "License has not been set"
        return pandoc.Note("*@" .. ft .. " " .. title .. " (" .. license_text .. ")")
    end
  end
end

