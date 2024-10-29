********************************************************************************
** TITLE: 		Linear splines in Stata
** PROGRAMMER: 	Mark Bounthavong
** DATE: 		28 October 2024
** UPDATED:		NA
** UPDATED BY: 	NA
********************************************************************************

/***************************************************
Notes (28 October 2024):
- Generate dataset for linear splines tutorial.
- Upload to GitHub
- GitHub repository:
- https://github.com/mbounthavong/Stata-tutorials

***************************************************/

// SELECT DIRECTORY / LOAD DATA FROM GITHUB
clear all
import delimited "https://raw.githubusercontent.com/mbounthavong/Stata-tutorials/refs/heads/main/Data/linear_spline.csv"

// DESCRIBE DATA
describe


// VISUALIZE PATTERNS
egen avg_score = mean(score), by(time)

sort time
graph twoway (scatter avg_score time, msize(large) col("navy"))



// MKSPLINE SETUP
mkspline time1 3 time2 7 time3 = time 
			 
// MKSPLINE MODEL - LINEAR REGRESSION MODEL
xtset subjectid time

xtreg score time1-time3, re vce(cluster subjectid)
predict linear1 /* Generate the predicted scores */

sort time
graph twoway (scatter avg_score time) ///
			 (lfit linear1 time if shocks == 0, col("navy")) ///
			 (lfit linear1 time if shocks == 1, col("purple")) ///
			 (lfit linear1 time if shocks == 2, col("brown") ///
			  graphregion(color(white)) ///
			  ylab(, nogrid labsize(small)) ///
			  ytitle("Average score per student") ///
			  xtitle("Time (Quarters)") ///
			  xline(3 7, lpattern(dash) lcol("cranberry")) ///
			  legend(off))			  
			  
			  
			  
// MKSPLINE SETUP - MARGINAL DIFFERENCES IN SLOPES
mkspline marginal1 3 marginal2 7 marginal3 = time, marginal 
/* the marginal options gives us the relative change to the previous period */
			 
// MKSPLINE MODEL - LINEAR REGRESSION MODEL
xtset subjectid time

xtreg score marginal1-marginal3, re vce(cluster subjectid)
predict linear2 /* Generate the predicted scores */

sort time
graph twoway (scatter avg_score time) ///
			 (lfit linear2 time if shocks == 0, col("navy")) ///
			 (lfit linear2 time if shocks == 1, col("purple")) ///
			 (lfit linear2 time if shocks == 2, col("brown") ///
			  graphregion(color(white)) ///
			  ylab(, nogrid labsize(small)) ///
			  ytitle("Average score per student") ///
			  xtitle("Time (Quarters)") ///
			  xline(3 7, lpattern(dash) lcol("cranberry")) ///
			  legend(off))
			  
			  
			  
// MISSING DATA ISSUE
/* Let's assume we have missing data at the FALL of GRADE 1 */

// SELECT DIRECTORY / LOAD DATA FROM GITHUB
clear all
import delimited "https://raw.githubusercontent.com/mbounthavong/Stata-tutorials/refs/heads/main/Data/linear_spline.csv"

// INPUT MISSING DATA
replace score = . if grade == 1 & time == 3


// VISUALIZE PATTERNS
egen avg_score = mean(score), by(time)

sort time
graph twoway (scatter avg_score time, col("navy"))



// MKSPLINE SETUP
mkspline mtime1 3 mtime2 7 mtime3 = time 

	 
// MKSPLINE MODEL - LINEAR MIXED EFFECTS MODEL
xtset subjectid time

xtreg score mtime1-mtime3, re vce(cluster subjectid)
predict linear3 /* Generate the predicted scores */

sort time
graph twoway (scatter avg_score time) ///
			 (lfit linear3 time if shocks == 0, col("navy")) ///
			 (lfit linear3 time if shocks == 1, col("purple")) ///
			 (lfit linear3 time if shocks == 2, col("brown") ///
			  graphregion(color(white)) ///
			  ylab(, nogrid labsize(small)) ///
			  ytitle("Average score per student") ///
			  xtitle("Time (Quarters)") ///
			  xline(3 7, lpattern(dash) lcol("cranberry")) ///
			  legend(off))			  
			  
			  
			  
			  
// MKSPLINE SETUP - MARGINAL OPTION
mkspline mmarginal1 3 mmarginal2 7 mmarginal3 = time, marginal

// MKSPLINE MODEL - LINEAR MIXED EFFECTS MODEL
xtset subjectid time

xtreg score mmarginal1-mmarginal3, re vce(cluster subjectid)
predict linear4 /* Generate the predicted scores */

sort time
graph twoway (scatter avg_score time) ///
			 (lfit linear4 time if shocks == 0, col("navy")) ///
			 (lfit linear4 time if shocks == 1, col("purple")) ///
			 (lfit linear4 time if shocks == 2, col("brown") ///
			  graphregion(color(white)) ///
			  ylab(, nogrid labsize(small)) ///
			  ytitle("Average score per student") ///
			  xtitle("Time (Quarters)") ///
			  xline(3 7, lpattern(dash) lcol("cranberry")) ///
			  legend(off))		
			  
			  
			  