local rsa = require "rsa"

local dict = ngx.shared.miuzc

local rsa_public_key, rsa_priv_key, err = rsa:generate_rsa_keys(2048)
if not rsa_public_key then
  ngx.log(ngx.ERR, "generate rsa keys err: ", err)
  return
end

dict:set("public_key", rsa_public_key)
dict:set("private_key", rsa_priv_key)

--[[
local root_path = "/root/miuzcServer"

-- 读取密钥文件
local pub_r = io.open(root_path .. "/rsa/public.pem", "r")
local priv_r = io.open(root_path .. "/rsa/private.pem", "r")


if pub_r and priv_r then
  -- 密钥存在
  -- 读取密钥文件内容
  dict:set("public_key", pub_r:read("*all"))
  dict:set("private_key", priv_r:read("*all"))
else
  -- 密钥不存在
  -- 生成RSA密钥
  local rsa_public_key, rsa_priv_key, err = rsa:generate_rsa_keys(2048)
  if not rsa_public_key then
    ngx.log(ngx.ERR, "generate rsa keys err: ", err)
    return
  end

  -- 打开只写密钥文件
  local pub_w = io.open(root_path .. "/rsa/public.pem", "w")
  local priv_w = io.open(root_path .. "/rsa/private.pem", "w")
  if not (pub_w and priv_w) then
    ngx.log(ngx.ERR, "open rsa keys err")
    return
  end

  -- 写入密钥文件
  pub_w:write(rsa_public_key)
  priv_w:write(rsa_priv_key)
  io.close(pub_w)
  io.close(priv_w)

  dict:set("public_key", rsa_public_key)
  dict:set("private_key", rsa_priv_key)
end

-- 关闭打开的只读密钥文件
if pub_r then
  io.close(pub_r)
end

if priv_r then
  io.close(priv_r)
end
--]]
