/*
 * Alfa/Traffic/Common/Common.sqf
 * Defines shared parameter lookup helpers for Alfa traffic.
 */

ENGIMA_TRAFFIC_GetParamValue = {
	private ["_params", "_key"];
	private ["_value"];

	_params = _this select 0;
	_key = _this select 1;
	_value = if (count _this > 2) then { _this select 2 } else { objNull };

	{
		if (_x select 0 == _key) then {
			_value = _x select 1;
		};
	} foreach (_params);

	_value
};

ENGIMA_TRAFFIC_MarkerExists = {
	private ["_exists", "_marker"];

	_marker = _this select 0;

	_exists = false;
	if (((getMarkerPos _marker) select 0) != 0 || ((getMarkerPos _marker) select 1 != 0)) then {
		_exists = true;
	};
	_exists
};
