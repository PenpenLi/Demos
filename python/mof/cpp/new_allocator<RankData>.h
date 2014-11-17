#ifndef MOF_NEW_ALLOCATOR<RANKDATA>_H
#define MOF_NEW_ALLOCATOR<RANKDATA>_H

class new_allocator<RankData>{
public:
	void construct(RankData*,RankData const&);
}
#endif