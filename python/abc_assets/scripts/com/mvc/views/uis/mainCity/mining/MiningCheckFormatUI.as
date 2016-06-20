package com.mvc.views.uis.mainCity.mining
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.display.Image;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.common.util.GetCommon;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class MiningCheckFormatUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_campInfo:SwfSprite;
      
      private var spr_defendPowerTf:SwfSprite;
      
      private var spr_attackPowerTf:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_loot:SwfButton;
      
      public var btn_selectCamp:SwfButton;
      
      private var tf_lv:TextField;
      
      private var tf_nickname:TextField;
      
      private var tf_areaNum:TextField;
      
      private var tf_areaName:TextField;
      
      private var tf_powerPay:TextField;
      
      public var tf_defendPower:TextField;
      
      public var tf_defendSpeed:TextField;
      
      private var tf_attackGet:TextField;
      
      private var campObj:Object;
      
      private var headPic:Image;
      
      private var vipSpr:Sprite;
      
      public function MiningCheckFormatUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.5;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("mining");
         spr_campInfo = swf.createSprite("spr_campInfo");
         spr_campInfo.x = 1136 - spr_campInfo.width >> 1;
         spr_campInfo.y = 640 - spr_campInfo.height >> 1;
         addChild(spr_campInfo);
         spr_defendPowerTf = spr_campInfo.getSprite("spr_defendPowerTf");
         spr_attackPowerTf = spr_campInfo.getSprite("spr_attackPowerTf");
         btn_close = spr_campInfo.getButton("btn_close");
         btn_loot = spr_campInfo.getButton("btn_loot");
         btn_selectCamp = spr_campInfo.getButton("btn_selectCamp");
         tf_lv = spr_campInfo.getTextField("tf_lv");
         tf_nickname = spr_campInfo.getTextField("tf_nickname");
         tf_areaNum = spr_campInfo.getTextField("tf_areaNum");
         tf_areaName = spr_campInfo.getTextField("tf_areaName");
         tf_powerPay = spr_campInfo.getTextField("tf_powerPay");
         tf_defendPower = spr_campInfo.getTextField("tf_totalFightPower");
         tf_defendSpeed = spr_defendPowerTf.getTextField("tf_getNum");
         tf_attackGet = spr_attackPowerTf.getTextField("tf_getNum");
      }
      
      public function updateCheckFormat(param1:Object) : void
      {
         campObj = param1;
         tf_nickname.text = param1.userInfo.userName;
         tf_lv.text = "Lv:" + param1.userInfo.lv;
         tf_defendPower.text = param1.battle;
         if(param1.canGainRes)
         {
            switchShow(true);
            tf_attackGet.text = param1.canGainRes;
            tf_areaNum.text = param1.userInfo.controlId + "区:";
            tf_areaName.text = param1.userInfo.controlName;
         }
         else
         {
            switchShow(false);
            tf_defendSpeed.text = param1.perRes;
         }
         showHeadPic();
      }
      
      private function showHeadPic() : void
      {
         if(headPic)
         {
            headPic.removeFromParent(true);
         }
         headPic = GetPlayerRelatedPicFactor.getHeadPic(campObj.userInfo.headPtId);
         headPic.x = 31;
         headPic.y = 56;
         spr_campInfo.addChild(headPic);
         if(vipSpr)
         {
            vipSpr.removeFromParent(true);
         }
         if(campObj.userInfo.vipRank > 0)
         {
            vipSpr = GetCommon.getVipIcon(campObj.userInfo.vipRank);
            vipSpr.x = headPic.x - 5;
            vipSpr.y = headPic.y - 5;
            spr_campInfo.addChild(vipSpr);
         }
      }
      
      private function switchShow(param1:Boolean) : void
      {
         btn_selectCamp.visible = !param1;
         spr_defendPowerTf.visible = !param1;
         tf_areaNum.visible = param1;
         tf_areaName.visible = param1;
         tf_powerPay.visible = param1;
         btn_loot.visible = param1;
         spr_attackPowerTf.visible = param1;
         if(campObj.userInfo.userId != PlayerVO.userId)
         {
            btn_selectCamp.visible = false;
         }
      }
   }
}
