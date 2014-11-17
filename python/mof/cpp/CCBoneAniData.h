#ifndef MOF_CCBONEANIDATA_H
#define MOF_CCBONEANIDATA_H

class CCBoneAniData{
public:
	void addAnimation(CCFrameNodeList *, char const*);
	void getDurationTo(void)const;
	void getDuration(void);
	void setDuration(int);
	void setEventList(cocos2d::CCArray *);
	void setFrameNodeListDic(cocos2d::CCDictionary *);
	void setTweenEasing(float);
	void getTweenEasing(void)const;
	void getEventList(void);
	void getDuration(void)const;
	void setDurationTween(int);
	void getDurationTween(void);
	void addAnimation(CCFrameNodeList *,char const*);
	void getLoop(void);
	void setDurationTo(int);
	void getLoop(void)const;
	void copyWithZone(cocos2d::CCZone *);
	void getDurationTo(void);
	void getAnimationsStartWithName(char const*);
	void ~CCBoneAniData();
	void getFrameNodeListDic(void)const;
	void getDurationTween(void)const;
	void getAnimation(char const*);
	void getEventList(void)const;
	void create(void);
	void setLoop(bool);
	void getFrameNodeListDic(void);
	void init(void);
	void getTweenEasing(void);
}
#endif