#ifndef MOF_CCPROCESSBASE_H
#define MOF_CCPROCESSBASE_H

class CCProcessBase{
public:
	void getIsComplete(void)const;
	void ~CCProcessBase();
	void stop(void);
	void updateHandler(void);
	void setScale(float	const&);
	void getNoScaleListFrames(void)const;
	void setCurrentPrecent(float const&);
	void getIsPause(void)const;
	void playTo(void *,	int, int, bool,	int);
	void getAnimationInternal(void)const;
	void setIsPause(bool const&);
	void update(float);
	void remove(void);
	void CCProcessBase(void);
	void getIsComplete(void);
	void getNoScaleListFrames(void);
	void getCurrentPrecent(void);
	void getScale(void);
	void getAnimationInternal(void);
	void getLoop(void);
	void getLoop(void)const;
	void setAnimationInternal(float const&);
	void getCurrentPrecent(void)const;
	void getIsPause(void);
	void playTo(void *,int,int,bool,int);
	void setNoScaleListFrames(int const&);
	void setEase(int const&);
	void setLoop(int const&);
	void setIsComplete(bool const&);
	void getEase(void)const;
	void getEase(void);
}
#endif