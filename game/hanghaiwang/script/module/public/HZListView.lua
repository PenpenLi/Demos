-- FileName: HZListView.lua 
-- Author: zhangqi
-- Date: 14-5-25 
-- Purpose: 对 HZTableView 的封装，方便使用

require "script/module/public/class"

HZListView = class("HZListView")

function HZListView:ctor(...)
    -- add by huxiaozhou swallow touch 
    self.sListType = ...
    -- LayerManager.addLoading()
    self.tbCellMap = {} -- 存放CCTableViewCell和Cell对象的对应关系, 便于复用
    self.Data = {} -- 数据源，默认空表
    self.nCount = 0
    self.idxBarData = -1 -- 按钮面板的 data index, 2015-04-20
    self.idxLastBar = -1 -- 上一个按钮面板的data index
    self.idxNowBar = -1
end

-- tbView = {szView, szCell, tbDataSource, CellAtIndexCallback, CellTouchedCallback, didScrollCallback, didZoomCallback}
function HZListView:init(tbView)
    -- TimeUtil.timeStart("HZListView:init") -- 2015-06-10
    self.viewCfg = tbView
    self.view = HZTableView:create(tbView.szView)

    self.view:registerScriptHandlerForNode(function ( eventType, node )
        if (eventType == "exit") then
            logger:debug("HZTableView onExit")
            self:setBtnBarData()
        end
    end)

    
    if (self.view) then
        self.view:setDirection(kCCScrollViewDirectionVertical) -- 默认垂直滑动
        self.view:setVerticalFillOrder(kCCTableViewFillTopDown) -- 默认从上至下放置
        self.view:setPosition(ccp(0, 0))
        
        if (tbView.tbDataSource) then
            self.Data = tbView.tbDataSource
            self.count = #self.Data
            logger:debug("self.Data count: %d", #self.Data)
        end
        
        self.CellAtIndexCallback = tbView.CellAtIndexCallback
        self.CellTouchedCallback = tbView.CellTouchedCallback
        self.didScrollCallback = tbView.didScrollCallback
        self.didZoomCallback = tbView.didZoomCallback
        
        
        -- CCTableView.kTableCellSizeAtIndex 事件回调
        local function cellAtIndex( view, idx )
            local cell = view:dequeueCell()
            local tbData = self.Data[idx+1] -- 数据源table的index从1开始，tableView的index从0开始，所以此处需要+1

            if (not cell) then
                if (self.CellAtIndexCallback) then
                    local objCell = self.CellAtIndexCallback(tbData, idx, self)
                    
                    cell = CCTableViewCell:new()
                    local gp = objCell:getGroup() -- 每个cell上的touch group
                    cell:addChild(gp, 100, 100)
                    
                    self.tbCellMap[cell] = objCell
                    self.nCount = self.nCount + 1 -- add by huxiaozhou 
                end
            else
                local objCell = self.tbCellMap[cell]
                if (objCell) then
                    objCell:refresh(tbData,idx)
                end
            end

            return cell
        end
    
        -- CCTableView.kTableCellTouched 事件回调
        local function cellOnTouch( view, cell )
            logger:debug("HZListView:cellOnTouch")

            self.cellWdPos = cell:convertToWorldSpace(ccp(0, 0))
            self.viewWdPos = self:getWorldPosition()
            logger:debug("cellOnTouch: cellWdPos.x = %f, y = %f; viewWdPos.x = %f, y = %f;", self.cellWdPos.x, self.cellWdPos.y, self.viewWdPos.x, self.viewWdPos.y)

            local point = tolua.cast(cell:getUserData(), "CCPoint")
            
            local objCell = self.tbCellMap[cell]
            if (objCell) then
                local objTouch = objCell:touchMask(point)
                if (objTouch) then
                    -- objTouch.sender:setFocused(false)
                    if (objTouch.sender:getName() == self.btnTouchedName and objTouch.event) then
                        objTouch.event(objTouch.sender, TOUCH_EVENT_ENDED)
                    end
                    return
                end
            end
            
            if (self.CellTouchedCallback) then
                -- add by sunyunpeng 2015.5.12
                AudioHelper.playCommonEffect()
                self.CellTouchedCallback(view, cell, objCell)
            end
        end
    
        -- CCTableView.kNumberOfCellsInTableView 事件回调
        local function numberOfCells(view)
            return #self.Data
        end
        
        local function didScroll(view)
            if (self.didScrollCallback) then
                self.didScrollCallback()
            end
        end
        
        local function didZoom(view)
            if (self.didZoomCallback) then
                self.didZoomCallback()
            end
        end

        -- CCTableView::kTableCellHighLight
        local function highLightCell( view, cell )
            logger:debug("HZListView:highLightCell")
            local point = tolua.cast(cell:getUserData(), "CCPoint")
            
            local objCell = self.tbCellMap[cell]
            if (objCell) then
                logger:debug("objCell is not nil")
                local objTouch = objCell:touchMask(point)
                if (type(objTouch) == "table") then -- zhangqi, 如果touchMask返回的是table则包含按钮和按钮事件
                    logger:debug("objTouch is not nil")
                    if (objTouch.sender) then
                        logger:debug("objTouch.sender name = %s", objTouch.sender:getName())
                        self.btnTouchedName = objTouch.sender:getName()
                        objTouch.sender:setFocused(true)
                        self.btnTouched = objTouch.sender
                    end
                end
            end
        end
        -- CCTableView::kTableCellUnhighLight
        local function unhighLightCell( view, cell )
            logger:debug("HZListView:unhighLightCell")
            if (self.btnTouched) then
                self.btnTouched:setFocused(false)
                self.btnTouched = nil
            end
        end
        self.view:registerScriptHandler(highLightCell, CCTableView.kTableCellHighLight)
        self.view:registerScriptHandler(unhighLightCell, CCTableView.kTableCellUnhighLight)

        self.view:registerScriptHandler(cellAtIndex, CCTableView.kTableCellSizeAtIndex)
        self.view:registerScriptHandler(cellOnTouch, CCTableView.kTableCellTouched)
        self.view:registerScriptHandler(numberOfCells, CCTableView.kNumberOfCellsInTableView)
        self.view:registerScriptHandler(
            function ( view, idx )
                local tbData = self.Data[idx+1] -- zhangqi, 2015-04-29, 获取按钮面板对应的数据
                if (tbData.height) then
                    return tbData.height, tbData.width
                else
                    return tbView.szCell.height, tbView.szCell.width
                end
            end, CCTableView.kTableCellSizeForIndex
        )
        if (tbView.didScrollCallback) then
            self.view:registerScriptHandler(didScroll, CCTableView.kTableViewScroll)
        end
        if (tbView.didZoomCallback) then
            self.view:registerScriptHandler(didZoom, CCTableView.kTableViewZoom)
        end
        return true
    end

    -- TimeUtil.timeEnd() -- 2015-06-10

    return false
end

function HZListView:refresh()
    -- TimeUtil.timeStart("HZListView:refresh") -- 2015-06-10
    if (self.view) then
        LayerManager.addUILoading()
        -- add by huxiaozhou 2014-08-08 当背包列表数据是空的时候 移除掉loading，因为没用数据不会执行 背包进入动画，需要提前判断是否移除
        if (#self.Data==0 or self.sListType == nil) then
            LayerManager.begainRemoveUILoading()
        end

        -- TimeUtil.timeStart("view:reloadData " .. #self.Data) -- 2015-06-10
        self.view:reloadData()
        -- TimeUtil.timeEnd() -- 2015-06-10
    end
    -- TimeUtil.timeEnd() -- 2015-06-10
end
function HZListView:refreshNotReload()
    if (self.view) then
        -- logger:debug(self.Data)
        -- add by huxiaozhou 2014-08-08 当背包列表数据是空的时候 移除掉loading，因为没用数据不会执行 背包进入动画，需要提前判断是否移除
        if (#self.Data==0 or self.sListType == nil) then
            LayerManager.begainRemoveUILoading()
        end
       -- self.view:reloadData()
    end
end
--  add by huxiaozhou  2014-08-01 
--  背包 进入 cell 动画
function HZListView:enterAnimation(  )
    logger:debug("self.nCount = " .. self.nCount)
    -- self.view:setTouchEnabled(false)
    for idx=0,self.nCount-1 do
        local cell = self.view:cellAtIndex(idx)
        if (cell==nil) then
            break
        end

        local objCell = self.tbCellMap[cell]
        UIHelper.startCellAnimation(objCell.mCell, idx+1,function ( )
            if(self.view:cellAtIndex(idx+1)==nil or idx==(self.nCount-1)) then
                logger:debug("Cell 动画播放完了")
                -- self.view:setTouchEnabled(true)
                LayerManager.begainRemoveUILoading()
            end
        end)
    end
end

function HZListView:changeDataSource(tbData)
    self.Data = tbData
    self.count = #self.Data
    self:refresh()
end
 
--by ZhangXiangHui
function HZListView:changeData(tbData)
    self.Data = tbData
    self.count = #self.Data
end
 
--[[desc:zhangjunwu 2014-09-10 重新加载tableview并且保持之前的位置不变
    arg1: nil
    return: nil  
—]]
function HZListView:reloadDataByBeforeOffset()
    local offset = self.view:getContentOffset()
    self.view:reloadData()
    self.view:setContentOffset(ccp(offset.x,offset.y))
end

--[[desc:lizy 2014-09-10 重新加载tableview并且保持之前的位置不变
    modified: zhangqi, 2014-12-26
    num: 需要删除的cell数量
    nIndex: 被删除所有cell里最后一个（最下面一个）在TableView中的index（index从0开始）
    return: nil  
—]]
function HZListView:reloadDataDelByOffset(num, nIndex)
    logger:debug("HZListView:reloadDataDelByOffset-num:%s, nIndex:%s", tostring(num), tostring(nIndex))

    local nInnerCount = math.ceil(self.view:getViewSize().height/self.viewCfg.szCell.height)
    logger:debug("self.count = %d, nInnerCount = %d", self.count, nInnerCount)
    local offset = self.view:getContentOffset()

    self.view:reloadData()

    -- 实际数量比滑动区域可显示的数量少，刷新整个列表
    -- 实际数量比滑动区域可显示的数量多，但是只删除了最上面的第一个cell, 刷新整个列表
    -- 同时删除2个以上cell，刷新整个列表
    if (self.count <= nInnerCount) or (num == 1 and nIndex == 0) or (num > 2) then
        return
    end

    -- 删除 2 个以内的物品，下面的依次上移
    self.view:setContentOffset(ccp(offset.x, offset.y + num * self.viewCfg.szCell.height))  
end

--[[desc:李卫东 20140814 重新加载tableview并且保持之前的位置不变
    arg1: nil
    return: nil
    modified: zhangqi, 2015-10-16, 增加参数cellHight，用于在伙伴、装备、饰品背包里指定按钮面板的cell高度，避免位移偏差
—]]
function HZListView:reloadDataByOffset(cellHight)
    local offset=self.view:getContentOffset()
    self.view:reloadData()
    self.view:setContentOffset(ccp(offset.x,offset.y + (cellHight or self.viewCfg.szCell.height)))
end

--[[desc:李卫东 20140814 增加新的数据后 重新加载tableview并且保持之前的位置上向移动一个格
    arg1: num 给出新增加的个数
    return: nil  
—]]
function HZListView:reloadDataByInsertData(num)
    local offset=self.view:getContentOffset()
    self.view:reloadData()
    self.view:setContentOffset(ccp(offset.x,-num*self.viewCfg.szCell.height))
    
end

--[[desc:孙云鹏 
    arg1: cellIndex 移动到列表指定cellIndex
    return: nil  
—]]
function HZListView:moveToCellIndex( cellIndex)
    local offset=self.view:getContentOffset()
    local nInnerCount = self.view:getViewSize().height/self.viewCfg.szCell.height
    -- self.view:reloadData()
    logger:debug({cellIndex=cellIndex})
    self.view:setContentOffset(ccp(offset.x, -(#self.Data - cellIndex -nInnerCount) * self.viewCfg.szCell.height )) 
end


--更新某一个cell,idx为cctableview的行标,更新前需要处理数据，再changeData更新下原来的数据，by ZhangXiangHui
function HZListView:updateCellAtIndex(idx)
    local cell = self.view:cellAtIndex(idx)
    local objCell = self.tbCellMap[cell]
    if (objCell) then
        local tbDataItem = self.Data[idx+1]
        objCell:refresh(tbDataItem)
    end
end

--更新所有cell,更新前需要先删除/改变数据，再changeData更新下原来的数据，by ZhangXiangHui
function HZListView:updateAllCell()
    if (#self.Data > 0) then
        for i, v in ipairs(self.Data) do -- zhangqi, 2014-07-17, self.Data 本来就是一个 array 型table，需要用ipairs来遍历
            self:updateCellAtIndex(i-1)
        end
    else
        self:refresh()
    end
end

function HZListView:insertMoreCell(m,n)
    for i=m,m+n do
        self.view:insertCellAtIndex(i)
    end
end

function HZListView:getView()
   return self.view
end

function HZListView:setEnabled( bStat )
    logger:debug(bStat)
    self.view:setVisible(bStat)
    self.view:setTouchEnabled(bStat)
end

-- 返回列表所有数据的个数
function HZListView:cellCount( ... )
    return self.count
end

-- zhangjunwu
function HZListView:removeView()
    if (self.view) then
        self.view:removeFromParentAndCleanup(true)
    end
end

-- zhangqi, 2015-04-29
function HZListView:getWorldPosition( ... )
    return self.view:convertToWorldSpace(ccp(0, 0));
end

function HZListView:saveOffsetYBeforeBarDown( ... )
    self.downOffset = self.view:getContentOffset()
end

function HZListView:saveOffsetOfInit( ... )
    self.origOffsetY = self.view:getContentOffset().y
    logger:debug("HZListView:saveOffsetOfInit origOffsetY = %f", self.origOffsetY)
end

-- zhangqi, 2015-04-29
-- nFlag, 1 表示弹出，-1 表示收起； nDataIdx，表示点击的收放按钮所在Cell的数据index（用来判断是第一个或最后一个）
function HZListView:reloadDataForBtnBar( nFlag, nDataIdx )

    local numOffsetY = 15*g_fScaleX
    local minOffsetY = self.view:minContainerOffset().y
    local maxOffsetY = self.view:maxContainerOffset().y

    local szBar = self:getBtnBarSize() -- 按钮面板 size
    local newOffset = self.downOffset --  oldOffset
    logger:debug("reloadDataForBtnBar1: self.downOffset.y = %f", self.downOffset.y)

    if (nFlag == -1) then
        self:setBtnBarData() -- 收起按钮面板时删除对应的面板数据
    end

    
    local viewTop = self:getWorldPosition().y + self.viewCfg.szView.height -- listView 顶部的世界坐标
    local heightCell = self.viewCfg.szCell.height -- 普通Cell高度
    local distY = self.cellWdPos.y - self.viewWdPos.y -- 当前点击的Cell底边和listView底边的距离，世界坐标
    local distYtop = viewTop - self.cellWdPos.y
    logger:debug("reloadDataForBtnBar: szBar.height = %f, distY = %f, viewTop = %f, heightCell = %f", szBar.height, distY, viewTop, heightCell)

    -- -- 第一个Cell
    -- if (nDataIdx == 1) then
    --     newOffset.y = self.origOffsetY > minOffsetY and self.origOffsetY or minOffsetY
    --     if (nFlag == 1) then
    --         newOffset.y = newOffset.y - szBar.height
    --     end
    --     logger:debug("TOP 1: dataIdx = %d, newOffset.y = %f", nDataIdx, newOffset.y)

    --     self.view:reloadData()
    --     self.view:setContentOffset(newOffset)
    --     return
    -- end

    -- -- 最后一个Cell
    -- if (self.idxNowBar == #self.Data or nDataIdx == #self.Data) then
    --     newOffset.y = self.origOffsetY > maxOffsetY and self.origOffsetY or maxOffsetY
    --     if (newOffset.y == maxOffsetY) then
    --         newOffset.y = newOffset.y + numOffsetY
    --     end
    --     logger:debug("END 1: dataIdx = %d, newOffset.y = %f", nDataIdx, newOffset.y)
    --     self.view:reloadData()
    --     self.view:setContentOffset(newOffset)
    --     return
    -- end

    if (self.idxLastBar > 0) then -- 点击下拉按钮前已经展开一个按钮面板
        -- if (self.idxLastBar < self.idxNowBar) then -- 已展开的按钮面板位置在当前的上面
        --     if (distYtop < heightCell) then -- 当前点击的 cell 下边和 view 顶部间距不足一个cell高度（没有完全显示）
        --         -- ShowNotice.showShellInfo("condition1 OK")
        --         newOffset.y = newOffset.y - (heightCell - distYtop) - szBar.height
        --     elseif (distY < heightCell) then -- 当前点击的 cell 下边和 view 底边间距不足一个cell高度
        --         -- ShowNotice.showShellInfo("condition2 OK")

        --         numOffsetY = distY > 0 and 0 or numOffsetY
        --         distY = distY > 0 and (szBar.height - distY) or -distY

        --         newOffset.y = newOffset.y + distY + numOffsetY
        --     else
        --         -- ShowNotice.showShellInfo("condition3 OK")
        --         newOffset.y = newOffset.y --  - nFlag * szBar.height
        --     end
        -- else -- 已展开的按钮面板位置在当前的下面
        --     if (distYtop < heightCell) then
        --         -- ShowNotice.showShellInfo("condition4 OK")
        --         newOffset.y = newOffset.y - (heightCell - distYtop)
        --     elseif (distY < heightCell) then
        --         -- ShowNotice.showShellInfo("condition5")
  
        --         distY = distY > 0 and (szBar.height - distY) or (szBar.height + math.abs(distY))

        --         newOffset.y = newOffset.y + distY + numOffsetY
        --     else
        --         -- ShowNotice.showShellInfo("condition6")
        --         newOffset.y = newOffset.y -- - szBar.height
        --     end
        -- end
    else -- 点击下拉按钮前没有展开过按钮面板
        -- if (distYtop < heightCell) then
        --     -- ShowNotice.showShellInfo("condition7 OK")
        --     newOffset.y = newOffset.y - (heightCell - distYtop) - szBar.height - numOffsetY
        -- elseif (distY < heightCell) then
        --     -- ShowNotice.showShellInfo("condition8 OK")

        --     numOffsetY = distY > 0 and 0 or numOffsetY
        --     distY = distY > 0 and 0 or -distY

        --     newOffset.y = newOffset.y + distY + numOffsetY
        -- else
        --     -- ShowNotice.showShellInfo("condition9 OK")
        --     newOffset.y = newOffset.y - nFlag * szBar.height
        -- end
        newOffset.y = newOffset.y - nFlag * szBar.height

        if (distY < szBar.height) then
            newOffset.y = newOffset.y + nFlag * szBar.height
        end
    end

    self.view:reloadData()
    self.view:setContentOffset(newOffset)
end

-- zhangqi, 2015-04-29, 获取ButtonBar的size, 如果没有则返回cell的size
function HZListView:getBtnBarSize( ... )
    if (self.btnBarSize) then
        return self.btnBarSize
    end

    local objCell = nil
    for k, v in pairs(self.tbCellMap) do
        objCell = v
        break
    end
    if (objCell) then
        self.btnBarSize = g_fnCellSize(CELLTYPE.BTN_BAR) -- objCell.objBtnBar:cellSize()
        return self.btnBarSize
    end

    return self.viewCfg.szCell
end

-- 设置和删除给按钮面板构造的cell数据，2015-04-24
-- barData, 按钮面板的人造data; idxData, 下拉按钮所在cell的data index
function HZListView:setBtnBarData( barData, idxData )
    logger:debug("HZListView:setBtnBarData")

    local idxOffset = 0 -- 保存因为先关闭上次打开的按钮面板造成的index偏移

    if (barData) then
        if (self.idxBarData > 0) then -- 已经存在一个按钮面板，需要先关闭(从dataSource中删除)
            self.idxLastBar = self.idxBarData

            idxOffset = self.idxBarData < idxData and -1 or 0 -- 如果当前按钮面板在点击的cell之前就需要将 idxData 减 1 得到修正后data index
            table.remove(self.Data, self.idxBarData)

            self.idxBarData = -1
        end

        local newIdx = idxData + 1 + idxOffset -- + 1 是当前不存在已显示按钮面板时, 按钮面板的 data index 肯定就是cell 的 data index 加 1

        self.idxBarData = newIdx
        table.insert(self.Data, self.idxBarData, barData)

        self.idxNowBar = self.idxBarData

        for i, data in ipairs(self.Data) do
            data.idx = i
        end
    elseif (self.idxBarData > 0) then
        logger:debug("self.idxBarData = %d", self.idxBarData)

        table.remove(self.Data, self.idxBarData)
        self.idxBarData = -1
        self.idxLastBar = -1
        self.idxNowBar = -1

        for i, data in ipairs(self.Data) do
            data.idx = i
        end
    end
end

function HZListView:getBtnBarDataIdx( ... )
    return self.idxBarData
end
