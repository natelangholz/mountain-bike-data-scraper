
#pull the ews races full history

#only need one package
library(rvest)

#who should have an ID?
#athlete
#race
#organizer


#ews 2018; sam hill
#5977:5984
#ews 2017; sam hill
#4480,:4487
#ews 2016; richie rude, first full 8 round season
#3921:3928
#ews 2015; 3033 was canceled; richie rude
#3029:3036
#ews 2014; 7 rounds; jared graves?
#2091:2097
#ews 2013; Jerome Clementz
#2017:2023

race_ids <- c(2017:2023,2091:2097,3029:3032,3034:3036,3921:3925,4093,3927:3928,4480:4487,5977:5981,6880,5983:5984)
stage_list <- NULL
divisions <- NULL
races <- NULL


for(i in 1:length(race_ids)){
  
  url <- paste0('https://www.rootsandrain.com/race',race_ids[i],'/')
  #url<-paste0('https://www.rootsandrain.com/race',i,'/')

  #Reading the HTML code from the website
  webpage <- read_html(url)
  
  #race
  race_name_dirty <- html_nodes(webpage,'#h1-title')
  race_name_data <- html_text(race_name_dirty)
  #race_name_data
  
  #race name split
  race_name_dirty <- html_nodes(webpage,'h1 a')
  race_name_data2 <- html_text(race_name_dirty)
  print(race_name_data2)
  #race_name_data2
  
  #race date
  date_dirty <- html_nodes(webpage,'time')
  date_data <- html_text(date_dirty)
  date_data2 <- unlist(html_attrs(date_dirty))
  #date_data
  
  #if (!(race_name_data %in% races)){races <- rbind(races, c(race_name_data,race_name_data2, date_data,date_data2,webpage))}
  races <- rbind(races, c(race_name_data,race_name_data2, date_data,date_data2,webpage))
  
  #race organizer
  #organizer_dirty <- html_nodes(webpage,'p a')
  #organizer_data <- html_text(organizer_dirty)[3]
  #organizer_data
  
  #if (!(organizer_data %in% organizers)){organizers <- rbind(organizers, organizer_data)}
  

  
  #rider names, times, results
  stages <- NULL
  for(k in 1:20){
    stage_data_dirty <- html_nodes(webpage, paste0('td:nth-child(',k,')'))
    stage_data <- html_text(stage_data_dirty)
    stages <- cbind(stages,stage_data)
  }
  stages <- as.data.frame(stages)
  
  #race divisions
  division_data <- NULL
  division_dirty <- html_nodes(webpage,'div h2')
  division_data <- html_text(division_dirty)
  #division_data

  #table headers
  header_data <- NULL
  header_dirty <- html_nodes(webpage,'th')
  header_data <- html_text(header_dirty)[1:dim(stages)[2]]
  #header_data
  
  #change stages table names
  names(stages) <- header_data
  stage_list[[i]] <- stages
  divisions[[i]] <- as.data.frame(division_data)
}


#divisions
#stage_list
#races
save(divisions, file ='data/raw-ews-data/divisions.Rdata')
save(stage_list, file ='data/raw-ews-data/stage-list.Rdata')
save(races, file ='data/raw-ews-data/ews-races.Rdata')


series_ids <- c(342,351,509,655,743,907)
series_list <- NULL


for(i in 1:length(series_ids)){
  
  url <- paste0('https://www.rootsandrain.com/series',series_ids[i],'/')
  #url<-paste0('https://www.rootsandrain.com/race',i,'/')
  
  #Reading the HTML code from the website
  webpage <- read_html(url)
  
  #race
  series_list[[i]] <- html_table(webpage)
}

save(series_list, file ='data/raw-ews-data/ews-series-years.Rdata')


#create unique ids
#install.packages("uuid",,'http://rforge.net/',type='source')
#library(uuid)
#UUIDgenerate(FALSE)
#TRUE sets time based UID and is increasing..
#UUIDgenerate(TRUE)

#maybe do this?
#my_database<- src_sqlite("adverse_events", create = TRUE) # create =TRUE creates a new database



