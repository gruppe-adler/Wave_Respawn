//define the paths to your loadout init for each side (e.g. bluforLoadoutPath = "loadouts\bluforInit.sqf"; if you use one init for all sides, enter the same value for each variable)
//define params for loadout init for each side (e.g. "[roleDescription player]"; if you use one init for all sides, enter the same value for each variable)
//leave empty if you are not using custom loadouts
bluforLoadoutPath = "";
bluforLoadoutParams = "[]";
opforLoadoutPath = "";
opforLoadoutParams = "[]";
indepLoadoutPath = "";
indepLoadoutParams = "[]";

if (!isServer) then {
  [] execVM "initWaveRespawn.sqf";
};
