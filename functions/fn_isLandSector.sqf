params
[
    ["_center", [0, 0, 0]],
    ["_halfSize", 0]
];

private _sampleOffset = _halfSize * 0.6;
private _sampleOffsets =
[
    [0, 0],
    [_sampleOffset, 0],
    [-_sampleOffset, 0],
    [0, _sampleOffset],
    [0, -_sampleOffset],
    [_sampleOffset, _sampleOffset],
    [_sampleOffset, -_sampleOffset],
    [-_sampleOffset, _sampleOffset],
    [-_sampleOffset, -_sampleOffset]
];

private _hasLand = false;

{
    private _samplePos =
    [
        (_center # 0) + (_x # 0),
        (_center # 1) + (_x # 1),
        0
    ];

    if !(surfaceIsWater _samplePos) exitWith
    {
        _hasLand = true;
    };
} forEach _sampleOffsets;

_hasLand
