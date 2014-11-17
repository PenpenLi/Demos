#ifndef MOF_MULTIKEYWORDMATCH_H
#define MOF_MULTIKEYWORDMATCH_H

class MultiKeywordMatch{
public:
	void match(char	const*,std::vector<MatchResult,std::allocator<MatchResult>> &);
	void generate(void);
	void addKeyword(char const*);
	void match(char	const*,	std::vector<MatchResult, std::allocator<MatchResult>> &);
	void MultiKeywordMatch(void);
}
#endif