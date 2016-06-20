package com.common.managers
{
   import com.common.events.EventCenter;
   import starling.display.Image;
   import com.mvc.views.mediator.fighting.AniFactor;
   import starling.core.Starling;
   
   public class ElfFrontImageManager
   {
      
      private static var instance:com.common.managers.ElfFrontImageManager;
      
      public static var tempNoRemoveTexture:Array = [];
       
      private var ElfImageName:Array;
      
      private var ElfImageTexture:Array;
      
      private var mQueue:Array;
      
      public function ElfFrontImageManager()
      {
         ElfImageName = [];
         ElfImageTexture = [];
         mQueue = [];
         super();
      }
      
      public static function getInstance() : com.common.managers.ElfFrontImageManager
      {
         return instance || new com.common.managers.ElfFrontImageManager();
      }
      
      public function getImg(param1:Array, param2:Function) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = true;
         trace("要加载的纹理" + param1);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(LoadOtherAssetsManager.getInstance().assets.getTexture(param1[_loc3_]) == null)
            {
               _loc4_ = false;
            }
            else
            {
               LogUtil("碰火龙删啊" + param1[_loc3_]);
               param1.splice(_loc3_,1);
               _loc3_--;
            }
            _loc3_++;
         }
         trace(_loc4_ + "精灵正面纹理" + param1);
         if(_loc4_)
         {
            return;
            §§push(param2());
         }
         else if(mQueue.length > 0)
         {
            mQueue.push([param1,param2]);
            return;
            §§push(LogUtil("精灵正面有在一直添加吗" + mQueue));
         }
         else
         {
            mQueue.push([param1,param2]);
            loadElfFrontAssets(param1,param2);
            return;
         }
      }
      
      private function loadElfFrontAssets(param1:Array, param2:Function) : void
      {
         textureName = param1;
         _callBack = param2;
         var addElfComplete:Function = function():void
         {
            var _loc1_:* = 0;
            Config.starling.root.touchable = true;
            EventCenter.removeEventListener("load_other_asset_complete",addElfComplete);
            _loc1_ = 0;
            while(_loc1_ < ElfImageName.length)
            {
               if(ElfImageTexture.indexOf(LoadOtherAssetsManager.getInstance().assets.getTexture(ElfImageName[_loc1_])) == -1)
               {
                  ElfImageTexture.push(LoadOtherAssetsManager.getInstance().assets.getTexture(ElfImageName[_loc1_]));
               }
               _loc1_++;
            }
            _callBack();
            mQueue.shift();
            LogUtil(ElfImageTexture.indexOf(LoadOtherAssetsManager.getInstance().assets.getTexture("img_da4zui3fu2")) + "精灵正面队列长度" + mQueue.length);
            if(mQueue.length > 0)
            {
               loadElfFrontAssets(mQueue[0][0],mQueue[0][1]);
            }
         };
         Config.starling.root.touchable = false;
         EventCenter.addEventListener("load_other_asset_complete",addElfComplete);
         var isExist:Boolean = true;
         var i:int = 0;
         while(i < textureName.length)
         {
            if(LoadOtherAssetsManager.getInstance().assets.getTexture(textureName[i]) == null)
            {
               isExist = false;
            }
            if(ElfImageName.indexOf(textureName[i]) == -1)
            {
               ElfImageName.push(textureName[i]);
            }
            i = i + 1;
         }
         if(isExist)
         {
            return;
            §§push(addElfComplete());
         }
         else
         {
            LoadOtherAssetsManager.getInstance().addElfFrontAssets(textureName,true);
            return;
         }
      }
      
      public function autoZoom(param1:Image, param2:Number = 100, param3:Boolean = false, param4:int = 0) : void
      {
         var _loc5_:* = NaN;
         param1.pivotX = param1.width / 2;
         if(param3)
         {
            param1.pivotY = param1.height / 2;
            param1.y = param2 / 2;
            param1.x = param2 / 2;
         }
         else
         {
            param1.pivotY = param1.height;
         }
         if(param1.height > param1.width)
         {
            if(param1.height < param2)
            {
               return;
            }
            _loc5_ = (param2 - param4) / param1.height;
         }
         else
         {
            if(param1.width < param2)
            {
               return;
            }
            _loc5_ = (param2 - param4) / param1.width;
         }
         var _loc6_:* = _loc5_;
         param1.scaleY = _loc6_;
         param1.scaleX = _loc6_;
      }
      
      public function disposeImg(param1:Image) : void
      {
         var _loc2_:* = 0;
         if(param1 != null)
         {
            _loc2_ = ElfImageTexture.indexOf(param1.texture);
            LogUtil(ElfImageName + "精灵正面索引" + _loc2_);
            if(_loc2_ != -1)
            {
               if(tempNoRemoveTexture.indexOf(ElfImageName[_loc2_]) == -1)
               {
                  LoadOtherAssetsManager.getInstance().removeAsset([ElfImageName[_loc2_]],false);
                  ElfImageName.splice(_loc2_,1);
                  ElfImageTexture.splice(_loc2_,1);
               }
            }
            LogUtil(ElfImageName + "精灵正面");
            param1.removeFromParent(true);
            var param1:Image = null;
            AniFactor.ifOpen = false;
            Starling.juggler.removeTweens(param1);
         }
      }
      
      public function dispose() : void
      {
         LogUtil(ElfImageName + "释放精灵正面纹理");
         LoadOtherAssetsManager.getInstance().removeAsset(ElfImageName,false);
         ElfImageName = [];
         ElfImageTexture = [];
         tempNoRemoveTexture = [];
         mQueue = [];
      }
   }
}
