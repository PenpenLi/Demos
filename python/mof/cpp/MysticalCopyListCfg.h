#ifndef MOF_MYSTICALCOPYLISTCFG_H
#define MOF_MYSTICALCOPYLISTCFG_H

class MysticalCopyListCfg{
public:
	void getNoOpenListSize(void);
	void findNoOpenList(std::vector<int, std::allocator<int>> &);
	void load(char const*);
	void getNoOpenList(void);
	void getCfg(int);
	void getCopyID(int);
	void findNoOpenList(std::vector<int,std::allocator<int>> &);
}
#endif