#ifndef MOF_CCTMXMAPINFO_H
#define MOF_CCTMXMAPINFO_H

class CCTMXMapInfo{
public:
	void endElement(void *,char	const*);
	void getParentGID(void)const;
	void getLayerAttribs(void);
	void internalInit(char const*, char	const*);
	void formatWithXML(char const*,char	const*);
	void setParentElement(int);
	void getStoringCharacters(void)const;
	void endElement(void *,char const*);
	void textHandler(void *, char const*, int);
	void getParentElement(void);
	void setTileSize(cocos2d::CCSize const&);
	void setObjectGroups(cocos2d::CCArray *);
	void startElement(void *, char const*, char	const**);
	void getTileSize(void)const;
	void textHandler(void	*,char const*,int);
	void setMapSize(cocos2d::CCSize const&);
	void parseXMLString(char const*);
	void getLayers(void);
	void startElement(void *, char const*, char const**);
	void getStoringCharacters(void);
	void textHandler(void	*, char	const*,	int);
	void getOrientation(void)const;
	void getLayerAttribs(void)const;
	void setLayerAttribs(int);
	void getTileSize(void);
	void CCTMXMapInfo(void);
	void setParentGID(unsigned int);
	void setTilesets(cocos2d::CCArray *);
	void setProperties(cocos2d::CCDictionary *);
	void setStoringCharacters(bool);
	void getObjectGroups(void);
	void getProperties(void);
	void getParentGID(void);
	void internalInit(char const*,char const*);
	void getMapSize(void)const;
	void ~CCTMXMapInfo();
	void getMapSize(void);
	void endElement(void *, char const*);
	void getParentElement(void)const;
	void setParentGID(uint);
	void startElement(void *,char const*,char const**);
	void textHandler(void *,char const*,int);
	void setOrientation(int);
	void setLayers(cocos2d::CCArray *);
	void getOrientation(void);
	void startElement(void *,char	const*,char const**);
	void getTilesets(void);
	void getTileProperties(void);
}
#endif