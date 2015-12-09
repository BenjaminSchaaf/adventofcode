import std.ascii;
import std.array;
import std.range;
import std.stdio;
import std.format;
import std.typecons;
import std.algorithm;

enum Instruction {
    ON,
    OFF,
    TOGGLE,
}

auto readInstruction(char[] text) {
    uint[2] sCorner, lCorner;
    char[] rangeText = find!isDigit(text);
    formattedRead(rangeText, "%d,%d through %d,%d", &sCorner[0], &sCorner[1],
       &lCorner[0], &lCorner[1]);

    const instructionNames = [
        "n": Instruction.ON,
        " ": Instruction.TOGGLE,
        "f": Instruction.OFF,
    ];

    return tuple(instructionNames[text[6..7]], sCorner, lCorner);
}

const fileName = "day6.txt";

const gridWidth = 1000;
const gridHeight = 1000;

void main() {
    auto file = File(fileName);
    auto instructions = array(file.byLine().map!readInstruction());

    writefln("Lights on: %d", doEnglishInstructions(instructions));
    writefln("Nordic lights on: %d", doNordicInstructions(instructions));
}

auto doEnglishInstructions(T)(T instructions) {
    return doInstructions!bool(instructions, (instr, light) {
        if (instr == Instruction.TOGGLE) {
            return !light;
        }
        return instr == Instruction.ON;
    });
}

auto doNordicInstructions(T)(T instructions) {
    return doInstructions!int(instructions, (instr, light) {
        if (instr == Instruction.ON) {
            return light + 1;
        }
        if (instr == Instruction.TOGGLE) {
            return light + 2;
        }
        if (light > 0) return light - 1;
        return light;
    });
}

auto doInstructions(G, T)(T instructions, G function(Instruction, G) pure fun) {
    G[gridWidth][gridHeight] grid;

    foreach (instr; instructions) {
        auto lower = instr[1];
        auto higher = instr[2];

        foreach (x; lower[0]..higher[0] + 1)
                 foreach (y; lower[1]..higher[1] + 1) {
            grid[x][y] = fun(instr[0], grid[x][y]);
        }
    }

    return grid.dup.map!(a => a.dup.sum()).sum();
}
