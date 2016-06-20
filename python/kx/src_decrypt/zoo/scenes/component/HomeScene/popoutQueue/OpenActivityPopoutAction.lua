
OpenActivityPopoutAction = class(HomeScenePopoutAction)

function OpenActivityPopoutAction:ctor(actId)
    self.actId = actId
end

function OpenActivityPopoutAction:popout( ... )
    if not self.actId then
        self:placeholder()
        self:next()
        return
    end

    local function onSuccess( ... )
    end

    local function onError( ... )
        self.source = ""
        self:placeholder()
        self:next()
    end
    -- 
    local function onEnd( ... )
        self:next()
    end

    ActivityUtil:getActivitys(function( activitys )
        local activity = table.find(activitys,function( v ) return tostring(v.actId) == tostring(self.actId) end)
    
        if activity then
            self.source = activity.source
            local data = ActivityData.new(activity)
            data:start(true,false,onSuccess,onError,onEnd)
        else
            -- local tip = "由于您的开心消消乐版本、等级、平台等原因，不能显示此活动~或改活动已结束~"
            local tip = Localization:getInstance():getText("forcepop.tip1")
            CommonTip:showTip(tip,"negative",onEnd)
        end
    end)    
end

function OpenActivityPopoutAction:getSource( ... )
    return self.source or ""
end


function OpenActivityPopoutAction:getConditions( ... )
    return {"enter","enterForground","preActionNext"}
end