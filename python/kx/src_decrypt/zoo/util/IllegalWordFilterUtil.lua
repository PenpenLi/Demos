IllegalWordFilterUtil = {}

local instance
local wordsFilter
function IllegalWordFilterUtil.getInstance()
	if not instance then
		instance = IllegalWordFilterUtil
		if __ANDROID then
			wordsFilter = luajava.bindClass("com.happyelements.android.utils.IllegalWordFilter"):getInstance()
			wordsFilter:loadWordsWithAssetsFile("illegalwords.txt")
		end
	end
	return instance
end

function IllegalWordFilterUtil:isIllegalWord(word)
	if not word or type(word) ~= "string" then return false end
	if not wordsFilter then return false end
	if __ANDROID then 
		return wordsFilter:isIllegalWord(word)
	end
	return false
end

return IllegalWordFilterUtil