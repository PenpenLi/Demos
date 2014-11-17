#ifndef MOF_CCTEXTUREPVR_H
#define MOF_CCTEXTUREPVR_H

class CCTexturePVR{
public:
	void CCTexturePVR(void);
	void unpackPVRv2Data(unsigned char *, unsigned int);
	void unpackPVRv3Data(uchar *,uint);
	void unpackPVRv2Data(uchar *,uint);
	void initWithContentsOfFile(char const*);
	void unpackPVRv3Data(unsigned char *, unsigned int);
	void createGLTexture(void);
	void ~CCTexturePVR();
}
#endif