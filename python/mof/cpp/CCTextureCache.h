#ifndef MOF_CCTEXTURECACHE_H
#define MOF_CCTEXTURECACHE_H

class CCTextureCache{
public:
	void removeTextureForKey(char const*);
	void textureForKey(char const*);
	void ~CCTextureCache();
	void addPVRImage(char const*);
	void purgeSharedTextureCache(void);
	void CCTextureCache(void);
	void sharedTextureCache(void);
	void removeUnusedTextures(void);
	void addImage(char const*);
}
#endif