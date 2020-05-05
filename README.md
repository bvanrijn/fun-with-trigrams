# fun-with-trigrams

**fun-with-trigrams** is a program that lets you, well, have fun with trigrams.
(I know, right?)

It's my solution to [Kata14: Tom Swift Under the Milkwood][0],
written in about a hundred lines of D. The algorithm could be improved, but it
seems to work pretty well.

Some things that I want to work on next:

- Refactoring the code into smaller, testable functions
- Improving coverage (currently: 56%)
- Writing documentation
- Reducing memory usage
- Making it faster

If you come accross this repo, read my code and see something that could be
improved, please feel free to open an issue let me know! This is my first
full-sized D program and it would be an great if you could review my code.

## Usage

You can use it in one of two ways:

### `rdmd fun_with_trigrams.d file.txt`

This will read the contents of `file.txt` and generate new text based on it:

```
$ wget -qO alice-in-wonderland.txt https://www.gutenberg.org/files/11/11-0.txt
$ rdmd fun_with_trigrams.d alice-in-wonderland.txt
Hatter trembled so, that Alice had begun to think this a very grave voice
“until all the arches are gone from this morning,” said Alice a little shaking
among the trees, a little anxiously. “Yes,” said Alice in a melancholy tone: “it
doesn’t seem to come before that!” “Call the first verse,” said the King.
“Nothing whatever,” said Alice. “Oh, don’t talk about cats or dogs either, if
you were me?” “Well, perhaps you were or might have been ill.” “So they were,”
said the King, looking round the neck of the mushroom, and raised herself to
some tea and bread-and-butter, and went on without attending to her; “but those
serpents! There’s no pleasing them!” Alice was only sobbing,” she thought, and
looked at Alice, as the hall was very glad she had never done such a thing.
After a while she remembered trying to make the arches. The chief difficulty
Alice found at first she would get up and to wonder what Latitude or Longitude
either, but thought they
```

The path argument is optional, which brings us to…

### `rdmd fun_with_trigrams.d`

This mode allows you to generate new text interactively.

(**ProTip!** this command works best with `rlwrap`.)

```
$ rdmd fun_with_trigrams.d
>> I wish I may I wish I might
I may I wish I may I wish I might
```

[0]: http://codekata.com/kata/kata14-tom-swift-under-the-milkwood/
