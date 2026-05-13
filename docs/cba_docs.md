# CBA Docs Dump

- Index: https://cbateam.github.io/CBA_A3/docs/index/General.html
- Generated (UTC): 2026-02-07T19:07:42.634621+00:00
- Entries: 125

## 1. CBA_fnc_actionArgument

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_actionArgument-sqf.html#CBA_fnc_actionArgument

CBA_fnc_actionArgument
Description
Used to call the code parsed in the addaction argument.
Parameters
Returns
Examples
captive addaction ["rescue",CBA_fnc_actionargument_path,[[],{[_target] join (group _caller)},true]] //captive joins action callers group, action is removed (true)
Author
Rommel

## 2. ADD

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#ADD

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 3. CBA_fnc_addAttachmentCondition

Source: https://cbateam.github.io/CBA_A3/docs/files/accessory/fnc_addAttachmentCondition-sqf.html#CBA_fnc_addAttachmentCondition

CBA_fnc_addAttachmentCondition
Description
Adds condition to be able to switch to an attachment.
Parameters
0: _itemAttachment classname STRING
1: _conditionCode (return false if not allowed) <CODE>

Returns
None
Examples
["ACE_acc_pointer_red", { false }] call CBA_fnc_addAttachmentCondition
Author
PabstMirror

## 4. CBA_fnc_addBackpackCargo

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_addBackpackCargo-sqf.html#CBA_fnc_addBackpackCargo

CBA_fnc_addBackpackCargo
Description
Add backpack(s) to vehicle cargo.
Function which verifies existence of _item and _container, returns false in case of trouble, or when able to add _item to _container true in case of success.
Parameters
_containerthe vehicle <OBJECT>
_itemname of backpack STRING
_countnumber of weapons to add <NUMBER> (Default: 1)
_verifyif true, then put item on the ground if it can’t be added <BOOLEAN>

Returns
true on success, false otherwise <BOOLEAN>
Examples
// Add one laser designator to the cargo of SomeTruck
_result = [SomeTruck, "B_Kitbag_cbr"] call CBA_fnc_addBackpackCargo

// Add two MXC rifles to MyAPC. If the inventory is full, then put the rest on the ground
_result = [MyAPC, "B_Kitbag_cbr", 2, true] call CBA_fnc_addBackpackCargo
Author
commy2

## 5. CBA_fnc_addBinocularMagazine

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_addBinocularMagazine-sqf.html#CBA_fnc_addBinocularMagazine

CBA_fnc_addBinocularMagazine
Description
Adds a magazine to the units rangefinder.
Parameters
_unitA unit <OBJECT>
_magazineThe magazine to add STRING
_ammoAmmo count of the magazine (optional, default: full magazine) <NUMBER>

Returns
None
Examples
player addWeapon "Laserdesignator";
[player, "Laserbatteries"] call CBA_fnc_addBinocularMagazine;
Author
commy2

## 6. CBA_fnc_addBISEventHandler

Source: https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addBISEventHandler-sqf.html#CBA_fnc_addBISEventHandler

CBA_fnc_addBISEventHandler
Description
Adds an event handler with arguments.
Additional arguments are passed as _thisArgs.  The ID is passed as _thisID.
Parameters
_objectThing to attach event handler to.  <OBJECT, CONTROL, DISPLAY>
_typeEvent handler type.  STRING
_functionFunction to add to event.  <CODE>
_argumentsArguments to pass to event handler.  <Any>

Returns
_idThe ID of the event handler.  Same as _thisID <NUMBER>

Examples
// one time fired event handler that removes itself
_id = [player, "fired", {systemChat _thisArgs; player removeEventHandler ["fired", _thisID]}, "bananas"] call CBA_fnc_addBISEventHandler;
Author
commy2

## 7. CBA_fnc_addBISPlayerEventHandler

Source: https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addBISPlayerEventHandler-sqf.html#CBA_fnc_addBISPlayerEventHandler

CBA_fnc_addBISPlayerEventHandler
Description
Adds an engine event handler just to the controlled entity.
Parameters
_keyUnique identifier for the event.  STRING
_eventTypeType of event to add.  Can be any event supported by addEventHandler.  STRING
_eventCodeCode to run when event is raised.  <CODE>
_ignoreVirtualIgnore virtual units (spectators, virtual zeus, UAV RC) [optional] (default: true) <BOOLEAN>

Returns
Event was added <BOOLEAN>
Examples
["TAG_MyFiredNearEvent", "FiredNear", {systemChat str _this}] call CBA_fnc_addBISPlayerEventHandler
Author
PabstMirror

## 8. CBA_fnc_addClassEventHandler

Source: https://cbateam.github.io/CBA_A3/docs/files/xeh/fnc_addClassEventHandler-sqf.html#CBA_fnc_addClassEventHandler

