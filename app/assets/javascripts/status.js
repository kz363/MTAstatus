var Status = {
  init: function() {
    this.setupStatuses();
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
  }
};