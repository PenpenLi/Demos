
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
		local a, b, key, value = string.find(parser[1], "(%w+)=(%w+)")
		if key and value then res.para[key] = value end
		table.remove(parser, 1)
	end
	return res
end