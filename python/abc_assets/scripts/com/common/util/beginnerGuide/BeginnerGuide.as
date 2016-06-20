package com.common.util.beginnerGuide
{
   import lzm.starling.swf.display.SwfMovieClip;
   import flash.geom.Point;
   import starling.display.Sprite;
   import flash.geom.Rectangle;
   import com.mvc.models.vos.beginnerGuide.BeginnerGuideVO;
   import lzm.starling.display.GridMask;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import com.mvc.views.uis.fighting.FightingUI;
   import com.mvc.views.uis.mainCity.elfSeries.ElfSeriesUI;
   import com.mvc.views.uis.mainCity.kingKwan.KingKwanUI;
   import starling.display.DisplayObject;
   import extend.SoundEvent;
   import com.mvc.GameFacade;
   import com.mvc.views.mediator.mainCity.MainCityMedia;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.display.DisplayObjectContainer;
   import com.mvc.views.uis.ShowBagElfUI;
   import com.mvc.views.mediator.fighting.FightingMedia;
   import com.mvc.views.uis.mainCity.MainCityUI;
   import starling.utils.deg2rad;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.mvc.views.mediator.mainCity.MenuMedia;
   import org.puremvc.as3.patterns.facade.Facade;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mainCity.chat.ChatBtnUI;
   import com.mvc.models.proxy.login.LoginPro;
   import lzm.util.LSOManager;
   
   public class BeginnerGuide
   {
      
      private static var arrow:SwfMovieClip;
      
      private static var arrowPoint:Point;
      
      private static var circle:SwfMovieClip;
      
      private static var root:Game;
      
      private static var container:Sprite;
      
      private static var rectangle:Rectangle;
      
      private static var targetRectangle:Rectangle;
      
      private static var beginnerVec:Vector.<BeginnerGuideVO>;
      
      public static var index:int = 0;
      
      private static var gridMask:GridMask;
      
      private static var bg:Quad;
      
      public static var mark:String;
       
      public function BeginnerGuide()
      {
         super();
      }
      
      private static function init() : void
      {
         root = Config.starling.root as Game;
         container = new Sprite();
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         arrow = _loc1_.createMovieClip("mc_finger");
         circle = _loc1_.createMovieClip("mc_circle");
         container.name = "container";
         container.addChild(circle);
         container.addChild(arrow);
         gridMask = new GridMask(0,0,false,16777215);
         rectangle = new Rectangle(0,0,1136,640);
         targetRectangle = new Rectangle(0,0,0,0);
         beginnerVec = new Vector.<BeginnerGuideVO>([]);
         arrow.touchable = false;
         circle.touchable = false;
         bg = new Quad(1136,640,3806992);
         bg.alpha = 0;
      }
      
      public static function playBeginnerGuide() : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc1_:* = false;
         if(!Config.isOpenBeginner)
         {
            if(Config.isCompleteBeginner)
            {
               if(root != null)
               {
                  dispose();
               }
               return;
            }
            Config.isOpenBeginner = true;
            if(root == null)
            {
               init();
               addInitGuideVec();
            }
            _loc2_ = 0;
            while(_loc2_ < beginnerVec.length)
            {
               if(beginnerVec[_loc2_].targetPgae == "playground")
               {
                  index = _loc2_;
                  break;
               }
               _loc2_++;
            }
         }
         if(root == null)
         {
            init();
            addInitGuideVec();
         }
         if(beginnerVec != null && beginnerVec.length == 0)
         {
            return;
         }
         container.visible = true;
         mark = beginnerVec[index].mark;
         if(root.page is FightingUI && beginnerVec[index].targetPgae != "FightingMedia")
         {
            removeFromParent();
            return;
         }
         if(root.page is ElfSeriesUI && beginnerVec[index].targetPgae != "elfSeries")
         {
            removeFromParent();
            return;
         }
         if(root.page is KingKwanUI && beginnerVec[index].targetPgae != "kingKwan")
         {
            removeFromParent();
            return;
         }
         if(beginnerVec[index].targetName == "" && beginnerVec[index].description == "")
         {
            nextIndex();
            removeFromParent();
            return;
         }
         if(beginnerVec[index].targetName != "")
         {
            root.addChild(container);
            LogUtil("目标名称" + beginnerVec[index].targetName);
            _loc3_ = findTagerBtn(root);
            LogUtil("最终目标" + _loc3_);
            setArrowPoint(_loc3_);
         }
         else if(beginnerVec[index].description != "")
         {
            removeFromParent();
            _loc1_ = true;
            if(beginnerVec[index].voice != "")
            {
               _loc1_ = false;
               SoundEvent.dispatchEvent("PLAY_DIALOGUE_AND_STOP_LAST",beginnerVec[index].voice);
            }
            BeginnerGuideDia.updateDialogue(beginnerVec[index].description,true,_loc1_);
            if(beginnerVec[index].targetPgae == "feedHouseOutSide")
            {
               (GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.horizontalScrollPosition = 1200;
            }
            else if(beginnerVec[index].targetPgae == "elfSeriesOutSide")
            {
               (GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.horizontalScrollPosition = 700;
            }
            else if(beginnerVec[index].targetPgae == "kingKwanOutSide")
            {
               (GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.horizontalScrollPosition = 950;
            }
            else if(beginnerVec[index].targetPgae == "pvp")
            {
               (GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.horizontalScrollPosition = 800;
            }
            else if(beginnerVec[index].targetPgae == "hunting")
            {
               (GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.horizontalScrollPosition = 200;
            }
            else if(beginnerVec[index].targetPgae == "unionOutSide")
            {
               (GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.horizontalScrollPosition = 1200;
            }
            else if(beginnerVec[index].targetPgae == "elfCenter")
            {
               (GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.horizontalScrollPosition = 650;
            }
         }
         nextIndex();
      }
      
      private static function setTouchTrue() : void
      {
         root.touchable = true;
         (GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.removeEventListener("creationComplete",setTouchTrue);
      }
      
      public static function dispose() : void
      {
         if(root != null)
         {
            circle.stop(true);
            arrow.stop(true);
            container.removeFromParent(true);
            root = null;
            beginnerVec = Vector.<BeginnerGuideVO>([]);
            beginnerVec = null;
            bg.dispose();
            gridMask = null;
            rectangle = null;
            BeginnerGuideDia.dispose();
            BeginnerGuideTips.dispose();
            index = 0;
         }
      }
      
      private static function nextIndex() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         index = index + 1;
         if(index == beginnerVec.length)
         {
            if(mark == "sta_BeginnersGuide2")
            {
               _loc1_ = [];
               _loc2_ = 1;
               while(_loc2_ < 44)
               {
                  _loc1_.push("guide_" + _loc2_);
                  _loc2_++;
               }
               LoadOtherAssetsManager.getInstance().removeAsset(_loc1_,true);
            }
            mark = "";
            index = 0;
            Config.isOpenBeginner = false;
            beginnerVec = Vector.<BeginnerGuideVO>([]);
         }
      }
      
      private static function findTagerBtn(param1:DisplayObjectContainer) : DisplayObject
      {
         var _loc2_:* = null;
         var _loc6_:* = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:int = param1.numChildren;
         LogUtil(param1 + "寻找");
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.getChildAt(_loc4_) as DisplayObjectContainer;
            if(_loc2_ != null)
            {
               _loc6_ = _loc2_.getChildByName(beginnerVec[index].targetName);
               if(_loc6_ != null)
               {
                  return _loc6_;
               }
            }
            _loc4_++;
         }
         if(_loc6_ == null)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc2_ = param1.getChildAt(_loc5_) as DisplayObjectContainer;
               if(_loc2_ != null)
               {
                  _loc6_ = findTagerBtn(_loc2_);
                  if(_loc6_ != null)
                  {
                     return _loc6_;
                  }
               }
               _loc5_++;
            }
            return null;
         }
         return _loc6_;
      }
      
      private static function setArrowPoint(param1:DisplayObject) : void
      {
         var _loc9_:* = false;
         if(param1.name == "nameTF2")
         {
            ShowBagElfUI.getInstance().removeFromParent();
         }
         if(param1.name == "backPackBtn")
         {
            ((GameFacade.getInstance().retrieveMediator("FightingMedia") as FightingMedia).UI as FightingUI).eleBtn.touchable = false;
         }
         if(param1.name == "eleCenterBtn" || param1.name == "homeBtn" || param1.name == "playgroundBtn" || param1.name == "btn_elfPVP" || param1.name == "btn_elfSeries" || param1.name == "btn_hunting" || param1.name == "btn_fourKing" || param1.name == "btn_union")
         {
            hideSomeBtn();
         }
         if(root.page is MainCityUI)
         {
            (GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.isEnabled = false;
         }
         if(param1.name == "playgroundBtn")
         {
            if((GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.horizontalScrollPosition == 650)
            {
               arrowPoint = param1.parent.localToGlobal(new Point(param1.x,param1.y));
            }
            else
            {
               (GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.horizontalScrollPosition = 650;
               arrowPoint = param1.parent.localToGlobal(new Point(param1.x - 650,param1.y));
            }
         }
         else
         {
            arrowPoint = param1.parent.localToGlobal(new Point(param1.x,param1.y));
         }
         arrowPoint.x = arrowPoint.x / Config.scaleX;
         arrowPoint.y = arrowPoint.y / Config.scaleY;
         targetRectangle.x = arrowPoint.x;
         targetRectangle.y = arrowPoint.y;
         targetRectangle.width = param1.width;
         targetRectangle.height = param1.height;
         if(param1.name == "advanceBtn" && beginnerVec[index].targetPgae == "mainCity")
         {
            targetRectangle.width = 122;
            targetRectangle.height = 122;
         }
         gridMask.show(container,rectangle,targetRectangle,false);
         LogUtil(arrowPoint.x + "箭头位置mmmmm" + arrowPoint.y);
         var _loc6_:* = 0.0;
         var _loc4_:* = 1.0;
         var _loc2_:* = 1.0;
         var _loc7_:* = 0.0;
         var _loc8_:* = 0.0;
         if(arrowPoint.x <= 1136 / 4)
         {
            _loc4_ = -1.0;
            _loc6_ = deg2rad(90);
            _loc7_ = arrowPoint.x + param1.width + 10;
            _loc8_ = arrowPoint.y + (param1.height >> 1);
            _loc9_ = true;
         }
         if(arrowPoint.x > 1136 - 1136 / 4)
         {
            _loc6_ = deg2rad(-90);
            _loc4_ = 1.0;
            _loc7_ = arrowPoint.x - 10;
            _loc8_ = arrowPoint.y + (param1.height >> 1);
            _loc9_ = true;
         }
         if(arrowPoint.y + param1.height <= 640 / 2)
         {
            _loc2_ = -1.0;
            _loc6_ = deg2rad(0);
            _loc7_ = arrowPoint.x + (param1.width >> 1);
            _loc8_ = arrowPoint.y + param1.height + 40;
            _loc9_ = true;
         }
         if(arrowPoint.y > 640 - 640 / 4)
         {
            _loc2_ = 1.0;
            _loc6_ = deg2rad(0);
            _loc7_ = arrowPoint.x + (param1.width >> 1);
            _loc8_ = arrowPoint.y - 40;
            _loc9_ = true;
         }
         if(!_loc9_)
         {
            _loc6_ = deg2rad(-90);
            _loc4_ = 1.0;
            _loc7_ = arrowPoint.x - 10;
            _loc8_ = arrowPoint.y + (param1.height >> 1);
         }
         if(param1.name == "btn_right")
         {
            _loc7_ = _loc7_ - 40;
         }
         LogUtil(arrow.x + ":箭头位置:" + arrow.y);
         LogUtil(_loc4_ + ":箭头方向:" + _loc2_);
         arrow.scaleX = _loc4_;
         arrow.scaleY = _loc2_;
         var _loc5_:Tween = new Tween(arrow,1,"easeOut");
         Starling.juggler.add(_loc5_);
         _loc5_.moveTo(_loc7_,_loc8_);
         _loc5_.animate("rotation",_loc6_);
         var _loc3_:String = beginnerVec[index].description;
         BeginnerGuideTips.showBeginnersGuide(_loc3_,arrow,container,_loc7_,_loc8_,_loc6_);
         if(param1.name != "elfBallContain" && beginnerVec[index].isIntroduction != "true")
         {
            circle.visible = true;
            circle.x = arrowPoint.x + (targetRectangle.width >> 1);
            circle.y = arrowPoint.y + (targetRectangle.height >> 1);
         }
         else
         {
            circle.visible = false;
         }
         if(beginnerVec[index].isIntroduction == "true")
         {
            if(GameFacade.getInstance().hasMediator("FightingMedia"))
            {
               ((GameFacade.getInstance().retrieveMediator("FightingMedia") as FightingMedia).UI as FightingUI).eleBtn.touchable = true;
            }
            root.page.touchable = false;
            container.addChildAt(bg,0);
            container.addEventListener("touch",nextGuideHandler);
         }
         if(beginnerVec[index].voice != "")
         {
            SoundEvent.dispatchEvent("PLAY_DIALOGUE_AND_STOP_LAST",beginnerVec[index].voice);
         }
      }
      
      private static function hideSomeBtn() : void
      {
         (GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.advanceBtn.visible = false;
         (GameFacade.getInstance().retrieveMediator("MenuMedia") as MenuMedia).menu.spr_menu_row.visible = false;
         (GameFacade.getInstance().retrieveMediator("MenuMedia") as MenuMedia).menu.leftIntermittentSpr.visible = false;
         Facade.getInstance().sendNotification("HIDE_ACTIVE_REWARD");
         Facade.getInstance().sendNotification("HIDE_INFOMATION_NEWS");
      }
      
      private static function nextGuideHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         _loc2_ = param1.getTouch(container);
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.phase == "began")
         {
            root.page.touchable = true;
            container.removeEventListeners("touch");
            bg.removeFromParent();
            BeginnerGuide.playBeginnerGuide();
         }
      }
      
      private static function addInitGuideVec() : void
      {
         var _loc2_:* = null;
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_BeginnersGuide;
         for each(var _loc3_ in _loc1_.sta_BeginnersGuide)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
         _loc1_ = null;
      }
      
      public static function addFeedHouseGuide() : void
      {
         var _loc2_:* = null;
      }
      
      public static function addElfSeries() : void
      {
         var _loc2_:* = null;
         if(root == null)
         {
            init();
         }
         beginnerVec = Vector.<BeginnerGuideVO>([]);
         index = 0;
         Config.isOpenBeginner = true;
         ChatBtnUI.getInstance().remove();
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_elfSeries;
         for each(var _loc3_ in _loc1_.sta_elfSeries)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
         _loc1_ = null;
      }
      
      public static function addKingKwan() : void
      {
         var _loc2_:* = null;
         if(root == null)
         {
            init();
         }
         beginnerVec = Vector.<BeginnerGuideVO>([]);
         index = 0;
         Config.isOpenBeginner = true;
         ChatBtnUI.getInstance().remove();
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_kingKwan;
         for each(var _loc3_ in _loc1_.sta_kingKwan)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
      }
      
      public static function playRestrainGudie() : void
      {
         var _loc2_:* = null;
         LogUtil("什么情况" + Config.isCompleteRestrain);
         if(Config.isCompleteRestrain)
         {
            return;
         }
         (Facade.getInstance().retrieveProxy("LoginPro") as LoginPro).write1161(Config.isCompleteBeginner,true,Config.isCompleteCatchElf);
         Config.isCompleteRestrain = true;
         if(root == null)
         {
            init();
         }
         Config.isOpenBeginner = true;
         beginnerVec = Vector.<BeginnerGuideVO>([]);
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_restrain;
         for each(var _loc3_ in _loc1_.sta_restrain)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
         index = 0;
         playBeginnerGuide();
      }
      
      public static function playEvolution() : void
      {
         var _loc2_:* = null;
         LogUtil("介绍进化什么情况" + LSOManager.get("isCompleteEvolution"));
         LSOManager.put("isCompleteEvolution",true);
         if(root == null)
         {
            init();
         }
         Config.isOpenBeginner = true;
         beginnerVec = Vector.<BeginnerGuideVO>([]);
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_elf;
         for each(var _loc3_ in _loc1_.sta_elf)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
         index = 0;
         playBeginnerGuide();
      }
      
      public static function playCatchGuideOrChangeElf() : void
      {
         LogUtil("什么情况介绍捕捉" + Config.isCompleteCatchElf);
         if(!Config.isCompleteCatchElf)
         {
            startCatchGuide();
            return;
         }
      }
      
      private static function startChangeElfGuide() : void
      {
         var _loc2_:* = null;
         if(root == null)
         {
            init();
         }
         LSOManager.put("isCompleteChange",true);
         Config.isOpenBeginner = true;
         beginnerVec = Vector.<BeginnerGuideVO>([]);
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_changeElf;
         for each(var _loc3_ in _loc1_.sta_changeElf)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
         index = 0;
         playBeginnerGuide();
      }
      
      private static function startCatchGuide() : void
      {
         var _loc2_:* = null;
         Config.isCompleteCatchElf = true;
         if(root == null)
         {
            init();
         }
         Config.isOpenBeginner = true;
         beginnerVec = Vector.<BeginnerGuideVO>([]);
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc6_:* = 0;
         var _loc5_:* = _loc1_.sta_catchElf;
         for each(var _loc3_ in _loc1_.sta_catchElf)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
         if(!Config.isCompleteBeginner)
         {
            LogUtil("捕捉引导时加入下一步引导");
            var _loc8_:* = 0;
            var _loc7_:* = _loc1_.sta_BeginnersGuide2;
            for each(var _loc4_ in _loc1_.sta_BeginnersGuide2)
            {
               _loc2_ = new BeginnerGuideVO();
               _loc2_.isIntroduction = _loc4_.@isIntroduction;
               _loc2_.targetName = _loc4_.@targetName;
               _loc2_.targetPgae = _loc4_.@targetPgae;
               _loc2_.description = _loc4_.@description;
               _loc2_.voice = _loc4_.@voice;
               _loc2_.mark = _loc4_.name();
               beginnerVec.push(_loc2_);
            }
            Config.isCompleteBeginner = true;
         }
         (Facade.getInstance().retrieveProxy("LoginPro") as LoginPro).write1161(Config.isCompleteBeginner,Config.isCompleteRestrain,true);
         index = 0;
         playBeginnerGuide();
      }
      
      public static function removeFromParent() : void
      {
         if(container != null && container.parent != null)
         {
            container.removeFromParent();
         }
      }
      
      public static function addTrain() : void
      {
         var _loc2_:* = null;
         if(root == null)
         {
            init();
         }
         beginnerVec = Vector.<BeginnerGuideVO>([]);
         index = 0;
         Config.isOpenBeginner = true;
         ChatBtnUI.getInstance().remove();
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_train;
         for each(var _loc3_ in _loc1_.sta_train)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
         _loc1_ = null;
      }
      
      public static function addTrial() : void
      {
         var _loc2_:* = null;
         if(root == null)
         {
            init();
         }
         beginnerVec = Vector.<BeginnerGuideVO>([]);
         index = 0;
         Config.isOpenBeginner = true;
         ChatBtnUI.getInstance().remove();
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_trial;
         for each(var _loc3_ in _loc1_.sta_trial)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
         _loc1_ = null;
      }
      
      public static function addPvp() : void
      {
         var _loc2_:* = null;
         if(root == null)
         {
            init();
         }
         beginnerVec = Vector.<BeginnerGuideVO>([]);
         index = 0;
         Config.isOpenBeginner = true;
         ChatBtnUI.getInstance().remove();
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_pvp;
         for each(var _loc3_ in _loc1_.sta_pvp)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
         _loc1_ = null;
      }
      
      public static function addMiracle() : void
      {
         var _loc2_:* = null;
         if(root == null)
         {
            init();
         }
         beginnerVec = Vector.<BeginnerGuideVO>([]);
         index = 0;
         Config.isOpenBeginner = true;
         ChatBtnUI.getInstance().remove();
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_miracle;
         for each(var _loc3_ in _loc1_.sta_miracle)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
         _loc1_ = null;
      }
      
      public static function addHunting() : void
      {
         var _loc2_:* = null;
         if(root == null)
         {
            init();
         }
         beginnerVec = Vector.<BeginnerGuideVO>([]);
         index = 0;
         Config.isOpenBeginner = true;
         ChatBtnUI.getInstance().remove();
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_hunting;
         for each(var _loc3_ in _loc1_.sta_hunting)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
         _loc1_ = null;
      }
      
      public static function addUnion() : void
      {
         var _loc2_:* = null;
         if(root == null)
         {
            init();
         }
         beginnerVec = Vector.<BeginnerGuideVO>([]);
         index = 0;
         Config.isOpenBeginner = true;
         ChatBtnUI.getInstance().remove();
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("beginnersGuide");
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_union;
         for each(var _loc3_ in _loc1_.sta_union)
         {
            _loc2_ = new BeginnerGuideVO();
            _loc2_.mark = _loc3_.name();
            _loc2_.voice = _loc3_.@voice;
            _loc2_.isIntroduction = _loc3_.@isIntroduction;
            _loc2_.targetName = _loc3_.@targetName;
            _loc2_.targetPgae = _loc3_.@targetPgae;
            _loc2_.description = _loc3_.@description;
            beginnerVec.push(_loc2_);
         }
         _loc1_ = null;
      }
   }
}
