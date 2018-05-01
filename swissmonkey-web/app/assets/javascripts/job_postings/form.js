function capitalizeFirstLetter(id) {
  var value = document.getElementById(id).value;
  var val = value.substr(0, 1).toUpperCase() + value.substr(1);
  $("#" + id).val(val);
}

$(document).ready(function () {
  var wrapper = $('#wrapper.edit-job');
  var check = wrapper.attr('data-check') === 'true';
  var jobID = wrapper.attr('data-job-id');
  var saveURL = wrapper.attr('data-save-url');
  var saveMethod = wrapper.attr('data-save-method');

  var on_off_switch = 1;
  var stepsEl = $("#jobPostingSteps");
  var jobDetailsForm = $("#job-details-form");
  var stepsLiSelector = '.job_posting_steps li';
  var loaderOverlay = $("#loader-overlay");
  var firstjob = wrapper.attr('data-plan-id');
  var pageContainer = $("#page-container");
  var formContainer = $('#form-container');

  $('.price').hide();
  $('.skills-header').hide();
  jQuery('.slide-details').hide();
  jQuery('.more-details').on('click', function () {
    $(".slide-details").slideToggle('slow', function () {
      if ($(this).is(':visible')) {
        jQuery('.more-details').text('-Show less details');
      } else {
        jQuery('.more-details').text('+Show more details');
      }
    });
  });

  $('#selectpicker12').change(function () {
    var picker = $('#selectpicker12.selectpicker')["0"];
    var lang_checked = false;
    var val_checked = false;
    var total_items = picker.length;

    for (var i = 0; i < total_items; i++) {
      if (picker[i].selected) {
        val_checked = true;
        if (picker[i].text === "Bilingual") {
          lang_checked = true;
        }
      }
    }
    if (lang_checked) {
      jQuery('.bilingual-text').show();
    } else {
      $('#languages').val('');
      jQuery('.bilingual-text').hide();
    }
    if (val_checked) {
      jQuery('.skills-header').show();
    } else {
      jQuery('.skills-header').hide();
    }
  });

  $('#myonoffswitch').attr('checked', true);
  $('.save_card').attr('checked', true);
  $('.pay_through_card').attr('checked', false);

  jQuery(".card-close").on('click', function () {
    jQuery("#delete-card-modal").modal('toggle'
    );
  });

  jQuery(".delete-card").on('click', function () {
    var customer_id = $('#customer_id').val();
    jQuery.ajax({
      url: "/stripe/delete_card",
      type: 'POST',
      data: { customer_id: customer_id },
      success: function () {
        var switchEl = $('#myonoffswitch');
        jQuery("#delete-card-modal").modal('toggle');
        switchEl.attr('checked', false);
        switchEl.prop('disabled', true);
        $('.fill-payment-details').show();
        $('.main-card-type').hide();
      },
      error: function (xhr, status, error) {

      }
    });
  });

  // if (!check)
  //   jQuery("#alert-modal").modal({
  //     keyboard: "false",
  //     backdrop: "static"
  //   });

  jQuery(".jobslist").on('click', function () {
    window.location.href = "/jobs";
  });

  jQuery('.bilingual-text').hide();

  $(".phoneno").mask("(999) 999-9999");

  loaderOverlay.hide();

  $('#details_step').addClass('active');

  stepsEl.hide();
  if (firstjob !== 4) {
    // plan_type = 1;
    stepsEl.hide();
    $("#job-details-form-buttons").hide();
  } else {
    $("#info_about_free_post").hide();
    stepsEl.show();
    $("#postJob").hide();
    stepsEl.show();
    $("#job-details-form-buttons").show();
    $("#job-pricing").hide();
    $("#paymentDetails").hide();


  }

  //If Buy then job is not published
  //If Buy and Publish then job is pubshiled

  var job_status = '';
  $("#buy").on('click', function () {
    job_status = 'Unpublished'
  });
  $(".submitBtn").on('click', function () {
    job_status = 'Published'
  });
  $.validator.addMethod("emailValid", function (value) {
    return (value.match(/^([a-zA-Z0-9_.+-])+@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/)) || value === '';
  }, 'Enter valid email.');

  $.validator.addMethod('intlphone', function (value) {
    return (value.match(/^((\+)?[1-9]{1,2})?([-\s.])?((\(\d{1,4}\))|\d{1,4})(([-\s\.])?[0-9]{1,12}){1,2}(\s*(ext|x)\s*\.?:?\s*([0-9]+))?$/) || value === '');
  }, 'Enter a valid phone number');


  $("#payment-form").validate({
    rules: {
      email: {
        required: true,
        emailValid: true
      },
      name: {
        required: true,
        minlength: 3
      },
      languages: {
        required: true
      },
      address_zip: {
        required: true
      },
      pay_through_card: {
        required: true
      },
      cardnumber: {
        required: true
      },
      exp_month: {
        required: true
      },
      exp_year: {
        required: true
      },
      cvv: {
        required: true
      }
    },
    messages: {
      pay_through_card: {
        required: "*select payment"
      },
      email: {
        required: "*Required"
      },
      name: {
        required: "*Required",
        minlength: "*Required"
      },
      address_zip: {
        required: "*Required"
      },
      cardnumber: {
        required: "*Required"
      },
      exp_month: {
        required: "*Required"
      },
      exp_year: {
        required: "*Required"
      },
      cvv: {
        required: "*Required"
      },
      job_posting_languages: {
        required: "Enter languages"
      }

    },
    errorPlacement: function (error, element) {
      var name = $(element).attr("name");
      error.appendTo($("#" + name + "_validate"));
    },
    submitHandler: function (form) {
    }
  });

  $.validator.addMethod("check", function () {
    if ($('input:checkbox[name^="workshift"]:checked').length === 0) {
      $("#workshift_validate").text('Select shifts');
      return false;
    }
    return true;

  }, 'Select Shifts');

  // Validating Job details form
  $.validator.addMethod("greaterThan",

    function (value, element, param) {
      var $min = $(param);
      if (value || parseInt($min.val())) {
        if (this.settings.onfocusout) {
          $min.off(".validate-greaterThan").on("blur.validate-greaterThan", function () {
            $(element).valid();
          });
        }
        return parseInt(value) > parseInt($min.val());
      } else
        return true;
    }, "Must be greater than from compensation");


  // jobDetailsForm.validate({
  //   rules: {
  //     'job_posting[job_position_id]': {
  //       required: true
  //     },
  //     'job_posting[fill_by]': {
  //       required: true
  //     },
  //     'job_posting[job_type]': {
  //       required: true
  //     },
  //     'job_posting[practice_management_system_ids][]': {
  //       required: true
  //     },
  //     'job_posting[years_experience]': {
  //       required: false
  //     },
  //     'job_posting[compensation_type]': {
  //       required: function () {
  //         return ($("#job_posting_compensation_range_low").val().trim() !== "");
  //       }
  //     },
  //     'job_posting[job_description]': {
  //       required: false
  //     },
  //     // new_position: {
  //     //   required: function () {
  //     //     return $("#job_position_id").val().trim() !== "";
  //     //   }
  //     // },
  //     'job_posting[compensation_range_low]': {
  //       required: false,
  //       compensationRangeCheck: true
  //     },
  //     'job_posting[compensation_range_high]': {
  //       required: false,
  //       compensationRangeCheck: true,
  //       greaterThan: '#job_posting_compensation_range_low'
  //     },
  //     'job_posting[company_id]': {
  //       required: true
  //     }
  //   },
  //   // messages: {
  //   //   position: {
  //   //     required: "Select position"
  //   //   },
  //   //   jobtype: {
  //   //     required: "Select job type"
  //   //   },
  //   //   filldate: {
  //   //     required: "Select position available on date"
  //   //   },
  //   //   softwareExperience: {
  //   //     required: "Select softwareExperience"
  //   //   },
  //   //   experience: {
  //   //     required: "Select experience"
  //   //   },
  //   //   'job_posting[compensation_range_low]': {
  //   //     required: "Enter compensation ",
  //   //     compensationRangeCheck: "Enter correct compensation"
  //   //   },
  //   //   'job_posting[compensation_range_high]': {
  //   //     required: "Enter compensation ",
  //   //     compensationRangeCheck: "Enter correct compensation"
  //   //   },
  //   //   'job_posting[company_id]': {
  //   //     required: "Select practice"
  //   //   },
  //   //   'job_posting[compensation]': {
  //   //     required: "Select compensation"
  //   //   },
  //   //   'job_posting[new_practice_software]': {
  //   //     required: "Enter practice software experience"
  //   //   },
  //   //   practiceSoftware: {
  //   //     required: "Select practice software experience"
  //   //   }
  //   // },
  //   submitHandler: function () {
  //     if (firstjob === 2) {
  //       $("#job-pricing").show();
  //       jobDetailsForm.hide();
  //       $("#paymentDetails").hide();
  //       return false;
  //     }
  //   }
  // });

  $(".custom_practice_software").hide();


  $("#jobDetailNext").click(function () {
    var error = false;
    if ($('input:checkbox[name^="workshift"]:checked').length === 0) {
      $("#workshift_validate").text('Select shifts');
      error = true;
    } else {
      $("#workshift_validate").text('');
    }
    if ($('input:text[name^="filldate"]').val() === "") {
      $("#filldate_validate").text('Select position available on');
      error = true;
    } else {
      $("#filldate_validate").text('');
    }
    if (jobDetailsForm.valid() && !error) {

      $(stepsLiSelector).removeClass('active');
      //$('#pricing_step').addClass('active');
      jobDetailsForm.hide();
      $("#job-details-form-buttons").hide();
      $("#job-pricing").show();
      $("#paymentDetails").show();
    }
  });

  $("#practiceSoftware").on('change', function () {
    var valueSelected = $("option:selected", this).attr("softwarename");
    if (valueSelected === 'Other') {

      $(".custom_practice_software").show();
    } else
      $(".custom_practice_software").hide();
  });

  var selectedpricing = true;

  $("#backToPostJob").click(function () {

    $(stepsLiSelector).removeClass('active');
    $('#details_step').addClass('active');
    $("#job-pricing").hide();
    $("#paymentDetails").hide();
    jobDetailsForm.show();
    $("#job-details-form-buttons").show();
  });

  $("#movetopayment").click(function () {
    if (selectedpricing) {

      $(stepsLiSelector).removeClass('active');
      $('#payment_step').addClass('active');
      $("#job-pricing").hide();
      jobDetailsForm.hide();
      $("#job-details-form-buttons").hide();
      $("#paymentDetails").show();
    } else {
      $(".pricing-alert").html('Select Pricing').addClass('alert alert-danger');
    }
  });

  $("#backToPricing").click(function () {

    $(stepsLiSelector).removeClass('active');
    $("#job-pricing").show();
    jobDetailsForm.hide();
    $("#job-details-form-buttons").hide();
    $("#paymentDetails").hide();
  });

  $.validator.addMethod('compensationRangeCheck', function (value) {
    return !(isNaN(value) || value.length > 10)
  }, 'Enter correct compensation');

  $.validator.addMethod('validformat', function (value) {
    value = value.replace(/\s+/g, ' ');

    if (value === '')
      return true;
    return (value.match(/^[a-zA-Z() ]+$/));
  }, "");

  jQuery(function ($) {
    $('#payment-form').submit(function () {
      if ($("#payment-form").valid()) {
        $("#buy").prop('disabled', true);
        $(".submitBtn").prop('disabled', true);
        var $form = $(this);
        Stripe.card.createToken($form, stripeResponseHandler);
        return false;
      }
    });
  });

  function stripeResponseHandler(status, response) {
    var submitBtn = $('.submitBtn');
    var paymentForm = $('#payment-form');
    var stripe_customer_id = $('#customer_id').val();
    if (!stripe_customer_id && response.error) {
      $("#buy").prop('disabled', false);
      submitBtn.prop('disabled', false);
      var str = response.error.message;
      paymentForm.find('.payment-errors').text(str.replace(/_/g, " "));
      paymentForm.find('.payment-errors').addClass('alert alert-danger');
      submitBtn.button('reset');
    } else {
      var token = response.id;
      paymentForm.append($('<input type="hidden" name="stripeToken" />').val(token));
      jobDetailsForm.submit();
    }
  }
});

