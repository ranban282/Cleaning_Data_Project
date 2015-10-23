## Cleaining Data - Course Project.
### Find below the steps I took to obtain a tidy data set.
1. Read the variable names from UCI HAR Dataset/features.txt
2. Obtain indices of the variables that contain the string mean() from Step 1
3. Obtain indices of the variables that contain the string std() from Step 1
4. Combine the output of steps 2 and 3
5. Obtain the variable names correponding to the indices obtained in step 4
6. Rename the variable names, to a more human-readable format. This includes
  1. We substitute () with " of ". E.g. tBodyAcc-mean()-Z becomes tBodyAcc-mean of -Z
  2. We move mean and std to the front. Thus "tBodyAcc-mean of -Z" becomes "mean of tBodyAccZ". This works even when  the axis is not present. Eg "BodyAccMag-mean of" will become "mean of BodyAccMag"  
  3. If X,Y or Z are present, replace it with ", X-Axis", etc. Thus, "mean of tBodyAccZ" becomes "mean of tBodyAcc, Z-Axis"
  4.  Capitalize mean to Mean
  5. Change  std to Std.dev
7. Read train observations from UCI HAR Dataset/train/X_train.txt
8. Read test observations from UCI HAR Dataset/test/X_test.txt
9. Extract only the fields we want, i.e. the ones with mean and std in them, using the indices obtained in step 4, from the train observations, obtained in step 7.
10. Repeat step 9, but this time for the test observations obtained in step 8, instead of train obervations in the last step
11. Combine the outputs of step 9 and 10, using rbind.data.frame to have the complete set of observations.
12. Rename the variables of this dataset to the human-readable names we got is step 6.
13. Read the activity labels from UCI HAR Dataset/activity_labels.txt
14. Make a factor out of the activities, ensuring correctness even if the order of activities change, e.g if 4 SITTING appears before 1 WALKING, the factor should still map WALKING to 1 and SITTING to 4. 
15. Read the train activity file UCI HAR Dataset/train/y_train.txt
16. Read the test activity file UCI HAR Dataset/test/y_test.txt
17. Merge the two datasets above using rbind.data.frame
18. Change the result obtained in step 17 from numbers to descriptive activity names, obtained from step 14. 
19. Read the train subject file UCI HAR Dataset/train/subject_train.txt
20. Read the test subject file UCI HAR Dataset/test/subject_test.txt
21. Merge the two datasets above using rbind.data.frame
22. Combine the three data (i.e the ones obtained in steps 12, 18 and 21) sets column-wise, using cbind.data.frame
23. Summarize the data set on Subject and activity.
24. Rename the first two variables to Subject and Activity, respectively, as they have become "un-renamed"
25. Sort by Subject and Activity. We finally have the tidy data set as asked for in the question. You can read the result.txt file using excel/libreoffice calc; when importing, use space as the seperator. 
