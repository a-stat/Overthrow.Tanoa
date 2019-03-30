params ["_target","_destpos"];
_txt = "";
_radius = 5;
if(count _this > 2) then {
    _txt = _this select 2;
};
if(count _this > 3) then {
    _radius = _this select 3;
};

while {(count (waypoints group _target)) > 0} do {
    deleteWaypoint ((waypoints group _target) select 0);
};
private _wp = (group _target) addWaypoint [position player, 0];
private _wp = (group player) addWaypoint [_destpos, 15];
OT_missionMarker = _destpos;
OT_missionMarkerText = _txt;

[{
  params ["_target","_radius","_wp"];
  !(!isNil "_wp" && (player distance waypointPosition _wp) > _radius)
},
{
  params ["_target","_radius","_wp"];

  if(!isNil "_wp") then {
    giveWaypoint_handle = [{
      params [["_target","_radius","_wp"]];
      if ((count (waypoints group _target)) > 0) then {
        deleteWaypoint ((waypoints group _target) select 0);
        if !((count (waypoints group _target)) > 0) then {
          OT_missionMarker = nil;
          [giveWaypoint_handle] call CBA_fnc_removePerFrameHandler;
          giveWaypoint_handle = nil;
        };
      };
      }, 1, [_target,_radius,_wp]] call CBA_fnc_addPerFrameHandler;
  };
}, [_target,_radius,_wp]] call CBA_fnc_waitUntilAndExecute;

_wp;
