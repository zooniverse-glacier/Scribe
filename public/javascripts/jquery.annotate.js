$.widget("ui.annotate", {
	options: {'zoomLevel'       : 1, 
						'assetScreenWidth'       : 600,
						'assetScreenHeight'      : 900,
						'annotationBoxWidth'  : 500,
						'annotationBoxHeight' : 100,
						'zoomBoxWidth'	: 500,
						'zoomBoxHeight' : 200,
						'markerIcon'       : '/images/annotationMarker.png',
						zoomLevel					 : 1,
						onSubmitedPassed   : null,
						onSubmitedFailed   : null,
						onAnnotationAdded  : null,
						showHelp					 : false,
						initalEntity       : null,
						annotationBox			 : null,
						image							 : null,
						page_data					 : {},
						annotations: []
   },
	_create: function() {
			var self= this;
			if (this.options.initalEntity==null){
				this.options.initalEntity = this.options.template.entities[0].name.replace(/ /,"_");
			}
			
			
			this.element.imgAreaSelect({
		      handles: false,
					autoHide : true,
		      onSelectEnd: function render_options(img, box){
						if (self.options.annotationBox==null){
							var midX=(box.x1+box.x2)/2.0;
							var midY=(box.y1+box.y2)/2.0;
							self.showBox({x:midX,y:midY, width:box.width,height:box.height});
						}
					}
		  });
			this.element.css("width",this.options.assetScreenWidth)
			 						.css("height",this.options.assetScreenHeight)
									.css("position","relative");
			var image= $("<img></img>").attr("id","scribe_main_image")
																 .attr("src",this.options.imageURL)
																 .css("width",this.options.assetScreenWidth)
																 .css("height",this.options.assetScreenHeight)
																 .css("position","relative")
																 .css("margin", "0px auto")
																 .css("left","0px")
																 .css("top","0px");
			this.options.image=image;
			
			this.element.append(image);
			if(this.options.doneButton && this.options.submitURL){
				this.options.doneButton.click(function(event){
					event.preventDefault();
					this.submitResults(this.options.submitURL);
				}.bind(this))
			}
			
			
			this.options.page_data["asset_screen_width"] = this.options.assetScreenWidth;
			this.options.page_data["asset_screen_height"] = this.options.assetScreenHeight;
			this.options.page_data["asset_width"] = this.options.assetWidth;
			this.options.page_data["asset_height"] = this.options.assetHeight;
			
			this.options.xZoom = this.options.assetWidth/this.options.assetScreenWidth;
			this.options.yZoom = this.options.assetHeight/this.options.assetScreenHeight;
			
			this.element.click(function(event){
				if(self.options.annotationBox==null){
					self.showBox({x:event.offsetX,y:event.offsetY});
				}
			});
	},
	showBox               : function(position) {
														this.options.annotationBox = $(this._generateAnnotationBox());
														this.element.append(this.options.annotationBox);
														this.element.imgAreaSelect({disable:true});
														if(position){
																		if(position.width && position.height){
																			var zoomLevel = this.options.zoomLevel;
																			this.options.zoomBoxWidth= position.width*zoomLevel;
																			this.options.zoomBoxHeight=position.height*zoomLevel;
																			
																			this.options.zoomBox.css("width",position.width*zoomLevel)
																								.css("height",position.height*zoomLevel)
																			 					.css("top", this.options.annotationBoxHeight+1)
																					 			.css("left",this.options.annotationBoxWidth/2.0-this.options.zoomBoxWidth/2.0);
																			
																		}
																		var xOffset = $(this.options.annotationBox).width()/2.0;
																		var yOffset = $(this.options.annotationBox).height()+($(this.options.zoomBox).height())/2.0;
																		var screenX = position.x-xOffset;
																		var screenY = position.y-yOffset;
																		this.options.annotationBox.css("left",position.x-xOffset);
																		this.options.annotationBox.css("top",position.y-yOffset);
																		this.options.annotationBox.css("position","absolute");
																		var zoomX = -1*(position.x*this.options.zoomLevel-this.options.zoomBoxWidth/2.0);
																		var zoomY = -1*(position.y*this.options.zoomLevel-this.options.zoomBoxHeight/2.0);
																		
																		$(this.options.zoomBox).find("img").css("top", zoomY )
																																			.css("left", zoomX);
																	  this._selectEntity(this.options.initalEntity);
																																			
																		
														}
												}, 
	hideBox               : function() { this._annatationBox.remove();}, 
	getAnnotations        : function() { return this.options.annotations},
	deleteAnnotation      : function(annotationId){ this._trigger('anotationDeleted',{},"message deleting"+annotationId)},
	editAnnotation        : function(annotationId){ this._trigger('anotationEdited',{},"message editing"+annotationId)},
	setMarkerIcon         : function(icon){},
	submitResults         : function(url){ 

														this._trigger('resultsSubmited',{},this.options.annotations);
														$.ajax({
												          url: url,
												          data: {"transcription" :{"annotations" : this.options.annotations, "page_data": this.options.page_data}},
																	type :"POST",
												          success: this._postAnnotationsSucceded.bind(this),
												          error: this._postAnnotationsFailed.bind(this)
												    });
													},
	_postAnnotationsSucceded: function (){
													alert('internal success');
													if (this.options.onSubmitedPassed){
														this.options.onSubmitedPassed.apply(this);
													}
	},
	_postAnnotationsFailed  : function (){
 													if (this.options.onSubmitedFailed){
														this.options.onSubmitedFailed.apply(this);
													}
  },
	_addAnnotation          : function (event){
														this.element.imgAreaSelect({disable:false});
														
														event.preventDefault();
														event.stopPropagation();
												   	
														var image = $(this.options.zoomBox).find("img");
														var zoomBox = $(this.options.zoomBox);
														var zoomLevel = this.options.zoomLevel;
														var location = {width : zoomBox.css("width").replace(/px/,'')/zoomLevel,
														 								height: zoomBox.css("height").replace(/px/,'')/zoomLevel,
																						y : -1*image.css("top").replace(/px/,'')/zoomLevel,
																						x : -1*image.css("left").replace(/px/,'')/zoomLevel};
														this._generateMarker(location, this.options.annotations.length);
														var annotation_data=this._serializeCurrentForm();
														
														var normalized_bounds = {width: location.width/this.options.assetScreenWidth,
																										 height: location.width/this.options.assetScreenHeight,
																										 x : location.x/this.options.assetScreenWidth,
																										 y : location.y/this.options.assetScreenHeight,
																										 zoom_level:zoomLevel };
																										
														annotation_data["bounds"]= normalized_bounds;
														this.options.annotations.push(annotation_data);
													//	this._trigger('annotationAdded',  {annotation:annotation_data });
													 	this.options.onAnnotationAdded.call(this,annotation_data);
													
														this.options.annotationBox.remove();
													  this.options.annotationBox=null;
	},
	_serializeCurrentForm   : function(){	
														var targetInputs =$(".scribe_current_inputs input"); 
														var parent  = $(targetInputs[0]).parent().parent();
														var annotationType = parent.attr("id").replace("scribe_input_","");
														
														var result = {kind:annotationType, data:{}};
														targetInputs.each(function(){
															var fieldName= $(this).attr("id").replace("scribe_field_","");
															result.data[fieldName]=$(this).val();
														});
														return result ;
														
	},
	_generateMarker 				: function (position,marker_id){
		
														var marker = $("<div></div>").attr("id",marker_id)
																												 .css("width",position.width)
																												 .css("height",position.height)
																												 .css("top", position.y)
																												 .css("left", position.x)
																												 .css("position","absolute")
																												 .css("z-index",1)
																												 .css("border-style","solid")
																												 .css("border-width","2px")
																												 .css("border-color","red");
														marker.append($("<p>"+marker_id+"</p>"));
														this.element.append(marker);
	},
 	_generateField          : function (field){
														var inputDiv= $("<div class='scribe_input_field'></div>");
														var label = $("<p class='scribe_input_label'>"+field.name+"</p>");
														inputDiv.append(label)
														switch(field.kind){
															case("text"):
																result=$("<input>");
																result.attr("kind",'text')
																			.attr("id","scribe_field_"+field.field_key);
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
	_selectEntity 					: function(entityName){
															$("#scribe_tab_bar li").removeClass("scribe_selected_tab");
															$("#scribe_tab_bar #scribe_tab_"+entityName).addClass("scribe_selected_tab");
															$(".scribe_annotation_input").hide();
															$("#scribe_input_"+entityName).show();
															$(".scribe_current_inputs").removeClass("scribe_current_inputs");
															$("#scribe_input_"+entityName+" .scribe_input_field").addClass("scribe_current_inputs");
															$(".scribe_input_field").show();
															$(".scribe_input_field").filter(".scribe_current_inputs").addClass("scribe_current_help");
	},
	_switchEntityType       : function (event){
															this._selectEntity(event.data);
														},
														
	_updateWithDrag 				: function(position){
															var x = position.left+ this.options.annotationBoxWidth/2;
															var y = position.top + this.options.annotationBoxHeight+ this.options.zoomBoxHeight/2.0;
															var zoomX = -1*(x*this.options.zoomLevel-this.options.zoomBoxWidth/2.0);
															var zoomY = -1*(y*this.options.zoomLevel-this.options.zoomBoxHeight/2.0);
														
															$(this.options.zoomBox).find("img").css("top", zoomY )
																																.css("left", zoomX);	},
	_generateAnnotationBox  : function(){
													var self=this;
													var image = $(this.options.image);
													var imageLoc = image.offset();
													var totalHeight = this.options.zoomBoxHeight/2+ this.options.annotationBoxHeight;
													var containment = [imageLoc.left-this.options.annotationBoxWidth/2, imageLoc.top-totalHeight, imageLoc.left+image.width()-this.options.annotationBoxWidth/2, imageLoc.top+image.height()-totalHeight	];
													var annotationBox = $("<div id ='scribe_annotation_box'> </div>").draggable(this,{ containment: containment , drag: function(event,ui){
														self._updateWithDrag(ui.position);
													}});
													annotationBox.css("width",this.options.annotationBoxWidth+"px")
		 																	 .css("height",this.options.annotationBoxHeight+"px")
																			 .css("cursor","move");
													
													var topBar 				= $("<div id ='scribe_top_bar'></div>");
													var tabBar 				= this._generateTabBar(this.options.template.entities);
													var help 					= this._generateHelp(this.options.template.entities);
													
													topBar.append(tabBar);
													topBar.append(help);
													
													var helpButton = $("<a href=# id='scribe_annotation_help_button' >help</a>");
													helpButton.click(this,this.toggleHelp);
													
													topBar.append(helpButton);
													var bottomArea    = $("<div id='scribe_bottom_area'></div>");
													var inputBar      = this._generateInputs(this.options.template.entities);
													bottomArea.append(inputBar);
													bottomArea.append($("<input type='submit' value='add'>").click(function(e){ self._addAnnotation(e) } ));
													
													annotationBox.append(topBar);
													annotationBox.append(bottomArea);
													
													
													this.options.zoomBox=this._generateZoomBox();
													helpButton.toggle(function(){$(".scribe_current_help").stop().animate({top:'-80', opacity:"100"},500);$("#scribe_help").html("Hide help"); }, function(){ $(".scribe_current_help").stop().animate({top:'0',opacity:"0"},500); $("#scribe_help").html("Show help");});
													annotationBox.append(this.options.zoomBox);
													annotationBox.css("z-index","2");
													return annotationBox;
													
	},
	_generateZoomBox 			 : function(){
													var imageWidth = this.options.assetScreenWidth*this.options.zoomLevel;
													var imageHeight = this.options.assetScreenHeight*this.options.zoomLevel;
													var image = $("<img></img>").attr("src", this.options.imageURL)
																											.css("width",imageWidth)
																											.css('height',imageHeight)
																											.css('position','absolute')
																											.css('top',0)
																											.css('left',0);
													var zoomBox = $("<div id='scribe_zoom_box'></div>").css("width", this.options.zoomBoxWidth)
																																		 .css("height",this.options.zoomBoxHeight)
																																		 .css("position","absolute")
																																		 .css("overflow","hidden")
																																		 .css("top", this.options.annotationBoxHeight)
																																		 .css("left",this.options.annotationBoxWidth/2.0-this.options.zoomBoxWidth/2.0);
													return zoomBox.append(image);
	
	},
	_generateHelp 				 : function(entities){
														var helpDiv = $("<div id='scribe_annotation_help'></div>").hide();
														$.each(entities, function(){
															helpDiv.append( $("<div id='scribe_help_"+this.name.replace(/ /,"_")+"'>"+this.help+"</div>"));
														});
														return helpDiv;
	},
	_generateTabBar        : function(entities){
														var tabBar = $("<ul id='scribe_tab_bar'></ul>");
														var self=this;
														$.each(entities, function(){
																var elementName= this.name.replace(/ /,"_");
																var elementId = "scribe_tab_"+elementName;
																var tab = $("<li id='"+elementId+"'>"+elementName+"</li>");
																tab.click(elementName,self._switchEntityType.bind(self) );
																tabBar.append(tab);
														});
														return tabBar;
	},
	_generateInputs 			: function(entities){
													 var inputBar =$("<div id='scribe_input_bar'></div>");
													 var self = this;
													 
													 $.each(entities, function(entity_index,entity){
															var currentInputPane = $("<div id='scribe_input_"+entity.name.replace(/ /,"_")
															+"'></div>").addClass("scribe_annotation_input").hide();
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
														var helpID=$("#scribe_tab_bar.scribe_selected_tab").attr("id");
	}

});
	