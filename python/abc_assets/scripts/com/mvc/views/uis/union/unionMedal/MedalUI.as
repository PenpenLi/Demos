package com.mvc.views.uis.union.unionMedal
{
   import starling.display.Sprite;
   import feathers.controls.List;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfScale9Image;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetUnionMedal;
   import com.mvc.models.vos.login.PlayerVO;
   import flash.geom.Rectangle;
   import com.common.util.GetCommon;
   import starling.display.Image;
   import starling.display.Quad;
   
   public class MedalUI extends Sprite
   {
       
      public var medalList:List;
      
      private var swf:Swf;
      
      public var spr_medal:SwfSprite;
      
      private var expTxt:TextField;
      
      private var expSpr:SwfSprite;
      
      private var propmt:TextField;
      
      private var s9txtBg:SwfScale9Image;
      
      public var btn_myMedal:SwfButton;
      
      public var btn_gift:SwfButton;
      
      public var btn_close:SwfButton;
      
      public function MedalUI()
      {
         super();
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionWorld");
         var _loc3_:Image = _loc2_.createImage("img_bg0");
         addChild(_loc3_);
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionMedal");
         spr_medal = swf.createSprite("spr_medal");
         expTxt = spr_medal.getTextField("expTxt");
         expSpr = spr_medal.getSprite("expSpr");
         propmt = spr_medal.getTextField("propmt");
         s9txtBg = spr_medal.getScale9Image("s9txtBg");
         btn_myMedal = spr_medal.getButton("btn_myMedal");
         btn_gift = spr_medal.getButton("btn_gift");
         btn_close = spr_medal.getButton("btn_close");
         spr_medal.x = 1136 - spr_medal.width >> 1;
         spr_medal.y = 640 - spr_medal.height >> 1;
         addChild(spr_medal);
      }
      
      private function addList() : void
      {
         medalList = new List();
         medalList.width = 735;
         medalList.height = 336;
         medalList.x = 62;
         medalList.y = 246;
         medalList.isSelectable = false;
         medalList.itemRendererProperties.paddingTop = 0;
         medalList.itemRendererProperties.paddingBottom = -3;
         spr_medal.addChild(medalList);
      }
      
      public function showInfo() : void
      {
         GetUnionMedal.getMedalIcon(110,228,PlayerVO.medalLv,spr_medal);
         if(PlayerVO.medalLv < 34)
         {
            GetUnionMedal.getMedalIcon(840,228,PlayerVO.medalLv + 1,spr_medal);
         }
         var _loc1_:int = GetUnionMedal.GetMedalLvExp(PlayerVO.medalLv + 1) - GetUnionMedal.GetMedalLvExp(PlayerVO.medalLv);
         var _loc2_:int = PlayerVO.medalExp - GetUnionMedal.GetMedalLvExp(PlayerVO.medalLv);
         expTxt.text = _loc2_ + "/" + _loc1_;
         expSpr.clipRect = new Rectangle(0,0,expSpr.width * _loc2_ / _loc1_,expSpr.height);
      }
      
      public function getTitle(param1:String, param2:int = 0) : Sprite
      {
         var _loc3_:Sprite = new Sprite();
         _loc3_.addChild(swf.createImage("img_medalBg"));
         GetCommon.getText(15,20,150,30,param1,"img_medalFont",20,16777215,_loc3_,false,true,true);
         _loc3_.x = 5;
         _loc3_.y = param2;
         return _loc3_;
      }
      
      public function getBTn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
   }
}
