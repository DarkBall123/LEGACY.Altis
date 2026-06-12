/*
 * DZ_fnc_storeFlush
 * Commits pending writes of the persistent key-value store.
 *
 * Backend "profile": saveProfileNamespace (only when something is
 * pending — keeps disk writes cheap).
 * Backend "extdb3":  no-op (writes are immediate), except flushing
 * profile mirrors made while the DB was degraded.
 */

if (!isServer) exitWith { false };

if (missionNamespace getVariable ["DZ_storeFlushPending", false]) then
{
    missionNamespace setVariable ["DZ_storeFlushPending", false];
    saveProfileNamespace;
};

true
