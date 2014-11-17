#ifndef MOF_CCEDITBOXIMPLIOS_H
#define MOF_CCEDITBOXIMPLIOS_H

class CCEditBoxImplIOS{
public:
	void setInputMode(cocos2d::extension::EditBoxInputMode);
	void initWithSize(cocos2d::CCSize const&);
	void ~CCEditBoxImplIOS();
	void setReturnType(cocos2d::extension::KeyboardReturnType);
	void doAnimationWhenKeyboardMove(float,float);
	void setMaxLength(int);
	void setPosition(cocos2d::CCPoint const&);
	void getMaxLength(void);
	void doAnimationWhenKeyboardMove(float, float);
	void setPlaceHolder(char const*);
	void setInputFlag(cocos2d::extension::EditBoxInputFlag);
	void setContentSize(cocos2d::CCSize const&);
	void setFontColor(cocos2d::_ccColor3B const&);
	void openKeyboard(void);
	void closeKeyboard(void);
	void setPlaceholderFontColor(cocos2d::_ccColor3B const&);
	void setText(char const*);
	void isEditing(void);
	void visit(void);
	void getText(void);
}
#endif