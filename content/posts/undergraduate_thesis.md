+++
date = "2005-01-01T21:49:10+01:00"
draft = false
description = "My undergraduate thesis"
keywords = ["decompiler", ""]
title = "LibID for Boomerang"
type = "post"
+++

##### Thesis: A Decompiler Project
A Decompiler is a program that takes executable data as input and generates the corresponding source codes in a high-level language. Useless? No. There are many uses for this process. Viruses/worms analysis, platform migration, recovery of lost source codes and many more.

In my thesis project, I tried to implement a static library detection module for Boomerang project, an open-source (and somehow the only existing and maintained) decompiler.

[Download source code](boomerang_libid.zip) |
[Download thesis documents](A Decompiler Project.doc) |
[Some notes about compiling](compile_libbfd.dll.txt)


Following is some descriptions about the contents of the package:

###### SymbolMatcherFactory

Finds the proper SymbolMatcher for the specified
symbol container file



###### SymbolMatcher

Matches symbols from a symbol container to the executable.
They will search through the executable and use BinaryFile::AddSymbol
whenever they find a match.(what about variables?)
(what about callback functions which are passed as parameter?)
Symbol container can be applied using:

1. LibSigMatcher: Signature of a static library
  This part is used to apply previously generated
  signatures to the executable

2. BfdObjMatcher: A static library, or an object file
  To apply raw object files to the executable
  the object file should be in a BFD compatible
  format. This matcher also has the possiblity
  of detecting variables, the ones that are
  references in between of a detected function.

3. DynLibMatcher: A dynamically linked library
  To apply dynamically linked libraries to the executable,
  ordinally imported functions are named here

4. DbgInfoMatcher(Not sure if it is the right place):
  The executable file itself, or a pdb or ... file.
  to apply any file that can be read using dbghelp(windows specific)


###### SignatureGenerator

Generates signatures for the specified static library,
to be used by LibSigMatcher


###### Workflow

when a (Win32)BinaryFile is loaded, it uses DynLibMatcher
and LibSigMatcher as startup.

LibSigMatcher will match all its signatures against
the code section of the executable, and adds the symbols
whenever a match is found.

DynLibMatcher will read the import section of the
executable and adds the matched symbols.
