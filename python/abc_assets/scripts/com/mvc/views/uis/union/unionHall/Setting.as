package com.mvc.views.uis.union.unionHall
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.proxy.union.UnionPro;
   import com.common.util.WinTweens;
   import starling.events.Event;
   import com.common.themes.Tips;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import starling.display.Quad;
   
   public class Setting extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.union.unionHall.Setting;
       
      private var swf:Swf;
      
      private var spr_setting:SwfSprite;
      
      private var btn_sub:SwfButton;
      
      private var btn_add:SwfButton;
      
      private var limitLv:TextField;
      
      private var btn_return:SwfButton;
      
      private var btn_ok:SwfButton;
      
      public function Setting()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.union.unionHall.Setting
      {
         return instance || new com.mvc.views.uis.union.unionHall.Setting();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionHall");
         spr_setting = swf.createSprite("spr_setting");
         btn_sub = spr_setting.getButton("btn_sub");
         btn_add = spr_setting.getButton("btn_add");
         limitLv = spr_setting.getTextField("limitLv");
         btn_return = spr_setting.getButton("btn_return");
         btn_ok = spr_setting.getButton("btn_ok");
         limitLv.text = UnionPro.myUnionVO.needLv;
         spr_setting.x = 1136 - spr_setting.width >> 1;
         spr_setting.y = 640 - spr_setting.height >> 1;
         addChild(spr_setting);
         WinTweens.openWin(spr_setting);
         this.addEventListener("triggered",click);
      }
      
      private function click(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_sub !== _loc2_)
         {
            if(btn_add !== _loc2_)
            {
               if(btn_return !== _loc2_)
               {
                  if(btn_ok === _loc2_)
                  {
                     EventCenter.addEventListener("EDIT_NOTICE_LVLIMT_SUCCESS",editLv);
                     (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3417(limitLv.text);
                  }
               }
               else
               {
                  WinTweens.closeWin(spr_setting,remove);
               }
            }
            else
            {
               if(limitLv.text >= 80)
               {
                  return Tips.show("已经是玩家的最高等级");
               }
               limitLv.text = limitLv.text + 1;
            }
         }
         else
         {
            if(limitLv.text <= 1)
            {
               return Tips.show("已经是玩家的最低等级");
            }
            limitLv.text = limitLv.text - 1;
         }
      }
      
      private function editLv() : void
      {
         EventCenter.removeEventListener("EDIT_NOTICE_LVLIMT_SUCCESS",editLv);
         WinTweens.closeWin(spr_setting,remove);
      }
      
      public function remove() : void
      {
         if(getInstance().parent)
         {
            getInstance().removeFromParent(true);
         }
         instance = null;
      }
   }
}
