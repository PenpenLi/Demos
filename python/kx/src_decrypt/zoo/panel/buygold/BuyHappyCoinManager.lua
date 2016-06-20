BuyHappyCoinManager = {}

function BuyHappyCoinManager:getShowConfigById(price)
	local itemIndex = 1
	if price <= 6 then 
		itemIndex = 1
	elseif price > 6 and price <= 20 then 
		itemIndex = 2
	elseif price > 20 and price <= 30 then 
		itemIndex = 3
	elseif price > 30 and price <= 60 then 
		itemIndex = 4
	elseif price > 60 then 
		itemIndex = 5
	end
	return itemIndex
end