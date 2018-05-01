# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
# vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https:#github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
# jquery must be required first
#= require jquery
#= require jquery_ujs
#= require jquery.validate.min
#= require jquery.maskedinput
#= require jquery.rateyo.min

#= require bootstrap

#= require bootstrap-datepicker
#= require bootstrap-select

#= require cable
# channels must be required after cable
#= require_tree ./channels/

#= require ./agree_to_terms
