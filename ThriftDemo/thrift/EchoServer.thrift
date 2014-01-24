enum PacketType {
    PacketTypeCmd = 0,
    PacketTypeData
}

struct packet {
    1: required PacketType type,
    2: required i32 len,
    3: binary data
}

service server {
    string echo(1:string msg),
}
