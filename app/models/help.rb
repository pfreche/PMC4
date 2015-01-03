class Help
  def attributSelector 
    
    a =    session[:selectedAttris]  
   
    selector = Attri.joins(:mfiles)
   
    @selectedAttributes = Attri.find(a) if a
    
    if @selectedAttributes  != nil

      jointext = 'inner join attris_mfiles AS amX on amX.mfile_id = mfiles.id'
      wheretext = 'amX.attri_id'
      
#      loop of attribute to build selection
       a.each do |i|
         selector = selector.joins(jointext.gsub("X",i.to_s)).where(wheretext.gsub("X",i.to_s) => i)
       end
       @attris = selector.distinct
     else
       @attris = Attri.all
     end 
     selector    
  end
end