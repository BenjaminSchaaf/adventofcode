import std.stdio;
import std.array;
import std.format;
import std.algorithm;

class Node {
    bool visited = false;
    uint[Node] neighbours;
}

const fileName = "day9.txt";

void main() {
    Node[string] graph;

    auto file = File(fileName);
    file.byLine().each!(a => graph.populate(a));

    writefln("Shortest path: %d", bruteForce!min(graph));
    writefln("Longest path: %d", bruteForce!max(graph));
}

void populate(ref Node[string] graph, char[] str) {
    string from, to;
    uint distance;
    formattedRead(str, "%s to %s = %s", &from, &to, &distance);

    if (from !in graph) graph[from] = new Node();
    if (to !in graph) graph[to] = new Node();

    graph[from].neighbours[graph[to]] = distance;
    graph[to].neighbours[graph[from]] = distance;
}

uint bruteForce(alias filter)(Node[string] graph) {
    return graph.values.map!(a => bruteForce!filter(graph, a)).reduce!filter;
}

uint bruteForce(alias filter)(Node[string] graph, Node start) {
    start.visited = true;
    auto shortest = 0;
    auto visitableNeighbours = start.neighbours.keys.filter!(a => !a.visited).array;
    if (visitableNeighbours.length > 0) {
        shortest = visitableNeighbours.map!(a => start.neighbours[a] + bruteForce!filter(graph, a)).reduce!filter;
    }
    start.visited = false;
    return shortest;
}
