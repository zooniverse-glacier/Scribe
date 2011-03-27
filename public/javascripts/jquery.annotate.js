$.widget("ui.annotate", {
	options: {'zoomLevel'       : 1, 
						'assetScreenWidth'       : 600,
						'assetScreenHeight'      : 900,
						'annotationBoxWidth'  : 500,
						'annotationBoxHeight' : 100,
						'zoomBoxWidth'	: 500,
						'zoomBoxHeight' : 200,
						'markerIcon'       : '/images/annotationMarker.png',
						zoomLevel					 : 3,
						onSubmitedPassed   : null,
						onSubmitedFailed   : null,
						showHelp					 : false,
						initalEntity       : null,
						annotationBox			 : null,
						annotations: []
   },
	_create: function() {
			var self= this;
			this.options.initalEntity = this.options.template.entities[0].name;
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
			 						.css("height",this.options.assetScreenHeight);
			var image= $("<img></img>").attr("src",this.options.imageURL)
																 .css("width",this.options.assetScreenWidth)
																 .css("height",this.options.assetScreenHeight)
																 .css("position","absolute")
																 .css("left","0px")
																 .css("top","0px");
			this.element.append(image);
			if(this.options.doneButton && this.options.submitURL){
				this.options.doneButton.click(function(event){
					event.preventDefault();
					this.submitResults(this.options.submitURL);
				}.bind(this))
			}
			
			
			
			this.options.xZoom = this.options.assetWidth/this.options.assetScreenWidth;
			this.options.yZoom = this.options.assetHeight/this.options.assetScreenHeight;
			
			this.element.click(function(event){
				if(self.options.annotationBox==null){
					console.log(event);
					self.showBox({x:event.offsetX,y:event.offsetY});
				}
			});
	},
	showBox               : function(position) {
														this.options.annotationBox = $(this._generateAnnotationBox());
														this.element.append(this.options.annotationBox);
														this.element.imgAreaSelect({disable:true});
														if(position){
																		console.log("element");
																		console.log(this.options.annotationBox);
																		if(position.width && position.height){
																			var zoomLevel = this.options.zoomLevel;
																			this.options.zoomBoxWidth= position.width*zoomLevel;
																			this.options.zoomBoxHeight=position.height*zoomLevel;
																			
																			this.options.zoomBox.css("width",position.width*zoomLevel)
																													.css("height",position.height*zoomLevel)
																			 										.css("top", this.options.annotationBoxHeight)
																					 								.css("left",this.options.annotationBoxWidth/2.0-this.options.zoomBoxWidth/2.0);
																			
																		}
																		var xOffset = $(this.options.annotationBox).width()/2.0;
																		var yOffset = $(this.options.annotationBox).height()+($(this.options.zoomBox).height())/2.0;
																		var screenX = position.x-xOffset;
																		var screenY = position.y-yOffset;
																		this.options.annotationBox.css("left",position.x-xOffset);
																		this.options.annotationBox.css("top",position.y-yOffset);
																		console.log(this.options.xZoom+" "+this.options.yZoom);
																		var zoomX = -1*(position.x*this.options.zoomLevel-this.options.zoomBoxWidth/2.0);
																		var zoomY = -1*(position.y*this.options.zoomLevel-this.options.zoomBoxHeight/2.0);
																		
																		$(this.options.zoomBox).find("img").css("top", zoomY )
																																			.css("left", zoomX);
																		
														}
												}, 
	hideBox               : function() { this._annatationBox.remove();}, 
	getAnnotations        : function() { return this.options.annotations},
	deleteAnnotation      : function(annotationId){ this._trigger('anotationDeleted',{},"message deleting"+annotationId)},
	editAnnotation        : function(annotationId){ this._trigger('anotationEdited',{},"message editing"+annotationId)},
	setMarkerIcon         : function(icon){},
	submitResults         : function(url){ 
														console.log("submited annotations");
														console.log(this.options.annotations);
														this._trigger('resultsSubmited',{},this.options.annotations);
														$.ajax({
												          url: url,
												          data: {"transcription" :this.options.annotations},
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
	_addAnnotation          : function (event){
														event.data.element.imgAreaSelect({disable:false});
														
														event.preventDefault();
														event.stopPropagation();
												   
														console.log(event.data.options.annotations);
														var annotation_data=event.data._serializeCurrentForm();
														event.data.options.annotations.push(annotation_data);
														event.data._trigger('annotationAdded', {}, {annotation:annotation_data });
														event.data.options.annotationBox.remove();
														event.data.options.annotationBox=null;
	},
	_serializeCurrentForm   : function(){		
														var targetInputs =$(".currentInputs input"); 
														var parent  = $(targetInputs[0]).parent().parent();
														var annotationType = parent.attr("id").substring(6);
														
														var result = {kind:annotationType, data:{}};
														targetInputs.each(function(){
															result.data[$(this).attr("id")]=$(this).val();
														});
														return result ;
														
	},
 	_generateField          : function (field){
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
															$(".currentInputs").removeClass("currentInputs");
															$("#input-"+event.data+" .inputField").addClass("currentInputs");
															$(".inputField").show();
															$(".inputField").filter(".currentInputs").addClass("currentHelp");
	},
	_updateWithDrag 				: function(position){
															console.log(position);
															var x = position.left+ this.options.annotationBoxWidth/2;
															var y = position.top + this.options.annotationBoxHeight+ this.options.zoomBoxHeight/2.0;
															var zoomX = -1*(x*this.options.zoomLevel-this.options.zoomBoxWidth/2.0);
															var zoomY = -1*(y*this.options.zoomLevel-this.options.zoomBoxHeight/2.0);
														
															$(this.options.zoomBox).find("img").css("top", zoomY )
																																.css("left", zoomX);	},
	_generateAnnotationBox  : function(){
													var self=this;
													var annotationBox = $("<div id ='annotationBox'> </div>").draggable(this,{ drag: function(event,ui){
														console.log("position"+ui.position.left+" "+ui.position.top+" offset "+ui.offset.left+" "+ui.offset.top);
														self._updateWithDrag(ui.position);
													}});
													annotationBox.css("width",this.options.annotationBoxWidth+"px")
		 																	 .css("height",this.options.annotationBoxHeight+"px")
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
													bottomArea.append($("<input type='submit' value='add'>").click(this,this._addAnnotation));
													
													annotationBox.append(topBar);
													annotationBox.append(bottomArea);
													
													
													this.options.zoomBox=this._generateZoomBox();
													helpButton.toggle(function(){$(".currentHelp").stop().animate({top:'-80', opacity:"100"},500);$("#help").html("Hide help"); }, function(){ $(".currentHelp").stop().animate({top:'0',opacity:"0"},500); $("#help").html("Show help");});
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
													var zoomBox = $("<div id='zoomBox'></div>").css("width", this.options.zoomBoxWidth)
																																		 .css("height",this.options.zoomBoxHeight)
																																		 .css("position","absolute")
																																		 .css("overflow","hidden")
																																		 .css("top", this.options.annotationBoxHeight)
																																		 .css("left",this.options.annotationBoxWidth/2.0-this.options.zoomBoxWidth/2.0);
												  return zoomBox.append(image);
	
	},
	_generateHelp 				 : function(entities){
														var helpDiv = $("<div id='annotationHelp'></div>").hide();
														$.each(entities, function(){
															helpDiv.append( $("<div id='help-"+this.name.replace(/ /,"_")+"'>"+this.help+"</div>"));
														});
														return helpDiv;
	},
	_generateTabBar        : function(entities){
														var tabBar = $("<ul id='tabBar'></ul>");
														var self=this;
														$.each(entities, function(){
																var elementId = this.name.replace(/ /,"_");
																var tab = $("<li id='"+elementId+"'>"+elementId+"</li>");
																tab.click(elementId,self._switchEntityType.bind(self) );
																tabBar.append(tab);
														});
														return tabBar;
	},
	_generateInputs 			: function(entities){
													 var inputBar =$("<div id='inputBar'></div>");
													 var self = this;
													 
													 $.each(entities, function(entity_index,entity){
															var currentInputPane = $("<div id='input-"+entity.name.replace(/ /,"_")
															+"'></div>").addClass("annotation-input");
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
														var helpID=$("#tabBar.selectedTab").attr("id");
	}

});
	