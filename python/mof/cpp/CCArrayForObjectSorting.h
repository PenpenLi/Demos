#ifndef MOF_CCARRAYFOROBJECTSORTING_H
#define MOF_CCARRAYFOROBJECTSORTING_H

class CCArrayForObjectSorting{
public:
	void objectWithObjectID(uint);
	void insertSortedObject(cocos2d::extension::CCSortableObject *);
	void objectWithObjectID(unsigned int);
	void removeSortedObject(cocos2d::extension::CCSortableObject *);
	void ~CCArrayForObjectSorting();
	void indexOfSortedObject(cocos2d::extension::CCSortableObject	*);
}
#endif