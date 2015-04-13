jQuery ->
  if $('.no-print').length
    window.print()

  # For page with New Reservation form
  if $('#new_reservation').length
    $('#reservation_bags_owner').closest('div input').focus()

    # Custom validator to ensure that at least one bag type is 
    # more than zero
    $.validator.addMethod 'allNotBlank', ((val, ele, param) ->
      requested = bagRequest()
      valid = requested.large > 0 or requested.medium > 0 or 
                                     requested.small  > 0
      valid),
      "At least one bag type must be more than 0."
    
    # Custom validator to ensure that there are enough combined
    # lockers for various combined bag types
    $.validator.addMethod 'combinedValid', ((val, ele, param) ->
      requested = bagRequest()
      left  = lockerLeft()
      valid = requested.large + requested.medium <= left.medium and
              requested.large + requested.medium + requested.small <= left.small
      
      valid),
      combinedValidErrorMessage()
    
    # Validate New Reservation Form
    $('#new_reservation').validate
      errorClass: "invalid"
      errorElement: 'div'

      groups:
        numberOfBags: 'reservation[large] reservation[medium] reservation[small]'

      rules:
        'reservation[bags_owner]':
          required: true
          remote:   '/customers/valid_identifier'
        'reservation[large]':
          digits:        true
          allNotBlank:   true
          combinedValid: true
        'reservation[medium]':
          digits:        true
          allNotBlank:   true
          combinedValid: true
        'reservation[small]':
          digits:        true
          allNotBlank:   true
          combinedValid: true

      messages:
        'reservation[bags_owner]':
          required: "Please provide Bag Owner's name."
          remote:   "Bag's owner is invalid. Please search from list provided."
        'reservation[large]':
          number: '"Large" must be a valid number.'
          digits: '"Large" must contain only digits.'
          max:    '"Large" must be less than or equal to {0}'
          min:    '"Large" must be greater than or equal to {0}'
        'reservation[medium]':
          number: '"Medium" must be a valid number.'
          digits: '"Medium" must contain only digits.'
          max:    '"Medium" must be less than or equal to {0}'
          min:    '"Medium" must be greater than or equal to {0}'
        'reservation[small]':
          number: '"Small" must be a valid number.'
          digits: '"Small" must contain only digits.'
          max:    '"Small" must be less than or equal to {0}'
          min:    '"Small" must be greater than or equal to {0}'

    # Validate one input field that failed validation when its 
    # content changes
    $('#reservation_bags_owner').on 'input', ->
      if $('#reservation_bags_owner.invalid').length
        $('#reservation_bags_owner').valid()

    # Validate all input fields for number of bags whenever any of those
    # input field's content changes (because some validations rely on
    # all 3 input fields)
    $('input[type=number]').on 'input', ->
      if $('.invalid').length
        $('#reservation_large').valid()
        $('#reservation_medium').valid()
        $('#reservation_small').valid()

  # For page with Search Reservations form
  if $('#search_reservations').length
    $('.form-row input').focus()

    # Validate Search Reservations Form
    $('#search_reservations').validate
      errorClass: "invalid"
      errorElement: 'div'

      rules:
        'reservation_number':
          required: true
          remote:   '/reservations/valid_number'

      messages:
        'reservation_number':
          required: 'Please provide a Reservation Number.'
          remote: 'Invalid Reservation Number. '+
                  'Please search from list provided.'

    # Validate input field that failed validation when its content changes
    $('#reservation_number').on 'input', ->
      if $('#reservation_number.invalid').length
        $('#reservation_number').valid()


bagRequest = ->
  large  = zeroOrPositiveInteger $('#reservation_large').val()
  medium = zeroOrPositiveInteger $('#reservation_medium').val()
  small  = zeroOrPositiveInteger $('#reservation_small').val()
  { large: large, medium: medium, small: small }

lockerLeft = ->
  large  = zeroOrPositiveInteger $('#reservation_large').attr('max')
  medium = zeroOrPositiveInteger $('#reservation_medium').attr('max')
  small  = zeroOrPositiveInteger $('#reservation_small').attr('max')
  { large: large, medium: medium, small: small }

zeroOrPositiveInteger = (num_str) ->
  num = parseInt num_str, 10
  if (not Boolean(num) or num < 0) then 0 else num

combinedValidErrorMessage = ->
  left = lockerLeft()
  "Not enough free lockers for bags requested. " + 
  "Lockers available - Large: #{left.large}; Medium: "+
  "#{left.medium - left.large}; Small: #{left.small - left.medium}."
