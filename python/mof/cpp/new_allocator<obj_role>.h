#ifndef MOF_NEW_ALLOCATOR<OBJ_ROLE>_H
#define MOF_NEW_ALLOCATOR<OBJ_ROLE>_H

class new_allocator<obj_role>{
public:
	void construct(obj_role*,obj_role const&);
}
#endif