#ifndef MOF_DICELOTTERYCFGMGR_H
#define MOF_DICELOTTERYCFGMGR_H

class DiceLotteryCfgMgr{
public:
	void needRmg(int, int &);
	void getGrid(int, int);
	void needRmg(int,int &);
	void loadGrid(char const*);
	void load(std::string const&,std::string const&);
	void getGrid(int,std::vector<DiceGrid *,std::allocator<DiceGrid	*>> &);
	void getGrid(int, std::vector<DiceGrid *, std::allocator<DiceGrid *>> &);
	void getGrid(int,int);
}
#endif