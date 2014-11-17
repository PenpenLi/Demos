#ifndef MOF_MAPLAYER_H
#define MOF_MAPLAYER_H

class MapLayer{
public:
	void draw(void);
	void ~MapLayer();
	void createEnemy(cocos2d::CCTMXTiledMap *);
	void mainRoleIn(LivingObject *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void outOfArea(LivingObject *);
	void changeTiledMap(char	*);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void goNextArea(void);
	void createAreas(cocos2d::CCTMXTiledMap *);
	void ccTouchMoved(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void IsPointOutOfArea(GameObject	*, cocos2d::CCPoint);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void createBG(cocos2d::CCTMXTiledMap *);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void createPartner(cocos2d::CCTMXTiledMap *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void createAreaBorns(cocos2d::CCTMXTiledMap *);
	void createPetArenaPet(cocos2d::CCTMXTiledMap *);
	void createWorldBoss(cocos2d::CCTMXTiledMap *);
	void createStatue(cocos2d::CCTMXTiledMap	*);
	void ccTouchEnded(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void createMonster(cocos2d::CCTMXTiledMap *);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void IsPointOutOfArea(GameObject	*,cocos2d::CCPoint);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void MapLayer(void);
	void createFG(cocos2d::CCTMXTiledMap *);
	void createMG(cocos2d::CCTMXTiledMap *);
	void ccTouchEnded(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void getArea(cocos2d::CCPoint const&);
	void createPortal(cocos2d::CCTMXTiledMap	*);
	void createFamous(cocos2d::CCTMXTiledMap	*);
	void createPetEliteCopy(cocos2d::CCTMXTiledMap *);
	void create(void);
	void init(void);
	void createDungeonParner(cocos2d::CCTMXTiledMap *);
	void correctPoint(cocos2d::CCPoint &);
	void ccTouchMoved(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void createNPC(cocos2d::CCTMXTiledMap *);
}
#endif