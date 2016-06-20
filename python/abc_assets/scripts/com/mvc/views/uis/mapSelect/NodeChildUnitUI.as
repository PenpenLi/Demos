package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import starling.text.TextField;
   import com.mvc.models.vos.mapSelect.MainMapVO;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Image;
   import flash.geom.Rectangle;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.util.xmlVOHandler.GetMapFactor;
   
   public class NodeChildUnitUI extends Sprite
   {
       
      private var nameText:TextField;
      
      private var _mainMapVo:MainMapVO;
      
      private var swf:Swf;
      
      private var spr_level:SwfSprite;
      
      private var starProgress:SwfSprite;
      
      private var levelName:TextField;
      
      private var star:SwfSprite;
      
      public function NodeChildUnitUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("cityMap");
         spr_level = swf.createSprite("spr_level");
         starProgress = spr_level.getSprite("starProgress");
         starProgress.x = starProgress.x - 2;
         star = starProgress.getSprite("star");
         levelName = spr_level.getTextField("levelName");
         addChild(spr_level);
      }
      
      private function addText() : void
      {
         nameText = new TextField(100,20,"","FZCuYuan-M03S",20,5584695,true);
         nameText.autoSize = "horizontal";
         nameText.hAlign = "center";
         nameText.vAlign = "center";
         nameText.y = 110;
         addChild(nameText);
      }
      
      public function set myLevelVo(param1:MainMapVO) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         _mainMapVo = param1;
         if(LoadSwfAssetsManager.getInstance().assets.getSwf("npcMin").hasImage("img_" + param1.picName))
         {
            _loc2_ = LoadSwfAssetsManager.getInstance().assets.getSwf("npcMin").createImage("img_" + param1.picName);
         }
         else
         {
            _loc2_ = LoadSwfAssetsManager.getInstance().assets.getSwf("npcMin").createImage("img_di4si4dao4guan3guan3zhu3");
         }
         _loc2_.x = 6;
         _loc2_.y = 1;
         addChildAt(_loc2_,0);
         if(param1.isPass)
         {
            _loc3_ = swf.createImage("img_pass");
            _loc3_.y = 15;
            _loc3_.x = 10;
            addChild(_loc3_);
            if(param1.isHard)
            {
               star.clipRect = new Rectangle(0,0,star.width / 3 * param1.hardStars,star.height);
            }
            else
            {
               star.clipRect = new Rectangle(0,0,star.width / 3 * param1.normalStars,star.height);
            }
         }
         else
         {
            star.clipRect = new Rectangle(0,0,0,0);
         }
         levelName.text = param1.npcName;
         addDoubleIcon();
      }
      
      private function addDoubleIcon() : void
      {
         var _loc1_:* = null;
         if(FightingConfig.cityIdArr.indexOf(GetMapFactor.countCityId(_mainMapVo.nodeId)) != -1)
         {
            _loc1_ = swf.createImage("img_double2");
            _loc1_.x = 80;
            _loc1_.y = 0;
            addChild(_loc1_);
         }
      }
   }
}
