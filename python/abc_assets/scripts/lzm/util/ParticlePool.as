package lzm.util
{
   import extend.particlesystem.PDParticleSystem;
   import starling.textures.Texture;
   
   public class ParticlePool
   {
      
      private static var _pool:Object = {};
       
      public function ParticlePool()
      {
         super();
      }
      
      public static function getParticle(param1:String, param2:XML, param3:Texture) : PDParticleSystem
      {
         var _loc4_:* = null;
         var _loc5_:Vector.<PDParticleSystem> = _pool[param1];
         if(_loc5_ == null || _loc5_.length == 0)
         {
            _loc4_ = new PDParticleSystem(param2,param3);
            _loc4_.name = param1;
            return _loc4_;
         }
         return _loc5_.shift();
      }
      
      public static function returnParticle(param1:PDParticleSystem) : void
      {
         param1.stop(true);
         param1.removeFromParent();
         var _loc2_:Vector.<PDParticleSystem> = _pool[param1.name];
         if(_loc2_ == null)
         {
            _loc2_ = new Vector.<PDParticleSystem>();
         }
         _loc2_.push(param1);
         _pool[param1.name] = _loc2_;
      }
   }
}
