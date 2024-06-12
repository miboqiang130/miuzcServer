local dict = ngx.shared.miuzc
local token = dict:get("token")
local headers = ngx.req.get_headers()

-- 没有请求头就假装接口不存在
if headers["X-User-Agent"] ~= "MIUZC" then
  return ngx.exit(408)
end

-- 公钥和登录不限制
if string.find(ngx.var.uri, "/pub", 1, true) == 1 then
  return
end

if (not token) or (headers["token"] ~= token) then
  return ngx.exit(401)
end
