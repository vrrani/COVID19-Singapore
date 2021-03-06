###############################################
requiredPackages = c('ggplot2','scales', 'gridExtra')
package.check <- lapply(
  requiredPackages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)
###############################################

setwd("~/COVID19-Singapore-master/Data") # Setting Working Directory
COVID <- read.csv('SortedRecoveryData.csv', sep=",", header = TRUE, fileEncoding="UTF-8-BOM")     

pdf("~/COVID19-Singapore-master/Loess-Curve.pdf", width = 10, height  = 6)
   
# Loess Smoothing
p <- qplot(data=COVID,x=as.Date(COVID_Confirm_Date),y=DaysInHospital, label = PatientID, geom=("point"), hjust=0, vjust=0)+ 
     geom_text(check_overlap = TRUE, size = 3, hjust = 0, nudge_x = 0.05)+ 
     scale_x_date(breaks = as.Date(COVID$COVID_Confirm_Date), labels = date_format("%m/%d")) + 
     theme(axis.text.x = element_text(angle = 90)) +
     geom_vline(xintercept=c(as.numeric(as.Date("2020-01-23")),as.numeric(as.Date("2020-02-03")), as.numeric(as.Date("2020-03-16"))),linetype=5, size =1, colour="red") +
     xlab("Case-wise Date of +ve Confirmation") +
          ylab("#Days from +ve-Confirmation to Clinical Recovery") +
          #ggtitle ("Clinical Recovery") +     
          theme_bw() +      
          theme(axis.text.x = element_text(face="bold", color="black", size=8, angle = 90),
                axis.text.y = element_text(face="bold", color="black", size=8),
                axis.title=element_text(size=12,face="bold")
               ) 
               
print(p) 
p + stat_smooth(color = "#FC4E07", fill = "#FC4E07", method = "loess")
p + stat_smooth(aes(outfit=fit<<-..y..), color = "#FC4E07", fill = "#FC4E07", method = "loess")

dev.off()
rm(list=ls())
###############################################