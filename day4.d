import std.conv;
import std.stdio;
import std.range;
import std.algorithm;
import std.digest.md;

const secret = "ckczppom";

void main() {
    writefln("mined with 5 zeros: %d", findSecret([0x00, 0x00, 0x0F]));
    writefln("mined with 6 zeros: %d", findSecret([0x00, 0x00, 0x00]));
}

auto findSecret(ubyte[] mask) {
    for (auto i = 0;; i++) {
        auto md5sum = md5Of(secret ~ to!string(i));

        if (all!"(a[0] & a[1]) == a[0]"(zip(md5sum.dup, mask))) {
            return i;
        }
    }
}
