import std.file;
import std.json;
import std.stdio;
import std.algorithm;

const fileName = "day12.txt";

void main() {
    JSONValue json = readText(fileName).parseJSON();

    writefln("json sum: %d", sumJSON(json));
    writefln("json sum ignoring red: %d", sumJSON(json, "red"));
}

long sumJSON(JSONValue json, string ignore = "") {
    alias mapIgnore = map!(a => sumJSON(a, ignore));
    if (json.type == JSON_TYPE.ARRAY) {
        return mapIgnore(json.array).sum();
    } if (json.type == JSON_TYPE.OBJECT) {
        auto stringValues = json.object.values.filter!(a => a.type == JSON_TYPE.STRING);
        if (canFind(stringValues.map!(a => a.str), ignore)) return 0;

        return mapIgnore(json.object.values).sum();
    } if (json.type == JSON_TYPE.INTEGER) {
        return json.integer;
    } return 0;
}
