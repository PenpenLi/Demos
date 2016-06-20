package com.mvc.views.uis.union.unionStudy
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.Label;
   import feathers.controls.List;
   import com.common.util.GetCommon;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.layout.HorizontalLayout;
   import com.mvc.views.mediator.union.unionStudy.StudyChildMedia;
   import lzm.starling.swf.display.SwfImage;
   import com.common.util.xmlVOHandler.GetUnionInfo;
   import starling.display.Image;
   import starling.display.Quad;
   
   public class StudyChildUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_child:SwfSprite;
      
      public var mainTitle:TextField;
      
      public var btn_close:SwfButton;
      
      private var pageTitle:Array;
      
      private var pageIcon:Array;
      
      private var label0:Label;
      
      private var label1:Label;
      
      public var donateList:List;
      
      public function StudyChildUI()
      {
         pageTitle = ["大厅","训练所","战斗基地"];
         pageIcon = ["img_hall","img_research","img_match"];
         super();
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionWorld");
         var _loc3_:Image = _loc2_.createImage("img_bg0");
         addChild(_loc3_);
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
         addLabel();
         setInfo();
      }
      
      private function addLabel() : void
      {
         label0 = GetCommon.getLabel(spr_child,85,363);
         label1 = GetCommon.getLabel(spr_child,85,460);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionStudy");
         spr_child = swf.createSprite("spr_child");
         mainTitle = spr_child.getTextField("mainTitle");
         btn_close = spr_child.getButton("btn_close");
         spr_child.x = 1136 - spr_child.width >> 1;
         spr_child.y = 640 - spr_child.height >> 1;
         addChild(spr_child);
      }
      
      private function addList() : void
      {
         donateList = new List();
         donateList.width = 620;
         donateList.height = 454;
         donateList.x = 365;
         donateList.y = 130;
         donateList.isSelectable = false;
         donateList.horizontalScrollPolicy = "on";
         donateList.verticalScrollPolicy = "off";
         donateList.itemRendererProperties.stateToSkinFunction = null;
         spr_child.addChild(donateList);
         donateList.addEventListener("creationComplete",changeHorizontalLayout);
      }
      
      private function changeHorizontalLayout() : void
      {
         donateList.removeEventListener("creationComplete",changeHorizontalLayout);
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.horizontalAlign = "justify";
         donateList.layout = _loc1_;
      }
      
      public function setInfo() : void
      {
         var _loc1_:SwfImage = swf.createImage(pageIcon[StudyChildMedia.typePage - 1]);
         _loc1_.pivotX = _loc1_.width / 2;
         _loc1_.pivotY = _loc1_.height;
         _loc1_.x = 200;
         _loc1_.y = 300;
         spr_child.addChildAt(_loc1_,spr_child.numChildren - 5);
         mainTitle.text = pageTitle[StudyChildMedia.typePage - 1];
         label0.text = "<font size=\'20\'>" + GetUnionInfo.studyDecArr[StudyChildMedia.typePage - 1][0] + "</font>";
         label1.text = "<font color=\'#33abfb\' size=\'20\'>" + GetUnionInfo.studyDecArr[StudyChildMedia.typePage - 1][1] + "</font>";
      }
   }
}
