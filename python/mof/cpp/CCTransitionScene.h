#ifndef MOF_CCTRANSITIONSCENE_H
#define MOF_CCTRANSITIONSCENE_H

class CCTransitionScene{
public:
	void draw(void);
	void initWithDuration(float, cocos2d::CCScene *);
	void ~CCTransitionScene();
	void sceneOrder(void);
	void initWithDuration(float,cocos2d::CCScene *);
	void finish(void);
	void hideOutShowIn(void);
	void onEnter(void);
	void cleanup(void);
	void setNewScene(float);
	void onExit(void);
}
#endif