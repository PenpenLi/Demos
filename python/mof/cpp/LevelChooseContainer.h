#ifndef MOF_LEVELCHOOSECONTAINER_H
#define MOF_LEVELCHOOSECONTAINER_H

class LevelChooseContainer{
public:
	void refreshTouchUpOutsideClicked(cocos2d::CCObject *);
	void create(void);
	void ~LevelChooseContainer();
	void onGoLevelItemDragInsideClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onGoLevelItemDragInsideClicked(cocos2d::CCObject	*);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void createMakeprintInfor(eSceneType,int,cocos2d::CCPoint,cocos2d::CCPoint);
	void onEnter(void);
	void refreshDragInsideClicked(cocos2d::CCObject *);
	void refreshTouchUpInsideClicked(cocos2d::CCObject *);
	void onGoLevelItemTouchUpOutsideClicked(cocos2d::CCObject *);
	void onGoLevelItemTouchDownClicked(cocos2d::CCObject *);
	void onGoLevelItemTouchUpInsideClicked(cocos2d::CCObject *);
	void createControl(std::vector<int,std::allocator<int>>,std::vector<int,std::allocator<int>>);
	void LevelChooseContainer(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void createControl(std::vector<int, std::allocator<int>>, std::vector<int, std::allocator<int>>);
	void onGoLevelItemTouchDownClicked(cocos2d::CCObject	*);
	void createMakeprintInfor(eSceneType, int, cocos2d::CCPoint,	cocos2d::CCPoint);
	void init(void);
	void onExit(void);
}
#endif