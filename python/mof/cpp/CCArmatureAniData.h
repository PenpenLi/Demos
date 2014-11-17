#ifndef MOF_CCARMATUREANIDATA_H
#define MOF_CCARMATUREANIDATA_H

class CCArmatureAniData{
public:
	void getBoneAniDataDic(void);
	void getAnimationNames(void);
	void addAnimation(char const*,CCBoneAniData *);
	void getAnimation(char const*);
	void ~CCArmatureAniData();
	void create(void);
	void setAnimationNames(std::vector<std::string,	std::allocator<std::string>>);
	void copyWithZone(cocos2d::CCZone *);
	void setAnimationNames(std::vector<std::string,std::allocator<std::string>>);
	void getBoneAniDataDic(void)const;
	void addAnimation(char const*, CCBoneAniData *);
	void setBoneAniDataDic(cocos2d::CCDictionary *);
	void init(void);
}
#endif