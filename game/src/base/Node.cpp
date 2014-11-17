//
//  Node.cpp
//  game
//
//  Created by Xiaobin Li on 9/19/14.
//
//

#include "Node.h"

namespace XL {
    
    uint64_t Node::m_nextId = 0;
    
    void Node::SetId(uint64_t val) {
        m_id = val;
    }
    
    uint64_t Node::Id() const {
        return m_id;
    }
    
    Node::Node(uint64_t val) {
        SetId(val);
    }
    
    Node::~Node() {
        
    }
}
