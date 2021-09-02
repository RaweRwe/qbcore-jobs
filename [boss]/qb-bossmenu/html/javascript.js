var choosingGrade = ''
var currentWithdrawAmount = 100;
var currentDepositAmount = 100;

addEventListener("message", function(event){
    let item = event.data;

    if(item.open == true) {
        if (item.class == "open") {
            $('.main-container').fadeIn();
            $('.welcome-container').fadeIn();
            document.getElementById('emplyees-list').innerHTML = item.employees;
            document.getElementById('grade-list').innerHTML = item.grades;
        }

        if (item.class == "refresh-players") {
            $('.employees-container').fadeIn();
            document.getElementById('emplyees-list').innerHTML = item.employees;
        }

        if (item.class == "refresh-recruits") {
            $('.recruits-container').fadeIn();
            document.getElementById('recruits-list').innerHTML = item.recruits;
        }

        if (item.class == "refresh-society") {
            $('#society-amount').html(item.amount);
        }
    } else {
        $('.main-container').fadeOut();
        $('.welcome-container').fadeOut();
        $('.employees-container').fadeOut();
        
        $.post('http://qb-bossmenu/closeNUI');
    }
});

$(document).on('click', '.goto', function(e) {
    var from = $(this).attr('datafrom');
    var to = $(this).attr('datato');
    if (to == 'quit') {
        $('.main-container').fadeOut();
        $('.waiting-hoster').fadeOut();
        $('.welcome-container').fadeOut();
        $('.settings-container').fadeOut();
        $.post('http://qb-bossmenu/closeNUI');
    } else {
        $('.' + from).fadeOut(0);
        $('.' + to).fadeIn();
    }
});

$(document).on('click', '.gradeschange', function(e) {
    var fullid = $(this).attr('id');
    var playerid = fullid.substring(7);
    openGrades(playerid, 'employees-container');
});

$(document).on('click', '.fireemployee', function(e) {
    var fullid = $(this).attr('id');
    var playerid = fullid.substring(7);

    $.post('http://qb-bossmenu/fireEmployee', JSON.stringify({
        source: playerid,
    }));
});

$(document).on('click', '.grade-box', function(e) {
    var fullid = $(this).attr('id');
    var gradeid = fullid.substring(6);

    $.post('http://qb-bossmenu/changeGrade', JSON.stringify({
        grade: gradeid,
        source: choosingGrade,
    }));

    $('.job-container').fadeOut(0);
    choosingGrade = '';
});

$(document).on('click', '#option-recruit', function(e) {

    $.post('http://qb-bossmenu/openRecruit', JSON.stringify({}));
});

$(document).on('click', '#option-bosstash', function(e) {

    $.post('http://qb-bossmenu/openStash', JSON.stringify({}));
});

$(document).on('click', '.givejob', function(e) {
    var fullid = $(this).attr('id');
    var playerid = fullid.substring(7);

    $.post('http://qb-bossmenu/giveJob', JSON.stringify({
        source: playerid,
    }));
});

$(document).on('click', '.withdraw-down', function(e) {
    var newAmount = currentWithdrawAmount = currentWithdrawAmount - 100;
    if (newAmount > 0) {
        currentWithdrawAmount = newAmount;
        $('#withdraw-amount').html(currentWithdrawAmount);
    }
});

$(document).on('click', '.withdraw-up', function(e) {
    var newAmount = currentWithdrawAmount = currentWithdrawAmount + 100;
    if (newAmount > 0) {
        currentWithdrawAmount = newAmount;
        $('#withdraw-amount').html(currentWithdrawAmount);
    }
});

$(document).on('click', '.deposit-down', function(e) {
    var newAmount = currentDepositAmount = currentDepositAmount - 100;
    if (newAmount > 0) {
        currentDepositAmount = newAmount;
        $('#deposit-amount').html(currentDepositAmount);
    }
});

$(document).on('click', '.deposit-up', function(e) {
    var newAmount = currentDepositAmount = currentDepositAmount + 100;
    if (newAmount > 0) {
        currentDepositAmount = newAmount;
        $('#deposit-amount').html(currentDepositAmount);
    }
});

$(document).on('click', '.deposit', function(e) {
    $.post('http://qb-bossmenu/deposit', JSON.stringify({
        amount: currentDepositAmount,
    }));
});

$(document).on('click', '.withdraw', function(e) {
    $.post('http://qb-bossmenu/withdraw', JSON.stringify({
        amount: currentWithdrawAmount,
    }));
});

$(document).on('mouseenter', '.player-box', function (event) {
    var id = $(this).attr('id');
    var playerid = id.substring(7);
    $('.hoster-options#playeroptions-' + playerid).fadeIn();
}).on('mouseleave', '.player-box',  function(){
    var id = $(this).attr('id');
    var playerid = id.substring(7);
    $('.hoster-options#playeroptions-' + playerid).fadeOut(0);
});

function openGrades(citizenid, from) {
    choosingGrade = citizenid;
    $('.employees-container').fadeOut(0);
    $('.job-container').fadeIn();
}