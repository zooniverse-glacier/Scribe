task :whats_the_score_bootstrap => :environment do
  Template.delete_all
  Entity.delete_all
  Asset.delete_all
  
  template = Template.create( :name => "Bodleian",
                              :description => "Main Bodleian whats the score templage",
                              :project => "Whats the Score",
                              :display_width => 600,
                              :default_zoom => 1.5)
  
                       
  
  
  creator_entity = Entity.create( :name => "Creator",
                                  :description =>"Details of the creator of this music",
                                  :help=>"Transcribe the name of the creator as seen on the page",
                                  :resizeable => false,
                                  :width => 450,
                                  :height => 80)
  


  creator_name_field = Field.new( :name => "name",
                                  :field_key => "creator_name",
                                  :kind => "text",
                                  :initial_value => "--",
                                  :options => { :text => { :max_length => 70, :min_length => 0 } })
  
  creator_role_field = Field.new( :name => "role",
                                  :field_key => "creator_role",
                                  :kind => "select",
                                  :initial_value => "--",
                                  :options => { :select => ['Composer', 'Arranger / transcriber', 'Performer', 'Lyricist','Other'] })
                                  
  
  creator_entity.fields << creator_name_field
  creator_entity.fields << creator_role_field
  
  creator_entity.save
  
  title_entity = Entity.create( :name => "Title",
                                  :description =>"The main title of this music",
                                  :help=>"Enter the title of this music as you find it",
                                  :resizeable => false,
                                  :width => 450,
                                  :height => 80)
  
  main_title_field = Field.new( :name => "Main Title",
                                  :field_key => "Main_title",
                                  :kind => "text",
                                  :initial_value => "--",
                                  :options => { :text => { :max_length => 70, :min_length => 0 } })
  
  title_entity.fields << main_title_field 
  title_entity.save
  
  
  front_cover_entity  = Entity.create( :name => "Front Cover",
                                  :description =>"The type of cover this music has",
                                  :help=>"If this page is a front cover what kind of data does it have",
                                  :resizeable => false,
                                  :width => 450,
                                  :height => 80)
                                  
  front_cover_type_field = Field.new( :name => "Type",
                                  :field_key => "front_cover_type",
                                  :kind => "select",
                                  :initial_value => "--",
                                  :options => { :select => ['Picture', 'Ornamental text', 'Decoration', 'Text only'] })  
  
  front_cover_entity.fields << front_cover_type_field  
  front_cover_entity.save
                         
  
  illustrator_entity  = Entity.create( :name => "Illustrator",
                                  :description =>"Details about the illustrator",
                                  :help=>"Enter the name and role of an illustrator involved in this work ",
                                  :resizeable => false,
                                  :width => 450,
                                  :height => 80)
                                  
  illustrator_name_field =  Field.new( :name => "Name",
                                  :field_key => "illustrator_name",
                                  :kind => "text",
                                  :initial_value => "--",
                                  :options => { :text => { :max_length => 70, :min_length => 0 } })

  illustrator_role_field =  Field.new( :name => "Role",
                                      :field_key => "illustrator_role",
                                      :kind => "select",
                                      :initial_value => "--",
                                      :options => { :select => ['Artist / illustrator', 'Engraver / Lithographer', 'Other', 'Not applicable'] })
                                      
  illustrator_entity.fields << illustrator_name_field
  illustrator_entity.fields << illustrator_role_field
                                   
  illustrator_entity.save
  
  publication_entity = Entity.create( :name => "Publication",
                                  :description => "Name / place of the publication of this music",
                                  :help => "Enter the name and publication of the publisher",
                                  :resizeable => false,
                                  :width => 450,
                                  :height => 80)
  
  publication_name_field =  Field.new( :name => "Name",
                                  :field_key => "publication_name",
                                  :kind => "text",
                                  :initial_value => "--",
                                  :options => { :text => { :max_length => 70, :min_length => 0 } })

  publication_role_field =  Field.new( :name => "Type",
                                      :field_key => "publication_type",
                                      :kind => "select",
                                      :initial_value => "--",
                                      :options => { :select => ['Place of publication', 'Publisher', 'Printer', 'Other'] })

  publication_entity.fields << publication_name_field
  publication_entity.fields << publication_role_field

  publication_entity.save                                 

                                  
  back_cover_entity = Entity.create( :name => "Back Cover",
                                  :description => "Details about the back cover",
                                  :help => "If this page is the back cover what type is it?",
                                  :resizeable => false,
                                  :width => 450,
                                  :height => 80)
                                  
  back_cover_field =  Field.new( :name => "Illustration type",
                                 :field_key => "illustration_type",
                                 :kind => "select",
                                 :initial_value => "--",
                                 :options => { :select => ['Publishers catalogue', 'Advertisement', 'Other', 'Not applicable'] })

  back_cover_entity.fields << back_cover_field
  
  back_cover_entity.save
                               
  
                                  
  other_entity      =   Entity.create( :name => "Other",
                                  :description => "Any other transcription",
                                  :help => "Any other transcriptions",
                                  :resizeable => false,
                                  :width => 450,
                                  :height => 80) 
  
  other_text_field =  Field.new( :name => "Text",
                                  :field_key => "other_text",
                                  :kind => "text",
                                  :initial_value => "--",
                                  :options => { :text => { :max_length => 70, :min_length => 0 } })  
                                  
  other_entity.fields << other_text_field
  other_entity.save
  
                                  
  genre_entity      =   Entity.create( :name => "Genre",
                                      :description => "Details about the genre of this peice",
                                      :help => "select the genre of this peice ",
                                      :resizeable => false,
                                      :width => 450,
                                      :height => 80)
                                      
 genre_type_field =  Field.new( :name => "Genre type",
                                  :field_key => "genre_type",
                                  :kind => "select",
                                  :initial_value => "--",
                                  :options => { :select => ['Galop', 'March', 'Polka ', 'Quadrille', 'Waltz','Other','No attempt to describe'] })     
  
 genre_entity.fields << genre_type_field
 genre_entity.save
                                                          
  key_entity      =   Entity.create( :name => "Key",
                                      :description => "Predominant key",
                                      :help => "Enter the predominant key of the peice ",
                                      :resizeable => false,
                                      :width => 450,
                                      :height => 80)
                                      
  key_field =  Field.new( :name => "Key",
                                 :field_key => "key",
                                 :kind => "select",
                                 :initial_value => "--",
                                 :options => { :select => ['C', 'D', 'E ', 'F', 'G','A','B'] })
  
  flat_sharp_field =  Field.new( :name => "Flat / Sharp",
                                :field_key => "flat_sharp",
                                :kind => "select",
                                :initial_value => "--",
                                :options => { :select => ['none','flat', 'sharp'] })                                                                       
  
  mode_field =  Field.new( :name => "mode",
                                :field_key => "mode",
                                :kind => "select",
                                :initial_value => "--",
                                :options => { :select => ['Major', 'Minor'] })
                                
  key_entity.fields << key_field
  key_entity.fields << flat_sharp_field
  key_entity.fields << mode_field
  
  key_entity.save

  tempo_entity      =   Entity.create( :name => "Tempo",
                                      :description => "Predominant tempo",
                                      :help => "Enter the predominant tempo of the peice ",
                                      :resizeable => false,
                                      :width => 450,
                                      :height => 80)
  
  tempo_field =  Field.new( :name => "Tempo",
                                      :field_key => "tempo",
                                      :kind => "text",
                                      :initial_value => "--",
                                      :options => { :text => { :max_length => 70, :min_length => 0 } })  

  tempo_entity.fields << tempo_field
  tempo_entity.save
  
                                      
  first_line_entity      =   Entity.create( :name => "First line",
                                      :description => "The first line of the peice",
                                      :help => "Enter the first line of the peice ",
                                      :resizeable => false,
                                      :width => 450,
                                      :height => 80)

  first_line_field =  Field.new( :name => "Text",
                                 :field_key => "first_line_text",
                                 :kind => "text",
                                 :initial_value => "--",
                                 :options => { :text => { :max_length => 70, :min_length => 0 } })  

  first_line_entity.fields << first_line_field
  first_line_entity.save
 
  
  template.entities << creator_entity
  template.entities << title_entity
  template.entities << front_cover_entity
  template.entities << illustrator_entity
  template.entities << publication_entity
  template.entities << back_cover_entity
  template.entities << other_entity  
  template.entities << genre_entity
  template.entities << key_entity
  template.entities << tempo_entity
  template.entities << first_line_entity
  
  
  template.save 
  

  #generate a single asset and a single user for testing just now
  
  Asset.create(:location=>"/images/testPage4.jpg", :display_width => 658, :height => 1941, :width => 1317,  :template => template)
  Asset.create(:location=>"/images/testPage3.jpg", :display_width => 658, :height => 1500, :width => 972,  :template => template)

  
end