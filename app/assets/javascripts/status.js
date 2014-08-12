var View = {
  init: function() {
    this.setupStatuses();
    this.setupReroutes();
  },
  setupStatuses: function() {
    var self = this;
    $('body').on('submit', 'form', function(event) {
      event.preventDefault();
      
      $("div .service_table").remove();

      var service = $("option:selected", this).attr('value');
      var request = $.ajax({
                      url: "/status/" + service,
                      type: "GET"
                    });

      request.done(function(response) {
        $('.status').append(response);
      });
    });
  },
  setupReroutes: function() {
    var self = this;
    $('body').on('click', '.service', function(event) {
      event.preventDefault();
      line = $(this).prev().text();

      var request = $.ajax({
                      url: "/reroute/" + line,
                      type: "GET"
                    });

      request.done(function(response) {
        $(".reroute_modal").html("");
        $('.reroute_modal').append(response);
        $('.reroute_modal').show();
      });
    });

    $('html').on('click', function(event) {
      $(".reroute_modal").html("");
      $('.reroute_modal').hide();
    });

  }
};