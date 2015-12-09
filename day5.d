import std.file;
import std.stdio;
import std.string;
import std.algorithm;

const vowels = "aeiou";
const badCombinations = ["ab", "cd", "pq", "xy"];

auto isNice(string str) {
    foreach (bad; badCombinations) {
        if (canFind(str, bad)) {
            return false;
        }
    }

    if (findAdjacent(str).length == 0) {
        return false;
    }

    return count!(a => canFind(vowels, a))(str) >= 3;
}

unittest {
    assert(isNice("ugknbfddgicrmopn"));
    assert(isNice("aaa"));
    assert(!isNice("jchzalrnumimnmhp"));
    assert(!isNice("haegwjzuvuyypxyu"));
    assert(!isNice("dvszwmarrgswjxmb"));
}

auto isReallyNice(string str) {
    bool[string] pairs;
    auto paired = false;
    auto repeated = false;

    foreach (index, chr; str) {
        if (!paired && index > 2) {
            pairs[str[index-3..index-1]] = true;
            paired = (str[index-1..index+1] in pairs) != null;
        }

        if (!repeated && index > 1) {
            repeated = str[index-2] == chr;
        }
    }

    return paired && repeated;
}

unittest {
    assert(isReallyNice("qjhvhtzxzqqjkmpb"));
    assert(isReallyNice("xxyxx"));
    assert(!isReallyNice("uurcxstgmygtbstg"));
    assert(!isReallyNice("ieodomkazucvgmuy"));
}

const fileName = "day5.txt";

void main() {
    string data = readText(fileName);

    writefln("Nice words: %d", data.split('\n').count!isNice());
    writefln("Nice words v2: %d", data.split('\n').count!isReallyNice());
}
