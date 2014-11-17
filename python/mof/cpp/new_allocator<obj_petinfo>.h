#ifndef MOF_NEW_ALLOCATOR<OBJ_PETINFO>_H
#define MOF_NEW_ALLOCATOR<OBJ_PETINFO>_H

class new_allocator<obj_petinfo>{
public:
	void construct(obj_petinfo*,obj_petinfo const&);
}
#endif