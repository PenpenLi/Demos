#ifndef MOF_GRAPH_H
#define MOF_GRAPH_H

class Graph{
public:
	void getStandingArmatureDisplay(cocos2d::CCNode *);
	void loadBoneAnimation(std::string &);
	void createRoleSkeletonDataCopy(int);
	void changeBodyFashion(int);
	void getBoundingBox(void);
	void loadAnimate(void);
	void startChangeBody(Graph*);
	void rebuildArmature(void);
	void addChild(cocos2d::CCNode	*);
	void completedAnimationSequenceNamed(char const*);
	void animationHandler(BoneAniEventType,std::string,std::string,bool);
	void addChild(cocos2d::CCNode	*, int,	int);
	void addChild(cocos2d::CCNode	*,int,int);
	void changeColorATime(float, cocos2d::_ccColor3B);
	void getResID(void);
	void transferVisibleChildren(Graph*, Graph*);
	void loadKeyFrameAnimation(std::string &);
	void getSprite(void);
	void endChangeColor(float);
	void create(int, int);
	void isFaceLeft(void);
	void clearAnimate(void);
	void setOpacityModifyRGB(bool);
	void changeWeaponFashion(int);
	void create(int,int);
	void transferVisibleChildren(Graph*,Graph*);
	void runAnimation(std::string,bool,bool);
	void flipxGraph(void);
	void addChild(cocos2d::CCNode *,int,int);
	void calculBoundingBox(void);
	void Graph(int, int);
	void getArg(void)const;
	void setOpacity(unsigned char);
	void addChild(cocos2d::CCNode *);
	void setPosition(cocos2d::CCPoint const&);
	void getArg(void);
	void setArg(int);
	void activeBoneAnimation(void);
	void ~Graph();
	void setColor(cocos2d::_ccColor3B const&);
	void endChangeBody(Graph*);
	void getResID(void)const;
	void addRoleSkeletonDataTimer(float);
	void getColor(void);
	void changeColorATime(float,cocos2d::_ccColor3B);
	void setResID(int);
	void Graph(int,int);
	void animationHandler(BoneAniEventType, std::string, std::string, bool);
	void changeWeaponTimer(float);
	void newArmature(std::string);
	void clearBoneAnimation(void);
	void runBoneAnimationTimer(float);
	void getOpacity(void);
	void setOrient(ObjOrientation);
	void setAnimationManager(cocos2d::extension::CCBAnimationManager *);
	void changeCloth(BodyPart,int);
	void changeCloth(BodyPart, int);
	void runAnimation(std::string, bool, bool);
	void setOpacity(uchar);
	void runBoneAnimation(std::string, bool);
	void addChild(cocos2d::CCNode *, int, int);
	void runBoneAnimation(std::string,bool);
	void loadAttackLight(ObjType);
	void getOrient(void);
	void reverseOrient(void);
	void isOpacityModifyRGB(void);
}
#endif