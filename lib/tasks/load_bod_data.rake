task :convert_files => :environment do
  
  outdir="/Users/stuartlynn/Desktop/musicScoresForUpload/"
  count = 0 
  ["Mus-400-b-1(1)","Mus-400-b-1(3)","Mus-400-b-1(8)","Mus-400-b-1(9)","Mus-400-b-1(16)","Mus-400-b-1(23)","Mus-400-b-1(28) ","Mus-400-b-1(31)","Mus-400-b-1(38)","Mus-400-b-1(39)","Mus-400-b-1(40)","Mus-400-b-1(41)","Mus-400-b-1(43)","Mus-400-b-1(47)","Mus-400-b-1(50)","Mus-400-b-1(51)","Mus-400-b-1(52)","Mus-400-b-1(53)","Mus-400-b-1(56)","Mus-400-b-1(57)"].each do |base_name|
  Dir.glob("/Volumes/Iomega\ HDD/Bodleian\ Music\ Pamphlets/Box\ 1/#{base_name}*").each do |asset|
    if count > 190 
      puts "doing #{asset}"
      asset_name = asset.split("/").last.split(".").first
      `convert "#{asset}" -resize 10% "#{outdir}/#{asset_name}.jpg"`
    end
    count +=1 
  end
end
end


task :generate_books =>:environment do
  
  data=IO.read("/Volumes/Iomega\ HDD/Bodleian\ Music\ Pamphlets/Box\ 1/Box\ 1\ Index.csv").split("\n").collect{|l| l.split(",")}
  
  data.each do |line|
    cat_no = line[0].gsub(/[\(]/,"_").gsub(/\)/,"")
    unless Book.find_by_cat_no(cat_no)
      b=Book.new(:cat_no=>cat_no, :composer=>line[2], :title=>line[3])
      puts "could not save book #{line[3]}" unless b.save
    end
  end
end


task :generate_assets =>:environment do 
  data = Dir.glob("/Users/stuartlynn/Desktop/musicScoresForUpload/*.jpg")
  template = Template.first
  data.each do |file|
    
      dimensions = `identify #{file}`.match("[0-9]*x[0-9]*").to_s.split("x")

      filename= file.split("/").last
      cat_no = filename.split(/-[0-9]*\.jpg/).first
      order  = filename.match(/[0-9]*\.jpg/).to_s.gsub(".jpg","").to_i
      b= Book.find_by_cat_no(cat_no)
      puts "could not find book #{cat_no}" unless b
      
      a= Asset.new(:order=>order,:location=>"http://whatsthescore.s3.amazonaws.com/#{filename}",:book=>b, :ext_ref=>filename.gsub(".jpg",""), :width => dimensions[0], :height=>dimensions[1], :template=>template, :display_width=>658)
      
      puts "count not save #{a.to_json}" unless a.save 
  end
end