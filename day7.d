// rdmd -I~/.dub/packages/pegged-0.2.1/ day7.d

import std.conv;
import std.stdio;
import std.array;
import std.algorithm;

import pegged.grammar;

mixin(grammar(`
Circuit:
    Wire < (BinaryOperation / UnaryOperation / Value) "->" Variable
    Number < ~([0-9]+)
    Variable <- identifier
    Value < Number / Variable
    BinaryOperators < "AND" / "OR" / "LSHIFT" / "RSHIFT"
    UnaryOperators < "NOT"
    BinaryOperation < Value BinaryOperators Value
    UnaryOperation < UnaryOperators Value
`));

const fileName = "day7.txt";

void main() {
    auto file = File(fileName);
    auto instructions = file.byLine().map!(a => Circuit(cast(string)a)).array;

    ushort[string] namespace;
    runInstructions(instructions, namespace);

    auto a = namespace["a"];
    writefln("a = %d", a);

    namespace = ["b": a];
    runInstructions(instructions, namespace);
    writefln("new a = %d", namespace["a"]);
}

class ValueError : object.Error {
    this() {
        super("");
    }
}

void runInstructions(ParseTree[] instructions, ref ushort[string] namespace) {
    while (true) {
        ParseTree[] oldInstructions = [];

        foreach (instruction; instructions) {
            try {
                auto wire = instruction.children[0];
                auto value = parseOperation(wire.children[0], namespace);
                auto variable = wire.children[1];
                // Only assign if it doesn't already exist. allows for overrides
                if (variable.matches[0] !in namespace) {
                    namespace[variable.matches[0]] = value;
                }
            } catch (ValueError e) {
                oldInstructions ~= instruction;
            }
        }

        if (oldInstructions.length == 0) break;
        instructions = oldInstructions;
    }
}

ushort parseOperation(ParseTree tree, ref ushort[string] namespace) {
    const (ushort delegate(ushort, ushort))[string] binaryOperations = [
        "AND": (a, b) => a & b,
        "OR":  (a, b) => a | b,
        "LSHIFT": (a, b) => cast(ushort)(a << b),
        "RSHIFT": (a, b) => a >> b,
    ];

    const (ushort delegate(ushort))[string] unaryOperations = [
        "NOT": (a) => ~a,
    ];

    if (tree.name == "Circuit.BinaryOperation") {
        auto lhs = parseValue(tree.children[0], namespace);
        auto rhs = parseValue(tree.children[2], namespace);
        return binaryOperations[tree.children[1].matches[0]](lhs, rhs);
    } else if (tree.name == "Circuit.UnaryOperation") {
        auto value = parseValue(tree.children[1], namespace);
        return unaryOperations[tree.children[0].matches[0]](value);
    }

    return parseValue(tree, namespace);
}

ushort parseValue(ParseTree tree, ref ushort[string] namespace) {
    assert(tree.name == "Circuit.Value");
    tree = tree.children[0];

    if (tree.name == "Circuit.Variable") {
        if (tree.matches[0] !in namespace) {
            throw new ValueError();
        }
        return namespace[tree.matches[0]];
    } else {
        return to!ushort(tree.matches[0]);
    }
}

unittest {
    auto instructions = [
        "NOT x -> h",
        "456 -> y",
        "y RSHIFT 2 -> g",
        "x OR y -> e",
        "x AND y -> d",
        "123 -> x",
        "NOT y -> i",
        "x LSHIFT 2 -> f",
    ].map!Circuit.array;

    ushort[string] namespace;
    runInstructions(instructions, namespace);

    const results = [
        "d": 72,
        "e": 507,
        "f": 492,
        "g": 114,
        "h": 65412,
        "i": 65079,
        "x": 123,
        "y": 456,
    ];

    foreach (name, result; results) {
        assert(namespace[name] == result);
    }
}
