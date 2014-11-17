#ifndef MOF_NEW_ALLOCATOR<LUCKYSTONELISTDATA>_H
#define MOF_NEW_ALLOCATOR<LUCKYSTONELISTDATA>_H

class new_allocator<LuckystoneListData>{
public:
	void construct(LuckystoneListData*,LuckystoneListData const&);
}
#endif