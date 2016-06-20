package com.common.util.loading
{
   import starling.display.Quad;
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfMovieClip;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class PVPLoading
   {
      
      private static var bg:Quad;
      
      private static var root:Sprite;
      
      private static var container:Sprite;
      
      private static var swf:Swf;
      
      private static var loading:SwfSprite;
      
      private static var mc_loading:SwfMovieClip;
      
      private static var mc_dian:SwfMovieClip;
      
      private static var isSpecialAdd:Boolean;
      
      private static var _isPvpLoading:Boolean;
       
      public function PVPLoading()
      {
         super();
      }
      
      public static function init() : void
      {
         root = Config.starling.root as Sprite;
         container = new Sprite();
         bg = new Quad(1136,640,0);
         bg.alpha = 0.5;
         container.addChild(bg);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         loading = swf.createSprite("spr_pvpLoading");
         loading.x = (1136 - loading.width) / 2;
         loading.y = (640 - loading.height) / 2 - 20;
         container.addChild(loading);
         mc_loading = loading.getMovie("mcBall");
         mc_loading.stop();
         mc_dian = loading.getMovie("mcDian");
         mc_dian.stop();
         container.name = "PVPLoading";
      }
      
      public static function addLoading(param1:Boolean = true, param2:Boolean = false) : void
      {
         if(!param1)
         {
            return;
         }
         isSpecialAdd = param2;
         if(root == null)
         {
            init();
         }
         if(container.parent == null)
         {
            root.addChild(container);
            mc_loading.play();
            mc_dian.play();
         }
         container.visible = true;
         _isPvpLoading = true;
      }
      
      public static function removeLoading(param1:Boolean = false) : void
      {
         _isPvpLoading = false;
         if(container == null)
         {
            return;
         }
         if(!param1 && isSpecialAdd)
         {
            return;
         }
         isSpecialAdd = false;
         container.removeFromParent();
         mc_loading.stop();
         mc_dian.stop();
      }
      
      public static function get isPvpLoading() : Boolean
      {
         return _isPvpLoading;
      }
   }
}