CBA_fnc_addClassEventHandler
Description
Add an eventhandler to a class and all children.
Parameters
0: _classNameThe classname of objects you wish to add the eventhandler too.  Can be a base class.  STRING
1: _eventNameThe type of the eventhandler.  E.g.  “init”, “fired”, “killed” etc.  STRING
2: _eventFuncFunction to execute when event happens.  <CODE>
3: _allowInheritanceAllow event for objects that only inherit from the given classname?  [optional] <BOOLEAN> (default: true)
4: _excludedClassesExclude these classes from this event including their children [optional] ARRAY (default: [])
5: _applyInitRetroactivelyApply “init” event type on existing units that have already been initilized.  [optional] <BOOLEAN> ((default: false)

Returns
_successWhether adding the event was successful or not.  <BOOLEAN>

Examples
["CAManBase", "fired", {systemChat str _this}] call CBA_fnc_addClassEventHandler;
["All", "init", {systemChat str _this}] call CBA_fnc_addClassEventHandler;
["Car", "init", {(_this select 0) engineOn true}, true, [], true] call CBA_fnc_addClassEventHandler; //Starts all current cars and those created later
Author
commy2

## 9. CBA_fnc_addDisplayHandler

Source: https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addDisplayHandler-sqf.html#CBA_fnc_addDisplayHandler

CBA_fnc_addDisplayHandler
Description
Adds an action to the main display.
They are reapplied after loading a save game.  Actions only persist for the mission and are removed after restart.
Parameters
_typeDisplay handler type to attach.  STRING
_codeCode to execute upon event.  <STRING, CODE>

Returns
_idThe ID of the attached handler.  Used to remove with “CBA_fnc_removeDisplayHandler” <NUMBER>

Examples
_id = ["KeyDown", {_this call myKeyDownEH}] call CBA_fnc_addDisplayHandler;
Author
Sickboy, commy2

## 10. CBA_fnc_addEventHandler

Source: https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addEventHandler-sqf.html#CBA_fnc_addEventHandler

CBA_fnc_addEventHandler
Description
Registers an event handler for a specific CBA event.
Parameters
_eventNameType of event to handle.  STRING
_eventFuncFunction to call when event is raised.  <CODE>

Returns
_eventIdUnique ID of the event handler (can be used with CBA_fnc_removeEventHandler).

Examples
_id = ["test", {systemChat str _this}] call CBA_fnc_addEventHandler;
Author
Spooner, commy2

## 11. CBA_fnc_addEventHandlerArgs

Source: https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addEventHandlerArgs-sqf.html#CBA_fnc_addEventHandlerArgs

CBA_fnc_addEventHandlerArgs
Description
Registers an event handler for a specific CBA event with arguments.
A event added with this function will have the following variables defined
_thisArguments passed by function calling the events.  <ANY>
_thisArgsArguments added to event by this function.  <ANY>
_thisIdSame as the return value of this function.  <NUMBER>
_thisTypeName of the event.  (Same as _eventName passed to this function) STRING
_thisFncPiece of code added to the event by this function <CODE>

Parameters
_eventNameType of event to handle.  STRING
_eventFuncFunction to call when event is raised.  <CODE>
_argumentsArguments to pass to event handler.  (optional) <Any>

Returns
_eventIdUnique ID of the event handler (can be used with CBA_fnc_removeEventHandler).

Examples
["test1", {
    systemChat str _thisArgs;
    [_thisType, _thisId] call CBA_fnc_removeEventHandler
}, "hello world"] call CBA_fnc_addEventHandlerArgs;

"test1" call CBA_fnc_localEvent;
Author
commy2

## 12. CBA_fnc_addItem

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_addItem-sqf.html#CBA_fnc_addItem

CBA_fnc_addItem
Description
Add an item to a unit.
Function which verifies existence of _item and _unit, returns false in case of trouble, or when able to add _item to _unit true in case of success.
Parameters
_unitthe unit <OBJECT>
_itemname of the weapon to add STRING
_verifyif true, then put item in vehicle or on the ground if it can’t be added <BOOLEAN>

Returns
true on success, false otherwise <BOOLEAN>
Examples
_result = [player, "Binocular"] call CBA_fnc_addItem
Author

## 13. CBA_fnc_addItemCargo

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_addItemCargo-sqf.html#CBA_fnc_addItemCargo

CBA_fnc_addItemCargo
Description
Add item(s) to vehicle cargo.
Function which verifies existence of _item and _container, returns false in case of trouble, or when able to add _item to _container true in case of success.
Parameters
_containerthe vehicle <OBJECT>
_itemname of item STRING
_countnumber of weapons to add <NUMBER> (Default: 1)
_verifyif true, then put item on the ground if it can’t be added <BOOLEAN>

Returns
true on success, false otherwise <BOOLEAN>
Examples
// Add one laser designator to the cargo of SomeTruck
_result = [SomeTruck, "FirstAidKit"] call CBA_fnc_addItemCargo

// Add two MXC rifles to MyAPC. If the inventory is full, then put the rest on the ground
_result = [MyAPC, "LaserDesignator", 2, true] call CBA_fnc_addItemCargo
Author
commy2

## 14. CBA_fnc_addItemContextMenuOption

Source: https://cbateam.github.io/CBA_A3/docs/files/ui/fnc_addItemContextMenuOption-sqf.html#CBA_fnc_addItemContextMenuOption

CBA_fnc_addItemContextMenuOption
Description
Adds context menu option to inventory display.
Parameters
_itemItem classname STRING Can be base class.

Can be item type as reported by BIS_fnc_itemType
[“Equipment”,”Headgear”] -> “#Equipment” and/or “##Headgear”
Wildcard
#All
_slotsRelevant slots <ARRAY, STRING> Values: ALL GROUND CARGO CONTAINER UNIFORM_CONTAINER VEST_CONTAINER BACKPACK_CONTAINER

CLOTHES UNIFORM VEST BACKPACK HEADGEAR GOGGLES
WEAPON RIFLE LAUNCHER PISTOL BINOCULAR
SILENCER RIFLE_SILENCER LAUNCHER_SILENCER PISTOL_SILENCER
BIPOD RIFLE_BIPOD LAUNCHER_BIPOD PISTOL_BIPOD
OPTIC RIFLE_OPTIC LAUNCHER_OPTIC PISTOL_OPTIC
POINTER RIFLE_POINTER LAUNCHER_POINTER PISTOL_POINTER
MAGAZINE RIFLE_MAGAZINE RIFLE_MAGAZINE_GL LAUNCHER_MAGAZINE PISTOL_MAGAZINE
ASSIGNED_ITEM MAP GPS RADIO COMPASS WATCH HMD
_displayName            String keys are automatically translated.  <STRING, ARRAY> 0: _displayName     - Option display name STRING 1: _tooltip         - Option tooltip STRING
_colorOption text color.  Default alpha is 1.  (default: [] = default color) ARRAY
_iconPath to icon.  (default: “” = no icon) STRING

_condition              <CODE, ARRAY> 0: _conditionEnable - Menu option is enabled and executed only if this condition reports ‘true’ (default: {true}) <CODE> 1: _conditionShow   - Menu option is shown only if this condition reports ‘true’.  (optional, default: {true}) <CODE>
Passed arguments: params [“_unit”, “_container”, “_item”, “_slot”, “_params”];

_statementOption statement (default: {}) <CODE> Return true to keep context menu opened.

Passed arguments: params [“_unit”, “_container”, “_item”, “_slot”, “_params”];

_consumeRemove the item before executing the statement code.  (default: false) <BOOLEAN>

This does NOT work for the following slots: GROUND CARGO

_paramsArguments passed as ‘_this select 4’ to condition and statement (optional, default: []) <ANY>

Returns
Nothing/Undefined.
Examples
["#All", "ALL", ">DEBUG ACTION<", nil, nil, {true}, {
    params ["_unit", "_container", "_item", "_slot", "_params"];
    systemChat str [name _unit, typeOf _container, _item, _slot, _params];
    true
}, false, [0,1,2]] call CBA_fnc_addItemContextMenuOption;
Author
commy2

## 15. CBA_fnc_addKeybind

Source: https://cbateam.github.io/CBA_A3/docs/files/keybinding/fnc_addKeybind-sqf.html#CBA_fnc_addKeybind

CBA_fnc_addKeybind
Description
Adds or updates the keybind handler for a specified mod action, and associates a function with that keybind being pressed.
This file should be included for readable DIK codes
#include “\a3\ui_f\hpp\defineDIKCodes.inc”
Additional DIK codes usable with this function
0xF0: Left mouse button 0xF1: Right mouse button 0xF2: Middle mouse button 0xF3: Mouse #4 0xF4: Mouse #5 0xF5: Mouse #6 0xF6: Mouse #7 0xF7: Mouse #8 0xF8: Mouse wheel up 0xF9: Mouse wheel down
0xFA: Custom user action 1 0xFB: Custom user action 2 0xFC: Custom user action 3 0xFD: Custom user action 4 0xFE: Custom user action 5 0xFF: Custom user action 6 0x100: Custom user action 7 0x101: Custom user action 8 0x102: Custom user action 9 0x103: Custom user action 10 0x104: Custom user action 11 0x105: Custom user action 12 0x106: Custom user action 13 0x107: Custom user action 14 0x108: Custom user action 15 0x109: Custom user action 16 0x10A: Custom user action 17 0x10B: Custom user action 18 0x10C: Custom user action 19 0x10D: Custom user action 20
Parameters
_addonName of the registering mod + optional sub-category <STRING, ARRAY>
_actionId of the key action.  STRING
_titlePretty name, or an array of pretty name and tooltip STRING
_downCodeCode for down event, empty string for no code.  <CODE>
_upCodeCode for up event, empty string for no code.  <CODE>

Optional
_defaultKeybindThe keybinding data in the format [DIK, [shift, ctrl, alt]] ARRAY
_holdKeyWill the key fire every frame while down <BOOLEAN>
_holdDelayHow long after keydown will the key event fire, in seconds.  <NUMBER>
_overwriteOverwrite any previously stored default keybind <BOOLEAN>

Returns
Returns the current keybind for the action ARRAY
Examples
// Register a simple keypress to an action
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

["MyMod", "MyKey", ["My Pretty Key Name", "My Pretty Tool Tip"], {
    _this call mymod_fnc_keyDown
}, {
    _this call mymod_fnc_keyUp
}, [DIK_TAB, [false, false, false]]] call CBA_fnc_addKeybind;

["MyMod", "MyOtherKey", "My Other Pretty Key Name", {
    _this call mymod_fnc_keyDownOther
}, {
    _this call mymod_fnc_keyUpOther
}, [DIK_K, [false, false, false]]] call CBA_fnc_addKeybind;
Author
Taosenai & Nou, commy2

## 16. CBA_fnc_addKeybindToFleximenu

Source: https://cbateam.github.io/CBA_A3/docs/files/keybinding/fnc_addKeybindToFleximenu-sqf.html#CBA_fnc_addKeybindToFleximenu

CBA_fnc_addKeybindToFleximenu
Description
Adds or updates the keybind handler for a defined Fleximenu and creates that Fleximenu.
Parameters
_modNameName of the registering mod [String]
_actionNameName of the action to register [String]
_displayNamePretty name, or an array of strings for the pretty name and a tool tip [String]
_fleximenuDefParameter array for CBA_fnc_flexiMenu_Add, but with the keybind set to [] [Array]

Optional
_defaultKeybindDefault keybind [DIK code, [shift?, ctrl?, alt?]] [Array]
_holdKeyWill the key fire every frame while down [Bool] (Default: true)
_holdDelayHow long after keydown will the key event fire, in seconds.  [Float] (Default: 0)
_overwriteOverwrite existing keybind data?  [Bool] (Default: False)

Returns
Returns the current keybind for the Fleximenu [Array]
Examples
["Your Mod", "Your_Action_Key", ["Your Action","ToolTip"], ["player", [], -100, "_this call my_menu_code_array"], [15, [true, true, true]]] call cba_fnc_addKeybindToFleximenu;
["Your Mod", "Your_Action_Key", "Your Action", ["player", [], -100, "_this call my_menu_code_array"], [15, [true, true, true]]] call cba_fnc_addKeybindToFleximenu;
Author: ViperMaul

## 17. CBA_fnc_addKeyHandler

Source: https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addKeyHandler-sqf.html#CBA_fnc_addKeyHandler

CBA_fnc_addKeyHandler
Description
Adds an action to a keybind.
Parameters
_keyKey (DIK-Code) to attach action to.  <NUMBER>
_settingsShift, Ctrl, Alt required.  (default: [false, false, false]) ARRAY
_codeCode to execute upon event.  <CODE>
_type”keydown” or “keyup”.  [optional] (default: “keydown”) STRING
_hashKeyKey handler identifier.  Randomly generated if not supplied.  [optional] STRING
_allowHoldWill the key fire every frame while hold down?  [optional] (default: true) <BOOLEAN>
_holdDelayHow long after keydown will the key event fire, in seconds.  [optional] <NUMBER>

Returns
_hashKeyKey handler identifier.  Used to remove or change the key handler.  STRING

Examples
_id = [47, [true, false, false], {_this call myAction}] call CBA_fnc_addKeyHandler;
Author
Sickboy, commy2

## 18. CBA_fnc_addKeyHandlerFromConfig

Source: https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addKeyHandlerFromConfig-sqf.html#CBA_fnc_addKeyHandlerFromConfig

CBA_fnc_addKeyHandlerFromConfig
Description
Adds an action to a keybind from config.
Parameters
_componentClassname under “CfgSettings” >> “CBA” >> “events” STRING
_actionAction name STRING
_codeCode to execute upon event.  <CODE>
_type”keydown” or “keyup”.  [optional] (default: “keydown”) STRING

Returns
_hashKeyKey handler identifier.  Used to remove or change the key handler.  STRING

Examples
["cba_sys_nvg", "nvgon", {_this call myAction}] call CBA_fnc_addKeyHandlerFromConfig
Author
Sickboy, commy2

## 19. CBA_fnc_addMagazine

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_addMagazine-sqf.html#CBA_fnc_addMagazine

CBA_fnc_addMagazine
Description
Add magazine to a vehicle/unit.
The function also verifies existence of _item and _unit, returns false in case of trouble, or true when able to add _item to _unit.
Parameters
_unitthe unit or vehicle <OBJECT>
_itemname of the magazine to add STRING
_ammoammo count <NUMBER>
_verifyif true, then put item in vehicle or on the ground if it can’t be added <BOOLEAN>

Returns
true on success, false otherwise <BOOLEAN>
Examples
_result = [player, "SmokeShell"] call CBA_fnc_addMagazine
Author

## 20. CBA_fnc_addMagazineCargo

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_addMagazineCargo-sqf.html#CBA_fnc_addMagazineCargo

CBA_fnc_addMagazineCargo
Description
Add magazine(s) to a vehicle’s cargo.
Function which verifies existence of _item and _container, returns false in case of trouble, or when able to add _item to _container true in case of success.
Parameters
_containerthe vehicle <OBJECT>
_itemname of magazine to STRING
_countnumber of magazines to add <NUMBER> (Default: 1)
_verifyif true, then put item on the ground if it can’t be added <BOOLEAN>
_ammoammo count <NUMBER> (Default: 1E6)

Returns
true on success, false otherwise <BOOLEAN>
Examples
// Add one mine to the cargo of SomeTruck
_result = [SomeTruck, "ATMine"] call CBA_fnc_addMagazineCargo

// Add three smoke cans to MyCar. If the inventory is full, then put the rest on the ground
_result = [MyCar, "SmokeShell", 3, true] call CBA_fnc_addMagazineCargo
Author

## 21. CBA_fnc_addMarkerEventHandler

Source: https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addMarkerEventHandler-sqf.html#CBA_fnc_addMarkerEventHandler

CBA_fnc_addMarkerEventHandler
Description
Adds an event handler that executes code when a marker is created or deleted.
Parameters
_eventTypeType of event to add.  Can be “created” or “deleted”.  STRING
_functionFunction to call when marker is created or deleted.  <CODE>

Returns
_eventIdUnique ID.  Used with ‘CBA_fnc_removeMarkerEventHandler’.

Examples
_id = ["created", {systemChat str _this}] call CBA_fnc_addMarkerEventHandler;
Author
commy2

## 22. CBA_fnc_addPauseMenuOption

Source: https://cbateam.github.io/CBA_A3/docs/files/ui/fnc_addPauseMenuOption-sqf.html#CBA_fnc_addPauseMenuOption

CBA_fnc_addPauseMenuOption
Description
Adds a menu option to the ESC menu “Options” tab.
Parameters
_namename of the menu button or array of name and tooltip <STRING, ARRAY>
_dialogDialog to open when clicking the menu button STRING

Returns
Nothing
Examples
["Menu Name", "RscDebugConsole"] call CBA_fnc_addPauseMenuOption;
Author
commy2

## 23. CBA_fnc_addPerFrameHandler

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_addPerFrameHandler-sqf.html#CBA_fnc_addPerFrameHandler

CBA_fnc_addPerFrameHandler
Description
Add a handler that will execute every frame, or every x number of seconds.
Parameters
_functionThe function you wish to execute.  <CODE>
_delayThe amount of time in seconds between executions, 0 for every frame.  (optional, default: 0) <NUMBER>
_argsParameters passed to the function executing.  This will be the same array every execution.  (optional) <ANY>

Passed Arguments
_this ARRAY 0: _args   - Parameters passed by this function.  Same as ‘_args’ above.  <ANY> 1: _handle - A number representing the handle of the function.  Same as ‘_handle’ returned by this function.  <NUMBER>
Returns
_handleA number representing the handle of the function.  Use this to remove the handler.  <NUMBER>

Examples
_handle = [{player sideChat format ["every frame! _this: %1", _this];}, 0, ["some","params",1,2,3]] call CBA_fnc_addPerFrameHandler;
Author
Nou & Jaynus, donated from ACRE project code for use by the community; commy2

## 24. CBA_fnc_addPlayerAction

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_addPlayerAction-sqf.html#CBA_fnc_addPlayerAction

CBA_fnc_addPlayerAction
Description
Adds persistent action to the player.
The action will be available in vehicles and after respawn or teamswitch.
Remove action with CBA_fnc_removePlayerAction.  Do not use standard removeAction command with these player-action indices!
Parameters
_actionArrayArray that defines the action, as used in addAction command [Array]

Returns
Index of action if added.  -1 if used on a dedicated server [Number]
Example
_actionIndex = [["Teleport", "teleport.sqf"]] call CBA_fnc_addPlayerAction;
Author
Sickboy

## 25. CBA_fnc_addPlayerEventHandler

Source: https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addPlayerEventHandler-sqf.html#CBA_fnc_addPlayerEventHandler

CBA_fnc_addPlayerEventHandler
Description
Adds a player event handler.
Possible events
”unit”player controlled unit changed
”weapon”currently selected weapon change
”turretweapon”currently selected turret weapon change
”muzzle”currently selected muzzle change
”weaponMode”currently selected weapon mode change
”loadout”players loadout changed
”vehicle”players current vehicle changed
”turret”position in vehicle changed
”turretOpticsMode”turret zoom (FOV) changed
”visionMode”player changed to normal/night/thermal view
”cameraView”camera mode changed (“Internal”, “External”, “Gunner” etc.)
”featureCamera”camera changed (Curator, Arsenal, Spectator etc.)
”visibleMap”opened or closed map
”group”player group changes
”leader”leader of player changes

Parameters
_typeEvent handler type.  STRING
_functionFunction to add to event.  <CODE>
_applyRetroactivelyCall function immediately if player is defined already (optional, default: false) <BOOL>

Returns
_idThe ID of the event handler.  <NUMBER>

Examples
_id = ["unit", {systemChat str _this}] call CBA_fnc_addPlayerEventHandler;
Author
commy2

## 26. CBA_fnc_addSetting

Source: https://cbateam.github.io/CBA_A3/docs/files/settings/fnc_addSetting-sqf.html#CBA_fnc_addSetting

CBA_fnc_addSetting
Description
Creates a new setting for that session.
Parameters
_settingUnique setting name.  Matches resulting variable name STRING
_settingTypeType of setting.  Can be “CHECKBOX”, “EDITBOX”, “LIST”, “SLIDER”, “COLOR” or “TIME” STRING
_titleDisplay name or display name + tooltip (optional, default: same as setting name) <STRING, ARRAY>
_categoryCategory for the settings menu + optional sub-category <STRING, ARRAY>
_valueInfoExtra properties of the setting depending of _settingType.  See examples below <ANY>
_isGlobal1: all clients share the same setting, 2: setting can’t be overwritten (optional, default: 0) <BOOL, NUMBER>
_scriptScript to execute when setting is changed.  (optional) <CODE>
_needRestartSetting will be marked as needing mission restart after being changed.  (optional, default false) <BOOL>

Returns
_returnError code <BOOLEAN> true: Success, no error false: Failure, error

Examples
// CHECKBOX --- extra argument: default value
["Test_Setting_1", "CHECKBOX", ["-test checkbox-", "-tooltip-"], "My Category", true] call CBA_fnc_addSetting;

// LIST --- extra arguments: [_values, _valueTitles, _defaultIndex]
["Test_Setting_2", "LIST",     ["-test list-",     "-tooltip-"], "My Category", [[1, 0], ["enabled","disabled"], 1]] call CBA_fnc_addSetting;

// SLIDER --- extra arguments: [_min, _max, _default, _trailingDecimals, _isPercentage]
["Test_Setting_3", "SLIDER",   ["-test slider-",   "-tooltip-"], "My Category", [0, 10, 5, 0]] call CBA_fnc_addSetting;

// COLOR PICKER --- extra argument: _color
["Test_Setting_4", "COLOR",    ["-test color-",    "-tooltip-"], "My Category", [1, 1, 0]] call CBA_fnc_addSetting;

// EDITBOX --- extra argument: default value
["Test_Setting_5", "EDITBOX",  ["-test editbox-", "-tooltip-"], "My Category", "defaultValue"] call CBA_fnc_addSetting;

// TIME PICKER (time in seconds) --- extra arguments: [_min, _max, _default]
["Test_Setting_6", "TIME",     ["-test time-",    "-tooltip-"], "My Category", [0, 3600, 60]] call CBA_fnc_addSetting;
Author
commy2

## 27. CBA_fnc_addUnitTrackProjectiles

Source: https://cbateam.github.io/CBA_A3/docs/files/diagnostic/fnc_addUnitTrackProjectiles-sqf.html#CBA_fnc_addUnitTrackProjectiles

CBA_fnc_addUnitTrackProjectiles
Description
Adds projectile tracking to a given unit or vehicle.  Will show colored lines following a projectile’s path.
Parameters
_unitthe unit or vehicle to track <OBJECT>

Returns
nil
Examples
private _eventId = [player] call CBA_fnc_addUnitTrackProjectiles;
Author
bux578

## 28. CBA_fnc_addWaypoint

Source: https://cbateam.github.io/CBA_A3/docs/files/ai/fnc_addWaypoint-sqf.html#CBA_fnc_addWaypoint

CBA_fnc_addWaypoint
Description
A function used to add a waypoint to a group.
Parameters
Group (Group or Object)
Position (XYZ, Object, Location or Group)

Optional
Radius (Scalar)
Waypoint Type (String)
Behaviour (String)
Combat Mode (String)
Speed Mode (String)
Formation (String)
Code To Execute at Each Waypoint (String)
TimeOut at each Waypoint (Array [Min, Med, Max])
Waypoint Completion Radius (Scalar)

Example
[this, this, 300, "MOVE", "AWARE", "YELLOW", "FULL", "STAG COLUMN", "this spawn CBA_fnc_searchNearby", [3, 6, 9]] call CBA_fnc_addWaypoint
Returns
Waypoint [Group, Waypoint Index] ARRAY
Author
Rommel

## 29. CBA_fnc_addWeapon

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_addWeapon-sqf.html#CBA_fnc_addWeapon

CBA_fnc_addWeapon
Description
Add a weapon to a unit.  Unit has to be local.
Function which verifies existence of _item and _unit, returns false in case of trouble, or when able to add _item to _unit true in case of success.
Parameters
_unitthe unit <OBJECT>
_itemname of the weapon to add STRING
_verifyif true, then put item on the ground if it can’t be added <BOOLEAN>

Returns
true on success, false otherwise <BOOLEAN>
Examples
_result = [player, "Binocular"] call CBA_fnc_addWeapon
Author

## 30. CBA_fnc_addWeaponCargo

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_addWeaponCargo-sqf.html#CBA_fnc_addWeaponCargo

CBA_fnc_addWeaponCargo
Description
Add weapon(s) to vehicle cargo.
Function which verifies existence of _item and _container, returns false in case of trouble, or when able to add _item to _container true in case of success.
Parameters
_containerthe vehicle <OBJECT>
_itemname of weapon STRING
_countnumber of weapons to add <NUMBER> (Default: 1)
_verifyif true, then put item on the ground if it can’t be added <BOOLEAN>

Returns
true on success, false otherwise <BOOLEAN>
Examples
// Add one laser designator to the cargo of SomeTruck
_result = [SomeTruck, "LaserDesignator"] call CBA_fnc_addWeaponCargo

// Add two MXC rifles to MyAPC. If the inventory is full, then put the rest on the ground
_result = [MyAPC, "arifle_MXC_F", 2, true] call CBA_fnc_addWeaponCargo
Author
Sickboy

## 31. CBA_fnc_addWeaponWithoutItems

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_addWeaponWithoutItems-sqf.html#CBA_fnc_addWeaponWithoutItems

CBA_fnc_addWeaponWithoutItems
Description
Adds weapon to unit without taking a magazine.  Attachments will be removed by default, but can be kept by setting a parameter.
Does not work on vehicles.  Attempts to keep magazine ids for unrelated magazines.
Parameters
_unitUnit to add the weapon to <OBEJCT>
_weaponWeapon to add STRING
_removeLinkedItemsIf linked items should be removed or not <BOOLEAN> (Default: true)

Returns
Nothing.
Examples
[player, "arifle_mx_F"] call CBA_fnc_addWeaponWithoutItems;
[player, "arifle_AK12_lush_arco_snds_pointer_bipod_F", false] call CBA_fnc_addWeaponWithoutItems;
Author
commy2, johnb43

## 32. CBA_fnc_allNamespaces

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_allNamespaces-sqf.html#CBA_fnc_allNamespaces

CBA_fnc_allNamespaces
Description
Reports namespaces created with CBA_fnc_createNamespace.
Parameters
None
Returns
_namespacesall custom namespaces <ARRAY of LOCATION, OBJECT>

Examples
_namespaces = call CBA_fnc_allNamespaces;
Author
commy2

## 33. ARG_#

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#ARG_#

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 34. ARR_#

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#ARR_#

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 35. ARRAY

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#ARRAY

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 36. ASSERT_DEFINED

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#ASSERT_DEFINED

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 37. ASSERT_FALSE

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#ASSERT_FALSE

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 38. ASSERT_OP

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#ASSERT_OP

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 39. ASSERT_TRUE

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#ASSERT_TRUE

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 40. Assertions

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#Assertions

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 41. CBA_fnc_binocularMagazine

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_binocularMagazine-sqf.html#CBA_fnc_binocularMagazine

CBA_fnc_binocularMagazine
Description
Returns the magazine of the units rangefinder.
Parameters
_unitA unit <OBJECT>

Returns
Magazine of the units binocular STRING
Examples
player call CBA_fnc_binocularMagazine
Author
commy2, johnb43

## 42. CBA_fnc_buildingPositions

Source: https://cbateam.github.io/CBA_A3/docs/files/ai/fnc_buildingPositions-sqf.html#CBA_fnc_buildingPositions

CBA_fnc_buildingPositions
Description
Reports positions of the building including nearby custom building positions.
Parameters
0: _buildingThe building.  <OBJECT>
1: _maxMaximum number of positions.  (optional, default: all) <NUMBER>

Example
[_building, _maxNumberOfPositions] call CBA_fnc_buildingPositions
Returns
Available building positions including custom positions <ARRAY <PosAGL>>
Author
commy2

## 43. CBA_fnc_canAddItem

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_canAddItem-sqf.html#CBA_fnc_canAddItem

CBA_fnc_canAddItem
Description
Checks if unit or object has enough free space in inventory to store item.
Doesn’t take current unit load into account unlike canAdd command.
Parameters
_unitUnit <OBJECT>
_itemItem to store STRING
_countItem count <NUMBER> (Default: 1)
_checkUniformCheck space in uniform <BOOLEAN> (Default: true)
_checkVestCheck space in vest <BOOLEAN> (Default: true)
_checkBackpackCheck space in backpack <BOOLEAN> (Default: true)

Returns
True if unit or object has free space, false otherwise <BOOLEAN>
Examples
[player, "acc_flashlight"] call CBA_fnc_canAddItem
[player, "30Rnd_556x45_Stanag", 7, false, true, false] call CBA_fnc_canAddItem
Author
Dystopian

## 44. CBA_fnc_canUseWeapon

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_canUseWeapon-sqf.html#CBA_fnc_canUseWeapon

CBA_fnc_canUseWeapon
Description
Checks if the unit can currently use a weapon.
Parameters
_unitA unit <OBJECT>

Returns
True if the unit is not in a vehicle or in a FFV position <BOOLEAN>
Examples
_result = player call CBA_fnc_canUseWeapon;
Author
commy2

## 45. CBA_fnc_capitalize

Source: https://cbateam.github.io/CBA_A3/docs/files/strings/fnc_capitalize-sqf.html#CBA_fnc_capitalize

CBA_fnc_capitalize
Description
Upper case the first letter of the string, lower case the rest.
Parameters
_stringString to capitalize [String]

Returns
Capitalized string [String].
Examples
_result = ["FISH"] call CBA_fnc_capitalize;
// _result => "Fish"

_result = ["frog-headed fish"] call CBA_fnc_capitalize;
// _result => "Frog-headed fish"
Author
Spooner, joko // Jonas

## 46. CBA_accessory_fnc_switchAttachment

Source: https://cbateam.github.io/CBA_A3/docs/files/accessory/fnc_switchAttachment-sqf.html#CBA_accessory_fnc_switchAttachment

CBA_accessory_fnc_switchAttachment
Description
Switches weapon accessories for the player.
Parameters
0: _itemTypeAttachment type (0: muzzle, 1: rail, 2: optic, 3: bipod).  <NUMBER>
1: _switchToSwitch to “next” or “prev” attachement STRING

Returns
_successIf switching was possible and keybind should be handled <BOOLEAN>

Examples
[1, "next"] call CBA_accessory_fnc_switchAttachment;
[2, "prev"] call CBA_accessory_fnc_switchAttachment;
Author
Robalo, optimized by Anton

## 47. CBA_diagnostic_fnc_initTargetDebugConsole

Source: https://cbateam.github.io/CBA_A3/docs/files/diagnostic/fnc_initTargetDebugConsole-sqf.html#CBA_diagnostic_fnc_initTargetDebugConsole

CBA_diagnostic_fnc_initTargetDebugConsole
Description
Adds additional watch statements that are run on a remote target and have their values returned to the client.  Requires `EnableTargetDebug = 1;` in addon root config or description.ext or 3den scenario attribute with the same name
Author
(based on BIS’s RscDebugConsole.sqf) PabstMirror commy2

## 48. CBA_events_fnc_playerEvent

Source: https://cbateam.github.io/CBA_A3/docs/files/events/fnc_playerEvent-sqf.html#CBA_events_fnc_playerEvent

CBA_events_fnc_playerEvent
Description
Poll player event states and possibly raise events on state change.
Parameters
None.
Returns
Nothing.  (May return assignment.)
Examples
call CBA_events_fnc_playerEvent;
Author
commy2

## 49. CBA_optics_fnc_setOpticMagnification

Source: https://cbateam.github.io/CBA_A3/docs/files/optics/fnc_setOpticMagnification-sqf.html#CBA_optics_fnc_setOpticMagnification

CBA_optics_fnc_setOpticMagnification
Description
Set magnification of the current optic of the unit.
Parameters
_unitThe unit with a weapon <OBJECT>
_magnificationMagnification to apply <NUMBER>

Returns
Nothing.
Examples
[player, 3] call cba_optics_fnc_setOpticMagnification;
Author
commy2

## 50. CBA_optics_fnc_setOpticMagnificationHelper

Source: https://cbateam.github.io/CBA_A3/docs/files/optics/fnc_setOpticMagnificationHelper-sqf.html#CBA_optics_fnc_setOpticMagnificationHelper

CBA_optics_fnc_setOpticMagnificationHelper
Description
Helper function used in config to set the magnification of a zooming optic.
Parameters
_valueMin, max or init optic zoom <NUMBER>

Returns
Nothing.
Examples
2 call (uiNamespace getVariable 'cba_optics_fnc_setOpticMagnificationHelper')
Author
commy2

## 51. CBA_optics_fnc_setOpticMagnificationHelperZeroing

Source: https://cbateam.github.io/CBA_A3/docs/files/optics/fnc_setOpticMagnificationHelperZeroing-sqf.html#CBA_optics_fnc_setOpticMagnificationHelperZeroing

CBA_optics_fnc_setOpticMagnificationHelperZeroing
Description
Helper function used in config to remember the zeroing of a zooming optic.
Parameters
_value”discreteDistanceInitIndex” <NUMBER>

Returns
Nothing.
Examples
2 call (uiNamespace getVariable 'cba_optics_fnc_setOpticMagnificationHelperZeroing')
Author
commy2

## 52. CBA_statemachine_fnc_addEventTransition

Source: https://cbateam.github.io/CBA_A3/docs/files/statemachine/fnc_addEventTransition-sqf.html#CBA_statemachine_fnc_addEventTransition

CBA_statemachine_fnc_addEventTransition
Description
Creates a transition between two states.
Parameters
_stateMachinea state machine <LOCATION>
_originalStatestate the transition origins from STRING
_targetStatestate the transition goes to STRING
_eventslist of events that can trigger the transition ARRAY
_conditionadditional condition required for the transition to trigger <CODE>
_onTransitioncode that gets executed once transition happens <CODE> (Default: {})
_namename for this specific transition STRING (Default: “NONAME”)

Returns
_wasCreatedcheck if the transition was created <BOOL>

Examples
[_stateMachine, "initial", "end", ["end_statemachine"], {true}, {
    systemChat format [
        "%1 transitioned from %2 to %3 via %4.",
        _this, _thisOrigin, _thisTarget, _thisTransition
    ];
}, "dummyTransition"] call CBA_statemachine_fnc_addEventTransition;
Author
BaerMitUmlaut

## 53. CBA_statemachine_fnc_addState

Source: https://cbateam.github.io/CBA_A3/docs/files/statemachine/fnc_addState-sqf.html#CBA_statemachine_fnc_addState

CBA_statemachine_fnc_addState
Description
Adds a state to a state machine.
Parameters
_stateMachinea state machine <LOCATION>
_onStatecode that is executed when state is active (frequency depends on amount of objects active in state machine) <CODE> (Default: {})
_onStateEnteredcode that is executed once when state was entered, after onTransition (also once for the intial state) <CODE> (Default: {})
_onStateLeavingcode that is executed once when exiting state, before onTransition <CODE> (Default: {})
_nameunique state name STRING (Default: “stateX” with X being a unique number)

Returns
_nameunique state name or empty string on error STRING

Examples
_name = [_stateMachine, {}] call CBA_statemachine_fnc_addState;
Author
BaerMitUmlaut

## 54. CBA_statemachine_fnc_addTransition

Source: https://cbateam.github.io/CBA_A3/docs/files/statemachine/fnc_addTransition-sqf.html#CBA_statemachine_fnc_addTransition

CBA_statemachine_fnc_addTransition
Description
Creates a transition between two states.
Parameters
_stateMachinea state machine <LOCATION>
_originalStatestate the transition origins from STRING
_targetStatestate the transition goes to STRING
_conditioncondition under which the transition will happen <CODE>
_onTransitioncode that gets executed once transition happens <CODE> (Default: {})
_namename for this specific transition STRING (Default: “NONAME”)

Returns
_wasCreatedcheck if the transition was created <BOOL>

Examples
[_stateMachine, "initial", "end", {true}, {
    systemChat format [
        "%1 transitioned from %2 to %3 via %4.",
        _this, _thisOrigin, _thisTarget, _thisTransition
    ];
}, "dummyTransition"] call CBA_statemachine_fnc_addTransition;
Author
BaerMitUmlaut

## 55. CBA_statemachine_fnc_clockwork

Source: https://cbateam.github.io/CBA_A3/docs/files/statemachine/fnc_clockwork-sqf.html#CBA_statemachine_fnc_clockwork

CBA_statemachine_fnc_clockwork
Description
Clockwork which runs all state machines.
Parameters
None
Returns
Nothing
Author
BaerMitUmlaut

## 56. CBA_statemachine_fnc_create

Source: https://cbateam.github.io/CBA_A3/docs/files/statemachine/fnc_create-sqf.html#CBA_statemachine_fnc_create

CBA_statemachine_fnc_create
Description
Creates a state machine.
Parameters
_listlist of anything over which the state machine will run (type needs to support setVariable) ARRAY OR code that will generate this list, called once the list has been cycled through <CODE>
_skipNullskip list items that are null

Returns
_stateMachinea state machine <LOCATION>

Examples
_stateMachine = call CBA_statemachine_fnc_create;
Author
BaerMitUmlaut

## 57. CBA_statemachine_fnc_createFromConfig

Source: https://cbateam.github.io/CBA_A3/docs/files/statemachine/fnc_createFromConfig-sqf.html#CBA_statemachine_fnc_createFromConfig

CBA_statemachine_fnc_createFromConfig
Description
Creates a state machine from a config class.
Parameters
_configconfig path that contains a valid state machine config (check the example.hpp file for the required structure) <CONFIG>

Returns
_stateMachinea state machine <LOCATION>

Examples
_stateMachine = [configFile >> "MyAddon_Statemachine"] call CBA_statemachine_fnc_createFromConfig;
Author
BaerMitUmlaut

## 58. CBA_statemachine_fnc_delete

Source: https://cbateam.github.io/CBA_A3/docs/files/statemachine/fnc_delete-sqf.html#CBA_statemachine_fnc_delete

CBA_statemachine_fnc_delete
Description
Deletes a state machine.
Parameters
_stateMachinea state machine <LOCATION>

Returns
Nothing
Examples
[_stateMachine] call CBA_statemachine_fnc_delete;
Author
BaerMitUmlaut

## 59. CBA_statemachine_fnc_dumpPerformanceCounters

Source: https://cbateam.github.io/CBA_A3/docs/files/statemachine/fnc_dumpPerformanceCounters-sqf.html#CBA_statemachine_fnc_dumpPerformanceCounters

CBA_statemachine_fnc_dumpPerformanceCounters
Description
Dumps the performance counters for each statemachine Requires `STATEMACHINE_PERFORMANCE_COUNTERS` in script_component.hpp Note that diag_tickTime has very limited precision; results may become more accurate with longer test runtime.
Parameters
Nothing
Returns
Nothing
Examples
[] call CBA_statemachine_fnc_dumpPerformanceCounters;
Author
PabstMirror

## 60. CBA_statemachine_fnc_getCurrentState

Source: https://cbateam.github.io/CBA_A3/docs/files/statemachine/fnc_getCurrentState-sqf.html#CBA_statemachine_fnc_getCurrentState

CBA_statemachine_fnc_getCurrentState
Description
Manually triggers a transition.
Parameters
_listItemitem to get the state of <any namespace type>
_stateMachinestate machine <LOCATION>

Returns
_currentStatestate of the given item STRING

Examples
_currentState = [player, _stateMachine] call CBA_statemachine_fnc_getCurrentState;
Author
BaerMitUmlaut

## 61. CBA_statemachine_fnc_manualTransition

Source: https://cbateam.github.io/CBA_A3/docs/files/statemachine/fnc_manualTransition-sqf.html#CBA_statemachine_fnc_manualTransition

CBA_statemachine_fnc_manualTransition
Description
Manually triggers a transition.
Parameters
_listItemthe item which should transition <any namespace type>
_stateMachinea state machine <LOCATION>
_thisOriginstate the transition origins from STRING
_thisTargetstate the transition goes to STRING
_onTransitioncode that gets executed once transition happens <CODE> (Default: {})
_thisTransitionname for this specific transition STRING (Default: “MANUAL”)

Returns
Nothing
Examples
[_stateMachine, "initial", "end", {
    systemChat format [
        "%1 transitioned from %2 to %3 manually.",
        _this, _thisOrigin, _thisTarget
    ];
}, "dummyTransition"] call CBA_statemachine_fnc_manualTransition;
Author
BaerMitUmlaut

## 62. CBA_statemachine_fnc_toString

Source: https://cbateam.github.io/CBA_A3/docs/files/statemachine/fnc_toString-sqf.html#CBA_statemachine_fnc_toString

CBA_statemachine_fnc_toString
Description
Creates a readable string representation of a state machine.
Parameters
_stateMachinea state machine <LOCATION>
_outputListoutput list over which the state machine runs <BOOL> (Default: false)
_outputCodeoutput code details such as the onState value <BOOL> (Default: false)

Returns
_outputstring representation of state machine STRING

Examples
_output = [_stateMachine, true] call CBA_statemachine_fnc_toString;
Author
BaerMitUmlaut

## 63. CBA_statemachine_fnc_updateList

Source: https://cbateam.github.io/CBA_A3/docs/files/statemachine/fnc_updateList-sqf.html#CBA_statemachine_fnc_updateList

CBA_statemachine_fnc_updateList
Description
Manually updates the list of a state machine.
Parameters
_stateMachinea state machine <LOCATION>
_listlist of anything over which the state machine will run (type needs to support setVariable) ARRAY

Returns
Nothing
Examples
[_stateMachine, _list] call CBA_statemachine_fnc_updateList;
Author
BaerMitUmlaut

## 64. CBA_fnc_changeKeyHandler

Source: https://cbateam.github.io/CBA_A3/docs/files/events/fnc_changeKeyHandler-sqf.html#CBA_fnc_changeKeyHandler

CBA_fnc_changeKeyHandler
Description
Changes the key of a key handler.
Parameters
_hashKeyKey handler identifier.  STRING
_keyNew key (DIK-Code).  <NUMBER>
_settingsNew Settings.  Shift, Ctrl, Alt required.  (default: [false, false, false]) ARRAY
_type”keydown” or “keyup”.  [optional] (default: “keydown”) STRING

Returns
None
Examples
[_id, 44, [false, false, false]] call CBA_fnc_changeKeyHandler;
Author
Sickboy, commy2

## 65. CBA_fnc_clearWaypoints

Source: https://cbateam.github.io/CBA_A3/docs/files/ai/fnc_clearWaypoints-sqf.html#CBA_fnc_clearWaypoints

CBA_fnc_clearWaypoints
Description
A function used to correctly clear all waypoints from a group.
Parameters
Group (Group or Object)

Example
[group player] call CBA_fnc_clearWaypoints
Returns
None
Author
SilentSpike

## 66. CBA_fnc_colorAHEXtoDecimal

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_colorAHEXtoDecimal-sqf.html#CBA_fnc_colorAHEXtoDecimal

CBA_fnc_colorAHEXtoDecimal
Description
Converts a hexidecimal coded color with transparency to the ingame decimal color format.
Parameters
_hexStringA hexidecimal color code, “AARRGGBB” with or without a leading # STRING

Returns
Ingame color format ARRAY
Examples
"AABA2619" call CBA_fnc_colorAHEXtoDecimal
Author
Lambda.Tiger & drofseh

## 67. CBA_fnc_colorARGBtoDecimal

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_colorARGBtoDecimal-sqf.html#CBA_fnc_colorARGBtoDecimal

CBA_fnc_colorARGBtoDecimal
Description
Converts an ARGB coded color with transparency to the ingame decimal color format.
Parameters
_alphaThe alpha/transparency channel, 0-255 <NUMBER>
_redThe red channel, 0-255 <NUMBER>
_greenThe green channel, 0-255 <NUMBER>
_blueThe blue channel, 0-255 <NUMBER>

Returns
Ingame color format ARRAY
Examples
[255,186,38,25] call CBA_fnc_colorARGBtoDecimal
Author
drofseh & Lambda.Tiger

## 68. CBA_fnc_colorHEXAtoDecimal

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_colorHEXAtoDecimal-sqf.html#CBA_fnc_colorHEXAtoDecimal

CBA_fnc_colorHEXAtoDecimal
Description
Converts a hexidecimal coded color with transparency to the ingame decimal color format.
Parameters
_hexStringA hexidecimal color code, “RRGGBBAA” with or without a leading # STRING

Returns
Ingame color format ARRAY
Examples
"BA2619AA" call CBA_fnc_colorHEXAtoDecimal
Author
Lambda.Tiger & drofseh

## 69. CBA_fnc_colorHEXtoDecimal

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_colorHEXtoDecimal-sqf.html#CBA_fnc_colorHEXtoDecimal

CBA_fnc_colorHEXtoDecimal
Description
Converts a hexidecimal coded color without transparency to the ingame decimal color format.
Parameters
_hexStringA hexidecimal color code, “RRGGBB” with or without a leading # STRING

Returns
Ingame color format ARRAY
Examples
"BA2619" call CBA_fnc_colorHEXtoDecimal
Author
Lambda.Tiger & drofseh

## 70. CBA_fnc_colorRGBAtoDecimal

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_colorRGBAtoDecimal-sqf.html#CBA_fnc_colorRGBAtoDecimal

CBA_fnc_colorRGBAtoDecimal
Description
Converts an RGBA coded color with transparency to the ingame decimal color format.
Parameters
_redThe red channel, 0-255 <NUMBER>
_greenThe green channel, 0-255 <NUMBER>
_blueThe blue channel, 0-255 <NUMBER>
_alphaThe alpha/transparency channel, 0-255 <NUMBER>

Returns
Ingame color format ARRAY
Examples
[186,38,25,255] call CBA_fnc_colorRGBAtoDecimal
Author
drofseh & Lambda.Tiger

## 71. CBA_fnc_colorRGBtoDecimal

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_colorRGBtoDecimal-sqf.html#CBA_fnc_colorRGBtoDecimal

CBA_fnc_colorRGBtoDecimal
Description
Converts an RGB coded color without transparency to the ingame decimal color format.
Parameters
_redThe red channel, 0-255 <NUMBER>
_greenThe green channel, 0-255 <NUMBER>
_blueThe blue channel, 0-255 <NUMBER>

Returns
Ingame color format ARRAY
Examples
[186,38,25] call CBA_fnc_colorRGBtoDecimal
Author
drofseh & Lambda.Tiger

## 72. CBA_fnc_compatibleItems

Source: https://cbateam.github.io/CBA_A3/docs/files/jr/fnc_compatibleItems-sqf.html#CBA_fnc_compatibleItems

CBA_fnc_compatibleItems
Description
Return all compatible weapon attachments.
Parameters
_weaponA weapons class name STRING
_typefilterOptional filter.  Can be “muzzle”, “optic”, “pointer” or “bipod”.  <STRING, NUMBER>

Returns
Class names of attachments compatible with weapon ARRAY
Examples
_acclist = ["LMG_Mk200_F"] call CBA_fnc_compatibleItems;
_muzzleacclist = ["LMG_Mk200_F", "muzzle"] call CBA_fnc_compatibleItems;
Author
Original by Karel Moricky, Enhanced by Robalo, jokoho, commy2, johnb43

## 73. CBA_fnc_compatibleMagazines

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_compatibleMagazines-sqf.html#CBA_fnc_compatibleMagazines

CBA_fnc_compatibleMagazines
Description
Retrieves a list of magazines that are compatible with a weapon.
Parameters
_weaponWeapon class name or config <STRING, CONFIG>
_allMuzzlesGet magazines for all muzzles on this weapon (optional, default: false) <BOOL>

Returns
Array of magazine classnames in config capitalization ARRAY
Examples
_mags = ["arifle_MX_SW_F"] call CBA_fnc_compatibleMagazines;
_mags = [configFile >> "CfgWeapons" >> _rifle >> _glMuzzle] call CBA_fnc_compatibleMagazines;
Author
PabstMirror, based on code from Dedmen

## 74. CBA_fnc_compileEventHandlers

Source: https://cbateam.github.io/CBA_A3/docs/files/xeh/fnc_compileEventHandlers-sqf.html#CBA_fnc_compileEventHandlers

CBA_fnc_compileEventHandlers
Description
Compiles all Extended EventHandlers in given config.
Parameters
0: _baseConfigWhat config file should be used.  <CONFIG>

Returns
Compiled code of all Extended EventHandlers ARRAY format: [event1, event2, ..., eventN] ARRAY eventX format: [_className STRING, _eventName STRING, _eventFunc <CODE>, _allowInheritance <BOOLEAN>, _excludedClasses ARRAY]
Examples
configFile call CBA_fnc_compileEventHandlers;
Author
commy2

## 75. CBA_fnc_compileFinal

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_compileFinal-sqf.html#CBA_fnc_compileFinal

CBA_fnc_compileFinal
Description
Defines a function in mission namespace and prevents it from being overwritten.
Parameters
_nameFunction name STRING
_functionA function <CODE>

Returns
Nothing
Examples
["MyFunction", {systemChat str _this}] call CBA_fnc_compileFinal;
Author
commy2

## 76. CBA_fnc_compileFunction

Source: https://cbateam.github.io/CBA_A3/docs/files/xeh/fnc_compileFunction-sqf.html#CBA_fnc_compileFunction

CBA_fnc_compileFunction
Description
Compiles a function into mission namespace and into ui namespace for caching purposes.  Recompiling can be enabled by inserting the CBA_cache_disable.pbo from the optionals folder.
Parameters
0: _funcFilePath to function sqf file STRING
1: _funcNameFinal function name STRING

Returns
None
Examples
[_funcFile, _funcName] call CBA_fnc_compileFunction;
Author
commy2

## 77. CBA_fnc_compileMusic

Source: https://cbateam.github.io/CBA_A3/docs/files/music/fnc_compileMusic-sqf.html#CBA_fnc_compileMusic

CBA_fnc_compileMusic
Description
A function used to gather a list of all music classes
Parameters
none
Returns
Array of compiled music (in CLASS format)
Example
_allMusic = [] call CBA_fnc_compileMusic
Author
Fishy, Dorbedo, Dedmen

## 78. CBA_fnc_consumeItem

Source: https://cbateam.github.io/CBA_A3/docs/files/ui/fnc_consumeItem-sqf.html#CBA_fnc_consumeItem

CBA_fnc_consumeItem
Description
Removes item from inventory.
Parameters
_unitUnit that consumeds item <OBJECT>
_itemItem classname STRING
_slotInventory slot of the item STRING
_containerContainer that has the item <OBJECT>

Returns
true if successful, false otherwise <BOOLEAN>
Examples
[player, headgear player, "HEADGEAR"] call CBA_fnc_consumeItem;
Author
commy2

## 79. CBA_fnc_createMarker

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_createMarker-sqf.html#CBA_fnc_createMarker

CBA_fnc_createMarker
Description
Creates a marker all at once.
Parameters
_markerNameName of marker to create [String]
_position[Array: [x, y]]
_shape”ICON”, “RECTANGLE” or “ELLIPSE” [String]
_size[Array: [width, height]]

Optional Parameters
”GLOBAL”Add for a global marker, but leave out for a local marker.
”PERSIST”Add for persisting global marker to JIP players.  Implies “GLOBAL” when included.
”BRUSH:”e.g.  “Solid”
”COLOR:”e.g.  “ColorRed”
”TEXT:”e.g.  “Objective Area”
”TYPE:”e.g.  “Pickup”

Returns
Name of the marker [String]
Examples
// simple marker creation
_marker = ["markername", [positionX,positionY], "Rectangle", [sizeX, sizeY]] call CBA_fnc_createMarker;
// Color yellow
_marker = ["markername", [positionX,positionY], "Rectangle", [sizeX, sizeY], "COLOR:", "ColorYellow"] call CBA_fnc_createMarker;
// Global marker - will be visible to all players currently ingame
_marker = ["markername", [positionX,positionY], "Rectangle", [sizeX, sizeY], "COLOR:", "ColorYellow", "GLOBAL"] call CBA_fnc_createMarker;
// Global persistent marker - will be visible to all players currently ingame, and also to JIP players
_marker = ["markername", [positionX,positionY], "Rectangle", [sizeX, sizeY], "COLOR:", "ColorYellow", "PERSIST"] call CBA_fnc_createMarker;
Author
Sickboy (sb_at_dev-heaven.net) 6thSense.eu Mod

## 80. CBA_fnc_createNamespace

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_createNamespace-sqf.html#CBA_fnc_createNamespace

CBA_fnc_createNamespace
Description
Creates a namespace.  Used to store and read variables via setVariable and getVariable.
The Namespace is destroyed after the mission ends.
Parameters
_isGlobalcreate a global namespace (optional, default: false) <BOOLEAN>

Returns
_namespacea namespace <LOCATION, OBJECT>

Examples
_namespace = call CBA_fnc_createNamespace;

My_GlobalNamespace = true call CBA_fnc_createNamespace;
publicVariable "My_GlobalNamespace";
Author
commy2

## 81. CBA_fnc_createPerFrameHandlerObject

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_createPerFrameHandlerObject-sqf.html#CBA_fnc_createPerFrameHandlerObject

CBA_fnc_createPerFrameHandlerObject
Description
Creates a PFH object, that will execute code every frame, or every x number of seconds.
Parameters
_functionThe function you wish to execute.  <CODE>
_delayThe amount of time in seconds between executions, 0 for every frame.  (optional, default: 0) <NUMBER>
_argsParameters passed to the function executing.  (optional) <ANY>
_startFunction that is executed when the PFH is added.  (optional) <CODE>
_endFunction that is executed when the PFH is removed.  (optional) <CODE>
_runConditionCondition that has to return true for the PFH to be executed.  (optional, default {true}) <CODE>
_exitConditionCondition that has to return true to delete the PFH object.  (optional, default {false}) <CODE>
_privateList of local variables that are serialized between executions.  (optional) <CODE>

Passed Arguments
_thisThe PFH logic.  <LOCATION>

More variables are attached to this PFH logic than can be retrieved via ‘getVariable’.  (_this getVariable “params”) It is not advised to overwrite these variables with ‘setVariable’!
”params”Parameters passed by this function.  Same as _args from above.  <ANY>
”handle”A number representing the handle of the PFH.  <NUMBER>
”private”List of local variables that are serialized between executions.  Same as _private from above.  ARRAY
”start”Same as _start from above.  <CODE>
”end”Same as _end from above.  <CODE>
”run”Same as _function from above.  <CODE>
”run_condition”Same as _runCondition from above.  <CODE>
”exit_condition”Same as _exitCondition from above.  <CODE>
”serialize”Internal reserved variable.
”deserialize”Internal reserved variable.

The PFH logic can be used to store additional custom variables.
Returns
_logicThe PFH logic.  <LOCATION>

Examples
[
    { systemChat format ["frame! params: %1", _this getVariable "params"]; },
    0,
    ["some_params", [1,2,3]],
    { systemChat format ["start! params: %1", _this getVariable "params"]; _test = 127; },
    { systemChat format ["end! params: %1",   _this getVariable "params"]; systemChat str [_test] },
    { random 1 > 0.5 },
    { random 1 > 0.8 },
    "_test"
] call CBA_fnc_createPerFrameHandlerObject;
Author
Nou & Jaynus, donated from ACRE project code for use by the community; commy2

## 82. CBA_fnc_createTrigger

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_createTrigger-sqf.html#CBA_fnc_createTrigger

CBA_fnc_createTrigger
Description
Create a trigger all at once.
Parameters
_posPosition [Array]

Optional Parameters
”AREA:”e.g.  [5, 5, 0, false]
”ACT:”e.g.  [“CIV”, “PRESENT”, true]
”STATE:”e.g.  [“this”, “hint ‘Civilian near player’”, “hint ‘no civilian near’”]
”NAME:”e.g.  “VariableName”

Returns
Trigger and parameters given in an array: [_trigger, _parameters]
Examples
[_position] call CBA_fnc_createTrigger;

[_position, "AREA:", [5, 5, 0, false], "ACT:", ["CIV", "PRESENT", true]] call CBA_fnc_createTrigger;
Author
Sickboy (sb_at_dev-heaven.net)

## 83. CBA_fnc_createUUID

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_createUUID-sqf.html#CBA_fnc_createUUID

CBA_fnc_createUUID
Description
Creates a version 4 UUID (universally unique identifier).
Parameters
None
Returns
UUID [String]
Example
private _uuid = call CBA_fnc_createUUID;
Author
BaerMitUmlaut

## 84. CBA_fnc_cssColorToDecimal

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_cssColorToDecimal-sqf.html#CBA_fnc_cssColorToDecimal

CBA_fnc_cssColorToDecimal
Description
Converts a CSS extended color keyword to the ingame decimal color format.  Reference for colors: https://www.w3.org/TR/css-color-3/#svg-color Parameters: _colorKeyword - A color keyword as defined as part of W3c’s CSS color module level 3.  STRING Returns: Ingame RGB color format ARRAY Examples:
"chartreuse" call CBA_fnc_cssColorToDecimal
Author: Lambda.Tiger & drofseh

## 85. CBA_fnc_cssColorToHEX

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_cssColorToHEX-sqf.html#CBA_fnc_cssColorToHEX

CBA_fnc_cssColorToHEX
Description
Converts a CSS extended color keyword to a hexidecimal coded color without transparency.  Reference for colors: https://www.w3.org/TR/css-color-3/#svg-color Parameters: _colorKeyword - A color keyword as defined as part of W3c’s CSS color module level 3.  STRING Returns: Hexidecimal color code in “#RRGGBB” format STRING Examples:
"paleturquoise" call CBA_fnc_cssColorToHEX
Author: Lambda.Tiger & drofseh

## 86. CBA_fnc_cssColorToTexture

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_cssColorToTexture-sqf.html#CBA_fnc_cssColorToTexture

CBA_fnc_cssColorToTexture
Description
Converts a CSS extended color keyword to a procedural texture without alpha.  Reference for colors: https://www.w3.org/TR/css-color-3/#svg-color Parameters: _colorKeyword - A color keyword as defined as part of W3c’s CSS color module level 3.  STRING Returns: Procedural color texture without transparency STRING Examples:
"firebrick" call CBA_fnc_cssColorToTexture
Author: Lambda.Tiger & drofseh

## 87. CBA_fnc_currentMagazineIndex

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_currentMagazineIndex-sqf.html#CBA_fnc_currentMagazineIndex

CBA_fnc_currentMagazineIndex
Description
Finds out the magazine ID of the currently loaded magazine of given unit.
Parameters
_unitUnit to check <OBJECT>
_turretWhat turret should be examined.  ARRAY

Returns
Magazine ID STRING
Author
commy2

## 88. CBA_fnc_currentUnit

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_currentUnit-sqf.html#CBA_fnc_currentUnit

CBA_fnc_currentUnit
Description
Returns the controlled unit.  (“player” or remote controlled unit via zeus)
Parameters
None
Returns
Currently controlled unit <OBJECT>
Author
commy2

## 89. CBA_fnc_debug

Source: https://cbateam.github.io/CBA_A3/docs/files/diagnostic/fnc_debug-sqf.html#CBA_fnc_debug

CBA_fnc_debug
Description
General Purpose Debug Message Writer
Handles very long messages without losing text.
Parameters
_messageMessage to write <STRING, ARRAY>
_titleMessage title (optional, default: “cba_diagnostic”) STRING
_typeType of message ARRAY
0: _useChatWrite to chat (optional, default: true) <BOOLEAN>
1: _useLogLog to arma.rpt (optional, default: true) <BOOLEAN>
2: _globaltrue: execute global (optional, default: false) <BOOLEAN>

Returns
nil
Examples
// Write the debug message in chat-log of every client
["New Player Joined the Server!", "cba_network", [true, false, true]] call CBA_fnc_debug;
Author
Sickboy, commy2

## 90. DEBUG_MODE_FULL

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#DEBUG_MODE_FULL

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 91. DEBUG_MODE_MINIMAL

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#DEBUG_MODE_MINIMAL

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 92. DEBUG_MODE_NORMAL

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#DEBUG_MODE_NORMAL

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 93. DEBUG_MODE_x

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#DEBUG_MODE_x

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 94. Debugging

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#Debugging

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 95. DEC

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#DEC

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 96. CBA_fnc_decodeURL

Source: https://cbateam.github.io/CBA_A3/docs/files/strings/fnc_decodeURL-sqf.html#CBA_fnc_decodeURL

CBA_fnc_decodeURL
Description
Reverse URL encoded text to readable text.
Parameters
_stringURL encoded text STRING

Returns
_returnHuman readable text STRING

Examples
"Mission%20Name" call CBA_fnc_decodeURL; // "Mission Name"
Author
commy2

## 97. DEFAULT_PARAM

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#DEFAULT_PARAM

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 98. CBA_fnc_deleteEntity

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_deleteEntity-sqf.html#CBA_fnc_deleteEntity

CBA_fnc_deleteEntity
Description
A function used to delete entities
Parameters
_entity to delete.  Can be array of entites.  <ARRAY, OBJECT, GROUP, LOCATION, MARKER>
Example
[car1,car2,car3] call CBA_fnc_deleteEntity
Returns
Nothing
Author
Rommel

## 99. CBA_fnc_deleteNamespace

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_deleteNamespace-sqf.html#CBA_fnc_deleteNamespace

CBA_fnc_deleteNamespace
Description
Deletes a namespace created with CBA_fnc_createNamespace.
Parameters
_namespacea namespace <LOCATION>

Returns
None
Examples
_namespace call CBA_fnc_deleteNamespace;
Author
commy2

## 100. CBA_fnc_deletePerFrameHandlerObject

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_deletePerFrameHandlerObject-sqf.html#CBA_fnc_deletePerFrameHandlerObject

CBA_fnc_deletePerFrameHandlerObject
Description
Deletes a PFH object that was previously created via CBA_fnc_createPerFrameHandlerObject
Parameters
_logicThe PFH object <LOCATION>

Returns
None
Examples
_pfhLogic call CBA_fnc_deletePerFrameHandlerObject;
Author
commy2

## 101. DEPRECATE

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#DEPRECATE

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 102. DEPRECATE_SYS

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#DEPRECATE_SYS

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 103. DEPRECATED

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#DEPRECATED

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 104. CBA_fnc_deserializeNamespace

Source: https://cbateam.github.io/CBA_A3/docs/files/hashes/fnc_deserializeNamespace-sqf.html#CBA_fnc_deserializeNamespace

CBA_fnc_deserializeNamespace
Description
Creates namespace containing all variables stored in a CBA hash.
Parameters
_hasha hash ARRAY
_isGlobalcreate a global namespace (optional, default: false) <BOOLEAN>

Returns
_namespacea namespace <LOCATION, OBJECT>

Examples
private _hash = profileNamespace getVariable "My_serializedNamespace";
My_namespace = [_hash] call CBA_fnc_deserializeNamespace;
Author
commy2

## 105. CBA_fnc_directCall

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_directCall-sqf.html#CBA_fnc_directCall

CBA_fnc_directCall
Description
Executes a piece of code in unscheduled environment.
Parameters
_codeCode to execute <CODE>
_argumentsParameters to call the code with.  (optional) <ANY>

Returns
_returnReturn value of the function <ANY>

Examples
0 spawn { {systemChat str canSuspend} call CBA_fnc_directCall; };
-> false
Author
commy2

## 106. CBA_fnc_dropItem

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_dropItem-sqf.html#CBA_fnc_dropItem

CBA_fnc_dropItem
Description
Drops an item.
Function which verifies existence of _item and _unit, returns false in case of trouble, or when able to remove _item from _unit true in case of success
Parameters
_unitthe unit that should drop the item <OBJECT>
_itemclass name of the item to drop STRING

Returns
true if successful, false otherwise <BOOLEAN>
Examples
_result = [player, "FirstAidKit"] call CBA_fnc_dropItem
Author
commy2

## 107. CBA_fnc_dropMagazine

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_dropMagazine-sqf.html#CBA_fnc_dropMagazine

CBA_fnc_dropMagazine
Description
Drops a magazine.
Function which verifies existence of _item and _unit, returns false in case of trouble, or when able to remove _item from _unit true in case of success.
Parameters
_unitthe unit that should drop a magazine <OBJECT>
_itemclass name of the magazine to drop STRING
_ammoammo count (optional).  If not specified a random magazine is chosen <NUMBER>

Returns
true if successful, false otherwise <BOOLEAN>
Examples
_result = [player, "SmokeShell"] call CBA_fnc_dropMagazine
Author
?, commy2

## 108. CBA_fnc_dropWeapon

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_dropWeapon-sqf.html#CBA_fnc_dropWeapon

CBA_fnc_dropWeapon
Description
Drops a weapon (including binocular).
Function which verifies existence of _item and _unit, returns false in case of trouble, or when able to remove _item from _unit true in case of success
Parameters
_unitthe unit that should drop a weapon <OBJECT>
_itemclass name of the weapon to drop STRING

Returns
true if successful, false otherwise <BOOLEAN>
Examples
_result = [player, primaryWeapon player] call CBA_fnc_dropWeapon
Author
commy2

## 109. CBA_fnc_encodeJSON

Source: https://cbateam.github.io/CBA_A3/docs/files/hashes/fnc_encodeJSON-sqf.html#CBA_fnc_encodeJSON

CBA_fnc_encodeJSON
Description
Serializes input to a JSON string.  Can handle
ARRAY
BOOL
CONTROL
GROUP
LOCATION
NAMESPACE
NIL (ANY)
NUMBER
OBJECT
STRING
TASK
TEAM_MEMBER
HASHMAP
Everything else will simply be stringified.

Parameters
_objectObject to serialize.  <ARRAY, ...>

Returns
_jsonJSON string containing serialized object.

Examples
private _settings = call CBA_fnc_createNamespace;
_settings setVariable ["enabled", true];
private _json = [_settings] call CBA_fnc_encodeJSON;
Author
BaerMitUmlaut

## 110. ERROR

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#ERROR

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 111. ERROR_MSG

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#ERROR_MSG

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 112. ERROR_WITH_TITLE

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#ERROR_WITH_TITLE

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 113. CBA_fnc_escapeRegex

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_escapeRegex-sqf.html#CBA_fnc_escapeRegex

CBA_fnc_escapeRegex
Description
Escapes special characters used in regex from a string
Parameters
_stringString to sanitize STRING

Returns
Safe string STRING
Examples
"\Q.*?AK-15.*?\E" call CBA_fnc_escapeRegex;
Author
LinkIsGrim

## 114. CBA_fnc_execAfterNFrames

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_execAfterNFrames-sqf.html#CBA_fnc_execAfterNFrames

CBA_fnc_execAfterNFrames
Description
Executes the given code after the specified number of frames.
Parameters
_functionThe function to run.  <CODE>
_argsParameters passed to the function executing.  This will be the same array every execution.  (optional, default: []) <ANY>
_framesThe amount of frames the execution of the function should be delayed by.  (optional, default: 0) <NUMBER>

Returns
Nothing Useful
Examples
[{hint "Done!"}, [], 5] call cba_fnc_execAfterNFrames;
Author
mharis001, donated from ZEN

## 115. CBA_fnc_execNextFrame

Source: https://cbateam.github.io/CBA_A3/docs/files/common/fnc_execNextFrame-sqf.html#CBA_fnc_execNextFrame

CBA_fnc_execNextFrame
Description
Executes a code once in non sched environment on the next frame.
Parameters
_functionThe function to run.  <CODE>
_argsParameters passed to the function executing.  This will be the same array every execution.  (optional, default: []) <ANY>

Returns
Nothing Useful
Examples
[{player sideChat format ["This is frame %1, not %2", diag_frameNo, _this select 0];}, [diag_frameNo]] call CBA_fnc_execNextFrame;
Author
esteldunedain and PabstMirror, donated from ACE3

## 116. EXPLODE_1(ARRAY,A,B)

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#EXPLODE_1(ARRAY,A,B)

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 117. EXPLODE_2(ARRAY,A,B)

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#EXPLODE_2(ARRAY,A,B)

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 118. EXPLODE_3(ARRAY,A,B,C)

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#EXPLODE_3(ARRAY,A,B,C)

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 119. EXPLODE_4(ARRAY,A,B,C,D)

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#EXPLODE_4(ARRAY,A,B,C,D)

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 120. EXPLODE_5(ARRAY,A,B,C,D,E)

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#EXPLODE_5(ARRAY,A,B,C,D,E)

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 121. EXPLODE_6(ARRAY,A,B,C,D,E,F)

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#EXPLODE_6(ARRAY,A,B,C,D,E,F)

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 122. EXPLODE_7(ARRAY,A,B,C,D,E,F,G)

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#EXPLODE_7(ARRAY,A,B,C,D,E,F,G)

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 123. EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 124. EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2

## 125. EXPLODE_n

Source: https://cbateam.github.io/CBA_A3/docs/files/main/script_macros_common-hpp.html#EXPLODE_n

script_macros_common.hpp
Description
A general set of useful macro functions for use by CBA itself or by any module that uses CBA.
Authors
Sickboy <sb_at_dev-heaven.net> and Spooner
Summary
script_macros_common.hppA general set of useful macro functions for use by CBA itself or by any module that uses CBA.
VERSION_CONFIGDefine CBA Versioning System config entries.
Debugging
DEBUG_MODE_xManaging debugging based on debug level.
LOG()Log a debug message into the RPT log.
INFO()Record a message without file and line number in the RPT log.
WARNING()Record a non-critical error in the RPT log.
ERROR()Record a critical error in the RPT log.
ERROR_MSG()Record a critical error in the RPT log and display on screen error message.
ERROR_WITH_TITLE()Record a critical error in the RPT log.
MESSAGE_WITH_TITLE()Record a single line in the RPT log.
RETDEF()If a variable is undefined, return the default value.
RETNIL()If a variable is undefined, return the value nil.
TRACE_n()Log a message and 1-8 variables to the RPT log.
General
INC()Increase a number by one.
DEC()Decrease a number by one.
ADD()Add a value to a variable.
SUB()Subtract a value from a number variable.
REM()Remove an element from an array each time it occurs.
PUSH()Appends a single value onto the end of an ARRAY.
MAP()Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.
FILTER()Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
UNIQUE()Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
INTERSECTION()Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
ISNILS()Sets a variable with a value, but only if it is undefined.
GVAR()Get full variable identifier for a global variable owned by this component.
GVARMAIN()Get full variable identifier for a global variable owned by this addon.
PREP()Defines a function.
PATHTO_FNC()Defines a function inside CfgFunctions.
ARG_#()Select from list of array arguments
ARR_#()Create list from arguments.
FORMAT_#(STR, ARG1)
IS_x()Checking the data types of variables.
SCRIPT()Sets name of script (relies on PREFIX and COMPONENT values being #defined).
EXPLODE_n()
xSTRING()Get full string identifier from a stringtable owned by this component.
Managing Function Parameters
PARAMS_n()
DEFAULT_PARAM()
KEY_PARAM()Get value from key in _this list, return default when key is not included in list.
Assertions
ASSERT_TRUE()Asserts that a CONDITION is true.
ASSERT_FALSE()Asserts that a CONDITION is false.
ASSERT_OP()Asserts that (A OPERATOR B) is true.
ASSERT_DEFINED()Asserts that a VARIABLE is defined.
Unit tests
TEST_TRUE()Tests that a CONDITION is true.
TEST_FALSE()Tests that a CONDITION is false.
TEST_OP()Tests that (A OPERATOR B) is true.
TEST_DEFINED_AND_OP()Tests that A and B are defined and (A OPERATOR B) is true.
TEST_DEFINED()Tests that a VARIABLE is defined.
Managing Deprecation
DEPRECATE_SYS()Allow deprecation of a function that has been renamed.
DEPRECATE()Allow deprecation of a function, in the current component, that has been renamed.
OBSOLETE_SYS()Replace a function that has become obsolete.
OBSOLETE()Replace a function, in the current component, that has become obsolete.
IS_ADMINCheck if the local machine is an admin in the multiplayer environment.
IS_ADMIN_LOGGEDCheck if the local machine is a logged in admin in the multiplayer environment.
FILE_EXISTSCheck if a file exists

VERSION_CONFIG
Define CBA Versioning System config entries.
VERSION should be a floating-point number (1 separator).  VERSION_STR is a string representation of the version.  VERSION_AR is an array representation of the version.
VERSION must always be defined, otherwise it is 0.  VERSION_STR and VERSION_AR default to VERSION if undefined.
Parameters
None
Example
#define VERSION 1.0
#define VERSION_STR 1.0.1
#define VERSION_AR 1,0,1

class CfgPatches {
    class MyMod_main {
        VERSION_CONFIG;
    };
};
Author
?, Jonpas

Debugging

DEBUG_MODE_x
Managing debugging based on debug level.
According to the highest level of debugging that has been defined before script_macros_common.hpp is included, only the appropriate debugging commands will be functional.  With no level explicitely defined, assume DEBUG_MODE_NORMAL.
DEBUG_MODE_FULLFull debugging output.
DEBUG_MODE_NORMALAll debugging except TRACE_n() and LOG() (Default setting if none specified).
DEBUG_MODE_MINIMALOnly ERROR() and ERROR_WITH_TITLE() enabled.

Examples
In order to turn on full debugging for a single file,
// Top of individual script file.
#define DEBUG_MODE_FULL
#include "script_component.hpp"
In order to force minimal debugging for a single component,
// Top of addons\<component>\script_component.hpp
// Ensure that any FULL and NORMAL setting from the individual files are undefined and MINIMAL is set.
#ifdef DEBUG_MODE_FULL
#undef DEBUG_MODE_FULL
#endif
#ifdef DEBUG_MODE_NORMAL
#undef DEBUG_MODE_NORMAL
#endif
#ifndef DEBUG_MODE_MINIMAL
#define DEBUG_MODE_MINIMAL
#endif
#include "script_macros.hpp"
In order to turn on full debugging for a whole addon,
// Top of addons\main\script_macros.hpp
#ifndef DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#endif
#include "\x\cba\addons\main\script_macros_common.hpp"
Author
Spooner

LOG()
Log a debug message into the RPT log.
Only run if DEBUG_MODE_FULL is defined.
Parameters
MESSAGEMessage to record STRING

Example
LOG("Initiated clog-dancing simulator.");
Author
Spooner

INFO()
Record a message without file and line number in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
INFO("Mod X is loaded, do Y");
Author
commy2

WARNING()
Record a non-critical error in the RPT log.
Only run if DEBUG_MODE_NORMAL or higher is defined.
Parameters
MESSAGEMessage to record STRING

Example
WARNING("This function has been deprecated. Please don't use it in future!");
Author
Spooner

ERROR()
Record a critical error in the RPT log.
Parameters
MESSAGEMessage to record STRING

Example
ERROR("value of frog not found in config ...yada...yada...");
Author
Spooner

ERROR_MSG()
Record a critical error in the RPT log and display on screen error message.
Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
MESSAGEMessage to record STRING

Example
ERROR_MSG("value of frog not found in config ...yada...yada...");
Author
commy2

ERROR_WITH_TITLE()
Record a critical error in the RPT log.
The title can be specified (in ERROR() the heading is always just “ERROR”) Newlines (\n) in the MESSAGE will be put on separate lines.
Parameters
TITLETitle of error message STRING
MESSAGEBody of error message STRING

Example
ERROR_WITH_TITLE("Value not found","Value of frog not found in config ...yada...yada...");
Author
Spooner

MESSAGE_WITH_TITLE()
Record a single line in the RPT log.
Parameters
TITLETitle of log message STRING
MESSAGEBody of message STRING

Example
MESSAGE_WITH_TITLE("Value found","Value of frog found in config <someconfig>");
Author
Killswitch

RETDEF()
If a variable is undefined, return the default value.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check
DEFAULT_VALUEthe default value to use if variable is undefined

Example
// _var is undefined
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=5"
_var = 7;
hintSilent format ["_var=%1", RETDEF(_var,5)]; // "_var=7"
Author: 654wak654

RETNIL()
If a variable is undefined, return the value nil.  Otherwise, return the variable itself.
Parameters
VARIABLEthe variable to check

Example
// _var is undefined
hintSilent format ["_var=%1", RETNIL(_var)]; // "_var=any"
Author
Alef (see CBA issue #8514)

TRACE_n()
Log a message and 1-8 variables to the RPT log.
Only run if DEBUG_MODE_FULL is defined.
TRACE_1(MESSAGE,A)Log 1 variable.
TRACE_2(MESSAGE,A,B)Log 2 variables.
TRACE_3(MESSAGE,A,B,C)Log 3 variables.
TRACE_4(MESSAGE,A,B,C,D)Log 4 variables.
TRACE_5(MESSAGE,A,B,C,D,E)Log 5 variables.
TRACE_6(MESSAGE,A,B,C,D,E,F)Log 6 variables.
TRACE_7(MESSAGE,A,B,C,D,E,F,G)Log 7 variables.
TRACE_8(MESSAGE,A,B,C,D,E,F,G,H)Log 8 variables.
TRACE_9(MESSAGE,A,B,C,D,E,F,G,H,I)Log 9 variables.

Parameters
MESSAGEMessage to add to the trace [String]
A..HVariable names to log values of [Any]

Example
TRACE_3("After takeoff",_vehicle player,getPos (_vehicle player), getPosASL (_vehicle player));
Author
Spooner

General

INC()
Description
Increase a number by one.
Parameters
VARVariable to increment [Number]

Example
_counter = 0;
INC(_counter);
// _counter => 1
Author
Spooner

DEC()
Description
Decrease a number by one.
Parameters
VARVariable to decrement [Number]

Example
_counter = 99;
DEC(_counter);
// _counter => 98
Author
Spooner

ADD()
Description
Add a value to a variable.  Variable and value should be both Numbers or both Strings.
Parameters
VARVariable to add to [Number or String]
VALUEValue to add [Number or String]

Examples
_counter = 2;
ADD(_counter,3);
// _counter => 5
_str = "hello";
ADD(_str," ");
ADD(_str,"Fred");
// _str => "hello Fred"
Author
Sickboy

SUB()
Description
Subtract a value from a number variable.  VAR and VALUE should both be Numbers.
Parameters
VARVariable to subtract from [Number]
VALUEValue to subtract [Number]

Examples
_numChickens = 2;
SUB(_numChickens,3);
// _numChickens => -1

REM()
Description
Remove an element from an array each time it occurs.
This recreates the entire array, so use BIS_fnc_removeIndex if modification of the original array is required or if only one of the elements that matches ELEMENT needs to be removed.
Parameters
ARRAYArray to modify [Array]
ELEMENTElement to remove [Any]

Examples
_array = [1, 2, 3, 4, 3, 8];
REM(_array,3);
// _array = [1, 2, 4, 8];
Author
Spooner

PUSH()
Description
Appends a single value onto the end of an ARRAY.  Change is made to the ARRAY itself, not creating a new array.
Parameters
ARRAYArray to push element onto [Array]
ELEMENTElement to push [Any]

Examples
_fish = ["blue", "green", "smelly"];
PUSH(_fish,"monkey-flavoured");
// _fish => ["blue", "green", "smelly", "monkey-flavoured"]
Author
Spooner

MAP()
Description
Applies given code to each element of the array, then assigns the resulting array to the original Parameters: ARRAY - Array to be modified CODE - Code that’ll be applied to each element of the array.  Example:
_array = [1, 2, 3, 4, 3, 8];
MAP(_array,_x + 1);
// _array is now [2, 3, 4, 5, 4, 9];
Author: 654wak654

FILTER()
Description
Filters an array based on given code, then assigns the resulting array to the original Parameters: ARRAY - Array to be filtered CODE - Condition to pick elements Example:
_array = [1, 2, 3, 4, 3, 8];
FILTER(_array,_x % 2 == 0)
// _array is now [2, 4, 8];
Author: Commy2

UNIQUE()
Description
Removes duplicate values in given array Parameters: ARRAY - The array to be modified Example:
_someArray = [4, 4, 5, 5, 5, 2];
UNIQUE(_someArray);
// _someArray is now [4, 5, 2]
Author: Commy2

INTERSECTION()
Description
Finds unique common elements between two arrays and assigns them to the first array Parameters: ARRAY0 - The array to be modified ARRAY1 - The array to find intersections with Example:
_someArray = [1, 2, 3, 4, 5, 5];
_anotherArray = [4, 5, 6, 7];
INTERSECTION(_someArray,_anotherArray);
// _someArray is now [4, 5]
Author: 654wak654

ISNILS()
Description
Sets a variable with a value, but only if it is undefined.
Parameters
VARIABLEVariable to set [Any, not nil]
DEFAULT_VALUEValue to set VARIABLE to if it is undefined [Any, not nil]

Examples
// _fish is undefined
ISNILS(_fish,0);
// _fish => 0
_fish = 12;
// ...later...
ISNILS(_fish,0);
// _fish => 12
Author
Sickboy

GVAR()
Get full variable identifier for a global variable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
GVAR(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_FrogDancing_frog = 12
Author
Sickboy

GVARMAIN()
Get full variable identifier for a global variable owned by this addon.
Parameters
VARIABLEPartial name of global variable owned by this addon [Any].

Example
GVARMAIN(frog) = 12;
// In SPON_FrogDancing component, equivalent to SPON_frog = 12
Author
Sickboy

PREP()
Description
Defines a function.
Full file path
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’
Resulting function name
’PREFIX_COMPONENT_<FNC>’
The PREP macro should be placed in a script run by a XEH preStart and XEH preInit event.
The PREP macro allows for CBA function caching, which drastically speeds up load times.  Beware though that function caching is enabled by default and as such to disable it, you need to #define DISABLE_COMPILE_CACHE above your #include “script_components.hpp” include!
The function will be defined in ui and mission namespace.  It can not be overwritten without a mission restart.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
PREP(banana);
call FUNC(banana);
Author
dixon13

PATHTO_FNC()
Description
Defines a function inside CfgFunctions.
Full file path in addons
’\MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\fnc_<FNC>.sqf’ Define ‘RECOMPILE’ to enable recompiling.  Define ‘SKIP_FUNCTION_HEADER’ to skip adding function header.
Parameters
FUNCTION NAMEName of the function, unquoted STRING

Examples
// file name: fnc_addPerFrameHandler.sqf
class CfgFunctions {
    class CBA {
        class Misc {
            PATHTO_FNC(addPerFrameHandler);
        };
    };
};
// -> CBA_fnc_addPerFrameHandler
Author
dixon13, commy2

ARG_#()
Select from list of array arguments
Parameters
VARIABLE(1-8)elements for the list

Author
Rommel

ARR_#()
Create list from arguments.  Useful for working around , in macro parameters.  1-8 arguments possible.
Parameters
VARIABLE(1-8)elements for the list

Author
Nou

FORMAT_#(STR, ARG1)
FormatUseful for working around , in macro parameters.  1-8 arguments possible.

Parameters
STRINGstring used by format
VARIABLE(1-8)elements for usage in format

Author
Nou & Sickboy

IS_x()
Checking the data types of variables.
IS_ARRAY()Array
IS_BOOL()Boolean
IS_BOOLEAN()UI display handle(synonym for IS_BOOL())
IS_CODE()Code block (i.e a compiled function)
IS_CONFIG()Configuration
IS_CONTROL()UI control handle.
IS_DISPLAY()UI display handle.
IS_FUNCTION()A compiled function (synonym for IS_CODE())
IS_GROUP()Group.
IS_INTEGER()Is a number a whole number?
IS_LOCATION()World location.
IS_NUMBER()A floating point number (synonym for IS_SCALAR())
IS_OBJECT()World object.
IS_SCALAR()Floating point number.
IS_SCRIPT()A script handle (as returned by execVM and spawn commands).
IS_SIDE()Game side.
IS_STRING()World object.
IS_TEXT()Structured text.

Parameters
VARIABLEVariable to check if it is of a particular type [Any, not nil]

Author
Spooner

SCRIPT()
Sets name of script (relies on PREFIX and COMPONENT values being #defined).  Define ‘SKIP_SCRIPT_NAME’ to skip adding scriptName.
Parameters
NAMEName of script [Indentifier]

Example
SCRIPT(eradicateMuppets);
Author
Spooner

EXPLODE_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Splitting an ARRAY into a number of variables (A, B, C, etc).
Note that this NOT does make the created variables private.  _PVT variants do.
EXPLODE_1(ARRAY,A,B)Split a 1-element array into separate variable.
EXPLODE_2(ARRAY,A,B)Split a 2-element array into separate variables.
EXPLODE_3(ARRAY,A,B,C)Split a 3-element array into separate variables.
EXPLODE_4(ARRAY,A,B,C,D)Split a 4-element array into separate variables.
EXPLODE_5(ARRAY,A,B,C,D,E)Split a 5-element array into separate variables.
EXPLODE_6(ARRAY,A,B,C,D,E,F)Split a 6-element array into separate variables.
EXPLODE_7(ARRAY,A,B,C,D,E,F,G)Split a 7-element array into separate variables.
EXPLODE_8(ARRAY,A,B,C,D,E,F,G,H)Split a 8-element array into separate variables.
EXPLODE_9(ARRAY,A,B,C,D,E,F,G,H,I)Split a 9-element array into separate variables.

Parameters
ARRAYArray to read from [Array]
A..HNames of variables to set from array [Identifier]

Example
_array = ["fred", 156.8, 120.9];
EXPLODE_3(_array,_name,_height,_weight);
Author
Spooner

xSTRING()
Get full string identifier from a stringtable owned by this component.
Parameters
VARIABLEPartial name of global variable owned by this component [Any].

Example
ADDON is CBA_Balls.
// Localized String (localize command must still be used with it)
LSTRING(Example); // STR_CBA_Balls_Example;
// Config String (note the $)
CSTRING(Example); // $STR_CBA_Balls_Example;
Author
Jonpas

Managing Function Parameters

PARAMS_n()
DEPRECATEDUse param/params commands added in Arma 3 1.48

Setting variables based on parameters passed to a function.
Each parameter is defines as private and set to the appropriate value from _this.
PARAMS_1(A)Get 1 parameter from the _this array (or _this if it’s not an array).
PARAMS_2(A,B)Get 2 parameters from the _this array.
PARAMS_3(A,B,C)Get 3 parameters from the _this array.
PARAMS_4(A,B,C,D)Get 4 parameters from the _this array.
PARAMS_5(A,B,C,D,E)Get 5 parameters from the _this array.
PARAMS_6(A,B,C,D,E,F)Get 6 parameters from the _this array.
PARAMS_7(A,B,C,D,E,F,G)Get 7 parameters from the _this array.
PARAMS_8(A,B,C,D,E,F,G,H)Get 8 parameters from the _this array.

Parameters
A..HName of variable to read from _this [Identifier]

Example
A function called like this:
[_name,_address,_telephone] call recordPersonalDetails;
expects 3 parameters and those variables could be initialised at the start of the function definition with:
recordPersonalDetails = {
    PARAMS_3(_name,_address,_telephone);
    // Rest of function follows...
};
Author
Spooner

DEFAULT_PARAM()
DEPRECATEDUse param/params commands added in Arma 3 1.48 - Will not work with HEMTT 1.13.2+

Getting a default function parameter.  This may be used together with PARAMS_n() to have a mix of required and optional parameters.
Parameters
INDEXIndex of parameter in _this [Integer, 0+]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case the array is too short or the value at INDEX is nil [Any]

Example
A function called with optional parameters:
[_name] call myFunction;
[_name, _numberOfLegs] call myFunction;
[_name, _numberOfLegs, _hasAHead] call myFunction;
1 required parameter and 2 optional parameters.  Those variables could be initialised at the start of the function definition with:
myFunction = {
    PARAMS_1(_name);
    DEFAULT_PARAM(1,_numberOfLegs,2);
    DEFAULT_PARAM(2,_hasAHead,true);
    // Rest of function follows...
};
Author
Spooner

KEY_PARAM()
Get value from key in _this list, return default when key is not included in list.
Parameters
KEYKey name [String]
NAMEName of the variable to set [Identifier]
DEF_VALUEDefault value to use in case key not found [ANY]

Example
Author
Muzzleflash

Assertions

ASSERT_TRUE()
Asserts that a CONDITION is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
ASSERT_TRUE(_frogIsDead,"The frog is alive");
Author
Spooner

ASSERT_FALSE()
Asserts that a CONDITION is false.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
ASSERT_FALSE(_frogIsDead,"The frog died");
Author
Spooner

ASSERT_OP()
Asserts that (A OPERATOR B) is true.  When an assertion fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
ASSERT_OP(_fish,>,5,"Too few fish!");
Author
Spooner

ASSERT_DEFINED()
Asserts that a VARIABLE is defined.  When an assertion fails, an error is raised with the given MESSAGE..
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
ASSERT_DEFINED("_anUndefinedVar","Too few fish!");
ASSERT_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Spooner

Unit tests

TEST_TRUE()
Tests that a CONDITION is true.  If the condition is not true, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to assert as true [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is false [String]

Example
TEST_TRUE(_frogIsDead,"The frog is alive");
Author
Killswitch

TEST_FALSE()
Tests that a CONDITION is false.  If the condition is not false, an error is raised with the given MESSAGE.
Parameters
CONDITIONCondition to test as false [Boolean]
MESSSAGEMessage to display if (A OPERATOR B) is true [String]

Example
TEST_FALSE(_frogIsDead,"The frog died");
Author
Killswitch

TEST_OP()
Tests that (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display if (A OPERATOR B)  is false.  [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch

TEST_DEFINED_AND_OP()
Tests that A and B are defined and (A OPERATOR B) is true.  If the test fails, an error is raised with the given MESSAGE.
Parameters
AFirst value [Any]
OPERATORBinary operator to use [Operator]
BSecond value [Any]
MESSSAGEMessage to display [String]

Example
TEST_OP(_fish,>,5,"Too few fish!");
Author
Killswitch, PabstMirror

TEST_DEFINED()
Tests that a VARIABLE is defined.
Parameters
VARIABLEVariable to test if defined [String or Function].
MESSAGEMessage to display if variable is undefined [String].

Examples
TEST_DEFINED("_anUndefinedVar","Too few fish!");
TEST_DEFINED({ obj getVariable "anUndefinedVar" },"Too many fish!");
Author
Killswitch

Managing Deprecation

DEPRECATE_SYS()
Allow deprecation of a function that has been renamed.
Replaces an old OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
NEW_FUNCTIONFull name of new function [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE_SYS(CBA_fnc_frog,CBA_fnc_fish);
Author
Sickboy

DEPRECATE()
Allow deprecation of a function, in the current component, that has been renamed.
Replaces an OLD_FUNCTION (which will have PREFIX_ prepended) with a NEW_FUNCTION (PREFIX_ prepended) with the intention that the old function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, but runs the new function.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
NEW_FUNCTIONName of new function, assuming PREFIX [Function]

Example
// After renaming CBA_fnc_frog as CBA_fnc_fish
DEPRECATE(fnc_frog,fnc_fish);
Author
Sickboy

OBSOLETE_SYS()
Replace a function that has become obsolete.
Replace an obsolete OLD_FUNCTION with a simple COMMAND_FUNCTION, with the intention that anyone using the function should replace it with the simple command, since the function will be disabled in the future.
Shows a warning in RPT each time the deprecated function is used, and runs the command function.
Parameters
OLD_FUNCTIONFull name of old function [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE_SYS(CBA_fMyWeapon,{ currentWeapon player });
Author
Spooner

OBSOLETE()
Replace a function, in the current component, that has become obsolete.
Replace an obsolete OLD_FUNCTION (which will have PREFIX_ prepended) with a simple COMMAND_CODE, with the intention that anyone using the function should replace it with the simple command.
Shows a warning in RPT each time the deprecated function is used.
Parameters
OLD_FUNCTIONName of old function, assuming PREFIX [Identifier for function that does not exist any more]
COMMAND_CODECode to replace the old function [Function]

Example
// In Arma2, currentWeapon command made the CBA_fMyWeapon function obsolete:
OBSOLETE(fMyWeapon,{ currentWeapon player });
Author
Spooner

IS_ADMIN
Check if the local machine is an admin in the multiplayer environment.
Reports ‘true’ for logged and voted in admins.
Parameters
None
Example
// print "true" if player is admin
systemChat str IS_ADMIN;
Author
commy2

IS_ADMIN_LOGGED
Check if the local machine is a logged in admin in the multiplayer environment.
Reports ‘false’ if the player was voted to be the admin.
Parameters
None
Example
// print "true" if player is admin and entered in the server password
systemChat str IS_ADMIN_LOGGED;
Author
commy2

FILE_EXISTS
Check if a file exists
Reports “false” if the file does not exist.
Parameters
FILEPath to the file

Example
// print "true" if file exists
systemChat str FILE_EXISTS("\A3\ui_f\data\igui\cfg\cursors\weapon_ca.paa");
Author
commy2
