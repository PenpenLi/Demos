RandomFactory = class()

function RandomFactory:create()
	local randomFactory = RandomFactory.new()
	randomFactory:init()
	return randomFactory
end

function RandomFactory:init()
	self.CCPObject = HERandomObject:create()
	self.randomIndex = 0
end


function RandomFactory:rand(a,b)
	local r = 0 
	
	if self.CCPObject then
		if a and b then
			self.randomIndex = self.randomIndex + 1
			r = self.CCPObject:rand(a,b)
		else
			self.randomIndex = self.randomIndex + 1
			r = self.CCPObject:rand()
		end
	end

	if _G.isCheckPlayModeActive then
		print("RRR  ===== rand   randomIndex = " , self.randomIndex , "  a = " , a , "  b = " , b , " r = " , r )
		print("RRR  " , debug.traceback())
	end

	return r
end

function RandomFactory:randSeed(seed)
	if self.CCPObject and seed then
		self.randomIndex = 0
		return self.CCPObject:randSeed(seed)
	end
	return nil
end