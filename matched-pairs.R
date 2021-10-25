library(psych)
library(dplyr)
library(lubridate)
############################# #############################
####################### ADVISEE + ADVISOR SURVEY #############################
############################# #############################

#assumes that it's coming straight from qualtrics::fetchResponse like:
#dat$
#  result$
#    values$
#      QID90
#      QID92
#      ...

# and packs it into
# res$CARGS_1
# res$CARGS_2
# ...

# IMPORTANT
# If you change questions on the qualtrics side, you will have to redo some(all)
# of the next two functions. There should be a better way to do this- the qualtrics
# response has the same labels in the dataset, but I didn't spend the time to
# do this nicely: bbb

mapAdviseeQualtricsResults <- function(dat) {
  res <- NULL
  values <- dat$result$values
  labels <- dat$result$labels
  res$CarGS <- c(values$QID1_1,
                 values$QID1_5,
                 values$QID1_26,
                 values$QID1_8,
                 values$QID1_7,
                 values$QID1_6,
                 values$QID1_4,
                 values$QID1_2,
                 values$QID1_3,
                 values$QID1_27,
                 values$QID87_2,
                 values$QID87_3,
                 values$QID87_4,
                 values$QID87_6,
                 values$QID87_7,
                 values$QID87_8,
                 values$QID87_28,
                 values$QID87_27,
                 values$QID87_26,
                 values$QID87_5,
                 values$QID87_29)
  
  res$PsychGS <- c(values$QID75_32,
                   values$QID75_33,
                   values$QID75_27,
                   values$QID75_13,
                   values$QID75_12,
                   values$QID75_14,
                   values$QID75_17,
                   values$QID75_28,
                   values$QID75_29,
                   values$QID75_9,
                   values$QID70_32,
                   values$QID70_33,
                   values$QID70_27,
                   values$QID70_13,
                   values$QID70_12,
                   values$QID70_14,
                   values$QID70_17,
                   values$QID70_28,
                   values$QID70_29,
                   values$QID70_9)
  
  res$RelGS <- c(values$QID72_2,
                 values$QID72_3,
                 values$QID72_4,
                 values$QID72_5)
  
  res$WorkingWell <- values$QID76_TEXT
  res$NeedsImprove <- values$QID77_TEXT
  res$FirstName <- values$QID91_TEXT
  res$LastName <- values$QID92_TEXT
  res$Email <- values$QID94_TEXT
  res$PrimaryDepartment <- labels$QID103
  res$StartYear <- as.numeric(labels$`QID100#2_1`) #amazing
  res$StartMonth <- as.numeric(labels$`QID100#1_1`)
  startMonth <- res$StartMonth + (res$StartYear * 12)
  endMonth <- month(Sys.Date()) + (year(Sys.Date()) * 12)
  res$YearInProgram <- ceiling((endMonth - startMonth)/12)
  
  res
}

mapAdvisorQualtricsResults <- function(dat) {
  res <- NULL
  values <- dat$result$values
  labels <- dat$result$labels
  res$CarRA <- c(values$QID41_1,
                 values$QID41_5,
                 values$QID41_27,
                 values$QID41_29,
                 values$QID41_30,
                 values$QID41_31,
                 values$QID41_32,
                 values$QID41_33,
                 values$QID41_34,
                 values$QID41_28,
                 values$QID44_34,
                 values$QID44_35,
                 values$QID44_36,
                 values$QID44_37,
                 values$QID44_38,
                 values$QID44_39,
                 values$QID44_16,
                 values$QID44_28,
                 values$QID44_32,
                 values$QID44_30,
                 values$QID44_33)
  res$PsychRA <- c(values$QID66_2,
                   values$QID66_3,
                   values$QID66_4,
                   values$QID66_6,
                   values$QID66_1,
                   values$QID66_7,
                   values$QID66_8,
                   values$QID66_24,
                   values$QID66_25,
                   values$QID66_26,
                   values$QID67_30,
                   values$QID67_31,
                   values$QID67_24,
                   values$QID67_12,
                   values$QID67_11,
                   values$QID67_13,
                   values$QID67_15,
                   values$QID67_25,
                   values$QID67_26,
                   values$QID67_27)
  res$RelRA <- c(values$QID69_2,
                 values$QID69_3,
                 values$QID69_4,
                 values$QID69_6)
  res$WorkingWell <- values$QID70_TEXT
  res$NeedsImprove <- values$QID71_TEXT
  res$FirstName <- values$QID77_TEXT
  res$LastName <- values$QID87_TEXT
  res$Email <- values$QID83_TEXT
  res$PrimaryDepartment <- labels$QID90
  res$Rank <- labels$QID92
  
  res
}
####################### IMPORT ADVISEE SURVEY #############################

