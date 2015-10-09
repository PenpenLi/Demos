require "main.view.tutor.ui.TutorPopup";
TutorMediator=class(Mediator);

function TutorMediator:ctor()
  self.class = TutorMediator;
	self.viewComponent=TutorPopup.new();
end

rawset(TutorMediator,"name","TutorMediator");

function TutorMediator:initializeUI(skeleton, userProxy, data)
  data.x = data.x + GameData.uiOffsetX
  data.y = data.y + GameData.uiOffsetY  
  self:getViewComponent():initializeUI(skeleton, userProxy, data);
end

function TutorMediator:refreshData(data)
  -- 加上偏移量
  --print("data.x======"..data.x.."------data.y="..data.y)
  data.x = data.x + GameData.uiOffsetX
  data.y = data.y + GameData.uiOffsetY
  --print("data.x======"..data.x.."------data.y="..data.y)  

  self:getViewComponent():refreshData(data);
end


function TutorMediator:setGirlPos(x, y)
  self:getViewComponent():setGirlPos(x, y)
end
--[[
function TutorMediator:showBattleOver()
  self:getViewComponent():showBattleOver();
end]]
function TutorMediator:getSmallTutorStep()
  return self:getViewComponent().smallStep;
end
function TutorMediator:clearSmallTutorStep()
  return self:getViewComponent().smallStep;
end
function TutorMediator:onRegister()

end

function TutorMediator:onClose(event)
  closeTutorUI();
end
function TutorMediator:onRemove()
    if self:getViewComponent().parent then
        self:getViewComponent().parent:removeChild(self:getViewComponent());
    end
end

