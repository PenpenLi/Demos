package com.mvc.views.uis.union.unionTrain
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Image;
   import com.mvc.models.vos.union.UnionMemberVO;
   import lzm.starling.swf.display.SwfImage;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.common.util.GetCommon;
   import com.mvc.models.proxy.union.UnionPro;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.union.unionTrain.OtherTrainMedia;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ListUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_list:SwfSprite;
      
      private var playerName:TextField;
      
      private var already:TextField;
      
      private var btn_speedUp:SwfButton;
      
      private var headImg:Image;
      
      private var _memberVo:UnionMemberVO;
      
      private var img_notSpeed:SwfImage;
      
      public function ListUnitUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionTrain");
         spr_list = swf.createSprite("spr_list");
         playerName = spr_list.getTextField("playerName");
         playerName.fontName = "1";
         addChild(spr_list);
      }
      
      public function set myMemberVo(param1:UnionMemberVO) : void
      {
         var _loc2_:* = null;
         _memberVo = param1;
         headImg = GetPlayerRelatedPicFactor.getHeadPic(_memberVo.headId,0.8);
         var _loc3_:* = 8;
         headImg.y = _loc3_;
         headImg.x = _loc3_;
         spr_list.addChild(headImg);
         if(param1.vipRank > 0)
         {
            _loc2_ = GetCommon.getVipIcon(param1.vipRank);
            _loc2_.x = headImg.x - 5;
            _loc2_.y = headImg.x - 5;
            spr_list.addChild(_loc2_);
         }
         playerName.text = "Lv." + _memberVo.userLv + "   " + _memberVo.userName;
         switch(_memberVo.trainStatus - 1)
         {
            case 0:
               already = new TextField(100,30,"已加速","FZCuYuan-M03S",25,2090570,true);
               already.x = 435;
               already.y = 30;
               spr_list.addChild(already);
               break;
            case 1:
               btn_speedUp = swf.createButton("btn_addSpeed");
               btn_speedUp.x = 435;
               btn_speedUp.y = 25;
               spr_list.addChild(btn_speedUp);
               btn_speedUp.addEventListener("triggered",speedUp);
               break;
            case 2:
               img_notSpeed = swf.createImage("img_notSpeed");
               img_notSpeed.x = 435;
               img_notSpeed.y = 25;
               spr_list.addChild(img_notSpeed);
               break;
         }
      }
      
      private function speedUp() : void
      {
         if(UnionPro.speedUpTimes <= 0)
         {
            return Tips.show("今日剩余加速次数已用完，明天再来吧");
         }
         OtherTrainMedia.userId = _memberVo.userId;
         (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3419(_memberVo.userId);
      }
   }
}
