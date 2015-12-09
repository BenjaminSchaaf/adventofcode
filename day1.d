import std.file;
import std.stdio;
import std.algorithm;

const fileName = "day1.txt";

void main() {
    string data = readText(fileName);

    long floor = 0;
    auto foundFirstBasement = false;
    size_t firstBasement = 0;

    foreach (index, characher; data) {
        if (characher == '(') floor++;
        else if (characher == ')') floor--;

        if (!foundFirstBasement && floor < 0) {
            firstBasement = index;
            foundFirstBasement = true;
        }
    }
    writefln("floor: %d", floor);
    writefln("firstBasement: %d", firstBasement + 1);
}
