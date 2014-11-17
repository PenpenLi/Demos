#ifndef MOF_CCSPRITEFRAMECACHE_H
#define MOF_CCSPRITEFRAMECACHE_H

class CCSpriteFrameCache{
public:
	void removeSpriteFramesFromDictionary(cocos2d::CCDictionary *);
	void addSpriteFramesWithFile(char const*,char	const*);
	void purgeSharedSpriteFrameCache(void);
	void addSpriteFramesWithFile(char const*,cocos2d::CCTexture2D	*);
	void sharedSpriteFrameCache(void);
	void ~CCSpriteFrameCache();
	void addSpriteFramesWithDictionary(cocos2d::CCDictionary *,cocos2d::CCTexture2D *);
	void addSpriteFramesWithFile(char const*, char const*);
	void addSpriteFramesWithDictionary(cocos2d::CCDictionary *, cocos2d::CCTexture2D *);
	void spriteFrameByName(char const*);
	void removeSpriteFramesFromFile(char const*);
	void addSpriteFramesWithFile(char const*);
	void init(void);
	void addSpriteFramesWithFile(char const*, cocos2d::CCTexture2D *);
}
#endif