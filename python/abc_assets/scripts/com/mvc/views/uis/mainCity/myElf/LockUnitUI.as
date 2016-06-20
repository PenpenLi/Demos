package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.events.Event;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class LockUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_unlock:SwfSprite;
      
      public var btn_lock200:SwfButton;
      
      public var btn_lock300:SwfButton;
      
      public var btn_lock400:SwfButton;
      
      public var lockTxt:TextField;
      
      public function LockUnitUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_unlock = swf.createSprite("spr_unlock");
         btn_lock200 = spr_unlock.getButton("btn_lock200");
         btn_lock300 = spr_unlock.getButton("btn_lock300");
         btn_lock400 = spr_unlock.getButton("btn_lock400");
         lockTxt = spr_unlock.getTextField("lockTxt");
         var _loc1_:* = false;
         btn_lock400.visible = _loc1_;
         _loc1_ = _loc1_;
         btn_lock300.visible = _loc1_;
         btn_lock200.visible = _loc1_;
         addChild(spr_unlock);
         addEventListener("triggered",lockClick);
      }
      
      private function lockClick(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = param1.target;
         if(btn_lock200 !== _loc5_)
         {
            if(btn_lock300 !== _loc5_)
            {
               if(btn_lock400 === _loc5_)
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
      
      private function removeLock() : void
      {
         EventCenter.removeEventListener("UNLOCK_SUCCESS",removeLock);
         LogUtil("成功解锁===========",PlayerVO.pokeSpace - 2);
         lockTxt.removeFromParent();
         this["btn_lock" + (PlayerVO.pokeSpace - 2) + "00"].removeFromParent();
         var _loc1_:TextField = new TextField(80,60,PlayerVO.pokeSpace,"FZCuYuan-M03S",50,16777215,true);
         _loc1_.x = this.width - _loc1_.width >> 1;
         _loc1_.y = 8;
         addChild(_loc1_);
      }
   }
}
