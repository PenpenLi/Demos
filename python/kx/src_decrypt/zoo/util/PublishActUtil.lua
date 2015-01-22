PublishActUtil = {}

function PublishActUtil:isGroundPublish()
	return false
end

function PublishActUtil:getTempPropTable()
	return {10015,10016,10017,10019,10024,10007}
end

function PublishActUtil:getTempSelectedPropTable()
	return {{id=10015},{id=10016},{id=10017},{id=10024},{id=10019},{id=10007}}
end

function PublishActUtil:getTempPropNum()
	return 5
end

function PublishActUtil:getLevelId()
	return 9999
end