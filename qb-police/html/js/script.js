Databank = {}
Fingerprint = {}

Databank.Open = function() {
 $(".databank-container").css("display", "block").css("user-select", "none");
 $(".databank-container iframe").css("display", "block");
 $(".tablet-frame").css("display", "block").css("user-select", "none");
 $(".databank-bg").css("display", "block");
 $(".Klik").css("display", "block");
}

Databank.Close = function() {
 $(".databank-container iframe").css("display", "none");
 $(".databank-container").css("display", "none");
 $(".tablet-frame").css("display", "none");
 $(".databank-bg").css("display", "none");
 $(".Klik").css("display", "none");
}

Fingerprint.Open = function() {
 $(".fingerprint-container").fadeIn(150);
 $(".fingerprint-id").html("Fingerprint ID<p>Geen resultaat</p>");
}

Fingerprint.Close = function() {
 $(".fingerprint-container").fadeOut(150);
}

Fingerprint.Update = function(data) {
 $(".fingerprint-id").html("Fingerprint ID<p>"+data.fingerprintId+"</p>");
}

$(document).on('click', '.take-fingerprint', function(){
    $.post('http://qb-police/ScanFinger');
})

document.onreadystatechange = () => {
if (document.readyState === "complete") {
 window.addEventListener('message', function(event) {
     if (event.data.type == "databank") {
         Databank.Open();
     } else if (event.data.type == "closedatabank") {
         Databank.Close();
     } else if (event.data.type == "OpenFinger") {
         Fingerprint.Open();
     } else if (event.data.type == "CloseFinger") {
         Fingerprint.Close();
     } else if (event.data.type == "UpdateFingerId") {
         Fingerprint.Update(event.data);
     } else if (event.data.type == "enablecam") {
         CameraApp.OpenCameras(event.data.label, event.data.connected, event.data.id, event.data.time);
     } else if (event.data.type == "disablecam") {
         CameraApp.CloseCameras();
     } else if (event.data.type == "updatecam") {
         CameraApp.UpdateCameraLabel(event.data.label);
     } else if (event.data.type == "updatecamtime") {
         CameraApp.UpdateCameraTime(event.data.time);
     }
    });
 };
};

$(document).on("click", ".Klik", function(e){
    e.preventDefault();
    Databank.Close();
    $.post('http://qb-police/CloseNui');
});

$(document).on('keydown', function() {
 switch(event.keyCode) {
     case 27: // ESC
      Databank.Close();
      Fingerprint.Close();
      $.post('http://qb-police/CloseNui');
      break;
 }
});