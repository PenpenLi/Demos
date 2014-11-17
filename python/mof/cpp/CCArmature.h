#ifndef MOF_CCARMATURE_H
#define MOF_CCARMATURE_H

class CCArmature{
public:
	void getName(void)const;
	void setBoneDisplayFactory(CCBoneDisplayFactory *);
	void changeClothWithCCArmatureData(std::string,std::string,_CCArmatureData *,bool);
	void addBone(char const*, char	const*,	cocos2d::CCNode	*, int);
	void getAnimation(void);
	void getSkeletonName(void);
	void ~CCArmature();
	void changeClothWithSelfSkeleton(std::string,std::string);
	void setAnimation(CCArmatureAnimation *);
	void createBoneDisplay(char const*);
	void getBoneDisplayFactory(void)const;
	void changeToColor(cocos2d::_ccColor3B);
	void createBones(cocos2d::CCArray *);
	void findClothDataInSkeletonFile(std::string, std::string, std::string, int);
	void getArmaureDisplayFactory(void);
	void remove(void);
	void getDisPlayBatchNode(void)const;
	void changeColor(void);
	void setDisPlayBatchNode(cocos2d::CCSpriteBatchNode *);
	void removeFashionSprites(std::string);
	void update(float);
	void createFashionSprites(cocos2d::CCDictionary *,cocos2d::CCNode *);
	void createArmatureDisplay(char const*);
	void init(int,char const*,char	const*,char const*,cocos2d::CCNode *,cocos2d::CCSpriteBatchNode	*,int,bool,char	const*);
	void getDisplay(void);
	void findClothDataInSkeletonFile(std::string,std::string,std::string,int);
	void create(int,char const*,char const*,char const*,cocos2d::CCNode *,cocos2d::CCSpriteBatchNode *,int,bool,char const*);
	void getDisPlayBatchNode(void);
	void getBoneDisplayFactory(void);
	void changeClothWithCCArmatureData(std::string, std::string, _CCArmatureData *, bool);
	void changeClothWithOtherSkeleton(std::string,std::string,std::string);
	void changeClothInOtherArmatures(_CCArmatureData *,std::string,bool);
	void getAnimation(void)const;
	void endChangeToColor(void);
	void createFashionSprites(cocos2d::CCDictionary *, cocos2d::CCNode *);
	void synthesizeFashionSprites(void);
	void changeClothTextureInAnimationData(CCArmatureAniData *, std::string, _CCArmatureData *, bool);
	void changeClothInOtherArmatures(_CCArmatureData *, std::string, bool);
	void getArmaureDisplayFactory(void)const;
	void changeClothWithOtherSkeleton(std::string,	std::string, std::string);
	void setDisplay(cocos2d::CCNode *);
	void addBone(char const*,char const*,cocos2d::CCNode *,int);
	void getSkeletonName(void)const;
	void init(int,	char const*, char const*, char const*, cocos2d::CCNode *, cocos2d::CCSpriteBatchNode *,	int, bool, char	const*);
	void setArmaureDisplayFactory(CCArmatureDisplayFactory	*);
	void removeAllFashionSprites(void);
	void getDisplay(void)const;
	void resetBonesParent(void);
	void getName(void);
	void changeClothTextureInAnimationData(CCArmatureAniData *,std::string,_CCArmatureData	*,bool);
	void changeClothWithSelfSkeleton(std::string, std::string);
}
#endif