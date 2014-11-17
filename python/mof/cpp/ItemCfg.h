#ifndef MOF_ITEMCFG_H
#define MOF_ITEMCFG_H

class ItemCfg{
public:
	void getShopPropsVec(void);
	void getSkillBooksByQua(int,bool,int);
	void getSkillBooksByQua(int, bool, int);
	void getItemsByType(int);
	void load(std::string);
	void getCfg(int);
	void getPotionID(void);
	void getAllItemDatas(void);
}
#endif