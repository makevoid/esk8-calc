function updateCalcs() {
  var lipoVolts = 3.7;
  var battS = document.getElementById('battS').value;
  var battVolts = 0;

  if (battS) {
   battVolts = battS * lipoVolts;
   document.getElementById('battVolts').innerHTML = battVolts.toFixed(1);
  }

  /* ---------------------------------------------------------------------------- */

  var motorKV = document.getElementById('motorKV').value;
  var rawefficiency = document.getElementById('efficiency').value;
  var efficiency = rawefficiency / 100;
  var motorRPM = 0;
  if (motorKV && battVolts > 0) {

   motorRPM = motorKV * battVolts;
   weightedmotorRPM = motorRPM * efficiency;
   document.getElementById('motorRPM').innerHTML = motorRPM.toFixed(0);
   document.getElementById('weightedmotorRPM').innerHTML = weightedmotorRPM.toFixed(0);
  }

  /* ---------------------------------------------------------------------------- */

  var gearHub = document.getElementById('gearHub').value;
  var gearPulley = document.getElementById('gearPulley').value;
  var gearRatio = 0;
  var gearRatioDisplay = 0;
  var gearWheelSize = document.getElementById('gearWheelSize').value;

  if (gearHub && gearPulley && motorRPM > 0) {
   gearRatio = gearHub / gearPulley;
   gearRatioDisplay = gearPulley / gearHub;
   document.getElementById('gearRatio').innerHTML = gearRatioDisplay.toFixed(2).replace(/\.00$/, '') + " : 1";

   // Speed!
   var topspeedMPH = motorRPM * gearWheelSize * 3.1415926535897932 * 0.00003728226 * gearRatio;
   var topspeedKPH = topspeedMPH * 1.609344;
   var weightedtopspeedMPH = motorRPM * gearWheelSize * 3.1415926535897932 * 0.00003728226 * gearRatio * efficiency;
   var weightedtopspeedKPH = weightedtopspeedMPH * 1.609344;
   document.getElementById('finalTopSpeed').innerHTML =  topspeedMPH.toFixed(2) + " mph / " + topspeedKPH.toFixed(2) + " kph";
   document.getElementById('weightedTopSpeed').innerHTML =  weightedtopspeedMPH.toFixed(2) + " mph / " + weightedtopspeedKPH.toFixed(2) + " kph";
  }
 }
