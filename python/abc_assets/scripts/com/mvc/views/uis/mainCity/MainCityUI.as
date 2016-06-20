package com.mvc.views.uis.mainCity
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.MenuMedia;
   
   public class MainCityUI extends Sprite
   {
       
      public var swf:Swf;
      
      public var mainCtySpr:SwfSprite;
      
      public var advanceBtn:Button;
      
      public var scene:com.mvc.views.uis.mainCity.SceneUI;
      
      public var btn_note:SwfButton;
      
      public function MainCityUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("mainCity");
         initScene();
         initadvanceBtnBtn();
         addMenu();
      }
      
      private function initNote() : void
      {
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("assist");
         btn_note = _loc1_.createButton("btn_notetest");
         btn_note.x = 450;
         btn_note.y = 400;
         addChild(btn_note);
      }
      
      private function initadvanceBtnBtn() : void
      {
         advanceBtn = swf.createButton("btn_adventure_bb");
         advanceBtn.name = "advanceBtn";
         advanceBtn.x = 25;
         advanceBtn.y = 200;
         addChild(advanceBtn);
         advanceBtn.blendMode = "none";
      }
      
      public function addMenu() : void
      {
         if(!Facade.getInstance().hasMediator("MenuMedia"))
         {
            Facade.getInstance().registerMediator(new MenuMedia(new MenuUI()));
         }
         var _loc1_:MenuUI = (Facade.getInstance().retrieveMediator("MenuMedia") as MenuMedia).UI as MenuUI;
         addChild(_loc1_);
      }
      
      private function initScene() : void
      {
         scene = new com.mvc.views.uis.mainCity.SceneUI();
         addChild(scene);
      }
   }
}
