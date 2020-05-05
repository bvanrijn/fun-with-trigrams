enum maxLength = 1000;

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

unittest
{
    import std.algorithm : canFind;

    string text = "I wish I may I wish I might";
    string[][string] trigrams = generateTrigrams(text);
    string[][string] expectedTrigrams = [
        "I wish" : ["I", "I"], "wish I" : ["may", "might"], "may I" : ["wish"],
        "I may" : ["I"],
    ];

    assert(trigrams.keys.length == 4);

    foreach (kv; trigrams.byKeyValue)
    {
        auto key = kv.key;

        assert((key in expectedTrigrams) !is null);

        foreach (value; kv.value)
        {
            assert(expectedTrigrams[key].canFind(value));
        }
    }
}

string[][string] generateTrigrams(string text)
{
    import std.array : split, array;
    import std.format : format;
    import std.uni : isWhite;
    import std.algorithm : filter;

    auto words = text.split!isWhite().filter!(word => word != "").array();
    string[][string] trigrams;

    for (auto i = 0; i < words.length - 2; i++)
    {
        auto word = words[i];
        auto nextWord = words[i + 1];
        auto nextNextWord = words[i + 2];

        auto key = "%s %s".format(word, nextWord);

        if ((key in trigrams) is null)
        {
            trigrams[key] = [];
        }

        trigrams[key] ~= nextNextWord;
    }

    return trigrams;
}

unittest
{
    string[][string] trigrams = generateTrigrams("I wish I may I wish I might");

    assert(generateNewText(trigrams).length <= maxLength);
}

string generateNewText(string[][string] trigrams, uint maxLength = maxLength)
{
    import std.random : choice;
    import std.array : split, join;
    import std.uni : isWhite;

    auto newText = choice(trigrams.keys);

    while (newText.length < maxLength)
    {
        auto lastTwoWords = newText.split!isWhite()[$ - 2 .. $].join(" ");

        if ((lastTwoWords in trigrams) is null)
        {
            break;
        }

        newText ~= " " ~ choice(trigrams[lastTwoWords]);
    }

    return newText;
}
