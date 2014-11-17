#ifndef MOF_WORDMATCHMANAGER_H
#define MOF_WORDMATCHMANAGER_H

class WordMatchManager{
public:
	void match(char const*, std::vector<MatchResult,	std::allocator<MatchResult>> &);
	void match(char const*,std::vector<MatchResult,std::allocator<MatchResult>> &);
	void preloadwordMatch(void);
}
#endif