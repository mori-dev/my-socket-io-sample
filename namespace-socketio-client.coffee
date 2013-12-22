$ ->
  formats =
    json: io.connect 'ws://localhost:8081/json'
    xml: io.connect 'ws://localhost:8081/xml'
   
  formats.json.on 'connect', ->
    $('#profiles').html '<option></option>'
    @emit 'profiles', (profile_names) ->
      $.each profile_names, (i, profile_name) ->
        $('#profiles').append "<option>#{profile_name}</option>"
   
  $('#profiles, #formats').change ->
    socket = formats[$('#formats').val()]
    socket.emit 'profile', $('#profiles').val()
   
  formats.json.on 'profile', (profile) ->
    $('#raw').val(JSON.stringify(profile))
    $('#output').html('')
    $.each profile, (k, v) ->
      $('#output').append('<b>' + k + '</b>：' + v + '<br>')
   
  formats.xml.on 'profile', (profile) ->
    $('#raw').val(profile)
    $('#output').html('')
    $.each $(profile)[1].nextSibling.childNodes, (k, v) ->
      if v?.nodeType is 1
        $('#output').append('<b>' + v.localName + '</b>：' + v.textContent + '<br>')
