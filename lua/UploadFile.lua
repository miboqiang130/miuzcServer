local upload = require "resty.upload"

local chunk_size = 8192
local file_path = ngx.var.file_path

local form, err = upload:new(chunk_size)

if not form then
    ngx.log(ngx.ERR, "Failed to new upload: ", err)
    ngx.exit(500)
end
form:set_timeout(10000)
local file = nil

while true do
    local typ, res, err = form:read()
    if typ == "header" then
        if res[1] == "Content-Disposition" then
            local _, _, filename = string.find(res[2], 'filename="([^"]+)"')
            if filename then
                file = io.open(file_path .. filename, "wb")
            end
        end
    elseif typ == "body" then
        if file then
            file:write(res)
        else
            ngx.status = 502
            ngx.print("Failed to open file")
            return
        end
    elseif typ == "part_end" then
        if file then
            file:close()
            file = nil
        end
    elseif not typ then
        ngx.status = 502
        ngx.print("Failed to read: " .. err)
        return
    elseif typ == "eof" then
        -- 成功
        ngx.status = 200
        ngx.print("上传成功")
        break
    end
end
