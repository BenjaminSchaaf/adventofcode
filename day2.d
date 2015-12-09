import std.stdio;
import std.format;
import std.algorithm;

const fileName = "day2.txt";

void main() {
    auto file = File(fileName);
    writefln("paper needed: %d", file.byLine()
                                     .map!readSize
                                     .map!getPaper
                                     .sum());
    file.seek(0);
    writefln("ribbon needed: %d", file.byLine()
                                      .map!readSize
                                      .map!getRibbon
                                      .sum()
                                      );
}

auto readSize(char[] text) {
    uint[3] size;
    formattedRead(text, "%dx%dx%d", &size[0], &size[1], &size[2]);
    return size;
}

auto getPaper(uint[3] s) {
    auto sides = [s[0]*s[1], s[0]*s[2], s[1]*s[2]];
    return sum(map!"a*2"(sides)) + reduce!"min(a, b)"(sides);
}

auto getRibbon(uint[3] size) {
    auto maxSide = size.reduce!"max(a, b)";
    auto maxIndex = size.dup.countUntil(maxSide);
    return 2*size.dup.remove(maxIndex).sum() + reduce!"a * b"(size);
}
