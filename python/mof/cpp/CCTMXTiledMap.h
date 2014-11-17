#ifndef MOF_CCTMXTILEDMAP_H
#define MOF_CCTMXTILEDMAP_H

class CCTMXTiledMap{
public:
	void tilesetForLayer(cocos2d::CCTMXLayerInfo *,cocos2d::CCTMXMapInfo *);
	void parseLayer(cocos2d::CCTMXLayerInfo *,cocos2d::CCTMXMapInfo *);
	void removeAllData(void);
	void tilesetForLayer(cocos2d::CCTMXLayerInfo *, cocos2d::CCTMXMapInfo *);
	void setTileSize(cocos2d::CCSize const&);
	void setObjectGroups(cocos2d::CCArray *);
	void createWithXML(char const*,char const*);
	void getTileSize(void)const;
	void getMapOrientation(void)const;
	void setMapSize(cocos2d::CCSize const&);
	void getTileSize(void);
	void getMapSize(void)const;
	void setProperties(cocos2d::CCDictionary *);
	void getObjectGroups(void);
	void parseLayer(cocos2d::CCTMXLayerInfo *,	cocos2d::CCTMXMapInfo *);
	void layerNamed(char const*);
	void getProperties(void);
	void buildWithMapInfo(cocos2d::CCTMXMapInfo *);
	void setMapOrientation(int);
	void getMapOrientation(void);
	void objectGroupNamed(char	const*);
	void getMapSize(void);
	void ~CCTMXTiledMap();
	void CCTMXTiledMap(void);
}
#endif