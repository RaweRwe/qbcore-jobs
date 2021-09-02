var selectedCategory = $('#home');

var currentVehicleData = null;
var inWorldMap = false;

$(document).ready(function(){
    $('.container').hide();
    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "ui") {
            if (eventData.ui) {
                $('.container').fadeIn(200);
            } else {
                $('.container').fadeOut(200);
            }
        }

        if (eventData.action == "setupVehicles") {
            setupVehicles(eventData.vehicles)
        }
    })

    $('[data-toggle="tooltip"]').tooltip();

    $('.vehicle-category').click(function(e){
        e.preventDefault();
        var vehicleCategory = $(this).attr('id');

        $(this).addClass('selected');
        if (selectedCategory !== null && selectedCategory !== this) {
            $(selectedCategory).removeClass('selected');
        }
        if (vehicleCategory == "home") {
            resetVehicles()
            $('.vehicle-shop-home').show();
        } else {
            if ($('.vehicle-shop-home').css("display") !== "none") {
                $.post('http://qb-vehicleshop/GetCategoryVehicles', JSON.stringify({
                    selectedCategory: vehicleCategory
                }))
                $('.vehicle-shop-home').fadeOut(100);
            } else {
                $.post('http://qb-vehicleshop/GetCategoryVehicles', JSON.stringify({
                    selectedCategory: vehicleCategory
                }))
            }
        }
        selectedCategory = this;
    });

    $('.map-pin').click(function(e){
        e.preventDefault();
        var garageId = $(this).attr('id');
        $.post('http://qb-vehicleshop/buyVehicle', JSON.stringify({
            vehicleData: currentVehicleData,
            garage: garageId
        }))
        currentVehicleData = null;
        inWorldMap = false;
        $('.vehicle-shop').css("filter", "none")
        $('.buy-vehicle-map').fadeOut(100);
    });

    $("#close-map").click(function(e){
        e.preventDefault();
        $('.vehicle-shop').css("filter", "none")
        $('.buy-vehicle-map').fadeOut(100);
        currentVehicleData = null;
        inWorldMap = false;
    });
});

function setupVehicles(vehicles) {
    console.log(JSON.stringify(vehicles))
    $('.vehicles').html("");
    $.each(vehicles, function(index, vehicle){
        // console.log(vehicle)
        $('.vehicles').append('<div class="vehicle" id='+index+'><div class="car-image" style="background-image: url('+vehicle.image+')"><span id="vehicle-name">'+vehicle.name+' - '+(vehicle.category)+'</span><span id="vehicle-price">$ '+vehicle.price+'</span><div class="vehicle-buy-btn" data-vehicle="'+vehicle+'"><p>Koop Voertuig</p></div></div>');
        $('#'+index).data('vehicleData', "");
        $('#'+index).data('vehicleData', vehicle);
    })
}

function resetVehicles() {
    $('.vehicles').html("");
}

$(document).on('click', '.vehicle-buy-btn', function(e){
    if (!inWorldMap) {
        e.preventDefault();
        currentVehicleData = null;
    
        var vehicleId = $(this).parent().parent().attr('id');
        var vehicleData = $('#'+vehicleId).data('vehicleData');
        currentVehicleData = vehicleData
        inWorldMap = true;

        $('.vehicle-shop').css("filter", "blur(2px)")
    
        $('.buy-vehicle-map').fadeIn(100);
    }
})

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            $.post('http://qb-vehicleshop/exit')
            break;
    }
});