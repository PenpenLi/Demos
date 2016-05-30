
UrlParser = class()

-- parse string to table for UrlSchemeSDK
function UrlParser:parseUrlScheme(url)
	if type(url) ~= "string" or string.len(url) <= 0 then return {} end
	local res, parser = {}, {}
	for v in string.gmatch(url, "[^:/?&]+") do
		table.insert(parser, v)
	end
	if #parser == 0 or string.lower(parser[1]) ~= "happyanimal3" then return res end
	table.remove(parser, 1)
	if #parser == 0 then return res end
	res.method = parser[1]
	table.remove(parser, 1)
	if #parser == 0 or string.lower(parser[1]) ~= "redirect" then return res end
	table.remove(parser, 1)
	if #parser == 0 then return res end
	res.para = {}
	while #parser > 0 do
		local a, b, key, value = string.find(parser[1], "([%w_]+)=([%w-_%%.,]+)")
		if key and value then
			if string.find(value, ',') then
				res.para[key] = string.split(value, ',')
			else
				res.para[key] = value
			end
		end
		table.remove(parser, 1)
	end
	return res
end

local sameUrl = {
	"http://animalmobile.happyelements.cn/",
	"http://mobile.app100718846.twsapp.com/",
}
if not table.exist(sameUrl, NetworkConfig.dynamicHost) then
	table.insert(sameUrl, NetworkConfig.dynamicHost)
end
function UrlParser:parseQRCodeAddFriendUrl(url)
	if type(url) ~= "string" or string.len(url) <= 0 then return {} end
	local res, parser = {}, {}
	for v in string.gmatch(url, "[^:/?&]+") do
		table.insert(parser, v)
	end

	local function checkUrl(parser, host)
		if #parser < 1 or string.lower(parser[1]) ~= string.lower(host[1]) then return false, res end
		if #parser < 2 or string.lower(parser[2]) ~= string.lower(host[2]) then return false, res end
		if #parser < 3 or string.lower(parser[3]) ~= "qrcode.jsp" then return false, res end
		for i = 4, #parser do
			local a, b, key, value = string.find(parser[i], "(%w+)=(%w+)")
			if key and value then res[key] = value end
		end
		return true, res
	end

	for k, v in ipairs(sameUrl) do
		local elem = {}
		for i in string.gmatch(v, "[^:/?&]+") do
			table.insert(elem, i)
		end
		local success, res = checkUrl(parser, elem)
		if success then return res end
	end
	return {}
end