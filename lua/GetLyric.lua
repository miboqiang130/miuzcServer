local lrc_path = ngx.var.lyric_path .. ngx.unescape_uri(ngx.var.arg_name) .. '.lrc'

-- 尝试打开文件
local content = ""
local file, err = io.open(lrc_path, "r")
if file then
  content = file:read("*all")
  file:close()
end

-- 返回文件内容
ngx.print(content)
