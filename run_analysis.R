#!/usr/bin/env Rscript
library(dplyr)
#Set the working directory to the directory this file is in. 
# Pity R doesn't provide a portable or elegant way to do this.


renameVars<- function(variableNames)
{
	 #convert to character vector first
        charVarNames <- as.character(variableNames)
        #First we replace mean() with "mean of ", and std() with "std of "
        temp1 <- gsub("\\(\\)"," of ",charVarNames)
        # Move mean/std to front
        parts <- strsplit(temp1,"-")
        temp2 <- sapply(parts,function(x){last <- if(length(x)==3){x[3]}else{""};paste(x[2],x[1],last,sep="")})
        
        #Replace X,Y,Z with X-axis, etc
        temp3 <- gsub("([XYZ])",", \\1-axis",temp2,fixed=FALSE) 
        
        #Capitalization and improvement
        temp4 <- gsub("(std)","Std.dev",temp3); 
        gsub("(mean)","Mean",temp4); 
	
}





#Read the variables from the features file. 
variableNames <- read.table("UCI HAR Dataset/features.txt")

#Extract the means, i.e. variables which have mean() and standard deviation, i.e variables which have std() in them.
meanVars <- grep(pattern="mean\\(\\)",variableNames[,2])
stdVars <- grep("std\\(\\)",variableNames[,2])


#Combine what we got from the above.
#combinedVars are the column numbers which are either mean or std.dev. Similarly, combinedVarNames are their variable names.  
combinedVars <- c(meanVars,stdVars)
combinedVarNames <- variableNames[combinedVars,2]

renamedVarNames <- renameVars(combinedVarNames)
#We now get meaningful variable names out of them.



#Read and combine the observations.
trainObs <- read.table("UCI HAR Dataset/train/X_train.txt")
testObs <- read.table("UCI HAR Dataset/test/X_test.txt")

#Lets now get only the columns we need, before we merge, so that the final rbind has fewer columns
relevantTrainObs <- trainObs[,combinedVars]
relevantTestObs <- testObs[,combinedVars]

#Merge the observations
combinedObs <- rbind.data.frame(relevantTrainObs,relevantTestObs)

#Next we correct the names of this dataset
names(combinedObs) <- renamedVarNames






#Read the activities	
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

#Doing this to ensure that we create factors correctly even if the order of the activities/labels changes.
numbers <- activities[,1]

#Create an activity factor. 
activityFactor <- activities[,2][numbers] 



#We now read the activities and merge them
trainActivity <- read.table("UCI HAR Dataset/train/y_train.txt")
testActivity <- read.table("UCI HAR Dataset/test/y_test.txt")

#Combine them. Remember that train is first. 
combinedActivity <- rbind.data.frame(trainActivity,testActivity)

#Change activity from number to a descritive activity name. 	
combinedActivity[,1] <- activityFactor[combinedActivity[,1]]

#Get the naming right.
names(combinedActivity) <- c("Activity")
#print(combinedActivity)

# Read the subjects and merge them. 
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
combinedSubjects <-rbind.data.frame(trainSubjects,testSubjects)

#Get the naming right.
names(combinedSubjects) <- c("Subject")


#Now merge all the data sets.
tidyDataSet <- cbind.data.frame(combinedSubjects,combinedActivity,combinedObs)

summarizedTidyDataSet  <- aggregate(select(tidyDataSet,-Subject,-Activity),by=list(tidyDataSet$Subject,tidyDataSet$Activity),FUN=mean)
names(summarizedTidyDataSet) [1:2] <- c("Subject","Activity")
summarizedTidyDataSet  <- arrange(summarizedTidyDataSet,Subject,Activity)

write.table(row.names=FALSE,file="result.txt",summarizedTidyDataSet)

write.table(x=names(summarizedTidyDataSet),"variables.txt",col.names=FALSE)


	
