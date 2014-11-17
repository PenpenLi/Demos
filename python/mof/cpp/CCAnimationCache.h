#ifndef MOF_CCANIMATIONCACHE_H
#define MOF_CCANIMATIONCACHE_H

class CCAnimationCache{
public:
	void addAnimationsWithDictionary(cocos2d::CCDictionary *);
	void addAnimation(cocos2d::CCAnimation *, char const*);
	void ~CCAnimationCache();
	void parseVersion1(cocos2d::CCDictionary *);
	void purgeSharedAnimationCache(void);
	void addAnimationsWithFile(char	const*);
	void sharedAnimationCache(void);
	void parseVersion2(cocos2d::CCDictionary *);
	void animationByName(char const*);
	void addAnimation(cocos2d::CCAnimation *,char const*);
	void init(void);
}
#endif