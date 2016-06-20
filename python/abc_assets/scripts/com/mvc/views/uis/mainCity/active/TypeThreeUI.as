package com.mvc.views.uis.mainCity.active
{
   import starling.display.Sprite;
   import starling.text.TextField;
   import feathers.controls.List;
   import starling.display.DisplayObject;
   import com.mvc.models.vos.mainCity.active.ActiveVO;
   import feathers.data.ListCollection;
   import com.common.util.DisposeDisplay;
   
   public class TypeThreeUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.mainCity.active.TypeThreeUI;
       
      private var textDec:TextField;
      
      public var actList:List;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function TypeThreeUI()
      {
         displayVec = new Vector.<DisplayObject>([]);
         super();
         addText();
         addContain();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.active.TypeThreeUI
      {
         return instance || new com.mvc.views.uis.mainCity.active.TypeThreeUI();
      }
      
      private function addText() : void
      {
         textDec = new TextField(730,50,"","FZCuYuan-M03S",20,5715237);
         textDec.autoSize = "vertical";
         textDec.hAlign = "left";
         textDec.x = 5;
      }
      
      private function addContain() : void
      {
         actList = new List();
         actList.width = 745;
         actList.x = -5;
         actList.isSelectable = false;
         actList.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:* = 3;
         actList.itemRendererProperties.paddingBottom = _loc1_;
         actList.itemRendererProperties.paddingTop = _loc1_;
      }
      
      public function set myActive(param1:ActiveVO) : void
      {
         textDec.text = param1.atvDescs;
         addChild(textDec);
         actList.y = textDec.height + 10;
         actList.height = 440 - actList.y;
         addChild(actList);
      }
      
      public function set showThree(param1:ActiveVO) : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         myActive = param1;
         var _loc2_:Array = [];
         LogUtil("小活动数量= ",param1.activeChildVec.length);
         _loc5_ = 0;
         while(_loc5_ < param1.activeChildVec.length)
         {
            _loc3_ = new RewardThreeUnit();
            _loc3_.myActiveChild = param1.activeChildVec[_loc5_];
            _loc3_.activeVo = param1;
            _loc2_.push({
               "icon":_loc3_,
               "label":""
            });
            displayVec.push(_loc3_);
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc2_);
         actList.dataProvider = _loc4_;
      }
      
      public function set showFour(param1:ActiveVO) : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         myActive = param1;
         LogUtil("小活动数量=",param1.activeChildVec.length);
         var _loc2_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < param1.activeChildVec.length)
         {
            _loc3_ = new RewardFourUnit();
            _loc3_.myActiveChild = param1.activeChildVec[_loc5_];
            _loc3_.activeVo = param1;
            _loc2_.push({
               "icon":_loc3_,
               "label":""
            });
            displayVec.push(_loc3_);
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc2_);
         actList.dataProvider = _loc4_;
      }
      
      public function clean() : void
      {
         if(actList.dataProvider)
         {
            actList.dataProvider.removeAll();
            actList.dataProvider = null;
         }
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         instance = null;
      }
   }
}
