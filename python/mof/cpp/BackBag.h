#ifndef MOF_BACKBAG_H
#define MOF_BACKBAG_H

class BackBag{
public:
	void ~BackBag();
	void GetTypeItems(int, std::vector<ItemGroup, std::allocator<ItemGroup>> &);
	void GetItemNum(int);
	void EmptyGridAmount(void);
	void Create(int);
	void GetTypeItems(int,std::vector<ItemGroup,std::allocator<ItemGroup>> &);
	void GetName(void);
}
#endif