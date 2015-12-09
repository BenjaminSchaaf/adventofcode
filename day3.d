import std.file;
import std.stdio;
import std.algorithm;

const fileName = "day3.txt";

void main() {
    string instructions = readText(fileName);

    uint[2] santa = [0, 0];
    auto map = doMove(instructions, (move) {
        santa = [santa[0] + move[0], santa[1] + move[1]];
        return santa;
    });
    writefln("santa houses: %d", map.length);

    santa = [0, 0];
    uint[2] robot = [0, 0];
    auto santasMove = false;
    map = doMove(instructions, (move) {
        santasMove = !santasMove;
        if (santasMove) {
            santa = add(santa, move);
            return santa;
        } else {
            robot = add(robot, move);
            return robot;
        }
    });
    writefln("santa houses: %d", map.length);
}

auto doMove(string instructions, uint[2] delegate(uint[2]) fn) {
    const uint[2][char] movementVectors = [
        '>': [1,  0],
        '<': [-1, 0],
        '^': [0,  1],
        'v': [0, -1],
    ];

    uint[uint[2]] map = [[0, 0]: 1];

    foreach (instruciton; instructions) {
        if (instruciton in movementVectors) {
            auto move = movementVectors[instruciton];

            auto coord = fn(move);
            if (coord in map) {
                map[coord]++;
            } else {
                map[coord] = 0;
            }
        }
    }

    return map;
}

uint[2] add(uint[2] a, uint[2] b) {
    return [a[0] + b[0], a[1] + b[1]];
}
