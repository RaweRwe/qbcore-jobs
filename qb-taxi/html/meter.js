var meterStarted = false;
var meterPlate = null;

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            $.post('http://qb-taxi/hideMouse');
            break;
    }
});

$(document).ready(function(){

    $('.container').hide();

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "openMeter") {
            if (eventData.toggle) {
                openMeter(eventData.meterData)
                meterPlate = eventData.plate;
            } else {
                closeMeter()
                meterPlate = null;
            }
        }

        if (eventData.action == "toggleMeter") {
            meterToggle()
        }

        if (eventData.action == "updateMeter") {
            updateMeter(eventData.meterData)
        }

        if (eventData.action == "resetMeter") {
            resetMeter()
        }
    });
});

function updateMeter(meterData) {
    $("#total-price").html("$ "+ (meterData.currentFare).toFixed(2))
    $("#total-distance").html((meterData.distanceTraveled / 200).toFixed(1) + " KM")
}

function resetMeter() {
    $("#total-price").html("$ 0.00")
    $("#total-distance").html("0.0 KM")
}

function meterToggle() {
    if (!meterStarted) {
        $.post('http://qb-taxi/enableMeter', JSON.stringify({
            enabled: true,
        }));
        toggleMeter(true)
        meterStarted = true;
    } else {
        $.post('http://qb-taxi/enableMeter', JSON.stringify({
            enabled: false,
        }));
        toggleMeter(false)
        meterStarted = false;
    }
}

function toggleMeter(enabled) {
    if (enabled) {
        $(".toggle-meter-btn").html("<p>Started</p>");
        $(".toggle-meter-btn p").css({"color": "rgb(51, 160, 37)"});
    } else {
        $(".toggle-meter-btn").html("<p>Stopped</p>");
        $(".toggle-meter-btn p").css({"color": "rgb(231, 30, 37)"});
    }
}

function openMeter(meterData) {
    $('.container').fadeIn(150);
    $('#total-price-per-100m').html("$ " + (meterData.defaultPrice).toFixed(2))
}

function closeMeter() {
    $('.container').fadeOut(150);
}