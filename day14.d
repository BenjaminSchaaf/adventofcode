import std.array;
import std.stdio;
import std.format;
import std.typecons;
import std.algorithm;

const fileName = "day14.txt";
const raceTime = 2503;

struct Reindeer{
    string name;
    uint speed, duration, restTime;
}

void main() {
    auto file = File(fileName);
    auto reindeers = file.byLine().map!readReindeer().array;

    writeln("Furthest = ", reindeers.map!(a => a.getDistance(raceTime)).reduce!max);
    writeln("Scorest = ", reindeers.getScores(raceTime).values.reduce!max);
}

auto readReindeer(char[] input) {
    Reindeer deer;
    formattedRead(input, "%s can fly %s km/s for %s seconds, but then must rest for %s seconds",
                  &deer.name, &deer.speed, &deer.duration, &deer.restTime);
    return deer;
}

auto getScores(Reindeer[] deers, uint time) {
    int[Reindeer] points;
    foreach (deer; deers) points[deer] = 0;

    foreach (second; 1..time) {
        auto furthest = deers.map!(a => a.getDistance(second)).reduce!max;
        auto leaders = deers.filter!(a => a.getDistance(second) == furthest);
        foreach (leader; leaders) points[leader]++;
    }

    return points;
}

unittest {
    auto comet = Reindeer("Comet", 14, 10, 128);
    auto dancer = Reindeer("Dancer", 16, 11, 162);

    auto scores = [comet, dancer].getScores(1000);
    assert(scores[comet] == 287);//312);
    assert(scores[dancer] == 713);//689);
}

auto getDistance(Reindeer deer, uint time) {
    auto cycleTime = deer.duration + deer.restTime;
    auto extra = deer.speed * deer.duration;
    if (time % cycleTime < deer.duration) {
        extra = (time % cycleTime) * deer.speed;
    }
    return (time / cycleTime) * deer.speed * deer.duration + extra;
}

unittest {
    auto comet = Reindeer("Comet", 14, 10, 128);
    assert(comet.getDistance(1000) == 1120);

    auto dancer = Reindeer("Dancer", 16, 11, 162);
    assert(dancer.getDistance(1000) == 1056);


}
