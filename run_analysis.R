###############################################################

# Read Data

###############################################################
#setwd("D:/GettingAndCleaningData/Assignment/UCI HAR Dataset")

features<-read.table("features.txt")["V2"]
activity_labels<-read.table("activity_labels.txt")["V2"]

# find indexes of columns corresponding to mean/std data 
index_of_means_and_stds<-grep("mean|std",features$V2) 

setwd("train")
X_train<-read.table("X_train.txt")
names(X_train)<-features$V2

y_train<-read.table("y_train.txt")
names(y_train)<-names(y_train)<-"labels"

subject_train<-read.table("subject_train.txt")
names(subject_train)<-"subjects"

setwd("../test/")
X_test<-read.table("X_test.txt")
names(X_test)<-features$V2

y_test<-read.table("y_test.txt")
names(y_test)<-"labels"

subject_test<-read.table("subject_test.txt")
names(subject_test)<-"subjects"

setwd("../../")



############################################################################################
# Extracts only the measurements on the mean and standard deviation for each measurement.
############################################################################################

means_and_std_colnames<-colnames(X_test)[index_of_means_and_stds]
X_test_subset<-cbind(subject_test,y_test,subset(X_test,select=means_and_std_colnames))
X_train_subset<-cbind(subject_train,y_train,subset(X_train,select=means_and_std_colnames))


##################################################################
# Merges the training and the test sets to create one data set.
##################################################################

Xy<-rbind(X_test_subset, X_train_subset)


# Remove parentheses
names(Xy) <- gsub('\\(|\\)',"",names(Xy), perl = TRUE)
# Make syntactically valid names
names(Xy) <- make.names(names(Xy))
# Make clearer names
names(Xy) <- gsub('Acc',"Acceleration",names(Xy))
names(Xy) <- gsub('GyroJerk',"AngularAcceleration",names(Xy))
names(Xy) <- gsub('Gyro',"AngularSpeed",names(Xy))
names(Xy) <- gsub('Mag',"Magnitude",names(Xy))
names(Xy) <- gsub('^t',"TimeDomain.",names(Xy))
names(Xy) <- gsub('^f',"FrequencyDomain.",names(Xy))
names(Xy) <- gsub('\\.mean',".Mean",names(Xy))
names(Xy) <- gsub('\\.std',".StandardDeviation",names(Xy))
names(Xy) <- gsub('Freq\\.',"Frequency.",names(Xy))
names(Xy) <- gsub('Freq$',"Frequency",names(Xy))


######################################################################################################################
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
######################################################################################################################
tidy<-aggregate(Xy[,3:ncol(Xy)],list(Subject=Xy$subjects, Activity=Xy$labels), mean)
tidy<-tidy[order(tidy$Subject),]

###########################################################################
# Uses descriptive activity names to name the activities in the data set
###########################################################################

tidy$Activity<-activity_labels[tidy$Activity,]

write.table(tidy, file="./tidydata.txt", sep="\t", row.names=FALSE)
