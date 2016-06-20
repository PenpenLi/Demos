package com.common.util
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.Event;
   import lzm.util.LSOManager;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import starling.display.Quad;
   
   public class ShowForceTip extends Sprite
   {
      
      public static var instance:com.common.util.ShowForceTip;
       
      private var swf:Swf;
      
      private var bg:SwfScale9Image;
      
      private var title:TextField;
      
      private var prompt:TextField;
      
      private var ForceTime:int;
      
      private var btn_close:SwfButton;
      
      public function ShowForceTip()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      public static function getInstance() : com.common.util.ShowForceTip
      {
         return instance || new com.common.util.ShowForceTip();
      }
      
      private function remove() : void
      {
         this.removeFromParent(true);
         instance = null;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         bg = swf.createS9Image("s9_bg3");
         bg.width = 550;
         bg.height = 275;
         bg.x = 1136 - bg.width >> 1;
         bg.y = 640 - bg.height >> 1;
         addChild(bg);
         title = GetCommon.getText(bg.x + 23,bg.y + 30,500,40,"","FZCuYuan-M03S",25,1862404,this);
         prompt = GetCommon.getText(bg.x + 45,bg.y + 55,480,150,"","FZCuYuan-M03S",22,9713664,this,false,true,true);
         prompt.hAlign = "left";
         btn_close = swf.createButton("btn_newOk_b");
         btn_close.x = 1136 - btn_close.width >> 1;
         btn_close.y = bg.y + 195;
         btn_close.visible = false;
         addChild(btn_close);
         btn_close.addEventListener("triggered",close);
      }
      
      private function close(param1:Event) : void
      {
         if(ForceTime == 0)
         {
            remove();
         }
      }
      
      public function show(param1:int, param2:String) : void
      {
         LSOManager.put("DAY",WorldTime.getInstance().day);
         ForceTime = param1;
         title.text = "距离关闭还剩" + param1 + "秒";
         prompt.text = param2;
         (Config.starling.root as Game).addChild(this);
         shwoBtn();
      }
      
      public function showCD() : void
      {
         if(ForceTime <= 0)
         {
            return;
         }
         ForceTime = ForceTime - 1;
         title.text = "距离关闭还剩" + ForceTime + "秒";
         shwoBtn();
      }
      
      private function shwoBtn() : void
      {
         if(ForceTime == 0)
         {
            title.text = "点击确定按钮关闭";
            btn_close.visible = true;
         }
      }
   }
}
