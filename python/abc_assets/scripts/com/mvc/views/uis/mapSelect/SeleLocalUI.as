package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfScale9Image;
   import feathers.controls.List;
   import starling.display.DisplayObject;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.GetCommon;
   import com.common.util.DisposeDisplay;
   import feathers.data.ListCollection;
   import starling.display.Quad;
   
   public class SeleLocalUI extends Sprite
   {
      
      public static var localNameArr:Array = [["关都地区","load_world_map_page"],["成都地区","LOAD_WORLD_MAPTWO_PAGE"]];
      
      public static var instance:com.mvc.views.uis.mapSelect.SeleLocalUI;
       
      private var swf:Swf;
      
      private var bg:SwfScale9Image;
      
      private var localList:List;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function SeleLocalUI()
      {
         displayVec = new Vector.<DisplayObject>([]);
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         _loc1_.addEventListener("touch",closeEvent);
         init();
         initList();
      }
      
      public static function getInstance() : com.mvc.views.uis.mapSelect.SeleLocalUI
      {
         return instance || new com.mvc.views.uis.mapSelect.SeleLocalUI();
      }
      
      private function closeEvent(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            remove();
         }
      }
      
      private function initList() : void
      {
         localList = new List();
         localList.x = bg.x + 28;
         localList.y = bg.y + 30;
         localList.width = bg.width - 56;
         localList.height = bg.height - 60;
         localList.isSelectable = false;
         localList.itemRendererProperties.stateToSkinFunction = null;
         addChild(localList);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         bg = swf.createS9Image("s9_bg");
         bg.width = 600;
         bg.height = 350;
         bg.x = 1136 - bg.width >> 1;
         bg.y = 640 - bg.height >> 1;
         addChild(bg);
         GetCommon.getText(bg.x,bg.y + 290,600,50,"点击空白处关闭窗口","FZCuYuan-M03S",20,9713664,this);
      }
      
      public function show(param1:int) : void
      {
         var _loc9_:* = 0;
         var _loc6_:* = null;
         var _loc10_:* = 0;
         var _loc4_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         if(localList.dataProvider)
         {
            localList.dataProvider.removeAll();
         }
         var _loc2_:Array = [];
         var _loc8_:int = localNameArr.length;
         var _loc3_:* = 2;
         var _loc5_:int = Math.floor(_loc8_ / 2);
         if(_loc8_ % 2 != 0)
         {
            _loc5_++;
         }
         _loc9_ = 0;
         while(_loc9_ < _loc5_)
         {
            _loc6_ = new Sprite();
            if(_loc9_ == _loc5_ - 1 && _loc8_ % 2 != 0)
            {
               _loc3_ = _loc8_ % 2;
            }
            _loc10_ = 0;
            while(_loc10_ < _loc3_)
            {
               _loc4_ = new LocalUnitUI();
               _loc4_.show(param1,2 * _loc9_ + _loc10_);
               _loc4_.x = 270 * _loc10_;
               _loc6_.addChild(_loc4_);
               displayVec.push(_loc6_);
               _loc10_++;
            }
            _loc2_.push({
               "icon":_loc6_,
               "label":""
            });
            _loc9_++;
         }
         var _loc7_:ListCollection = new ListCollection(_loc2_);
         localList.dataProvider = _loc7_;
         (Config.starling.root as Game).addChild(this);
      }
      
      public function remove() : void
      {
         if(instance)
         {
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            this.removeFromParent(true);
            instance = null;
         }
      }
   }
}
