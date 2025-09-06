# adsp-pl0

Transcription (and conversion to current Free Pascal code) of the PL0 compiler and interpreter presented in 1976 by Niklaus Wirth in his book *Algorithms + Data Structures = Programs*

The inclusion of source code from Wirth's book is believed to comply with fair use guidelines.

The grammar is available in [docs/PL-0 Grammar.txt](docs/PL-0%20Grammar.txt). As explained in the grammar, some symbols that were available in the CDC 6000 computer used by Wirth had to be replaced by ASCII characters in the conversion to Free Pascal.

The [example](examples/mdgdc.pl0) PL0 program is from the same book, Chapter 5, Page 310-311.

The .pp files are textual representations of the algorithms as presented in the book, and the .pas files are the conversions to Free Pascal code, including changing some symbols to ASCII alternatives, adding some minor changes, printing of debugging information, etc.

There are three increasingly refined version of the parser:

- The first one [pl054/PL054.pp](pl054/PL054.pp) is just a simple validator.
- The second one [pl055/PL055.pp](pl055/PL055.pp) is the previous parser with enhanced error detection and recovery.
- Work in progress

To compile the examples:

 `fpc .\pl054\PL054.pas`
  
And to run the examples:

`.\pl054\PL054.exe .\examples\mdgdc.pl0`
