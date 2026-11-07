After downloading all files, the archimate_to_asp.py script can be executed with as an argument either the vc.xml or tc.xml files. This will generate a vc.lp or tc.lp ASP scipt respectively.
These scripts can be combined with the vc_rules.lp or tc_rules.lp respectively.
The resulting .lp files can be solved by an ASP parser. 

For the purpose of this study the following ASP Parser has been used:
clingo version 5.8.0
Address model: 64-bit

libclingo version 5.8.0
Configuration: with Python 3.12.9, without Lua

libclasp version 3.4.0 (libpotassco version 1.2.0)
Configuration: WITH_THREADS=1
Copyright (C) Benjamin Kaufmann

License: The MIT License <https://opensource.org/licenses/MIT>

