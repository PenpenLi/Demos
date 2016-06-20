

local BattleChestData = class("BattleChestData")
 
	------------------ properties ----------------------
	-- 物品id
	BattleChestData.id 			= nil
	-- 物品类型
	BattleChestData.type 		= nil
	-- 物品icon图标的url
	BattleChestData.iconURL 	= nil
	-- 物品数量
	BattleChestData.num 		= nil

	BattleChestData.uiPosition  = nil -- 飞向的目标位置
	------------------ functions -----------------------
	function BattleChestData:resetByHeroPart( data )
		
		self.itemType = BATTLE_CONST.CHEST_HERO_PART
		self.num  = tonumber(data.num)
		self.id   = data.htid
		print("--- BattleChestData:resetByHeroPart:",self.num)

	end

	function BattleChestData:resetByItem(data)
		self.itemType = BATTLE_CONST.CHEST_ITEM
		self.num  = tonumber(data.item_num)
		self.id   = data.item_template_id

		print("--- BattleChestData:resetByItem:%d",data.item_num)
	end
	function BattleChestData:getLogicAction()
		
	end

	function BattleChestData:isItem( ... )
		return self.itemType == BATTLE_CONST.CHEST_ITEM
	end


	function BattleChestData:isHeroPart( ... )
		return self.itemType == BATTLE_CONST.CHEST_HERO_PART
	end


	function BattleChestData:getToPosition()

		print("--- itemType:",self.itemType)
		local mediator = EventBus.getMediator("BattleInfoUIMediator")
		assert(mediator,"未注册BattleInfoUIMediator!!!")
		local result = nil		
		local display = nil
		-- 如果类型是英雄碎片
		if(self.itemType == BATTLE_CONST.CHEST_HERO_PART or self.itemType == BATTLE_CONST.CHEST_ITEM) then

			
			display = mediator.infoView.itemIcon
			result = display:getParent():convertToWorldSpace(ccp(display:getPositionX() + display:getContentSize().width/2,display:getPositionY()+ display:getContentSize().height/2))

		-- -- 如果是宝箱碎片
		-- elseif(self.itemType == BATTLE_CONST.CHEST_ITEM) then
			
		-- 	display = mediator.infoView.itemIcon
		-- 	-- display = mediator.infoView.stoneIcon
		-- 	result = display:getParent():convertToWorldSpace(ccp(display:getPositionX(),display:getPositionY()))

		-- 	-- result = mediator.infoView.stoneIcon:getPosition()
		else
			-- 如果是debug模式,直接挂掉
			if(g_debug_mode) then
				error("错误的物品掉落类型:" .. tostring(self.itemType))
			-- 如果是release我们默认取值为英雄类型
			else
				display = mediator.infoView.itemIcon
				result = display:convertToWorldSpace(ccp(display:getPositionX(),display:getPositionY()))
			end
		end

		return result
	end

	-- 获取数据类的图标(CCSprite)
	function BattleChestData:getSprite()
		
		local resutl = nil

		local back  = nil--= CCSprite:create(BATTLE_CONST.BATTLE_DROP_BACK_IMG)
		if(self.itemType == BATTLE_CONST.CHEST_HERO_PART) then
			local item = DB_Item_hero_fragment.getDataById(self.id)
			local quality = item.quality
			local backImgURL = BattleURLManager.getBattleHeroItemBackImg(quality)
			back = CCSprite:create(backImgURL)
			local htid= item.aimItem

			local db_hero = DB_Heroes.getDataById(tonumber(htid))
			local sHeadIconImg="images/base/hero/head_icon/" .. db_hero.head_icon_id
			-- local sQualityBgImg="images/hero/quality/"..db_hero.star_lv .. ".png"
			-- print("BattleChestData:getSprite:",sHeadIconImg,sQualityBgImg)
			-- 头像item背景
			-- resutl = CCSprite:create(sHeadIconImg)
			local itemImg = CCSprite:create(sHeadIconImg)
			itemImg:setPosition(ccp(back:getContentSize().width/2,back:getContentSize().height/2))
			back:addChild(itemImg)
			-- 武将头像图标item
			-- local headIcon_n = CCSprite:create(sHeadIconImg)
			-- headIcon_n:setPosition(ccp(resutl:getContentSize().width/2,resutl:getContentSize().height/2))
			-- resutl:addChild(headIcon_n)
			-- resutl:setScale(0.5)
		-- 如果是宝箱碎片
		elseif(self.itemType == BATTLE_CONST.CHEST_ITEM) then
			local item = ItemUtil.getItemById(self.id)
			local backImgURL1 = BattleURLManager.getBattleHeroItemBackImg(item.quality)
			back = CCSprite:create(backImgURL1)
			-- resutl = CCSprite:create(item.imgFullPath)
			local itemImg = CCSprite:create(item.imgFullPath)
			itemImg:setPosition(ccp(back:getContentSize().width/2,back:getContentSize().height/2))
			back:addChild(itemImg)

			-- resutl:setScale(0.5)
		else
			error("错误的物品掉落类型:" .. tostring(self.itemType))
		end
		

		local size = back:getContentSize()
		back:setScale(BATTLE_CONST.DROP_ITEM_SIZE/size.width)
		return back
	end


return BattleChestData