import std.conv;
import std.stdio;
import std.algorithm;

S lookAndSay(S)(S str) {
    return str.group().map!(a => a[1].to!S ~ a[0].to!S).reduce!"a~b";
}

unittest {
    assert(lookAndSay("1") == "11");
    assert(lookAndSay("11") == "21");
    assert(lookAndSay("21") == "1211");
    assert(lookAndSay("1211") == "111221");
    assert(lookAndSay("111221") == "312211");
}

const seed = "3113322113";

void main() {
    string str = seed;
    foreach (_; 0..40) str = lookAndSay(str);
    writefln("I say %d numbers", str.length);
    foreach (_; 0..10) str = lookAndSay(str);
    writefln("Then %d numbers", str.length);
}
