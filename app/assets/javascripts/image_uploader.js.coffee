$ ->
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Changes the image preview when an image file is selected to be
  #%% uploaded.  Used for the idea form.
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  $("#idea_main_image").change (event) ->
    input =     $(event.currentTarget)
    file =      input[0].files[0]
    reader =    new FileReader()

    reader.readAsDataURL file
    reader.onload = (e) ->
      console.log "image loaded!"
      image_base64 = e.target.result
      $("#main_image_preview").attr("src", "#{image_base64}")
      $(".form-submit").prop('value', 'Save and Crop Image')
