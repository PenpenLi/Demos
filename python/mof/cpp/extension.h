#ifndef MOF_EXTENSION_H
#define MOF_EXTENSION_H

class extension{
public:
	void downLoadPackage(void *, unsigned long, unsigned long, void *);
	void assetsManagerDownloadAndUncompress(void *);
	void assetsManagerProgressFunc(void *,	double,	double,	double,	double);
	void assetsManagerProgressFunc(void *,double,double,double,double);
	void __createSystemEditBox(cocos2d::extension::CCEditBox *);
	void setRelativeScale(cocos2d::CCNode *,float,float,int,char const*);
	void setRelativeScale(cocos2d::CCNode *, float, float,	int, char const*);
	void getAbsolutePosition(cocos2d::CCPoint const&,int,cocos2d::CCSize const&,char const*);
	void downLoadPackage(void *,ulong,ulong,void *);
}
#endif