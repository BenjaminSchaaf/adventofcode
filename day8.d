import std.ascii;
import std.math;
import std.conv;
import std.stdio;
import std.algorithm;

const fileName = "day8.txt";

void main() {
    auto file = File(fileName);

    writefln("char diff = %d", file.byLine().map!codeStringDiff.sum());

    file.seek(0);
    writefln("char diff 2 = %d", file.byLine().map!stringCodeDiff.sum());
}

auto codeStringDiff(char[] str) {
    return str.length - decode(str[1..$-1]).length;
}

auto stringCodeDiff(char[] str) {
    return encode(str).length - str.length + 2;
}

// F*ckin D doesn't have this in the stdlib
auto decode(char[] str) {
    string decoded = "";

    for (auto i = 0; i < str.length;) {
        auto chr = str[i++];

        if (chr == '\\') {
            switch (str[i++]) {
                case '\\':
                    decoded ~= '\\';
                    break;
                case '"':
                    decoded ~= '"';
                    break;
                case 'x':
                    decoded ~= cast(char)hexString(str[i..i+2]);
                    i += 2;
                    break;
                default:
                    assert(false);
            }
        } else {
            decoded ~= chr;
        }
    }
    return decoded;
}

auto encode(char[] str) {
    string encoded = "";

    foreach (chr; str) {
        switch (chr) {
            case '\\':
                encoded ~= `\\`;
                break;
            case '"':
                encoded ~= `\"`;
                break;
            default:
                encoded ~= chr;
        }
    }
    return encoded;
}

// D also doesn't have non-templated hex conversion *sigh*
auto hexString(char[] str) {
    auto hex = 0;

    foreach_reverse (index, chr; str) {
        auto power = pow(16, str.length - index - 1);

        if (chr.isDigit) {
            hex += power * to!int(chr);
        } else {
            hex += power * cast(int)chr.toLower() - cast(int)'a';
        }
        power++;
    }

    return hex;
}
