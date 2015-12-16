import std.stdio;
import std.range;
import std.format;
import std.algorithm;

const fileName = "day13.txt";

void main() {
    auto happinessMap = File(fileName).readHappiness();

    writeln("d/h = ", happinessMap.calculateHappiest());

    foreach (person; happinessMap.keys) {
        happinessMap["self"][person] = happinessMap[person]["self"] = 0;
    }

    writeln("d/h with self = ", happinessMap.calculateHappiest());
}

auto readHappiness(File file) {
    long[string][string] happinessMap;

    foreach (line; file.byLine()) {
        string fromPerson, toPerson, gainLose;
        long deltaHappiness;
        formattedRead(line, "%s would %s %s happiness units by sitting next to %s.",
                      &fromPerson, &gainLose, &deltaHappiness, &toPerson);

        if (gainLose == "lose") deltaHappiness = -deltaHappiness;

        happinessMap[fromPerson][toPerson] = deltaHappiness;
    }

    return happinessMap;
}

auto calculateHappiest(long[string][string] happinessMap) {
    string[] table = happinessMap.keys;
    return table.permutations
                .map!(t => t.enumerate
                            .map!(p => getHappiness(p[0], t.array, happinessMap))
                            .sum())
                .reduce!max;
}

auto getHappiness(long index, string[] table, long[string][string] happinessMap) {
    auto person         = table[index];
    auto leftNeighbour  = table[(index - 1).rem(cast(long)$)];
    auto rightNeighbour = table[(index + 1).rem(cast(long)$)];
    return happinessMap[person][leftNeighbour] + happinessMap[person][rightNeighbour];
}

// F*cking modulus returning negative values
auto rem(long a, long b) {
    while (a < 0) a += b;
    return a % b;
}
