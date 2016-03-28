local ipfunc             = require "ipfunc"
local md5                = require "md5"

local ip                 = ngx.var.remote_addr
local args               = ngx.req.get_uri_args()
local cidr               = ipfunc.getIPNetwork(ip .. "/24")
local calulated_hash     = md5.sumhexa("no-more-secrets-" .. cidr)

-- ngx.log(ngx.INFO, "h: " .. args["h"])
-- ngx.log(ngx.INFO, "ch: " .. calulated_hash)

if (args["h"] == calulated_hash) then
    return
end

ngx.log(ngx.INFO, "HashCheck: " .. ip .. " is not allowed by the hash")

return ngx.exit(ngx.HTTP_FORBIDDEN)
