# adsp-pl0

Transcription (and conversion to current Free Pascal code) of the PL0 compiler and interpreter presented in 1976 by Niklaus Wirth in his book *Algorithms + Data Structures = Programs*

The inclusion of source code from Wirth's book is believed to comply with fair use guidelines.

I'm doing this to understand better the code generation mechanism, by generating it for different PL0 example programs and studying the generated pcode instructions corresponding to the PL0 statements and declarations.

The grammar is available in [docs/PL-0 Grammar.txt](docs/PL-0%20Grammar.txt). As explained in the grammar, some symbols that were available in the CDC 6000 computer used by Wirth had to be replaced by ASCII characters in the conversion to Free Pascal.

The .pp files are textual representations of the algorithms as presented in the book, and the .pas files are the conversions to Free Pascal code, including changing some symbols to ASCII alternatives, adding some minor changes, printing of debugging information, etc.

There are three increasingly refined version of the parser:

- The first one [pl054/PL054.pp](pl054/PL054.pp) is just a simple grammar validator.
- The second one [pl055/PL055.pp](pl055/PL055.pp) is the previous parser with enhanced error detection and recovery.
- The third one [pl056/PL056.pp](pl056/PL056.pp) adds code generation for the PL0 virtual machine, and the procedure for interpreting that intermediate code.

Then I modified the 5.6 parser so that the compiler and the interpreter are two separated programs, the compiler emit the generated code to a text file, and the interpreter reads that file and executes the code.

To build the compiler and the interpreter:

 `fpc .\compiler.pas`

 `fpc .\interpreter.pas`
  
And to run the examples (Windows example, not tested on Linux, but it should work fine):

`.\compiler.exe .\examples\mdgdc.pl0`

Compiles the PL0 program in the file `mdgdc.pl0` and generates the corresponding intermediate code in the file `mdgdc.pcode`.

`.\interpreter.exe .\examples\mdgdc.pcode`

Loads the intermediate code in the file `mdgdc.pcode` and executes (interprets) it.

There is an [examples README](examples/README.md) describing all the examples available and where they come from. I included the generated intermediate code corresponding to each example.
