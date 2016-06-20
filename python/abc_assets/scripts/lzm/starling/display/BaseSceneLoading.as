package lzm.starling.display
{
   import starling.display.Sprite;
   import swallow.filters.MosaicFilter;
   import starling.core.Starling;
   
   public class BaseSceneLoading extends Sprite
   {
       
      protected var _replaceScene:lzm.starling.display.BaseScene;
      
      protected var _targetScene:lzm.starling.display.BaseScene;
      
      public function BaseSceneLoading()
      {
         super();
      }
      
      public function show(param1:Function) : void
      {
         callBack = param1;
         var filter:MosaicFilter = new MosaicFilter(0.1,0.1);
         _replaceScene.filter = filter;
         Starling.juggler.tween(filter,0.3,{
            "thresholdX":12,
            "thresholdY":12,
            "onComplete":function():void
            {
               _replaceScene.filter = null;
               filter.dispose();
            }
         });
      }
      
      public function hide(param1:Function) : void
      {
         callBack = param1;
         var filter:MosaicFilter = new MosaicFilter(12,12);
         _targetScene.filter = filter;
         Starling.juggler.tween(filter,0.3,{
            "thresholdX":0.1,
            "thresholdY":0.1,
            "onComplete":function():void
            {
               _targetScene.filter = null;
               filter.dispose();
            }
         });
      }
      
      function set replaceScene(param1:lzm.starling.display.BaseScene) : void
      {
         _replaceScene = param1;
      }
      
      function get replaceScene() : lzm.starling.display.BaseScene
      {
         return _replaceScene;
      }
      
      function set targetScene(param1:lzm.starling.display.BaseScene) : void
      {
         _targetScene = param1;
      }
      
      function get targetScene() : lzm.starling.display.BaseScene
      {
         return _targetScene;
      }
   }
}
