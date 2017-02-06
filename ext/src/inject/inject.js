var intervalId;
var people;

$(function() {
    $('body').on('click', '#game-restart, #pre-elm-load-start', function() {
        if (!people) {
            scrapePeople(function(scrapedPeople) {
                people = scrapedPeople;
                resetGame(scrapedPeople);
            });
        } else {
            resetGame(people)
        }
    });

    window.setInterval(function() {
        if ($('#pre-elm-load-start').length == 0) {
            var $gameStart = $('<button id="pre-elm-load-start">Play the Name game</button>');
            $('body').prepend($gameStart);
        }
    }, 1000);
})

function resetGame(peoplePool) {
    $('body *').css('display', 'none');
    var randomSample = window.knuthShuffle(people).slice(0,6);
    Elm.Main.fullscreen({people: randomSample});
}

function scrapePeople (success) {
    function faceUrl($employee) {
        var backgroundImage = $employee.prop('style').getPropertyValue('background-image');
        try {
            var urlMatches = /url\("(.*)"\)/.exec(backgroundImage);
            if (urlMatches == null || urlMatches.length == 0) {
                return null;
            }
            var url = urlMatches[1];
            return url;
        } catch(error) {
            console.error(error);
            return null
        }
    }

    $('html').animate({ scrollTop: $(document).height() }, "slow", function(){
        $('body').animate({ scrollTop: $(document).height() }, "slow", function() {
            var people =  $('.tile .employee').map(function(_, employee) {
                var $employee = $(employee);
                return {
                    name: $employee.prop('title'),
                    faceUrl: faceUrl($employee)
                };
            }).toArray();

            var validPeople = people.filter(function(person) {
                return person.faceUrl && person.name
            });

            success(validPeople);
        })
    });
}
