void main(string[] args)
{
    import std.stdio : writeln;
    import std.format : format;

    switch (args.length)
    {
    case 1:
        repl();
        break;
    case 2:
        auto path = args[1];

        writeln(fromFile(path));
        break;
    default:
        writeln("Usage: %s [path]".format(args[0]));
    }
}

string fromFile(string path)
{
    import std.file : readText;

    auto text = readText(path);
    auto trigrams = generateTrigrams(text);

    return generateNewText(trigrams);
}

void repl()
{
    import std.stdio : write, writeln, stdin;

    while (true)
    {
        write(">> ");
        auto line = stdin.readln();

        if (line == null)
        {
            break;
        }

        auto trigrams = generateTrigrams(cast(string) line);

        writeln(generateNewText(trigrams));
    }
}

/// Returns true if associative array aa contains key.
bool containsKey(V, K)(V[K] aa, K key)
{
    return (key in aa) !is null;
}

///
unittest
{
    assert(["foo": 123].containsKey("foo"));
    assert(["foo": null].containsKey("foo"));
}

/// Splits s on whitespace.
string[] splitOnWhitespace(string s)
{
    import std.algorithm : filter;
    import std.array : array, split;
    import std.uni : isWhite;

    return s.split!isWhite().filter!(word => word != "").array();
}

///
unittest
{
    assert(splitOnWhitespace("Hello, World!") == ["Hello,", "World!"]);
}

/// Generates an associative array containing the trigrams of text.
string[][string] generateTrigrams(string text)
{
    import std.format : format;

    auto words = text.splitOnWhitespace();
    string[][string] trigrams;

    for (auto i = 0; i < words.length - 2; i++)
    {
        auto word = words[i];
        auto nextWord = words[i + 1];
        auto nextNextWord = words[i + 2];

        auto key = "%s %s".format(word, nextWord);

        if (!trigrams.containsKey(key))
        {
            trigrams[key] = [];
        }

        trigrams[key] ~= nextNextWord;
    }

    return trigrams;
}

///
unittest
{
    string[][string] trigrams = generateTrigrams("I wish I may I wish I might");
    string[][string] expectedTrigrams = [
        "I wish" : ["I", "I"], "wish I" : ["may", "might"], "may I" : ["wish"],
        "I may" : ["I"],
    ];

    assert(trigrams == expectedTrigrams);
}

/// The maximum length of the output of `generateNewText`.
enum maxLength = 1000;

/// Generates new text based on trigrams, not exceeding maxLength.
string generateNewText(string[][string] trigrams, uint maxLength = maxLength)
{
    import std.random : choice;
    import std.array : join;

    auto newText = choice(trigrams.keys);

    while (newText.length < maxLength)
    {
        auto lastTwoWords = newText.splitOnWhitespace()[$ - 2 .. $].join(" ");

        if (!trigrams.containsKey(lastTwoWords))
        {
            break;
        }

        newText ~= " " ~ choice(trigrams[lastTwoWords]);
    }

    return newText;
}

///
unittest
{
    string[][string] trigrams = generateTrigrams("I wish I may I wish I might");

    assert(generateNewText(trigrams).length <= maxLength);
}
