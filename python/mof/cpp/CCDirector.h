#ifndef MOF_CCDIRECTOR_H
#define MOF_CCDIRECTOR_H

class CCDirector{
public:
	void sharedDirector(void);
	void setProjection(cocos2d::ccDirectorProjection);
	void getActionManager(void);
	void calculateDeltaTime(void);
	void getClassTypeInfo(void);
	void setScheduler(cocos2d::CCScheduler *);
	void getContentScaleFactor(void);
	void setNextScene(void);
	void CCDirector(void);
	void setActionManager(cocos2d::CCActionManager *);
	void setDepthTest(bool);
	void replaceScene(cocos2d::CCScene *);
	void getWinSize(void);
	void ~CCDirector();
	void purgeCachedData(void);
	void getKeypadDispatcher(void);
	void showStats(void);
	void runWithScene(cocos2d::CCScene *);
	void getTouchDispatcher(void);
	void setGLDefaultValues(void);
	void setTouchDispatcher(cocos2d::CCTouchDispatcher *);
	void setKeypadDispatcher(cocos2d::CCKeypadDispatcher *);
	void getClassTypeInfo(void)::id;
	void setAccelerometer(cocos2d::CCAccelerometer *);
	void setNotificationNode(cocos2d::CCNode *);
	void getWinSizeInPixels(void);
	void getVisibleOrigin(void);
	void createStatsLabel(void);
	void getAccelerometer(void);
	void end(void);
	void pause(void);
	void getScheduler(void);
	void drawScene(void);
	void setOpenGLView(cocos2d::CCEGLView	*);
	void convertToGL(cocos2d::CCPoint const&);
	void purgeDirector(void);
	void resume(void);
	void init(void);
}
#endif