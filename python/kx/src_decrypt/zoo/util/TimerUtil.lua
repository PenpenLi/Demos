TimerUtil = {}

TimerUtil.inited = false
TimerUtil.autoInterval = 0.04
TimerUtil.timeMap = {}
TimerUtil.autoCountDonwTextMap = {}
TimerUtil.timeIdConut = 1

function TimerUtil.now()
	return os.time() + (__g_utcDiffSeconds or 0)
end 

function TimerUtil.init()
	
	if not TimerUtil.inited then

		TimerUtil.inited = true

		local function onAutoUpdated()
			TimerUtil.check()
			setTimeOut(onAutoUpdated , TimerUtil.autoInterval)
		end

		onAutoUpdated()
	end
end

function TimerUtil.addAlarm(callback, intervalTime , repeatTime , parameters)

	assert(callback)
	assert(type(callback) == "function")

	if not TimerUtil.inited then
		TimerUtil.init()
	end

	intervalTime = intervalTime or 1
	intervalTime = tonumber(intervalTime)
	if intervalTime <= 0 then
		intervalTime = 1
	end

	repeatTime = repeatTime or 1
	repeatTime = tonumber(repeatTime)
	if repeatTime < 0 then
		repeatTime = 1
	end

	TimerUtil.timeIdConut = TimerUtil.timeIdConut + 1
	local tarTime = TimerUtil.now() + intervalTime
	local data = { f=callback , t=tarTime , i=intervalTime , r=repeatTime , p=parameters , d=TimerUtil.timeIdConut }

	table.insert( TimerUtil.timeMap , data )

	
	return TimerUtil.timeIdConut
end

function TimerUtil.removeAlarm(id)
	for k,v in pairs( TimerUtil.timeMap ) do
		if tonumber(id) == v.d then
			table.remove( TimerUtil.timeMap , k )
			return
		end
	end
end

function TimerUtil.check()
	for k,v in pairs( TimerUtil.timeMap ) do
		if TimerUtil.now() >= v.t then
			v.r = v.r - 1

			if type(v.f) == "function" then
				if v.p then
					v.f(v.p)
				else
					v.f()
				end
			end

			if tonumber(v.r) == 0 then
				table.remove( TimerUtil.timeMap , k )
			else
				v.t = TimerUtil.now() + v.i
			end
		end
	end
end

--[[
text  文本框
startSec 起始秒数
endSec   结束秒数
perSec   刷新间隔秒数，默认1
format   格式 1 00:00:00  2 00时00分00秒
endCallback  即时结束时回调
perCallback  每次变更时回调
]]
function TimerUtil.setAutoCountDonwText(text , startSec , endSec , perSec , format , endCallback , perCallback)
	
	print("RRR  TimerUtil.setAutoCountDonwText  text = " .. tostring(text) .. 
		"  startSec = " .. tostring(startSec) ..
		"  endSec = " .. tostring(endSec) ..
		"  perSec = " .. tostring(perSec) ..
		"  format = " .. tostring(format) ..
		"  endCallback = " .. tostring(endCallback) ..
		"  perCallback = " .. tostring(perCallback)
		)

	assert(text)

	perSec = perSec or 1
	perSec = tonumber(perSec)
	if perSec <= 0 then
		perSec = 1
	end

	format = format or 1
	format = tonumber(format)
	print(tostring(format))
	if format <= 0 then
		format = 1
	end

	local data = { text=text , ss=tonumber(startSec) , es=tonumber(endSec) , ps=tonumber(perSec) , f=format , ef=endCallback , pf=perCallback }

	if tonumber(startSec) > tonumber(endSec) then
		data.ty = 1
	else
		data.ty = 2
	end

	local function onTimer(obj)

		local result = false
		if obj.ty == 1 then
			obj.ss = obj.ss - obj.ps
			if obj.ss <= obj.es then
				result = true
			end
		else
			obj.ss = obj.ss + obj.ps
			if obj.ss >= obj.es then
				result = true
			end
		end

		if result and obj.text then
			TimerUtil.removeAutoCountDonwText(obj.text)
		end
		
		if obj.text and not obj.text.isDisposed then
			obj.text:setString( convertSecondToHMSFormat(obj.ss) )
		end

		if obj.pf and type(obj.pf) == "function" then
			obj.pf()
		end

		if result then
			if obj.ef and type(obj.ef) == "function" then
				obj.ef()
			end
		end
	end

	data.tid = TimerUtil.addAlarm( onTimer , perSec , 0 , data)
	table.insert( TimerUtil.autoCountDonwTextMap , data )
	
end

function TimerUtil.removeAutoCountDonwText(text)
	for k,v in pairs( TimerUtil.autoCountDonwTextMap ) do

		if text == v.text then
			TimerUtil.removeAlarm(v.tid)
			table.remove( TimerUtil.autoCountDonwTextMap , k )
			return
		end
	end
end

function TimerUtil.transformToString(timeDate)

end