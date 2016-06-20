package com.common.util.loading
{
   import starling.display.Quad;
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfMovieClip;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.proxy.login.LoginPro;
   
   public class NETLoading
   {
      
      private static var bg:Quad;
      
      private static var root:Sprite;
      
      private static var container:Sprite;
      
      private static var swf:Swf;
      
      private static var loading:SwfSprite;
      
      private static var mc_loading:SwfMovieClip;
      
      private static var isLoadAssets:Boolean;
      
      public static var isNetLoading:Boolean;
       
      public function NETLoading()
      {
         super();
      }
      
      public static function init(param1:Sprite) : void
      {
         root = param1;
         container = new Sprite();
         bg = new Quad(1136,640,0);
         bg.alpha = 0;
         container.addChild(bg);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         loading = swf.createSprite("spr_loading");
         loading.x = (1136 - loading.width) / 2 + loading.width / 2;
         loading.y = (640 - loading.height) / 2 + 30;
         container.addChild(loading);
         mc_loading = loading.getChildAt(1) as SwfMovieClip;
         mc_loading.stop();
         container.name = "netLoading";
      }
      
      public static function addLoading(param1:Boolean = false) : void
      {
         if(LoginPro.logining)
         {
            return;
         }
         if(container.parent == null)
         {
            isLoadAssets = param1;
            root.addChild(container);
            mc_loading.play();
            container.visible = true;
            LogUtil("加载++++++++++++++++++++++++++++++",container.alpha,container.visible,container.parent);
            isNetLoading = true;
         }
      }
      
      public static function addLoading2() : void
      {
         if(isNetLoading)
         {
            if(container.parent == null)
            {
               addLoading();
            }
            else
            {
               removeLoading();
               addLoading();
            }
         }
      }
      
      public static function removeLoading(param1:Boolean = false) : void
      {
         if(container == null)
         {
            return;
         }
         if(isLoadAssets && !param1)
         {
            return;
         }
         if(isLoadAssets && param1)
         {
            isLoadAssets = false;
         }
         container.removeFromParent();
         mc_loading.stop();
         isNetLoading = false;
      }
   }
}
