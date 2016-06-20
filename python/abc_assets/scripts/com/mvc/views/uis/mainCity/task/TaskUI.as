package com.mvc.views.uis.mainCity.task
{
   import starling.display.Sprite;
   import feathers.controls.List;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import feathers.controls.TabBar;
   import lzm.starling.swf.display.SwfImage;
   import feathers.data.ListCollection;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class TaskUI extends Sprite
   {
       
      public var taskList:List;
      
      public var btn_close:SwfButton;
      
      public var swf:Swf;
      
      public var spr_taskBg:SwfSprite;
      
      public var tabs:TabBar;
      
      public var mainTaskNew:SwfImage;
      
      public var dateTaskNew:SwfImage;
      
      public function TaskUI()
      {
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("task");
         spr_taskBg = swf.createSprite("spr_taskBg");
         btn_close = spr_taskBg.getButton("btn_close");
         spr_taskBg.x = 1136 - spr_taskBg.width >> 1;
         spr_taskBg.y = 640 - spr_taskBg.height >> 1;
         addChild(spr_taskBg);
         initTaskList();
         addMainNew();
         addDateNew();
      }
      
      private function addMainNew() : void
      {
         mainTaskNew = swf.createImage("img_promptImg");
         mainTaskNew.x = 137;
         mainTaskNew.y = 97;
         mainTaskNew.touchable = false;
         mainTaskNew.visible = false;
         spr_taskBg.addChild(mainTaskNew);
      }
      
      private function addDateNew() : void
      {
         dateTaskNew = swf.createImage("img_promptImg");
         dateTaskNew.x = 289;
         dateTaskNew.y = 97;
         dateTaskNew.touchable = false;
         dateTaskNew.visible = false;
         spr_taskBg.addChild(dateTaskNew);
      }
      
      private function initTaskList() : void
      {
         tabs = new TabBar();
         tabs.dataProvider = new ListCollection([{"label":"成就"},{"label":"每日任务"}]);
         tabs.x = 17;
         tabs.y = 90;
         taskList = new List();
         taskList.width = 845;
         taskList.height = 360;
         taskList.x = 17;
         taskList.y = 165;
         taskList.isSelectable = false;
         spr_taskBg.addChild(tabs);
         spr_taskBg.addChild(taskList);
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
      
      public function getImage(param1:String) : SwfImage
      {
         return swf.createImage(param1);
      }
   }
}
