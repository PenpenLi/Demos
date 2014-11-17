#ifndef MOF_ITEMCONTAINER_H
#define MOF_ITEMCONTAINER_H

class ItemContainer{
public:
	void Store(int,std::vector<BagGrid,std::allocator<BagGrid>>	const&);
	void ~ItemContainer();
	void SetItem(int,ItemGroup const&);
	void Clear(void);
	void Store(int,int,ItemGroup const&);
	void SetItem(int, ItemGroup	const&);
	void Store(int,std::vector<int,std::allocator<int>>	&);
	void Store(int, std::vector<int, std::allocator<int>> &);
	void Store(int,int);
	void Store(int, int);
	void Store(int, int, ItemGroup const&);
	void Load(int);
	void ItemContainer(int);
	void Store(int, std::vector<BagGrid, std::allocator<BagGrid>> const&);
}
#endif