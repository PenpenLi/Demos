//
//  Hole.cpp
//  Billiard++
//
//  Created by Xiaobin Li on 2/2/15.
//
//

#include "Hole.h"
#include "Config.h"

const float Hole::R = HOLE_R;
const float Hole::D = 2*HOLE_R;

Hole::Hole(int id_) : holeId(id_) {
    // todo: hole pos and aim pos
}

Hole::~Hole() {
}
