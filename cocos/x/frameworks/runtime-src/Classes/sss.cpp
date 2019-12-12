
#include <cassert>
#include <cstdint>

#include "cocos2d.h"
using namespace cocos2d;

// clang-format off
static uint8_t key[] = {
    0x11, 0x2B, 0x65, 0x78, 0x17, 0xC, 0xD, 0x13, 0x15,
    0x35, 0x62, 0x6F, 0x7B, 0x62, 0x15, 0x7F, 0x11, 0x2C,
    0x63, 0x17, 0x16, 0x57, 0xC, 0x59, 0xB, 0x20, 0x65,
    0x21, 0x20, 0x63, 0xC, 0x7F, 8, 0, 0, 0
};
static const int key_len = 0x21;
// clang-format on

//lua1 55 46 00 01 0D 0E 7A 1C 70 40 43 67 64 32 49 2B
//lua2 55 46 00 01 10 3C 01 69 3A 3B 7A 21 74 26 0D 48
//png1 55 46 00 02 0A 7F 11 2E 63 17 16 57 0C 5A 7D 04
//png2 55 46 00 02 0E 17 16 55 0C 59 0B 20 65 31 20 57
static int dec(uint8_t* data, size_t len, int* unknown_0, int* unknown_100, size_t* out_len)
{
    if (len < 4) {
        CCLOG("data len < 4, len=%d", len);
        return -1;
    }

    if (data[0] != 'U' || data[1] != 'F') {
        return -2;
    }

    if (data[2] == 'O') {
        *unknown_100 = data[3];
        *unknown_0 = data[4];
    } else {
        *unknown_0 = data[2];
    }

    auto ver = data[3];
    if (ver == 1) {
        auto offset = data[4];
        auto real_len = len - 5;
        for (auto i = 0; i < real_len; ++i) {
            data[i] = data[i + 5] ^ key[(i + offset) % key_len];
        }
        *out_len = real_len;
    } else if (ver == 2) {
        auto offset = data[4];
        auto real_len = len - 5;
        for (auto j = 0; j < 5; ++j) {
            data[j] = data[j + real_len] ^ key[(j + offset) % key_len];
        }
        auto v5 = len - 10;
        if (len - 10 > 95) {
            v5 = 95;
        }
        for (auto k = 5; k < v5 + 5; ++k) {
            data[k] ^= key[(k + offset) % key_len];
        }
        *out_len = real_len;
    } else {
        CCLOG("unknow ver %d", ver);
        assert(false);
    }

    return 0;
}

void dec_sss()
{
    //std::vector<std::string> files;
    //GameBase::ListFiles("sss/src", files);
    //for (auto& file : files) {
    //    auto content = GameBase::ReadFile(file);
    //    auto data = (uint8_t*)content.c_str();
    //    int len = content.size();
    //    int unknown_0 = 0;
    //    int unknown_100 = 100;
    //    if (dec_lua(data, len, &unknown_0, &unknown_100, &len) == 0) {
    //        content.resize(len);
    //        std::cout << "dec " << file << std::endl;
    //        GameBase::WriteFile(file, content);
    //    }
    //}

    auto fu = FileUtils::getInstance();

    {
        auto in = fu->fullPathForFilename("sss/main.lua");
        auto out = fu->fullPathFromRelativeFile("main_out.lua", in);
        auto content = fu->getStringFromFile(in);
        auto data = (uint8_t*)content.c_str();
        auto len = content.size();
        int unknown_0 = 0;
        int unknown_100 = 100;
        if (dec(data, len, &unknown_0, &unknown_100, &len) == 0) {
            content.resize(len);
            fu->writeStringToFile(content, out);
        }
    }

    {
        auto in = fu->fullPathForFilename("sss/bg_fenxiang.png");
        auto out = fu->fullPathFromRelativeFile("bg_fenxiang_out.png", in);
        auto content = fu->getStringFromFile(in);
        auto data = (uint8_t*)content.c_str();
        auto len = content.size();
        int unknown_0 = 0;
        int unknown_100 = 100;
        if (dec(data, len, &unknown_0, &unknown_100, &len) == 0) {
            Image img;
            if (img.initWithImageData(data, len)) {
                img.saveToFile(out);
            } else {
                CCLOG("ERROR %s", in.c_str());
            }
        }
    }

    //DescriptorPool ns_dp;
    //extern bool build_pb_file(const std::string& file, DescriptorPool& dp, bool enc = true);
    //if (build_pb_file("sss/allProtos.pb", ns_dp, false)) {
    //    ns_dp.ForEach([](auto& name, auto discriptor) {
    //        std::ofstream of(std::string("nslm/proto/") + name);
    //        std::cout << "proto " << name << std::endl;
    //        auto pb = discriptor->DebugString();
    //        of.write(pb.c_str(), pb.size());
    //    });
    //}
}