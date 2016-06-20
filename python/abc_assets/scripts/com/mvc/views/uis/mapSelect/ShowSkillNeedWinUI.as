package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.Swf;
   import starling.text.TextField;
   import feathers.controls.ScrollContainer;
   import lzm.starling.display.Button;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.views.mediator.mainCity.task.TaskMedia;
   import com.mvc.views.uis.mainCity.myElf.EvoStoneGuideUI;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.mvc.views.mediator.mapSelect.WorldMapMedia;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.common.util.Finger;
   import feathers.layout.HorizontalLayout;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.managers.ELFMinImageManager;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import starling.display.Image;
   
   public class ShowSkillNeedWinUI extends Sprite
   {
       
      private var mySpr:SwfSprite;
      
      private var swf:Swf;
      
      private var tips1TF:TextField;
      
      private var tips2TF:TextField;
      
      private var tips3TF:TextField;
      
      private var skillNameTF:TextField;
      
      private var pointTF:TextField;
      
      private var panel:ScrollContainer;
      
      private var sureBtn:lzm.starling.display.Button;
      
      private var gotoCatchBtn:feathers.controls.Button;
      
      private var gotoShopBtn:feathers.controls.Button;
      
      private var nodeId:int;
      
      public function ShowSkillNeedWinUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("cityMap");
         mySpr = swf.createSprite("spr_needSkillInfoWin");
         mySpr.x = (1136 - mySpr.width) / 2;
         mySpr.y = (640 - mySpr.height) / 2;
         addChild(mySpr);
         tips1TF = mySpr.getTextField("Tips1TF");
         tips2TF = mySpr.getTextField("Tips2TF");
         tips3TF = mySpr.getTextField("Tips3TF");
         skillNameTF = mySpr.getTextField("skillNameTF");
         pointTF = mySpr.getTextField("pointTF");
         sureBtn = mySpr.getButton("sureBtn");
         addContain();
         sureBtn.addEventListener("triggered",btn_triggeredHandler);
         gotoCatchBtn = new feathers.controls.Button();
         gotoCatchBtn.label = "前往捕捉";
         gotoCatchBtn.x = 40;
         gotoCatchBtn.y = 365;
         mySpr.addChild(gotoCatchBtn);
         gotoCatchBtn.addEventListener("triggered",btn_triggeredHandler);
         gotoShopBtn = new feathers.controls.Button();
         gotoShopBtn.label = "前往购买";
         gotoShopBtn.x = 372;
         gotoShopBtn.y = 365;
         mySpr.addChild(gotoShopBtn);
         gotoShopBtn.addEventListener("triggered",btn_triggeredHandler);
      }
      
      private function btn_triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(sureBtn !== _loc2_)
         {
            if(gotoCatchBtn !== _loc2_)
            {
               if(gotoShopBtn === _loc2_)
               {
                  LogUtil("需要技能节点弹窗，前往购买");
                  disposeSelf();
                  MyElfMedia.isJumpPage = false;
                  EvoStoneGuideUI.parentPage = "";
                  if(Finger.getInstance().parent)
                  {
                     Finger.getInstance().removeFromParent();
                  }
                  Facade.getInstance().sendNotification("switch_page","load_shop_page");
               }
            }
            else
            {
               LogUtil("需要技能节点弹窗，前往捕捉");
               disposeSelf();
               TaskMedia.nodeId = nodeId;
               EvoStoneGuideUI.cityID = GetMapFactor.countCityId(nodeId);
               WorldMapMedia.mapVO = GetMapFactor.getMapVoById(EvoStoneGuideUI.cityID);
               Config.cityScene = WorldMapMedia.mapVO.bgImg;
               (Facade.getInstance().retrieveProxy("MapPro") as MapPro).write1703(WorldMapMedia.mapVO);
            }
         }
         else
         {
            WinTweens.closeWin(mySpr,disposeSelf);
         }
      }
      
      private function disposeSelf() : void
      {
         this.removeFromParent(true);
      }
      
      private function addContain() : void
      {
         panel = new ScrollContainer();
         mySpr.addChild(panel);
         panel.width = 489;
         panel.height = 105;
         panel.y = 248;
         panel.x = 40;
         panel.verticalScrollPolicy = "none";
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         panel.layout = _loc1_;
         _loc1_.gap = 20;
      }
      
      public function showMessage(param1:int) : void
      {
         var _loc2_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc3_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_needSkillTips");
         var _loc8_:* = 0;
         var _loc7_:* = _loc3_.sta_needSkillTips;
         for each(var _loc4_ in _loc3_.sta_needSkillTips)
         {
            if(param1 == _loc4_.@id)
            {
               nodeId = _loc4_.@nodeId;
               tips1TF.text = _loc4_.@prompt;
               tips2TF.text = _loc4_.@prompt2;
               tips3TF.text = "(" + _loc4_.@prompt3 + ")";
               pointTF.text = _loc4_.@nodename;
               skillNameTF.fontName = "img_special";
               skillNameTF.color = 16777215;
               skillNameTF.text = _loc4_.@name;
               if(skillNameTF.textBounds.width == 0)
               {
                  skillNameTF.fontName = "FZCuYuan-M03S";
                  skillNameTF.color = tips1TF.color;
               }
               _loc2_ = _loc4_.@pokelist.split("|");
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  _loc6_ = ELFMinImageManager.getElfM(GetElfFactor.getElfVO(_loc2_[_loc5_]).imgName,0.9);
                  panel.addChild(_loc6_);
                  _loc5_++;
               }
               _loc2_ = null;
               break;
            }
         }
         WinTweens.openWin(mySpr);
         (Config.starling.root as Game).addChild(this);
      }
   }
}
