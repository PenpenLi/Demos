#ifndef MOF_CCCAMERA_H
#define MOF_CCCAMERA_H

class CCCamera{
public:
	void CCCamera(void);
	void ~CCCamera();
	void getCenterXYZ(float	*,float	*,float	*);
	void getZEye(void);
	void restore(void);
	void setEyeXYZ(float, float, float);
	void getEyeXYZ(float *,float *,float *);
	void getEyeXYZ(float *,	float *, float *);
	void locate(void);
	void setEyeXYZ(float,float,float);
	void getCenterXYZ(float	*, float *, float *);
}
#endif