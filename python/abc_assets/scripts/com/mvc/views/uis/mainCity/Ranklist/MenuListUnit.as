package com.mvc.views.uis.mainCity.Ranklist
{
   import starling.display.Sprite;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.textures.Texture;
   import starling.events.TouchEvent;
   import com.mvc.views.mediator.mainCity.Ranklist.RanklistMedia;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class MenuListUnit extends Sprite
   {
       
      public var up:Image;
      
      public var down:Image;
      
      public var btnName:TextField;
      
      public var id:uint;
      
      public var parentId:uint;
      
      public function MenuListUnit(param1:String, param2:Texture, param3:Texture)
      {
         super();
         addBg(param2,param3);
         addText(param1);
         switchState(true);
         this.addEventListener("touch",touch);
      }
      
      public function addBg(param1:Texture, param2:Texture) : void
      {
         up = new Image(param1);
         down = new Image(param2);
         addChild(down);
         addChild(up);
      }
      
      public function addText(param1:String) : void
      {
         this.name = param1;
         btnName = new TextField(up.width,up.height,param1,"FZCuYuan-M03S",20,9119232,true);
         btnName.touchable = false;
         addChild(btnName);
      }
      
      public function switchState(param1:Boolean) : void
      {
         up.visible = param1;
         down.visible = !param1;
      }
      
      private function touch(param1:TouchEvent) : void
      {
         if(RanklistMedia.isScrolling)
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            switchState(false);
            Facade.getInstance().sendNotification("CLICK_RANK_MENU_LIST",{
               "id":id,
               "parentId":parentId,
               "name":this.name
            });
         }
      }
   }
}
