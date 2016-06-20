package com.mvc.views.uis.mainCity.elfSeries
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import starling.display.Image;
   import lzm.starling.display.Button;
   import com.mvc.models.vos.mainCity.elfSeries.RivalVO;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class RivalInfoUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_rivalInfo:SwfSprite;
      
      private var rivalnName:TextField;
      
      private var rivalLv:TextField;
      
      private var rivalPower:TextField;
      
      private var spr_head:Image;
      
      private var panel:Sprite;
      
      private var rivalrRank:TextField;
      
      public var closeBtn:Button;
      
      public function RivalInfoUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_rivalInfo = swf.createSprite("spr_rivalInfo_s");
         rivalnName = spr_rivalInfo.getTextField("rivalnName");
         rivalLv = spr_rivalInfo.getTextField("rivalLv");
         rivalrRank = spr_rivalInfo.getTextField("rivalrRank");
         rivalPower = spr_rivalInfo.getTextField("rivalPower");
         closeBtn = spr_rivalInfo.getButton("closeBtn");
         rivalnName.fontName = "1";
         spr_rivalInfo.x = 1136 - spr_rivalInfo.width >> 1;
         spr_rivalInfo.y = 640 - spr_rivalInfo.height >> 1;
         addChild(spr_rivalInfo);
         addPanel();
      }
      
      private function addPanel() : void
      {
         panel = new Sprite();
         panel.x = 0;
         panel.y = 214;
         spr_rivalInfo.addChild(panel);
      }
      
      public function set myRival(param1:RivalVO) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         panel.removeChildren(0,-1,true);
         if(spr_head != null)
         {
            GetpropImage.clean(spr_head);
         }
         spr_head = GetPlayerRelatedPicFactor.getHeadPic(param1.headPtId,1);
         spr_head.x = 41;
         spr_head.y = 55;
         spr_rivalInfo.addChild(spr_head);
         rivalnName.text = param1.userName;
         rivalLv.text = "" + param1.lv;
         rivalrRank.text = param1.rank;
         rivalPower.text = GetElfFactor.powerCalculate(param1.elfVec).toString();
         _loc3_ = 0;
         while(_loc3_ < param1.elfVec.length)
         {
            _loc2_ = new ElfBgUnitUI(false,false);
            _loc2_.identify = "排行榜";
            _loc2_.myElfVo = param1.elfVec[_loc3_];
            var _loc4_:* = 0.7;
            _loc2_.scaleY = _loc4_;
            _loc2_.scaleX = _loc4_;
            _loc2_.x = 41 + _loc3_ * 92;
            panel.addChild(_loc2_);
            _loc3_++;
         }
      }
   }
}
