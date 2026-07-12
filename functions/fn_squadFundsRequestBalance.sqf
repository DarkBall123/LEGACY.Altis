/*
 * DZ_fnc_squadFundsRequestBalance
 * Sends the calling player the balance of their own faction's wallet.
 *
 * If the caller belongs to a non-player side (e.g. spectator, Хунты role
 * during testing), we fall back to showing every player-side balance so
 * something useful still appears.
 */

if (!isServer) exitWith {};

params [["_caller", objNull, [objNull]]];
private _replyTarget = [owner _caller, 0] select (isNull _caller);

private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
private _callerSide  = if (isNull _caller) then { sideUnknown } else { side _caller };

private _hintTitle = "Бюджет отряда";
private _hintBody  = "";

if (_callerSide in _playerSides) then {
    private _balance = [_callerSide] call DZ_fnc_squadFundsGetBalance;
    private _label   = [_callerSide] call DZ_fnc_squadFundsSideLabel;
    _hintBody = format ["Текущий баланс %1: %2₽.", _label, _balance];
} else {

    private _lines = [];
    {
        private _balance = [_x] call DZ_fnc_squadFundsGetBalance;
        private _label   = [_x] call DZ_fnc_squadFundsSideLabel;
        _lines pushBack (format ["%1: %2₽", _label, _balance]);
    } forEach _playerSides;
    _hintBody = _lines joinString endl;
};

[_hintTitle, _hintBody] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
