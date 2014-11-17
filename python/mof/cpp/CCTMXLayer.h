#ifndef MOF_CCTMXLAYER_H
#define MOF_CCTMXLAYER_H

class CCTMXLayer{
public:
	void positionAt(cocos2d::CCPoint const&);
	void setLayerOrientation(unsigned int);
	void getMapTileSize(void)const;
	void setMapTileSize(cocos2d::CCSize const&);
	void vertexZForPos(cocos2d::CCPoint const&);
	void setLayerOrientation(uint);
	void setLayerSize(cocos2d::CCSize const&);
	void ~CCTMXLayer();
	void propertyNamed(char const*);
	void getLayerSize(void)const;
	void create(cocos2d::CCTMXTilesetInfo	*,cocos2d::CCTMXLayerInfo *,cocos2d::CCTMXMapInfo *);
	void parseInternalProperties(void);
	void appendTileForGID(unsigned int, cocos2d::CCPoint const&);
	void calculateLayerOffset(cocos2d::CCPoint const&);
	void setupTileSprite(cocos2d::CCSprite *, cocos2d::CCPoint, unsigned int);
	void getTiles(void);
	void getTileSet(void);
	void setupTiles(void);
	void getLayerSize(void);
	void setProperties(cocos2d::CCDictionary *);
	void removeChild(cocos2d::CCNode *,bool);
	void CCTMXLayer(void);
	void removeChild(cocos2d::CCNode *, bool);
	void setTiles(uint *);
	void getProperties(void);
	void getMapTileSize(void);
	void getLayerOrientation(void);
	void initWithTilesetInfo(cocos2d::CCTMXTilesetInfo *,cocos2d::CCTMXLayerInfo *,cocos2d::CCTMXMapInfo *);
	void setTileSet(cocos2d::CCTMXTilesetInfo *);
	void setTiles(unsigned int *);
	void setupTileSprite(cocos2d::CCSprite *,cocos2d::CCPoint,uint);
	void appendTileForGID(uint,cocos2d::CCPoint const&);
	void initWithTilesetInfo(cocos2d::CCTMXTilesetInfo *,	cocos2d::CCTMXLayerInfo	*, cocos2d::CCTMXMapInfo *);
	void getTiles(void)const;
	void positionForIsoAt(cocos2d::CCPoint const&);
	void addChild(cocos2d::CCNode	*,int,int);
	void addChild(cocos2d::CCNode	*, int,	int);
	void reusedTileWithRect(cocos2d::CCRect);
	void getLayerOrientation(void)const;
	void positionForHexAt(cocos2d::CCPoint const&);
}
#endif