calcPair <- function(advisorData, adviseeData) {
  res <- list()
  
  ####################### CALCULATING YEAR IN PROGRAM #############################
  #change StartedProgram_Year to character
  #data[16] <- sapply(data[16], as.character)
  
  #TODO: figure out program start year (probably just add a survey question)
  #data <- data%>%
  #  mutate(YearInProgram = 
  #           case_when(StartedProgram_Year == 2019 ~ 2,
  #                     StartedProgram_Year == 2018 ~ 3,
  #                     StartedProgram_Year == 2017 ~ 4,)) 
  
  ####################### DESCRIPTIVE STATS - ADVISEE #############################
  # First, we need to create mean scores for each of the constructs

  #Career support
  res$careersupportmeanGS <- mean(adviseeData$CarGS)

  #Psychosocial support
  res$psychsupportmeanGS <- mean(adviseeData$PsychGS)

  #Relationship Quality
  res$relqualmeanGS <- mean(adviseeData$RelGS)
  
  ####################### DESCRIPTIVE STATS - ADVISOR #############################
  #Career support
  res$careersupportmeanRA <- mean(advisorData$CarRA)
  
  #Psychosocial support
  res$psychsupportmeanRA <- mean(advisorData$PsychRA)

  res$relqualmeanRA <- mean(advisorData$RelRA)

  
  ####################### ITEM-BY-ITEM DIFFERENCE SCORES #############################
  #### career support ####
  res$Car_diff <- adviseeData$CarGS - advisorData$CarRA
  
  #### career support absolute value ####
  res$av_car_diff <- abs(res$Car_diff)

  
  #### sum of career support absolute values ####
  res$sum_av_car_diff <- sum(res$av_car_diff)
  #data$sum_av_car_diff <- rowSums(data[,c(168:187)])
  
  #### psych support ####
  res$Psych_diff <- adviseeData$PsychGS - advisorData$PsychRA

  #### psych support absolute value ####
  res$av_psych_diff <- abs(res$Psych_diff)
  
  #### sum of psych support absolute values ####
  res$sum_av_psych_diff <- sum(res$av_psych_diff)
  #data$sum_av_psych_diff <- rowSums(data[,c(209:228)])
  
  #### relationship quality ####
  res$Rel_diff <- adviseeData$RelGS - advisorData$RelRA
  
  #### relationship quality absolute value ####
  res$av_rel_diff <- abs(res$Rel_diff)
  
  res$sum_av_rel_diff <- sum(res$av_rel_diff)
  
  ####################### FLAGGING VALUES #############################
  ##############ITEM-BY-ITEM DIFFERENCE OF -2 OR LOWER ################
  #######Grad student rated advisor lower than advisor rated themself
  #career support
  #car_diff_neg_2 <- data%>% filter_at(vars(148:167), any_vars(. < 2)) 
  #psych support
  #psych_diff_neg_2 <- data%>% filter_at(vars(189:208), any_vars(. < 2))
  #relationship quality 
  #rel_diff_neg_2 <- data%>% filter_at(vars(230:233), any_vars(. < 2))
  
  ##############ITEM-BY-ITEM DIFFERENCE OF 2 OR HIGHER ################
  #######Grad student rated advisor higher than advisor rated themself
  #career support
  #car_diff_pos_2 <- data[rowSums(data[148:167] > 0) > 2,]
  #psych support
  #psych_diff_pos_2 <- data[rowSums(data[189:208] > 2) > 2,]
  #relationship quality 
  #rel_diff_pos_2 <- data[rowSums(data[230:233] > 2) > 2,]
  
  #############RESPONSES FROM GRAD STUDENTS OF 3 OR LOWER###########
  #career support
  #car_diff_neg_3 <- data%>% filter_at(vars(148:167), any_vars(. < 3))
  #psych support
  #psych_diff_neg_3 <- data%>% filter_at(vars(189:208), any_vars(. < 3))
  #relationship quality 
  #rel_diff_neg_3 <- data%>% filter_at(vars(230:233), any_vars(. < 3))
  
  #### Graduate Student Responses Median ####
  #Career Support
  res$car_median_GS <- median(adviseeData$CarGS)

  #Psychosocial Support
  res$psych_median_GS <- median(adviseeData$PsychGS)
  
  #Relationship Quality
  res$rel_median_GS <- median(adviseeData$RelGS)
  
  #### Research Advisor Response Median ####
  #Career Support
  res$car_median_RA <- median(advisorData$CarRA)
  
  #Psychosocial Support
  res$psych_median_RA <- median(advisorData$PsychRA)
  
  #Relationship Quality
  res$rel_median_RA <- median(advisorData$RelRA)

  res$WorkingWellGS <- adviseeData$WorkingWellGS
  res$NeedsImproveGS <- adviseeData$NeedsImproveGS
  
  res$WorkingWellRA <- advisorData$WorkingWellRA
  res$NeedsImproveRA <- advisorData$NeedsImproveRA
  
  res$FirstNameGS <- adviseeData$FirstName
  res$LastNameGS <- adviseeData$LastName
  res$PrimaryDepartmentGS <- adviseeData$PrimaryDepartment
  res$EmailGS <- adviseeData$Email
  res$WorkingWellGS <- adviseeData$WorkingWell
  res$NeedsImproveGS <- adviseeData$NeedsImprove
  res$YearInProgram <- adviseeData$YearInProgram
  
  res$FirstNameRA <- advisorData$FirstName
  res$LastNameRA <- advisorData$LastName
  res$PrimaryDepartmentRA <- advisorData$PrimaryDepartment
  res$EmailRA <- advisorData$Email
  res$WorkingWellRA <- advisorData$WorkingWell
  res$NeedsImproveRA <- advisorData$NeedsImprove
  res$RankRA <- advisorData$Rank
  
  
  res
}
#library("XLConnect")
#write.csv((data), "datafromR.csv")
