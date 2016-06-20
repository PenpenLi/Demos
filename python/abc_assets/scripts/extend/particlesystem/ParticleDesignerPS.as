package extend.particlesystem
{
   import starling.textures.Texture;
   
   public class ParticleDesignerPS extends PDParticleSystem
   {
      
      private static var sDeprecationNotified:Boolean = false;
       
      public function ParticleDesignerPS(param1:XML, param2:Texture)
      {
         if(!sDeprecationNotified)
         {
            sDeprecationNotified = true;
            LogUtil("[Starling] The class \'ParticleDesignerPS\' is deprecated. Please use \'PDParticleSystem\' instead.");
         }
         super(param1,param2);
      }
   }
}
