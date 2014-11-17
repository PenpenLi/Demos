#ifndef MOF_CCBREADER_H
#define MOF_CCBREADER_H

class CCBReader{
public:
	void readByte(void);
	void ~CCBReader();
	void readSequences(void);
	void getAnimationManager(void);
	void addDocumentCallbackName(std::string);
	void readFileWithCleanUp(bool,cocos2d::CCDictionary	*);
	void lastPathComponent(char	const*);
	void readCachedString(void);
	void readNodeGraphFromData(cocos2d::extension::CCData *,cocos2d::CCObject *,cocos2d::CCSize	const&);
	void addOwnerCallbackNode(cocos2d::CCNode *);
	void readFileWithCleanUp(bool, cocos2d::CCDictionary *);
	void getAnimationManagers(void);
	void readNodeGraph(cocos2d::CCNode *);
	void readNodeGraphFromFile(char const*, cocos2d::CCObject *);
	void addOwnerCallbackName(std::string);
	void getCCBRootPath(void);
	void CCBReader(cocos2d::extension::CCNodeLoaderLibrary *, cocos2d::extension::CCBMemberVariableAssigner *, cocos2d::extension::CCBSelectorResolver *, cocos2d::extension::CCNodeLoaderListener *);
	void readNodeGraphFromFile(char const*,cocos2d::CCObject *);
	void readFloat(void);
	void readStringCache(void);
	void readNodeGraphFromFile(char const*, cocos2d::CCObject *, cocos2d::CCSize const&);
	void isJSControlled(void);
	void addDocumentCallbackNode(cocos2d::CCNode *);
	void readNodeGraphFromFile(char const*,cocos2d::CCObject *,cocos2d::CCSize const&);
	void getLoadedSpriteSheet(void);
	void CCBReader(cocos2d::extension::CCNodeLoaderLibrary *,cocos2d::extension::CCBMemberVariableAssigner *,cocos2d::extension::CCBSelectorResolver *,cocos2d::extension::CCNodeLoaderListener	*);
	void CCBReader(cocos2d::extension::CCBReader*);
	void getCCBSelectorResolver(void);
	void getResolutionScale(void);
	void readNodeGraphFromFile(char const*);
	void getBit(void);
	void readKeyframe(int);
	void getAnimatedProperties(void);
	void cleanUpNodeGraph(cocos2d::CCNode *);
	void readUTF8(void);
	void setAnimationManager(cocos2d::extension::CCBAnimationManager *);
	void readInt(bool);
	void readHeader(void);
	void getCCBRootPath(void)const;
	void deletePathExtension(char const*);
	void getOwner(void);
	void readNodeGraphFromData(cocos2d::extension::CCData *, cocos2d::CCObject *, cocos2d::CCSize const&);
	void endsWith(char const*, char const*);
	void init(void);
	void endsWith(char const*,char const*);
	void readBool(void);
}
#endif