#ifndef MOF_ANSWERACTIVITYCFG_H
#define MOF_ANSWERACTIVITYCFG_H

class AnswerActivityCfg{
public:
	void randomQuestion4Selection(int const&);
	void getTotalawardItem(int const&);
	void getQuestion(int const&);
	void getChangeQuestionCost(int);
	void findOriginalSelection(int const&,std::string);
	void loadQuestionsFile(std::string const&);
	void findOriginalSelection(int const&, std::string);
	void getScoreRewards(int const&);
	void loadAnswerActivityFile(std::string	const&);
}
#endif