package com.mvc.views.uis.mainCity.playerInfo.infoPanel
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.display.Button;
   import starling.text.TextField;
   import starling.display.Image;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.controls.ScrollContainer;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import feathers.layout.TiledRowsLayout;
   
   public class InfoPanelUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var personalInfoSpr:SwfSprite;
      
      public var changeTrainerBtn:SwfButton;
      
      public var changeHeadPicBtn:Button;
      
      public var cancelHeadBtn:SwfButton;
      
      public var changeNameBtn:Button;
      
      public var gameSettingBtn:Button;
      
      public var checkBadgeBtn:Button;
      
      public var personalCloseBtn:Button;
      
      public var nicknameTf:TextField;
      
      public var levelTf:TextField;
      
      public var nextEXPTf:TextField;
      
      public var vipLvTf:TextField;
      
      public var handbookTf:TextField;
      
      public var elfLvMaxTf:TextField;
      
      public var adventureTimeTf:TextField;
      
      public var manSign:Image;
      
      public var womanSign:Image;
      
      public var headPicImg:Image;
      
      public var checkBadgeCloseBtn:Button;
      
      public var checkBadgeSpr:SwfSprite;
      
      public var badgeQuad:Quad;
      
      public var btn_test:SwfButton;
      
      public var idContentTf:TextField;
      
      public function InfoPanelUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         personalInfoSpr = swf.createSprite("spr_Personal_information_s");
         personalInfoSpr.x = 1136 - personalInfoSpr.width >> 1;
         personalInfoSpr.y = 640 - personalInfoSpr.height >> 1;
         addChild(personalInfoSpr);
         changeHeadPicBtn = personalInfoSpr.getButton("changeHeadPicBtn");
         cancelHeadBtn = personalInfoSpr.getButton("cancelHeadBtn");
         changeTrainerBtn = personalInfoSpr.getButton("changeTrainerBtn");
         changeNameBtn = personalInfoSpr.getButton("changeNameBtn");
         gameSettingBtn = personalInfoSpr.getButton("gameSettingBtn");
         checkBadgeBtn = personalInfoSpr.getButton("checkBadgeBtn");
         personalCloseBtn = personalInfoSpr.getButton("personalCloseBtn");
         btn_test = personalInfoSpr.getButton("btn_test");
         btn_test.removeFromParent();
         nicknameTf = personalInfoSpr.getTextField("nicknameTf");
         nicknameTf.fontName = "1";
         nicknameTf.text = "";
         levelTf = personalInfoSpr.getTextField("levelTf");
         levelTf.text = "";
         nextEXPTf = personalInfoSpr.getTextField("nextEXPTf");
         nextEXPTf.text = "";
         vipLvTf = personalInfoSpr.getTextField("vipLvTf");
         vipLvTf.text = "";
         handbookTf = personalInfoSpr.getTextField("handbookTf");
         handbookTf.text = "";
         elfLvMaxTf = personalInfoSpr.getTextField("elfLvMaxTf");
         elfLvMaxTf.text = "";
         adventureTimeTf = personalInfoSpr.getTextField("adventureTimeTf");
         adventureTimeTf.text = "";
         var _loc3_:TextField = new TextField(32,30,"ID:","FZCuYuan-M03S",23,5715238);
         _loc3_.x = 183;
         _loc3_.y = 388;
         personalInfoSpr.addChild(_loc3_);
         idContentTf = new TextField(420,30,"","FZCuYuan-M03S",23,15762178);
         idContentTf.x = 214;
         idContentTf.y = 388;
         idContentTf.hAlign = "left";
         personalInfoSpr.addChild(idContentTf);
         manSign = _loc2_.createImage("img_man");
         manSign.x = 238;
         manSign.y = 130;
         personalInfoSpr.addChild(manSign);
         manSign.visible = false;
         womanSign = _loc2_.createImage("img_woman");
         womanSign.x = 238;
         womanSign.y = 130;
         personalInfoSpr.addChild(womanSign);
         womanSign.visible = false;
         headPicImg = personalInfoSpr.getChildByName("headPicImg") as Image;
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.3;
         addChildAt(_loc1_,0);
      }
      
      public function checkBadge() : void
      {
         var _loc7_:* = 0;
         var _loc2_:* = null;
         var _loc8_:* = false;
         var _loc13_:* = 0;
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         badgeQuad = new Quad(1136,640,0);
         badgeQuad.alpha = 0.5;
         checkBadgeSpr = swf.createSprite("spr_replace_badgePanel");
         checkBadgeSpr.x = 1136 - checkBadgeSpr.width >> 1;
         checkBadgeSpr.y = 640 - checkBadgeSpr.height >> 1;
         checkBadgeCloseBtn = checkBadgeSpr.getButton("headCloseBtn");
         var _loc6_:ScrollContainer = new ScrollContainer();
         checkBadgeSpr.addChild(_loc6_);
         _loc6_.x = 10;
         _loc6_.y = 68;
         _loc6_.height = 242;
         _loc6_.width = 500;
         var _loc11_:Array = [];
         _loc7_ = 0;
         while(_loc7_ < PlayerVO.badgeNum)
         {
            _loc11_.push(_loc7_ + 1);
            _loc7_++;
         }
         var _loc9_:* = 0;
         var _loc10_:uint = _loc11_.length;
         var _loc12_:uint = 8;
         var _loc1_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc12_)
         {
            _loc8_ = false;
            if(_loc9_ < _loc10_)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc10_)
               {
                  if(_loc3_ + 1 == _loc11_[_loc5_])
                  {
                     _loc9_++;
                     _loc8_ = true;
                     _loc13_ = _loc5_;
                  }
                  _loc5_++;
               }
            }
            if(_loc8_)
            {
               _loc2_ = GetPlayerRelatedPicFactor.getBadgePic(_loc11_[_loc13_],1,false) as Image;
               _loc6_.addChild(_loc2_);
            }
            _loc3_++;
         }
         var _loc4_:TextField = new TextField(300,50,"当前拥有徽章数：" + PlayerVO.badgeNum,"FZCuYuan-M03S",24,4401181);
         _loc4_.hAlign = "left";
         _loc4_.x = 10;
         _loc4_.y = 20;
         checkBadgeSpr.addChild(_loc4_);
         var _loc14_:TiledRowsLayout = new TiledRowsLayout();
         _loc14_.gap = 20;
         _loc6_.layout = _loc14_;
      }
   }
}
