#ifndef MOF_CCEDITBOXDELEGATE_H
#define MOF_CCEDITBOXDELEGATE_H

class CCEditBoxDelegate{
public:
	void editBoxTextChanged(cocos2d::extension::CCEditBox *,std::string	const&);
	void editBoxEditingDidBegin(cocos2d::extension::CCEditBox *);
	void editBoxEditingDidEnd(cocos2d::extension::CCEditBox *);
	void ~CCEditBoxDelegate();
	void editBoxTextChanged(cocos2d::extension::CCEditBox *, std::string const&);
}
#endif