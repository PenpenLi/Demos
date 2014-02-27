enum PacketType {
    PacketTypeCmd = 0,
    PacketTypeData
}

struct Packet {
    1: required PacketType type,
    2: required i32 len,
    3: required binary data
}

service EchoServer {

    string Echo(1:string msg),

    Packet SendPacket(1:Packet p),

    string HelloString(1:string para),

    i32 HelloInt(1:i32 para),

    bool HelloBool(1:bool para),

    i64 HelloInt64(1:i64 para),

    void HelloVoid(),

    string HelloNull()
}
