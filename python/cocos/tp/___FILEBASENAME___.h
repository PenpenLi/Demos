#ifndef _____PROJECTNAME________FILEBASENAME_____
#define _____PROJECTNAME________FILEBASENAME_____

#include "cocos2d.h"
#include "ui/CocosGUI.h"

using cocos2d::Node;

class ___FILEBASENAME___ : public Node
{
public:
	CREATE_FUNC(___FILEBASENAME___);

	virtual bool init() override;

	virtual void onEnter() override;

	virtual void onExit() override;

CC_CONSTRUCTOR_ACCESS:
	___FILEBASENAME___();
	~___FILEBASENAME___();

private:

	void setupUI();
};

#endif /* defined(_____PROJECTNAME________FILEBASENAME_____) */
