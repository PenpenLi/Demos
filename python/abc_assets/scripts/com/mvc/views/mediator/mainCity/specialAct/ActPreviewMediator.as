package com.mvc.views.mediator.mainCity.specialAct
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.specialAct.actPreview.ActPreviewUI;
   import flash.net.URLLoader;
   import flash.display.Loader;
   import starling.display.Image;
   import flash.display.Bitmap;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.consts.ConfigConst;
   import flash.net.URLRequest;
   import com.common.themes.Tips;
   import flash.utils.ByteArray;
   import starling.textures.Texture;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.display.DisplayObject;
   import lzm.util.LSOManager;
   
   public class ActPreviewMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "ActPreviewMediator";
      
      public static var url:String;
      
      public static var gotoId:int;
       
      public var actPreviewUI:ActPreviewUI;
      
      private var url3:String = "http://image.game.uc.cn/2015/11/25/11461208.jpg";
      
      private var urlLoader:URLLoader;
      
      private var loader:Loader;
      
      private var image:Image;
      
      private var bitmap:Bitmap;
      
      public function ActPreviewMediator(param1:Object = null)
      {
         super("ActPreviewMediator",param1);
         actPreviewUI = param1 as ActPreviewUI;
         actPreviewUI.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:starling.events.Event) : void
      {
         var _loc2_:* = param1.target;
         if(actPreviewUI.btn_yes === _loc2_)
         {
            image.removeFromParent();
            WinTweens.closeWin(actPreviewUI.spr_actPreview,remove);
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         dispose();
         gotoSomeWhere();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if(ConfigConst.SHOW_ACTPREVIEW_IMAGE === _loc2_)
         {
            loadImg();
         }
      }
      
      private function loadImg() : void
      {
         urlLoader = new URLLoader();
         urlLoader.dataFormat = "binary";
         var _loc1_:URLRequest = new URLRequest(url);
         urlLoader.addEventListener("complete",loadComplete);
         urlLoader.addEventListener("ioError",load_IOError);
         urlLoader.load(_loc1_);
      }
      
      protected function load_IOError(param1:flash.events.Event) : void
      {
         LogUtil("活动图片加载失败");
         urlLoader.removeEventListener("complete",loadComplete);
         Tips.show("活动图片加载失败");
         actPreviewUI.btn_yes.visible = true;
      }
      
      protected function loadComplete(param1:flash.events.Event) : void
      {
         urlLoader.removeEventListener("complete",loadComplete);
         LogUtil("从服务器加载活动预览图完成=============");
         var _loc2_:ByteArray = urlLoader.data as ByteArray;
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener("complete",loadByteComplete);
         loader.loadBytes(_loc2_);
      }
      
      protected function loadByteComplete(param1:flash.events.Event) : void
      {
         loader.removeEventListener("complete",loadByteComplete);
         bitmap = param1.target.content as Bitmap;
         var _loc2_:Texture = Texture.fromBitmap(bitmap,false);
         image = new Image(_loc2_);
         image.x = 20;
         image.y = 68;
         image.width = 800;
         image.height = 400;
         actPreviewUI.spr_actPreview.addChild(image);
         actPreviewUI.btn_yes.visible = true;
      }
      
      private function gotoSomeWhere() : void
      {
         switch(gotoId - 1)
         {
            case 0:
               sendNotification("switch_win",null,"LOAD_ACTIVITY");
               break;
            case 1:
               sendNotification("switch_win",null,"load_dayrecharge");
               break;
            case 2:
               (facade.retrieveProxy("SpecialActivePro") as SpecialActPro).write1910();
               break;
            case 3:
               sendNotification("switch_win",null,"LOAD_PREFER_WIN");
               break;
            case 4:
               sendNotification("switch_page","LOAD_EXCHANGE_WIN");
               break;
            case 5:
               sendNotification("switch_win",null,"load_limit_specialelf");
               break;
            case 6:
               sendNotification("switch_page","LOAD_AMUSE_PAGE");
               break;
            case 7:
               if(PlayerVO.lv < 20)
               {
                  Tips.show("玩家等级达到20级后开放");
                  return;
               }
               sendNotification("switch_page","load_hunting_page");
               break;
            case 8:
               sendNotification("switch_win",null,"load_diamond_panel");
               break;
            case 9:
               sendNotification("switch_page","LOAD_LOTTERY");
               break;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.SHOW_ACTPREVIEW_IMAGE];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         LSOManager.put("ACT_PREVIEW_NOTTIP",actPreviewUI.spr_check.getChildAt(1).visible);
         image.texture.dispose();
         bitmap.bitmapData.dispose();
         bitmap = null;
         image.removeFromParent(true);
         facade.removeMediator("ActPreviewMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
