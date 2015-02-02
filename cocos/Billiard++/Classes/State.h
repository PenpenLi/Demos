//
//  State.h
//  Billiard++
//
//  Created by Xiaobin Li on 1/31/15.
//
//

#ifndef __Billiard____State__
#define __Billiard____State__

class State {
public:
    State(){
    }
    
    virtual ~State() {
    }
    
    virtual void Exec(float dt)   = 0;
    virtual void Enter()  = 0;
    virtual void Exit()   = 0;
};

#endif /* defined(__Billiard____State__) */
