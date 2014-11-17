#ifndef MOF_CCTMXOBJECTGROUP_H
#define MOF_CCTMXOBJECTGROUP_H

class CCTMXObjectGroup{
public:
	void getPositionOffset(void)const;
	void ~CCTMXObjectGroup();
	void CCTMXObjectGroup(void);
	void getProperties(void);
	void getPositionOffset(void);
	void setPositionOffset(cocos2d::CCPoint	const&);
	void setObjects(cocos2d::CCArray *);
	void getObjects(void);
	void setProperties(cocos2d::CCDictionary *);
}
#endif