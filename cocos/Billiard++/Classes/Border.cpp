//
//  Border.cpp
//  Billiard++
//
//  Created by Xiaobin Li on 1/29/15.
//
//

#include "Border.h"
#include "cocos2d.h"

USING_NS_CC;

Border::Border(int id_) : _borderId(id_), _type((Type)id_) {
    auto size = Director::getInstance()->getWinSize();
    
    // todo: border type
    switch (_type) {
        case Type::LEFT: //left
            _line = Line(Vec2(0, 0), Vec2(0, size.height));
            _normal = Vec2(1, 0);
            break;
        case Type::RIGHT: //right
            _line = Line(Vec2(size.width, 0), Vec2(size.width, size.height));
            _normal = Vec2(-1, 0);
            break;
        case Type::TOP: // top
            _line = Line(Vec2(0, size.height), Vec2(size.width, size.height));
            _normal = Vec2(0, -1);
            break;
        case Type::BOTTOM: // bottom
            _line = Line(Vec2(0, 0), Vec2(size.width, 0));
            _normal = Vec2(0, 1);
            break;
        default:
            break;
    }
}

Border::~Border() {
    
}

float Border::getCoord() {
    float result = 0.f;
    switch (_type) {
        case Type::LEFT: //left
        case Type::RIGHT: //right
            result = _line.a.x;
            break;
        case Type::TOP: // top
        case Type::BOTTOM: // bottom
            result = _line.a.y;
            break;
        default:
            break;
    }
    return result;
}
