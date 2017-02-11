var intervalId;

$(function() {
    $('body').on('click', '#pre-elm-load-start', function() {
        scrapePeople(function(people) {
            $('body *').css('display', 'none');
            Elm.Main.fullscreen({people: people});
        });
    });

    window.setInterval(function() {
        if ($('#pre-elm-load-start').length == 0) {
            var $gameStart = $('<button id="pre-elm-load-start">Play the Name game</button>');
            $('body').prepend($gameStart);
        }
    }, 1000);
})

function scrapePeople (success) {
    forceImagesToLoad(function() {
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

    function forceImagesToLoad(callback) {
        $('html').animate({ scrollTop: $(document).height() }, "slow", function(){
            $('body').animate({ scrollTop: $(document).height() }, "slow", callback)
        });
    }
}
