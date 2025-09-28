# Examples

The example PL0 programs follow the format expected by the compiler, they are ALL CAPS, comments are not supported by the lexer and, remarkably, the READ and WRITE statements are not supported.

Besides, some symbols that were available in the CDC 6000 computer used by Wirth were replaced by suitable ASCII characters, as follows:

- "≠" replaced by "#"
- "≤" replaced by "{"
- "≥" replaced by "}"

The **mdgdc** example is from the same A + DS = P book, Chapter 5, Page 310-311.

The other examples are in original form in my other PL/0 compiler project [dpl0c](https://github.com/dtoffe/dpl0c), they were adapted to this implementation, since the PL/0 compiler in Wirth's book includes special characters as explained before, the PL/0 source code is assumed in ALL CAPS and does not support read and write statements.

The **square** and **primes** examples are from the [PL/0](https://en.wikipedia.org/wiki/PL/0) page on Wikipedia.

The **nested** and **recursive** examples were found in this [PL/0 User Manual](https://github.com/addiedx44/pl0-compiler/blob/master/doc/PL0%20User's%20Manual.pdf) by Adam Dunson.

Besides the changes I made to the grammar as explained earlier, I had to apply these modifications to the source code of the examples in Adam's User Manual to agree with the grammar of this implementation:

- No "else"" in "if" statements.
- Semicolon is a statement separator, not a finalizer.
- Replace "in" and "out" by "read" and "write".
- Use "#" instead of "<>" for not-equal.
- Use "var" to declare variables, instead of "int".
