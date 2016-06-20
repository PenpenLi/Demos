package com.mvc.views.uis.union.unionWorld
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.GetCommon;
   import com.common.util.xmlVOHandler.GetTaskFactro;
   
   public class UnionWorldUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_unionWorld:SwfSprite;
      
      public var btn_shop:SwfButton;
      
      public var btn_hall:SwfButton;
      
      public var btn_study:SwfButton;
      
      public var btn_train:SwfButton;
      
      public var btn_notice:SwfButton;
      
      public var btn_trainBtn:SwfButton;
      
      public var btn_taskBtn:SwfButton;
      
      public var btn_backPackBtn:SwfButton;
      
      public var btn_eleBtn:SwfButton;
      
      public var btn_close:SwfButton;
      
      public var btn_Medal:SwfButton;
      
      public var noticeTxt:TextField;
      
      public var taskNews:Image;
      
      private var medalSwf:Swf;
      
      public function UnionWorldUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionWorld");
         spr_unionWorld = swf.createSprite("spr_unionWorld");
         btn_close = spr_unionWorld.getButton("btn_close");
         btn_shop = spr_unionWorld.getButton("btn_shop");
         btn_hall = spr_unionWorld.getButton("btn_hall");
         btn_study = spr_unionWorld.getButton("btn_study");
         btn_train = spr_unionWorld.getButton("btn_train");
         btn_notice = spr_unionWorld.getButton("btn_notice");
         btn_trainBtn = spr_unionWorld.getButton("btn_trainBtn");
         btn_taskBtn = spr_unionWorld.getButton("btn_taskBtn");
         btn_backPackBtn = spr_unionWorld.getButton("btn_backPackBtn");
         btn_eleBtn = spr_unionWorld.getButton("btn_eleBtn");
         medalSwf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionMedal");
         btn_Medal = medalSwf.createButton("btn_medalBtn");
         btn_Medal.x = 520;
         btn_Medal.y = 420;
         spr_unionWorld.addChild(btn_Medal);
         addChild(spr_unionWorld);
         taskNews = GetCommon.getNews(btn_taskBtn,1,0,10,1);
         if(GetTaskFactro.isGetTask())
         {
            taskNews.visible = true;
         }
      }
   }
}