$(document).ready(function () {
  var i = 0;
  $(".dropdown dt a").on('click', function () {
    $(".dropdown dd ul").slideToggle('fast');
  });

  $(".dropdown dd ul li a").on('click', function () {
    $(".dropdown dd ul").hide();
  });

  $(".pms_dropdown dt a").on('click', function () {
    $(".pms_dropdown dd ul").slideToggle('fast');
  });

  $(".pms_dropdown dd ul li a").on('click', function () {
    $(".pms_dropdown dd ul").hide();
  });


  $(document).bind('click', function (e) {
    var $clicked = $(e.target);
    if (!$clicked.parents().hasClass("dropdown"))
      $(".dropdown dd ul").hide();
    if (!$clicked.parents().hasClass("pms_dropdown"))
      $(".pms_dropdown dd ul").hide();
  });

  jQuery("#other_practice_software").on('click', function () {
    if ($(this).is(':checked')) {
      $(".custom_practice_software").show();
      $(".pms_dropdown dd ul").hide();
    } else {
      $(".custom_practice_software").hide();
      $('#job_posting_custom_practice_software').val('');
    }
  });

  $('.checklocation').change(function () {
    var id = $(this).val();
    $.ajax({
      url: "/stripe/check_location_payment",
      type: 'POST',
      data: { location_id: id },
      success: function (data) {
        if (data.jobcount >= 1) {
          $('#job-details-form-buttons').hide();
          $("#job-details-postjob-buttons").show();
        } else {
          $('#job-details-form-buttons').show();
          $("#job-details-postjob-buttons").hide();
        }
      },
      error: function (xhr) {
        alert(xhr.responseText);
        return false;
      }
    });
  });

  $('.mutliSelect_practiceSoftware input[type="checkbox"]').on('click', function () {
    var title;

    if (i === 0) {
      title = $(this).closest('.mutliSelect_practiceSoftware').find('input[type="checkbox"]').val();
      title = $(this).attr('software');
    } else {
      title = $(this).closest('.mutliSelect_practiceSoftware').find('input[type="checkbox"]').val();
      title = ", " + $(this).attr('software');
    }
    var software = $(this).attr('software');
    var checkedPracticeSoftware = $('input:checkbox[name^="practiceSoftware"]:checked');
    $('.mutliSelect_practice').html("");

    var p = checkedPracticeSoftware.length;

    checkedPracticeSoftware.each(function () {
      if (p === 1) {
        title = software;
      } else {
        title = software + ", ";
      }
      var html = '<span title="' + title + '"> ' + title + '</span>';
      $('.mutliSelect_practice').append(html);
      p -= 1;
    });
  });

  $("#datepicker").datepicker({
    autoclose: true,
    todayHighlight: true,
    startDate: "0"
  });
});