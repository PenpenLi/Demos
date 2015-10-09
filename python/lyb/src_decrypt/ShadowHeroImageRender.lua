
ShadowHeroImageRender=class(TouchLayer);

function ShadowHeroImageRender:ctor()
  self.class=ShadowHeroImageRender;
  self.selected = false;
  self.type = 1;
end

function ShadowHeroImageRender:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ShadowHeroImageRender.superclass.dispose(self);
	BitmapCacher:removeUnused();
end
function ShadowHeroImageRender:initializeUI(context, heroId)
  
  self:initLayer();
  self.context = context;
  self.skeleton = context.skeleton;

  local art2 = analysis("Kapai_Kapaiku", heroId, "art2")
  local headImg = Image.new();
  headImg:loadByArtID(art2);
  self:addChild(headImg)
  headImg:setPositionXY(20,20)

  local render_bg = self.skeleton:getBoneTextureDisplay("yxz/heroImage_render_bg");
  self:addChild(render_bg);

  local name = analysis("Kapai_Kapaiku", heroId, "name")
  local str = "";
  local _count = -1;
  while (-1-string.len(name)) < _count do
    str = str .. string.sub(name, -2 + _count, _count) .. "\n";
    _count = -3 + _count;
  end
  print("heroId, _count", heroId, _count)
  local yPos = 95;
  if _count == -7 then
    yPos = 95
  elseif _count == -10 then
    yPos = 65
  elseif _count == -13 then  
    yPos = 35
  end
  self.name_img=BitmapTextField.new(str,"yingxiongmingzi");
  self.name_img:setPositionXY(15,yPos);
  self:addChild(self.name_img)


end
function ShadowHeroImageRender:setData(data)

end
function ShadowHeroImageRender:showNewHeroEffect()
  local function callBackFun()
    self:removeChild(self.boneCartoon);
  end
  self.boneCartoon = cartoonPlayer("1379",95,260,1,callBackFun,1.5,nil)
  self:addChild(self.boneCartoon)

end