package com.mvc.views.uis.mainCity.home
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.elf.ElfVO;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import flash.geom.Point;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mapSelect.ExtendElfUnitTips;
   import com.mvc.views.mediator.mainCity.elfSeries.SelectFormationMedia;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   import com.mvc.views.mediator.mainCity.home.BagElfMedia;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.mvc.views.mediator.mainCity.home.ComElfMedia;
   import com.common.managers.ELFMinImageManager;
   import com.mvc.views.mediator.fighting.StatusFactor;
   import com.common.events.EventCenter;
   import starling.events.Event;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ElfBgUnitUI extends Sprite
   {
      
      public static var isScrolling:Boolean;
       
      private var swf:Swf;
      
      public var img:Image;
      
      public var tick:SwfImage;
      
      public var _elfVO:ElfVO;
      
      public var identify:String;
      
      public var identify2:String;
      
      public var identify3:String;
      
      public var comIndex:int;
      
      private var man:SwfImage;
      
      private var woman:SwfImage;
      
      private var spr_pknull:SwfSprite;
      
      private var btn_lock:SwfButton;
      
      private var btn_lockIcon:SwfButton;
      
      private var Lvtxt:TextField;
      
      private var hpText:TextField;
      
      private var stateText:TextField;
      
      private var dieIcon:SwfImage;
      
      private var lvBg:SwfImage;
      
      private var hpBg:SwfImage;
      
      private var stateBg:SwfImage;
      
      private var point:Point;
      
      private var bg:Image;
      
      private var dieMask:Image;
      
      private var loading:Swf;
      
      private var _isPrompt:Boolean;
      
      private var _isNickName:Boolean;
      
      private var lockFreeImg:Image;
      
      public function ElfBgUnitUI(param1:Boolean = false, param2:Boolean = true, param3:Boolean = false)
      {
         super();
         _isPrompt = param1;
         _isNickName = param3;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         loading = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         btn_lock = swf.createButton("btn_lock");
         btn_lockIcon = swf.createButton("btn_lockIcon");
         btn_lockIcon.x = 5;
         btn_lockIcon.y = 5;
         man = loading.createImage("img_man");
         woman = loading.createImage("img_woman");
         spr_pknull = swf.createSprite("spr_pknull");
         tick = swf.createImage("img_tick");
         tick.x = 60;
         tick.y = 70;
         tick.visible = false;
         tick.touchable = false;
         man.y = 75;
         man.x = 75;
         woman.y = 70;
         woman.x = 80;
         man.touchable = false;
         woman.touchable = false;
         addQuickChild(spr_pknull);
         spr_pknull.visible = false;
         spr_pknull.touchable = false;
         if(param2)
         {
            initEvent();
         }
      }
      
      public function getLoadPoint() : Point
      {
         point = this.parent.localToGlobal(new Point(this.x,this.y));
         if(point.y == 0)
         {
            point.y = 640;
         }
         else if(point.y < 0)
         {
            point.y = 152;
            point.x = 1200;
         }
         return point;
      }
      
      public function initEvent() : void
      {
         addEventListener("touch",ontouch);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         if(!_elfVO)
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(img);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               if(_isPrompt)
               {
                  if(_elfVO)
                  {
                     ExtendElfUnitTips.getInstance().showElfTips(_elfVO,this);
                  }
               }
            }
            if(_loc2_.phase == "ended")
            {
               if(_isPrompt)
               {
                  if(_elfVO)
                  {
                     ExtendElfUnitTips.getInstance().removeElfTips();
                  }
                  return;
               }
               if(identify != "神秘商店")
               {
                  getLoadPoint();
               }
               if(SelectFormationMedia.isPlay)
               {
                  return;
               }
               if(identify == "防守队伍")
               {
                  Facade.getInstance().sendNotification("SUB_FORMATION",_elfVO);
                  return;
               }
               if(identify == "出战队伍" || identify == "奇迹交换")
               {
                  return;
               }
               if(isScrolling)
               {
                  return;
               }
               if(!tick.visible)
               {
                  if(identify == "防守" && GetElfFactor.seriesElfNum(SelectFormationMedia.targetFormationElfVec) >= 6)
                  {
                     Tips.show("防守阵容已满");
                     return;
                  }
                  if(identify == "出战" && GetElfFactor.seriesElfNum(PlayerVO.bagElfVec) >= 6)
                  {
                     Tips.show("出战阵容已满");
                     return;
                  }
                  if(identify == "防守")
                  {
                     Facade.getInstance().sendNotification("CANCLE_FORMATION_FLATTEN",comIndex);
                     addMask();
                     if(_elfVO.isDetail)
                     {
                        Facade.getInstance().sendNotification("ADD_FORMATION",_elfVO);
                     }
                     else
                     {
                        (Facade.getInstance().retrieveProxy("HomePro") as HomePro).write2015(_elfVO,"防守",comIndex);
                     }
                  }
                  if(identify == "出战")
                  {
                     Facade.getInstance().sendNotification("CANCLE_PLAYELF_FLATTEN",comIndex);
                     addMask();
                     if(_elfVO.isDetail)
                     {
                        Facade.getInstance().sendNotification("ADD_PLAYELF",_elfVO);
                     }
                     else
                     {
                        (Facade.getInstance().retrieveProxy("HomePro") as HomePro).write2015(_elfVO,"出战",comIndex);
                     }
                  }
                  if(identify == "背包")
                  {
                     §§dup(BagElfMedia).seleNum++;
                     Facade.getInstance().sendNotification("SEND_COM_ELF",_elfVO);
                     BeginnerGuide.playBeginnerGuide();
                  }
                  if(identify == "电脑")
                  {
                     §§dup(ComElfMedia).seleNum++;
                     Facade.getInstance().sendNotification("CANCLE_COM_FLATTEN",comIndex);
                     if(_elfVO.isDetail)
                     {
                        Facade.getInstance().sendNotification("SEND_COM_ELF",_elfVO);
                     }
                     else
                     {
                        (Facade.getInstance().retrieveProxy("HomePro") as HomePro).write2015(_elfVO,"电脑",comIndex);
                     }
                  }
                  tick.visible = true;
                  if(identify == "神秘商店")
                  {
                     Facade.getInstance().sendNotification("freeshop_touch_complete",this);
                  }
               }
               else
               {
                  if(identify == "防守" && GetElfFactor.seriesElfNum(SelectFormationMedia.targetFormationElfVec) <= 1)
                  {
                     Tips.show("至少留一只精灵作为防守");
                     return;
                  }
                  tick.visible = false;
                  if(identify == "背包")
                  {
                     §§dup(BagElfMedia).seleNum--;
                  }
                  if(identify == "电脑")
                  {
                     §§dup(ComElfMedia).seleNum--;
                  }
                  if(identify == "防守")
                  {
                     Facade.getInstance().sendNotification("CANCLE_FORMATION_FLATTEN",comIndex);
                     Facade.getInstance().sendNotification("SUB_FORMATION",_elfVO);
                  }
                  if(identify == "出战")
                  {
                     Facade.getInstance().sendNotification("CANCLE_PLAYELF_FLATTEN",comIndex);
                     Facade.getInstance().sendNotification("SUB_PLAYRLF",_elfVO);
                  }
                  if(identify == "神秘商店")
                  {
                     Facade.getInstance().sendNotification("freeshop_touch_complete",this);
                  }
               }
               if(BagElfMedia.seleNum > 0 && identify == "背包" && ComElfMedia.seleNum != 0)
               {
                  Facade.getInstance().sendNotification("CLEAN_COM_TICK");
               }
               if(ComElfMedia.seleNum > 0 && identify == "电脑" && BagElfMedia.seleNum != 0)
               {
                  Facade.getInstance().sendNotification("CLEAN_BAG_TICK");
               }
            }
         }
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         var _loc2_:* = null;
         hideImg();
         _elfVO = param1;
         img = ELFMinImageManager.getElfM(param1.imgName);
         addQuickChild(img);
         lvBg = getTextBg(7,85);
         if(_isNickName)
         {
            _loc2_ = new TextField(112,22,"","FZCuYuan-M03S",22,2706232);
            _loc2_.text = param1.nickName + " (" + param1.character + ")";
            _loc2_.autoScale = true;
            _loc2_.y = 114;
            addChild(_loc2_);
         }
         if(identify == "王者之路")
         {
            lvBg.scaleX = 1.2;
            lvBg.scaleX = 1.2;
            Lvtxt = getText(10,84,"Lv." + param1.lv,18);
            Lvtxt.autoScale = false;
         }
         else
         {
            lvBg.scaleX = 0.8;
            Lvtxt = getText(0,84,"Lv." + param1.lv,14);
         }
         if(param1.sex == 0)
         {
            addQuickChild(woman);
         }
         else if(param1.sex == 1)
         {
            addQuickChild(man);
         }
         tick.visible = false;
         addQuickChild(tick);
         if(btn_lockIcon)
         {
            removeQuickChild(btn_lockIcon);
         }
         if((identify == "背包" || identify == "电脑") && param1.isLock)
         {
            lockFreeImg = swf.createImage("img_lock3");
            lockFreeImg.x = 75;
            lockFreeImg.touchable = false;
            addQuickChild(lockFreeImg);
         }
         if(_elfVO.currentHp == 0)
         {
            dieMask = getSwfImage("img_bg4");
            dieIcon = getSwfImage("img_dieIcon",20,20);
            if(identify == "出战")
            {
               LogUtil("出战队伍出战队伍出战队伍出战队伍出战队伍出战队伍出战队伍");
               this.touchable = false;
            }
         }
         else
         {
            removeNoNull(dieMask,true);
            if(_elfVO.status.length != 0)
            {
               stateBg = getTextBg(8,8);
               if(identify == "王者之路")
               {
                  var _loc3_:* = 1.2;
                  stateBg.scaleY = _loc3_;
                  stateBg.scaleX = _loc3_;
               }
               upDateStatusShow();
            }
         }
         if(identify == "出战队伍" || identify == "出战" || identify == "胜利队伍")
         {
            if(identify2 == "王者之路" || identify2 == "挖矿")
            {
               if(_elfVO.currentHp != 0)
               {
                  hpBg = getTextBg(54,85);
                  hpBg.scaleX = 0.9;
                  hpText = getText(50,84,param1.currentHp + "/" + param1.totalHp,14);
                  hpText.color = 5635669;
                  if(param1.currentHp / param1.totalHp <= 0.5 && param1.currentHp / param1.totalHp > 0.1)
                  {
                     hpText.color = 16710765;
                  }
                  else if(param1.currentHp / param1.totalHp <= 0.1)
                  {
                     hpText.color = 16595257;
                  }
               }
            }
            else
            {
               removeNoNull(stateBg,true);
               removeNoNull(stateText,true);
            }
            if(identify3 == "不可点击")
            {
               removeQuickChild(tick);
            }
            else
            {
               removeQuickChild(tick);
               addQuickChild(tick);
            }
            removeNoNull(man,true);
            removeNoNull(woman,true);
            return;
         }
         if(identify == "防守队伍" || identify == "联盟" || identify == "防守" || identify == "排行榜" || identify == "pvp" || identify == "试炼" || identify == "奇迹交换")
         {
            removeNoNull(stateBg,true);
            removeNoNull(stateText);
            removeNoNull(dieIcon,true);
            removeNoNull(dieMask,true);
         }
         if(identify == "王者之路")
         {
            removeNoNull(man,true);
            removeNoNull(woman,true);
         }
         if(identify == "突破成功")
         {
            removeNoNull(dieIcon,true);
            removeNoNull(dieMask,true);
         }
      }
      
      public function upDateStatusShow() : void
      {
         if(identify == "王者之路")
         {
            stateText = getText(8,8,"",20);
         }
         else
         {
            stateText = getText(4,7,"",14);
         }
         if(_elfVO.status.length == 0)
         {
            stateText.text = "";
            return;
         }
         var _loc1_:String = StatusFactor.status[_elfVO.status[_elfVO.status.length - 1] - 1];
         if(stateText.text == _loc1_)
         {
            return;
         }
         stateText.text = _loc1_;
      }
      
      public function get myElfVO() : ElfVO
      {
         return _elfVO;
      }
      
      public function hideImg() : void
      {
         if(img != null)
         {
            tick.visible = false;
            Lvtxt.text = "";
         }
         removeNoNull(img,true);
         removeNoNull(Lvtxt);
         removeNoNull(tick,true);
         removeNoNull(lvBg,true);
         removeNoNull(stateBg,true);
         removeNoNull(stateText);
         removeNoNull(hpBg,true);
         removeNoNull(hpText);
         removeNoNull(man,true);
         removeNoNull(woman,true);
         removeNoNull(dieIcon,true);
         removeNoNull(dieMask,true);
         removeNoNull(lockFreeImg,true);
         removeMask();
      }
      
      public function addLockIcon() : void
      {
         if(btn_lockIcon.parent == null)
         {
            addQuickChild(btn_lockIcon);
            btn_lockIcon.name = btn_lockIcon.parent.name;
            btn_lockIcon.addEventListener("triggered",onLock);
         }
      }
      
      private function removeLock() : void
      {
         EventCenter.removeEventListener("UNLOCK_SUCCESS",removeLock);
         if(btn_lockIcon)
         {
            removeQuickChild(btn_lockIcon);
            btn_lockIcon.removeEventListener("triggered",onLock);
         }
      }
      
      private function onLock(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = (param1.currentTarget as SwfButton).name;
         if("bag3" !== _loc5_)
         {
            if("bag4" !== _loc5_)
            {
               if("bag5" === _loc5_)
               {
                  if(PlayerVO.pokeSpace < 5)
                  {
                     Tips.show("请先解锁上一个");
                     return;
                  }
                  _loc4_ = Alert.show("你确定要花费400颗钻石解锁精灵背包吗？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc4_.addEventListener("close",lockSureHandler);
               }
            }
            else
            {
               if(PlayerVO.pokeSpace < 4)
               {
                  Tips.show("请先解锁上一个");
                  return;
               }
               _loc2_ = Alert.show("你确定要花费300颗钻石解锁精灵背包吗？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc2_.addEventListener("close",lockSureHandler);
            }
         }
         else
         {
            _loc3_ = Alert.show("你确定要花费200颗钻石解锁精灵背包吗？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc3_.addEventListener("close",lockSureHandler);
         }
      }
      
      private function lockSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            EventCenter.addEventListener("UNLOCK_SUCCESS",removeLock);
            (Facade.getInstance().retrieveProxy("MyElfPro") as MyElfPro).write2013();
         }
      }
      
      public function addLock() : void
      {
         btn_lock.x = 8;
         btn_lock.y = 30;
         addChild(btn_lock);
         btn_lock.addEventListener("triggered",onlock);
      }
      
      private function onlock(param1:Event) : void
      {
         ComLockUI.getInstance().show();
      }
      
      public function switchContain(param1:Boolean) : void
      {
         spr_pknull.visible = !param1;
      }
      
      public function addMask() : void
      {
         if(!bg)
         {
            bg = swf.createImage("img_bg4");
            addQuickChild(bg);
            bg.touchable = false;
         }
      }
      
      public function removeMask() : void
      {
         if(bg)
         {
            bg.texture.dispose();
            bg.removeFromParent(true);
            bg = null;
         }
      }
      
      public function selected() : void
      {
         var _loc1_:Tween = new Tween(this,0.3,"easeOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("scaleX",1.1);
         _loc1_.animate("scaleY",1.1);
         _loc1_.animate("alpha",0.5);
      }
      
      public function cancelSelected() : void
      {
         var _loc1_:Tween = new Tween(this,0.3,"easeOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("scaleX",1);
         _loc1_.animate("scaleY",1);
         _loc1_.animate("alpha",1);
      }
      
      private function getTextBg(param1:int, param2:int) : SwfImage
      {
         var _loc3_:SwfImage = swf.createImage("img_lvBg");
         _loc3_.x = param1;
         _loc3_.y = param2;
         _loc3_.touchable = false;
         addQuickChild(_loc3_);
         return _loc3_;
      }
      
      private function getText(param1:int, param2:int, param3:String, param4:int) : TextField
      {
         var _loc5_:TextField = new TextField(55,20,param3,"FZCuYuan-M03S",param4,16777215);
         _loc5_.x = param1;
         _loc5_.y = param2;
         _loc5_.touchable = false;
         _loc5_.autoScale = true;
         addQuickChild(_loc5_);
         return _loc5_;
      }
      
      private function addBitmap(param1:int, param2:int, param3:String, param4:int) : void
      {
         var _loc5_:TextField = new TextField(60,30,param3,"img_breakTxt",param4,16777215);
         _loc5_.x = param1;
         _loc5_.y = param2;
         _loc5_.hAlign = "right";
         _loc5_.touchable = false;
         addQuickChild(_loc5_);
      }
      
      private function getSwfImage(param1:String, param2:int = 0, param3:int = 0) : SwfImage
      {
         var _loc4_:SwfImage = swf.createImage(param1);
         _loc4_.touchable = false;
         _loc4_.x = param2;
         _loc4_.y = param3;
         addQuickChild(_loc4_);
         return _loc4_;
      }
      
      private function removeNoNull(param1:DisplayObject, param2:Boolean = false) : void
      {
         if(param1)
         {
            param1.removeFromParent(true);
            var param1:DisplayObject = null;
         }
      }
      
      public function subPlayTem() : void
      {
         Facade.getInstance().sendNotification("SUB_PLAYRLF",_elfVO);
      }
      
      public function addQuestionTf(param1:String, param2:int, param3:int = 0, param4:int = 0) : void
      {
         var _loc5_:TextField = new TextField(100,100,param1,"FZCuYuan-M03S",param2,16777215);
         _loc5_.x = param3;
         _loc5_.y = param4;
         _loc5_.touchable = false;
         addQuickChild(_loc5_);
      }
      
      public function switchLock() : void
      {
         if(_elfVO.isLock)
         {
            lockFreeImg = swf.createImage("img_lock3");
            lockFreeImg.x = 75;
            lockFreeImg.touchable = false;
            addQuickChild(lockFreeImg);
         }
         else
         {
            removeNoNull(lockFreeImg,true);
         }
      }
   }
}
