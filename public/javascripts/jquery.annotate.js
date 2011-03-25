$.widget("ui.annotate", {
	options: {'zoomLevel'       : 1, 
						'assetWidth'       : 600,
						'assetHeight'      : 900,
						'annotationBoxDefaultWidth'  : 200,
						'annotationBoxDefaultHeight' : 100,
						'markerIcon'       : '/images/annotationMarker.png',
						onSubmitedPassed   : null,
						onSubmitedFailed   : null,
						showHelp					 : false
   },
	annotations: [],
	_create: function() {
	},
	showBox               : function() {
														this._annotationBox = $(this._generateAnnotationBox());
														this.element.append(this._annotationBox);
												}, 
	hideBox               : function() {}, 
	getAnnotations        : function() { return annotations},
	deleteAnnotation      : function(annotationId){ $("*").trigger('anotationDeleted',"message deleting"+annotationId)},
	editAnnotation        : function(annotationId){ $("*").trigger('anotationEdited',"message editing"+annotationId)},
	setMarkerIcon         : function(icon){},
	submitResults         : function(url){ 
														console.log(this.options);
														$("*").trigger('resultsSubmited');
														$.ajax({
												          url: url,
												          data: this.annotations,
																	type :"POST",
												          success: this._postAnnotationsSucceded.bind(this),
												          error: this._postAnnotationsFailed.bind(this)
												    });
													},
	_postAnnotationsSucceded: function (){
													alert('internal success');
													console.log(this.options);
													if (this.options.onSubmitedPassed){
														this.options.onSubmitedPassed.apply(this);
													}
	},
	_postAnnotationsFailed  : function (){
 													if (this.options.onSubmitedFailed){
														this.options.onSubmitedFailed.apply(this);
													}
  },
 	_generateField         : function (field){
														var result ;
														console.log(field.kind);
														switch(field.kind){
															case("text"):
																result = $("<input>");
																result.attr("kind",'text')
																			.attr("id",field.field_key);
																break;
															case("select"):
															  result = $("<select>");
																result.attr("kind",'select')
																			.attr("id",field.field_key);
															  $.each(field.options.select, function(){
																	result.append("<option value='"+this+"'>"+this+"</option>");
																});
																break;
															case("date"):
																result = $("<input>");
																result.attr("kind","text")
																			.attr('id', field.field_key);
																result.datepicker({
																			changeMonth: true,
																			changeYear: true
																});
																break;
													 }
													
													 return result.hide();
},
	_switchEntityType       : function (type){},
	_generateAnnotationBox  : function(){
													var annotationBox = $("<div id ='annotationBox'> </div>").draggable({containment:this.element});
													annotationBox.css("width",this.options.annotationBoxDefaultWidth+"px")
		 																	 .css("height",this.options.annotationBoxDefaultHeight+"px");
													
													var topBar 				= $("<div id ='topBar'></div>");
													var tabBar 				= this._generateTabBar(this.options.template.entities);
													var help 					= this._generateHelp(this.options.template.entities);
													
													topBar.append(tabBar);
													topBar.append(help);
													console.log("help");
													console.log(help);
													topBar.append("<a href=# id='annotationHelpButton' >help</a>").click(this.toggleHelp);
													var bottomArea    = $("<div id='BottomArea'></div>");
													var inputBar      = this._generateInputs(this.options.template.entities);
													console.log(inputBar);
													bottomArea.append(inputBar);
													bottomArea.append($("<input type='submit' value='add'>").click(this._addAnnotation));
													
													annotationBox.append(topBar);
													annotationBox.append(bottomArea);
													return annotationBox;
													
	},
	_generateHelp 				 : function(entities){
														var helpDiv = $("<div id='annotationHelp'></div>").hide();
														$.each(entities, function(){
															helpDiv.append( $("<div id='help-"+this.name+"'>"+this.help+"</div>"));
														});
														return helpDiv;
	},
	_generateTabBar        : function(entities){
														var tabBar = $("<ul></ul>");
														$.each(entities, function(){
																tabBar.append("<li>"+this.name+"</li>");
														});
														return tabBar;
	},
	_generateInputs 			: function(entities){
													 var inputBar =$("<div id='inputBar'></div>");
													 var self = this;
													 
													 $.each(entities, function(){
															var currentInputPane = $("<div id='"+this.name+" '></div>").addClass("annotation-input");
															$.each(this.fields, function(){
																	var current_field = self._generateField(this);
																	currentInputPane.append(current_field);
															});
															inputBar.append(currentInputPane);
													 });
													return inputBar;
	}, 
	toggleHelp 						: function(event){
														event.preventDefault();
														if(this.options.showHelp){
															$(annotationHelpButton).slideDown(200);
														}
														else {
															$(annotationHelpButton).slideUp(200);
														}
	}

});
	