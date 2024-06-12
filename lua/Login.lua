local method = ngx.req.get_method()
if method ~= "POST" then
  ngx.exit(405)
end

local rsa = require "rsa"
local dict = ngx.shared.miuzc
local cjson = require "cjson"

local token_dur = 1 * 60 * 60

ngx.req.read_body()
local args, err = ngx.req.get_post_args()
if not args then
  ngx.log(ngx.ERR, err)
  return
end

-- 私钥
local priv, err = rsa:new({
  private_key = dict:get("private_key"),
  key_type = rsa.KEY_TYPE.PKCS1,
  padding = rsa.PADDING.RSA_PKCS1_PADDING,
  algorithm = "SHA256",
})
if not priv then
  ngx.log(ngx.ERR, err)
  return ngx.exit(ngx.ERROR)
end

local pw = priv:decrypt(args["pw"])
if pw == "mypassword" then
  -- 记录日志
  print("password verification passed")
  print(ngx.req.raw_header())

  -- 开始生成token
  local header = cjson.encode({
    alg = "RS256",
    typ = "JWT"
  })

  local payload = cjson.encode({
    startTime = ngx.req.start_time(),
    now       = ngx.localtime(),
    exp       = ngx.time() + token_dur
  })

  local newToken = ngx.encode_base64(header) .. '.' .. ngx.encode_base64(payload)
  newToken = newToken .. '.' .. ngx.encode_base64(priv:sign(newToken))

  dict:set("token", newToken, token_dur)
  ngx.print(newToken)
else
  print("incorrect password")
  ngx.exit(403)
end
