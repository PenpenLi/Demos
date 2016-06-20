package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.components.feathers.FeathersButton;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class TabBarUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var btn_world:FeathersButton;
      
      public var btn_privateChat:FeathersButton;
      
      public var btn_roomChat:FeathersButton;
      
      public var btn_union:FeathersButton;
      
      public var btn_system:FeathersButton;
      
      private var btnVec:Vector.<FeathersButton>;
      
      private var _selectedIndex:int;
      
      public function TabBarUI()
      {
         btnVec = new Vector.<FeathersButton>([]);
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("chat");
         btn_world = addMenu("comp_feathers_button2","0",0);
         btn_privateChat = addMenu("comp_feathers_button1","1",110);
         btn_roomChat = addMenu("comp_feathers_button3","2",220);
         btn_union = addMenu("comp_feathers_button4","3",330);
         btn_system = addMenu("comp_feathers_button5","4",440);
      }
      
      private function addMenu(param1:String, param2:String, param3:int) : FeathersButton
      {
         var _loc4_:FeathersButton = new FeathersButton();
         _loc4_.iconOffsetY = 30;
         _loc4_.upSkin = swf.createImage("img_01");
         _loc4_.hoverSkin = swf.createImage("img_01");
         _loc4_.disabledSkin = swf.createImage("img_00");
         _loc4_.downSkin = swf.createImage("img_00");
         _loc4_.upIcon = swf.createImage("img_" + (param2 + 1) + "1");
         _loc4_.hoverIcon = swf.createImage("img_" + (param2 + 1) + "1");
         _loc4_.disabledIcon = swf.createImage("img_" + (param2 + 1) + "0");
         _loc4_.downIcon = swf.createImage("img_" + (param2 + 1) + "0");
         _loc4_.name = param2;
         _loc4_.x = param3;
         addChild(_loc4_);
         btnVec.push(_loc4_);
         return _loc4_;
      }
      
      private function openCartoon(param1:int) : void
      {
         var _loc3_:* = 0;
         LogUtil("弹出动画" + param1);
         var _loc2_:Tween = new Tween(btnVec[param1],0.1,"linear");
         Starling.juggler.add(_loc2_);
         _loc2_.animate("y",20);
         btnVec[param1].isEnabled = false;
         _loc3_ = 0;
         while(_loc3_ < btnVec.length)
         {
            LogUtil("btnVec[i].y=",btnVec[_loc3_].y,_loc3_,param1);
            if(_loc3_ != param1)
            {
               closeCartoon(btnVec[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      private function closeCartoon(param1:FeathersButton) : void
      {
         LogUtil("收回动画",param1.name);
         var _loc2_:Tween = new Tween(param1,0.1,"linear");
         Starling.juggler.add(_loc2_);
         _loc2_.animate("y",0);
         param1.isEnabled = true;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         _selectedIndex = param1;
         openCartoon(_selectedIndex);
      }
      
      public function get selectedIndex() : int
      {
         return _selectedIndex;
      }
   }
}
