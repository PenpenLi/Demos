#ifndef MOF_MYSTERIOUSCFG_H
#define MOF_MYSTERIOUSCFG_H

class MysteriousCfg{
public:
	void getExchangeGoods(int);
	void ~MysteriousCfg();
	void getPropsExchangeByLvl(int, int);
	void getPropsExchangeByLvl(int,int);
	void readGoods(IniFile &);
	void readMerchant(IniFile &);
	void checkIsIndex(int);
	void isUseViplvlRefreshLimit(void)const;
	void getMyMysteriousTimeGoodsInLimitTime(int);
	void read(void);
	void isUseViplvlRefreshLimit(void);
	void readExchangeGoods(IniFile &);
	void readTimeActivaityGoods(IniFile	&);
	void getMysteriousGoodsDef(int);
}
#endif