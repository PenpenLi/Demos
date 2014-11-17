#ifndef MOF_CCTMXLAYERINFO_H
#define MOF_CCTMXLAYERINFO_H

class CCTMXLayerInfo{
public:
	void ~CCTMXLayerInfo();
	void setProperties(cocos2d::CCDictionary *);
	void CCTMXLayerInfo(void);
	void getProperties(void);
}
#endif