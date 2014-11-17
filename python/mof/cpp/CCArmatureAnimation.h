#ifndef MOF_CCARMATUREANIMATION_H
#define MOF_CCARMATUREANIMATION_H

class CCArmatureAnimation{
public:
	void updateTween(char	const*,	float);
	void playTo(void *, int, int,	bool, int);
	void setData(CCArmatureAniData *);
	void addTween(CCBone *);
	void updateTween(char	const*,float);
	void isContainAnimation(std::string);
	void getData(void);
	void stop(void);
	void ~CCArmatureAnimation();
	void create(void);
	void updateHandler(void);
	void remove(void);
	void updateCurrentPrecent(void);
	void getAniEventListener(void)const;
	void setAniEventListener(CCBoneAnimationEventListener	*);
	void playTo(void *,int,int,bool,int);
	void getAniEventListener(void);
	void init(void);
}
#endif