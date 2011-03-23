function initialise_drag_box(){
	var entity_count = $('.transcription_entity').length;
	var drag_box_id = entity_count;
	$('#transcription_image').imgAreaSelect({
      handles: true,
			areaId: drag_box_id,
      onSelectEnd: function render_options(img, box){
				$.post(
						'/transcriptions/add_entity',
						{ x1: box.x1, y1: box.y1, x2: box.x2, y2: box.y2, count: entity_count }
					);
			}
  });
}

function render_options(img, box){
	alert(val(box.x1));
}
function remove_transcription_entity(element){
	$(element).remove();
}