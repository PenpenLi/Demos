#ifndef MOF_CCBANIMATIONMANAGER_H
#define MOF_CCBANIMATIONMANAGER_H

class CCBAnimationManager{
public:
	void setAnimatedProperty(char const*,cocos2d::CCNode *,cocos2d::CCObject *,float);
	void getEaseAction(cocos2d::CCActionInterval *, int, float);
	void addNode(cocos2d::CCNode *, cocos2d::CCDictionary *);
	void setDelegate(cocos2d::extension::CCBAnimationManagerDelegate *);
	void getAction(cocos2d::extension::CCBKeyframe *,cocos2d::extension::CCBKeyframe *,char const*,cocos2d::CCNode *);
	void getBaseValue(cocos2d::CCNode	*, char	const*);
	void setAutoPlaySequenceId(int);
	void addDocumentCallbackName(std::string);
	void setBaseValue(cocos2d::CCObject *,cocos2d::CCNode *,char const*);
	void getContainerSize(cocos2d::CCNode *);
	void getSequences(void);
	void getAction(cocos2d::extension::CCBKeyframe *,	cocos2d::extension::CCBKeyframe	*, char	const*,	cocos2d::CCNode	*);
	void ~CCBAnimationManager();
	void runAction(cocos2d::CCNode *,cocos2d::extension::CCBSequenceProperty *,float);
	void addDocumentOutletNode(cocos2d::CCNode *);
	void CCBAnimationManager(void);
	void moveAnimationsFromNode(cocos2d::CCNode *, cocos2d::CCNode *);
	void sequenceCompleted(void);
	void getBaseValue(cocos2d::CCNode	*,char const*);
	void getRootNode(void);
	void runAnimationsForSequenceIdTweenDuration(int,float,bool);
	void setFirstFrame(cocos2d::CCNode *, cocos2d::extension::CCBSequenceProperty *, float);
	void setAnimatedProperty(float);
	void addNode(cocos2d::CCNode *,cocos2d::CCDictionary *);
	void getAutoPlaySequenceId(void);
	void runAction(cocos2d::CCNode *,	cocos2d::extension::CCBSequenceProperty	*, float);
	void getSequence(int);
	void addDocumentCallbackNode(cocos2d::CCNode *);
	void runAnimations(char const*,float,bool,bool);
	void setRootContainerSize(cocos2d::CCSize	const&);
	void getEaseAction(cocos2d::CCActionInterval *,int,float);
	void setDocumentControllerName(std::string const&);
	void moveAnimationsFromNode(cocos2d::CCNode *,cocos2d::CCNode *);
	void setRootNode(cocos2d::CCNode *);
	void setFirstFrame(cocos2d::CCNode *,cocos2d::extension::CCBSequenceProperty *,float);
	void init(void);
	void runAnimationsForSequenceIdTweenDuration(int,	float, bool);
	void getSequenceId(char const*);
	void runAnimations(char const*, float, bool, bool);
	void addDocumentOutletName(std::string);
	void setBaseValue(cocos2d::CCObject *, cocos2d::CCNode *,	char const*);
}
#endif