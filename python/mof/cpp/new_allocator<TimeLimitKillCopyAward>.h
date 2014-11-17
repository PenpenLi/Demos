#ifndef MOF_NEW_ALLOCATOR<TIMELIMITKILLCOPYAWARD>_H
#define MOF_NEW_ALLOCATOR<TIMELIMITKILLCOPYAWARD>_H

class new_allocator<TimeLimitKillCopyAward>{
public:
	void construct(TimeLimitKillCopyAward*,TimeLimitKillCopyAward const&);
}
#endif