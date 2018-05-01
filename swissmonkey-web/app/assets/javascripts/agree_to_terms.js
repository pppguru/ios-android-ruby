$(document).ready(function () {
  var body = $('body');
  var agreedToTerms = body.attr('data-terms-agreed') === 'true';
  var userSignedIn = body.attr('data-signed-in') === 'true';
  var userEmail = body.attr('data-user-email');

  if (userSignedIn && !agreedToTerms) {
    jQuery("#terms-modal").modal({
      keyboard: "false",
      backdrop: "static"
    });
  }

  $("#agree-terms").on('click', function () {
    if (userEmail && userEmail.length > 0) {
      $.ajax({
        url: "/api/v1.0/user/accept_privacy_policy",
        type: 'POST',
        data: { email: userEmail },
        success: function () {
          $("#terms-modal").modal("hide");
        },
        error: function () {
          alert('Error occured! Please try again.');
          $("#terms-modal").modal("hide");
        }

      });
    }
  });
  //End of Terms and Conditions
});