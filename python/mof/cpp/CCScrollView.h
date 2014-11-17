#ifndef MOF_CCSCROLLVIEW_H
#define MOF_CCSCROLLVIEW_H

class CCScrollView{
public:
	void getContentOffset(void);
	void ccTouchMoved(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void minContainerOffset(void);
	void addChild(cocos2d::CCNode *,int,int);
	void performedAnimatedScroll(float);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void setTouchEnabled(bool);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setViewSize(cocos2d::CCSize);
	void setContentOffset(cocos2d::CCPoint,bool);
	void setDirection(cocos2d::extension::CCScrollViewDirection);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void relocateContainer(bool);
	void setLastPos(cocos2d::CCPoint);
	void beforeDraw(void);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void setContentSize(cocos2d::CCSize const&);
	void addChild(cocos2d::CCNode *,int);
	void CCScrollView(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void addChild(cocos2d::CCNode *);
	void addChild(cocos2d::CCNode *,	int, int);
	void visit(void);
	void stoppedAnimatedScroll(cocos2d::CCNode *);
	void ~CCScrollView();
	void initWithViewSize(cocos2d::CCSize,cocos2d::CCNode *);
	void setContentOffsetInDuration(cocos2d::CCPoint,float);
	void registerWithTouchDispatcher(void);
	void setContainer(cocos2d::CCNode *);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void getContentSize(void);
	void create(cocos2d::CCSize, cocos2d::CCNode *);
	void addChild(cocos2d::CCNode *,	int);
	void setContentOffset(cocos2d::CCPoint, bool);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void deaccelerateScrolling(float);
	void getLastPos(void);
	void ccTouchEnded(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void setContentOffsetInDuration(cocos2d::CCPoint, float);
	void updateInset(void);
	void setZoomScale(float);
	void create(void);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void initWithViewSize(cocos2d::CCSize, cocos2d::CCNode *);
	void create(cocos2d::CCSize,cocos2d::CCNode *);
	void getContainer(void);
	void init(void);
}
#endif