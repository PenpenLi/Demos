package com.mvc.views.uis.mainCity.Ranklist
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import starling.display.Image;
   import starling.textures.Texture;
   import starling.text.TextField;
   import starling.events.TouchEvent;
   import com.mvc.views.mediator.mainCity.Ranklist.RanklistMedia;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class MenuButtonUnit extends Sprite
   {
       
      private var swf:Swf;
      
      public var btnTexture:Image;
      
      public var isDown:Boolean;
      
      public var upTexture:Texture;
      
      public var downTexture:Texture;
      
      public var btnName:TextField;
      
      public var id:uint;
      
      public var btnListVec:Vector.<com.mvc.views.uis.mainCity.Ranklist.MenuListUnit>;
      
      public function MenuButtonUnit(param1:String, param2:Texture, param3:Texture)
      {
         btnListVec = new Vector.<com.mvc.views.uis.mainCity.Ranklist.MenuListUnit>([]);
         super();
         upTexture = param2;
         downTexture = param3;
         btnTexture = new Image(upTexture);
         addChild(btnTexture);
         addText(param1);
         this.addEventListener("touch",touch);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("ranklist");
      }
      
      public function addText(param1:String) : void
      {
         btnName = new TextField(btnTexture.width,btnTexture.height,param1,"FZCuYuan-M03S",23,16777215);
         btnName.touchable = false;
         addChild(btnName);
      }
      
      public function switchState(param1:Boolean) : void
      {
         isDown = !param1;
         if(isDown)
         {
            btnTexture.texture = downTexture;
            btnName.color = 9713664;
            open();
         }
         else
         {
            btnTexture.texture = upTexture;
            btnName.color = 16777215;
            close();
         }
      }
      
      private function touch(param1:TouchEvent) : void
      {
         if(RanklistMedia.isScrolling)
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(btnTexture);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            switchState(isDown);
            Facade.getInstance().sendNotification("CLICK_RANK_MENU",id);
         }
      }
      
      public function set myListBtn(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         btnListVec = Vector.<com.mvc.views.uis.mainCity.Ranklist.MenuListUnit>([]);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = new com.mvc.views.uis.mainCity.Ranklist.MenuListUnit(param1[_loc3_],swf.createImage("img_listUp").texture,swf.createImage("img_listDown").texture);
            _loc2_.id = _loc3_;
            _loc2_.parentId = id;
            _loc2_.x = 4;
            btnListVec.push(_loc2_);
            _loc3_++;
         }
      }
      
      private function close() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < btnListVec.length)
         {
            btnListVec[_loc1_].removeFromParent();
            Facade.getInstance().sendNotification("UPDATE_MENU_POSITION",id);
            _loc1_++;
         }
      }
      
      private function open() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < btnListVec.length)
         {
            btnListVec[_loc1_].y = this.height + 10;
            addChild(btnListVec[_loc1_]);
            Facade.getInstance().sendNotification("UPDATE_MENU_POSITION",id);
            _loc1_++;
         }
      }
      
      public function change() : void
      {
         if(!isDown)
         {
            return;
         }
         switchState(isDown);
      }
   }
}
