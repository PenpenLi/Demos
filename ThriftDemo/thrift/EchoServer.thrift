enum PacketType {
    PacketTypeCmd = 0,
    PacketTypeData
}

struct Packet {
    1: required PacketType type,
    2: required i32 len,
    3: binary data
}

service EchoServer {

    string Echo(1:string msg),

    Packet SendPacket(1:Packet p)
}
