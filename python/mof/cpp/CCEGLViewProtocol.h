#ifndef MOF_CCEGLVIEWPROTOCOL_H
#define MOF_CCEGLVIEWPROTOCOL_H

class CCEGLViewProtocol{
public:
	void handleTouchesMove(int, int *, float *, float *);
	void setTouchDelegate(cocos2d::EGLTouchDelegate *);
	void CCEGLViewProtocol(void);
	void handleTouchesEnd(int,int *,float *,float *);
	void setScissorInPoints(float);
	void handleTouchesBegin(int, int *, float *, float *);
	void handleTouchesCancel(int,int *,float *,float *);
	void getFrameSize(void)const;
	void setFrameSize(float, float);
	void getDesignResolutionSize(void);
	void getScaleY(void)const;
	void getVisibleSize(void);
	void getScaleX(void)const;
	void handleTouchesMove(int,int	*,float	*,float	*);
	void getScaleY(void);
	void getViewPortRect(void)const;
	void ~CCEGLViewProtocol();
	void setViewPortInPoints(float);
	void getVisibleSize(void)const;
	void setFrameSize(float,float);
	void getDesignResolutionSize(void)const;
	void getVisibleOrigin(void);
	void handleTouchesCancel(int, int *, float *, float *);
	void setViewPortInPoints(float,float,float,float);
	void getVisibleOrigin(void)const;
	void handleTouchesEnd(int, int	*, float *, float *);
	void setViewName(char const*);
	void getSetOfTouchesEndOrCancel(cocos2d::CCSet	&, int,	int *, float *,	float *);
	void getViewPortRect(void);
	void getFrameSize(void);
	void handleTouchesBegin(int,int *,float *,float *);
	void getScaleX(void);
	void setScissorInPoints(float,float,float,float);
	void setDesignResolutionSize(float,float,ResolutionPolicy);
	void getSetOfTouchesEndOrCancel(cocos2d::CCSet	&,int,int *,float *,float *);
	void setDesignResolutionSize(float, float, ResolutionPolicy);
}
#endif