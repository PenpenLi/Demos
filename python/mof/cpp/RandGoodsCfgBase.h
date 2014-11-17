#ifndef MOF_RANDGOODSCFGBASE_H
#define MOF_RANDGOODSCFGBASE_H

class RandGoodsCfgBase{
public:
	void readGoods(IniFile &);
	void getVipRefreshTimes(int const&);
	void getGuildVipRefreshTimes(int	const&);
	void getGoods(int);
	void readMerchant(IniFile &);
	void checkIsIndex(int);
	void GoodsVecCmp(RandGoodsDef * const&,RandGoodsDef * const&);
	void GoodsVecCmp(RandGoodsDef * const&, RandGoodsDef * const&);
}
#endif