$.widget("ui.annotate", {
	options: {'zoomLevel'       : 1, 
						'assetWidth'       : 600,
						'assetHeight'      : 900,
						'annotationBoxDefaultWidth'  : 500,
						'annotationBoxDefaultHeight' : 100,
						'markerIcon'       : '/images/annotationMarker.png',
						onSubmitedPassed   : null,
						onSubmitedFailed   : null,
						showHelp					 : false,
						initalEntity       : null
   },
	annotations: [],
	_create: function() {
			this.options.initalEntity = this.options.template.entities[0].name;
	},
	showBox               : function() {
														this._annotationBox = $(this._generateAnnotationBox());
														this.element.append(this._annotationBox);
												}, 
	hideBox               : function() { this._annatationBox.remove();}, 
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
														var inputDiv= $("<div class='inputField'></div>");
														var label = $("<p class='inputLabel'>"+field.name+"</p>");
														inputDiv.append(label)
														switch(field.kind){
															case("text"):
																console.log(field);
																result=$("<input>");
																result.attr("kind",'text')
																			.attr("id",field.field_key);
																if (field.options.text){
																	if(field.options.text.max_length){
																		result.attr("size",field.options.text.max_length);
																	}
																}
																break;
															case("select"):
															  var result = $("<select>");
																result.attr("kind",'select')
																			.attr("id",field.field_key);
															  $.each(field.options.select, function(){
																	result.append("<option value='"+this+"'>"+this+"</option>");
																});
																
																break;
															case("date"):
																result=$("<input>");
																result.attr("kind","text")
																			.attr('id', field.field_key);
																result.datepicker({
																			changeMonth: true,
																			changeYear: true
																});
																break;
													 }
													 return inputDiv.append(result);
},
	_switchEntityType       : function (event){
															console.log(event);
															$("#tabBar li").removeClass("selectedTab");
															$("#tabBar #"+event.data).addClass("selectedTab");
															$(".annotation-input").hide();
															$("#input-"+event.data).show();
															$(".inputField").show();
	},
	_generateAnnotationBox  : function(){
													var annotationBox = $("<div id ='annotationBox'> </div>").draggable({containment:this.element});
													annotationBox.css("width",this.options.annotationBoxDefaultWidth+"px")
		 																	 .css("height",this.options.annotationBoxDefaultHeight+"px")
																			 .css("cursor","move");
													
													var topBar 				= $("<div id ='topBar'></div>");
													var tabBar 				= this._generateTabBar(this.options.template.entities);
													var help 					= this._generateHelp(this.options.template.entities);
													
													topBar.append(tabBar);
													topBar.append(help);
													console.log("help");
													console.log(help);
													var helpButton = $("<a href=# id='annotationHelpButton' >help</a>");
													helpButton.click(this,this.toggleHelp);
												
													topBar.append(helpButton);
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
														var tabBar = $("<ul id='tabBar'></ul>");
														var self=this;
														$.each(entities, function(){
																var tab = $("<li id='"+this.name+"'>"+this.name+"</li>");
																tab.click(this.name,self._switchEntityType.bind(self) );
																tabBar.append(tab);
														});
														return tabBar;
	},
	_generateInputs 			: function(entities){
													 var inputBar =$("<div id='inputBar'></div>");
													 var self = this;
													 
													 $.each(entities, function(entity_index,entity){
															var currentInputPane = $("<div id='input-"+entity.name+"'></div>").addClass("annotation-input");
															$.each(entity.fields, function(field_index,field){
																	var current_field = self._generateField(field);
																	if(entity_index==0) {current_field.show();}
																	else {current_field.hide();}
																	currentInputPane.append(current_field);
															});
															inputBar.append(currentInputPane);
													 });
													return inputBar;
	}, 
	toggleHelp 						: function(event){
														event.preventDefault();
														console.log("scope test");
	}

});
	