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
						onAnnotationRemoved : null,
						onAnnotationUpdated: null,
						onAnnotationEditedStarted : null,
						showHelp					 : false,
						initalEntity       : null,
						annotationBox			 : null,
						image							 : null,
						page_data					 : {},
						annotations				 : {},
						annIdCounter			 : 0,
						editing_id				 : null,
						update						 : false,
						authenticity_token : null,
						orientation : "floatAbove",
						helpShowing : false
   },
	_create: function() {
			var self= this;
			if (this.options.initalEntity==null){
				this.options.initalEntity = this.options.template.entities[0].name.replace(/ /,"_");
			}
			
			
		
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
		
			
			image.imgAreaSelect({
			      handles: false,
						autoHide : true,
			      onSelectEnd: function render_options(img, box){
							if (self.options.annotationBox==null){
								var midX=(box.x1+box.x2)/2.0;
								var midY=(box.y1+box.y2)/2.0;
								//console.log("showing box from select");
								//console.log({x:midX,y:midY, width:box.width,height:box.height});
								
								self.showBox({x:midX,y:midY, width:box.width,height:box.height});
							}
						}
			  });
			
			this.options.image=image;

			this.element.append(image);
			
			if(this.options.doneButton && this.options.submitURL){
				this.options.doneButton.click(jQuery.proxy(function(event){
					event.preventDefault();
					this.submitResults(this.options.submitURL);
				},this))
			}
			
			
			this.options.page_data["asset_screen_width"] = this.options.assetScreenWidth;
			this.options.page_data["asset_screen_height"] = this.options.assetScreenHeight;
			this.options.page_data["asset_width"] = this.options.assetWidth;
			this.options.page_data["asset_height"] = this.options.assetHeight;
			this.options.page_data["zooniverse_user_id"] = this.options.userID;
			
			
			this.options.xZoom = this.options.assetWidth/this.options.assetScreenWidth;
			this.options.yZoom = this.options.assetHeight/this.options.assetScreenHeight;
			
			this._setUpAnnotations();
			
			this.element.click(function(event){
				//console.log(event);
				if(self.options.annotationBox==null){
					self.showBox({x:event.offsetX,y:event.offsetY});
				}
			});
	},
	_entity_name_for_id		: function(id){
												for(var i in this.options.template.entities ){
													  //console.log("testing "+this.options.template.entities[i].id+" and "+id);
														if (this.options.template.entities[i].id==id){
															return this.options.template.entities[i].name.replace(/ /,"_");
														}
												}
												return nil;													
	},
	_setUpAnnotations 		: function(){
													//console.log("setting up annotations");
													this.options.annIdCounter = this.options.annotations.length;
													for(var id in this.options.annotations){
														//console.log("annotations "+id);
														//console.log(this.options.annotations[id].bounds);
														var bounds = this.options.annotations[id].bounds;
														//console.log(this._denormaliseBounds(bounds));
														
														this.options.annotations[id].kind=this._entity_name_for_id(this.options.annotations[id].entity_id);
														
														this._generateMarker(this._denormaliseBounds(bounds), id);
														if (this.options.onAnnotationAdded!=null){
													 		this.options.onAnnotationAdded.call(this, {annotation_id:id, data:this.options.annotations[id]});
														}
													}
	},
	
	_normaliseBounds      : function(bounds){
												var zoomLevel = this.options.zoomLevel;
												var normalized_bounds = {width: bounds.width/this.options.assetScreenWidth,
																								 height: bounds.height/this.options.assetScreenHeight,
																								 x : bounds.x/this.options.assetScreenWidth,
																								 y : bounds.y/this.options.assetScreenHeight,
																								 zoom_level:zoomLevel };
												return normalized_bounds
	},
	_denormaliseBounds 		: function(bounds){
												var denorm = {width  : bounds.width*this.options.assetScreenWidth, 
																		  height : bounds.height*this.options.assetScreenHeight,
																			x 		 : bounds.x*this.options.assetScreenWidth,
																			y 		 : bounds.y*this.options.assetScreenHeight,
																			zoom_level : bounds.zoomLevel}
												return denorm;
	},
	showBox               : function(position) {
														//console.log("showing box at"+position);
														
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
																		
																		if(position.y> this.options.assetScreenHeight/2){
																			this.options.orientation="floatAbove";
																			$("#scribe_transcription_area").css("top",0);
																		}
																		else{
																			this.options.orientation="floatUnder";
																			$("#scribe_transcription_area").css("top",(this.options.zoomBoxHeight+this.options.annotationBoxHeight));
																		}
																		
																		
																		$(this.options.zoomBox).find("img").css("top", zoomY )
																																			.css("left", zoomX);
																	  this._selectEntity(this.options.initalEntity);
																																			
																		
														}
												}, 
	showBoxWithAnnotation  : function(annotation) {
														//console.log("annotation for showing");
														//console.log(annotation);
														//console.log("bounds for showing");
														//console.log(annotation.bounds)
														zoom = this.options.zoomLevel;
														
														var bounds = this._denormaliseBounds(annotation.bounds);
														
														bounds = {x: bounds.x+bounds.width/2,
																		 y: bounds.y+bounds.height/2,
																 		 width: bounds.width ,
																		height: bounds.height}
														//console.log(bounds);
														
																			
														this.showBox(bounds);
														this._selectEntity(annotation.kind);
														//console.log(annotation.data);
														$("div.scribe_current_inputs input, div.scribe_current_inputs select").each(function(index,element){
																var ell_id=$(element).attr("id").replace("scribe_field_","");
																$(element).val(annotation.data[ell_id]);
														});
														
												},
	hideBox               : function() { this._annatationBox.remove();}, 
	getAnnotations        : function() { return this.options.annotations},
	setMarkerIcon         : function(icon){},
	submitResults         : function(url){ 
														var finalAnnotations=[];
														for(var id in this.options.annotations){
															if (this.options.annotations[id]!=null){
																finalAnnotations.push(this.options.annotations[id]);
															}
														}
														this._trigger('resultsSubmited',{},this.options.annotations);
													  type=	this.options.update ? "PUT" : "POST"
														$.ajax({
												          url: url,
												          data: {"transcription" :{"annotations" : finalAnnotations, "page_data": this.options.page_data}, "authenticity_token": this.options.authenticity_token},
																	type :type,
												          success: jQuery.proxy(this._postAnnotationsSucceded, this),
												          error: jQuery.proxy(this._postAnnotationsFailed, this)
												    });
													},
	_postAnnotationsSucceded: function (){
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
																						x : -1*image.css("left").replace(/px/,'')/zoomLevel,
																						zoom_level: zoomLevel};
																						
														var annotation_data=this._serializeCurrentForm();
														
													
																										
														annotation_data["bounds"]= this._normaliseBounds(location);
														
														
													//	this._trigger('annotationAdded',  {annotation:annotation_data });
													
														if (this.options.editing_id!=null){
															$("#scribe_marker"+this.options.editing_id).remove();
															
															this._generateMarker(location, this.options.editing_id);
															this.options.annotations[this.options.editing_id]=annotation_data;
															if (this.options.onAnnotationUpdated!=null){
														 		this.options.onAnnotationUpdated.call(this, {annotation_id:this.options.editing_id, data:annotation_data});
															}
															this.options.editing_id=null;
														}
														else{
															
															this.options.annotations[this.options.annIdCounter]=annotation_data;
															this._generateMarker(location, this.options.annIdCounter);
															
													  	if (this.options.onAnnotationAdded!=null){
														 		this.options.onAnnotationAdded.call(this, {annotation_id:this.options.annIdCounter, data:annotation_data});
															}
															this.options.annIdCounter++;
														}
														
														this.options.annotationBox.remove();
													  this.options.annotationBox=null;
	},
	_serializeCurrentForm   : function(){	
														var targetInputs =$(".scribe_current_inputs input, .scribe_current_inputs select"); 
														var parent  = $(targetInputs[0]).parent().parent();
														var annotationType = parent.attr("id").replace("scribe_input_","").replace(/_/," ");
														
														var result = {kind:annotationType, data:{}};
														targetInputs.each(function(){
															var fieldName= $(this).attr("id").replace("scribe_field_","");
															result.data[fieldName]=$(this).val();
														});
														return result ;
														
	},
	_generateMarker 				: function (position,marker_id){
														var self=this;
														var marker = $("<div></div>").attr("id","scribe_marker"+marker_id)
																	 											 .attr("class","scribe_marker")
																												 .css("width",position.width)
																												 .css("height",position.height)
																												 .css("top", position.y)
																												 .css("left", position.x);
														marker.append($("<p>"+marker_id+"</p>"));
														var controls = $("<div class='scribe_marker_controls'></div>");
														
														controls.append($("<a class='scribe_marker_edit' href=#>edit</a>").click(function(event){
															event.stopPropagation();
															self._editAnnotation(marker_id);
														}));
														controls.append($("<a class='scribe_marker_delete ' href=#>delete</a>").click(function(event){
															//console.log("running delete");
															event.stopPropagation();
															self._deleteAnnotation(marker_id);
														}));
														marker.append(controls);
														this.element.append(marker);
	},
	
	_deleteAnnotation					: function (annotation_id){
														$("#scribe_marker"+annotation_id).remove();
														this.options.annotations[annotation_id]=null;
														this._trigger('anotationDeleted',{},"message deleting"+annotation_id)
														if(this.options.onAnnotationRemoved!=null){
															this.options.onAnnotationRemoved.call(this, annotation_id);
													 	}
														  
	},
	_editAnnotation					: function (annotation_id){
														var annotation = this.options.annotations[annotation_id];
														this.options.editing_id=annotation_id;

														this._trigger('anotationEdited',{},"message editing"+annotation_id)
														if(this.options.onAnnotationEditedStarted!=null){
															this.options.onAnnotationEditedStarted.call(this,{annotation_id:annotation_id, data:annotation});
													 	}
														this.showBoxWithAnnotation(annotation);
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
															$(".scribe_input_field").filter(".scribe_current_inputs");
															this.changeHelp(entityName);
	},
	_switchEntityType       : function (event){
															this._selectEntity(event.data);
														},
														
	_updateWithDrag 				: function(position){
															var x = position.left+ this.options.annotationBoxWidth/2;
															var y = position.top + this.options.annotationBoxHeight+ this.options.zoomBoxHeight/2.0;
															
															this._checkAndSwitchOrientation({x:x,y:y});
															var zoomX = -1*(x*this.options.zoomLevel-this.options.zoomBoxWidth/2.0);
															var zoomY = -1*(y*this.options.zoomLevel-this.options.zoomBoxHeight/2.0);
														
															$(this.options.zoomBox).find("img").css("top", zoomY )
																																.css("left", zoomX);	},
	_checkAndSwitchOrientation : function(position){
														if (this.options.orientation == "floatUnder" && position.y> this.options.assetScreenHeight/2){
															this.options.orientation="floatAbove";
															$("#scribe_transcription_area").animate({"top":"-="+(this.options.zoomBoxHeight +this.options.annotationBoxHeight )},500);
																if(this.options.helpShowing){
																	this.hideHelp();
																	this.showHelp();
																}
														}
														
														if (this.options.orientation == "floatAbove" && position.y< this.options.assetScreenHeight/2){
															this.options.orientation="floatUnder";
															$("#scribe_transcription_area").animate({"top":"+="+(this.options.zoomBoxHeight+this.options.annotationBoxHeight)},500);
																if(this.options.helpShowing){
																	this.hideHelp();
																	this.showHelp();
																}
														}
													
	}	,																													
	_generateAnnotationBox  : function(){
													var self=this;
													var image = $(this.options.image);
													var imageLoc = image.offset();
													//console.log(this.options);
													var totalHeight = this.options.zoomBoxHeight/2+ this.options.annotationBoxHeight;
													var containment = [imageLoc.left-this.options.annotationBoxWidth/2, imageLoc.top-totalHeight, imageLoc.left+image.width()-this.options.annotationBoxWidth/2, imageLoc.top+image.height()-totalHeight	];
													//console.log(containment);
													var annotationBox = $("<div id ='scribe_annotation_box'> </div>").draggable(this,{ containment: containment , drag: function(event,ui){
														self._updateWithDrag(ui.position);
													}});
													
													annotationBox.css("cursor","move");
													
													var topBar 				= $("<div id ='scribe_top_bar'></div>");
													var tabBar 				= this._generateTabBar(this.options.template.entities);
													var help 					= this._generateHelp(this.options.template.entities);
													
													topBar.append(tabBar);
													topBar.append(help);
													
													var helpButton = $("<a href=# id='scribe_annotation_help_button' >show help</a>").css("opactiy","0");
													var closeButton = $("<a href=# id='scribe_annotation_close_button' >close</a>");
													
													closeButton.click(function(event){
														event.stopPropagation();
														self._dismissAnnotationBox();
													});
													
													
													helpButton.toggle( jQuery.proxy(this.showHelp, this), jQuery.proxy(this.hideHelp, this));
													
													topBar.append(helpButton);
													topBar.append(closeButton);
													var bottomArea    = $("<div id='scribe_bottom_area'></div>");
													var inputBar      = this._generateInputs(this.options.template.entities);
													bottomArea.append(inputBar);
													bottomArea.append($("<input type='submit' value='save'>").addClass("button").click(function(e){ self._addAnnotation(e) } ));
													
													var transcriptionArea= $("<div id='scribe_transcription_area'></div>").css("position","absolute").css("top",0);
													transcriptionArea.css("width",this.options.annotationBoxWidth+"px")
		 																	 .css("height",this.options.annotationBoxHeight+"px");
													annotationBox						.css("width",this.options.annotationBoxWidth+"px")
								 																	 .css("height",this.options.annotationBoxHeight+"px");
													transcriptionArea.append(topBar);
													transcriptionArea.append(bottomArea);
													annotationBox.append(transcriptionArea);
													
													this.options.zoomBox=this._generateZoomBox();
													annotationBox.append(this.options.zoomBox);
													annotationBox.css("z-index","2");
													return annotationBox;
													
	},
	_dismissAnnotationBox  : function(){
												if (this.options.editing_id!=null){
													var annotation_data=this.options.annotations[this.options.editing_id];
													if (this.options.onAnnotationUpdated!=null){
												 		this.options.onAnnotationUpdated.call(this, {annotation_id:this.options.editing_id, data:annotation_data});
													}
													this.options.editing_id=null;
												}	
												this.options.annotationBox.remove();
										  	this.options.annotationBox=null;
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
																																		 .css("left",this.options.annotationBoxWidth/2.0-this.options.zoomBoxWidth/2.0)
																																	 	 .resizable();
													return zoomBox.append(image);
	
	},
	_generateHelp 				 : function(entities){
														var helpDiv = $("<div id='scribe_annotation_help'></div>").hide();
														$.each(entities, function(){
															helpDiv.append( $("<div id='scribe_help_"+this.name.replace(/ /,"_")+"'></div>")
																		 						.append(this.help)
																								.hide()
																		 						.addClass("scribe_help_content"));
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
																tab.click(elementName,jQuery.proxy(self._switchEntityType, self) );
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
															$.each(entity.entry_fields, function(field_index,field){
																	var current_field = self._generateField(field);
																	if(entity_index==0) {current_field.show();}
																	else {current_field.hide();}
																	currentInputPane.append(current_field);
															});
															inputBar.append(currentInputPane);
													 });
													return inputBar;
	}, 
	
	changeHelp					: function(entity_name){
												$(".scribe_help_content").hide();
												$("#scribe_help_"+entity_name).show();
	},
	showHelp 						: function(){
														this.options.helpShowing=true;
														if(this.options.orientation=="floatAbove"){
															$("#scribe_annotation_help").stop().show().animate({"top":"-100","opacity":"100"},500);
														}
														else{
															$("#scribe_annotation_help").stop().show().animate({"top":"100","opacity":"100"},500);
															
														}
														var helpID=$("#scribe_tab_bar .scribe_selected_tab").attr("id");
														
														this.changeHelp(helpID.replace("scribe_tab_",""));
														// 													helpID=helpID.replace("tab","help");
														// 													alert("showing help "+helpID);
														// 													$("#"+helpID).addClass("scribe_current_help");
														// 													$(".scribe_current_help").stop().animate({top:'-80', opacity:"100"},500);
														// 													$("#scribe_annotation_help_button").html("hide help"); 
														$("#scribe_annotation_help_button").html("hide help");
														
												},
	hideHelp						: function(){
														this.options.helpShowing=false;
		
														$("#scribe_annotation_help").stop().animate({"top":"0","opacity":"0"},500);
														// $(".scribe_current_help").stop().animate({top:'0',opacity:"0"},500); 
														$("#scribe_annotation_help_button").html("show help");
	}
														
											

});
	