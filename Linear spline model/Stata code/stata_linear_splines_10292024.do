********************************************************************************
** TITLE: 		Linear spline (piecewise) models in Stata
** PROGRAMMER: 	Mark Bounthavong
** DATE: 		28 October 2024
** UPDATED:		29 October 2024
** UPDATED BY: 	Mark Bounthavong
********************************************************************************

/***************************************************
Notes (28 October 2024):
- Generate dataset for linear splines tutorial.
- Upload to GitHub
- GitHub repository:
- https://github.com/mbounthavong/Stata-tutorials

Notes (29 October 2024):
- Estimate level change using dummy variables

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

// GENERATE DUMMY VARIABLES
gen int1 = 0
	replace int1 = 1 if time >= 3

gen int2 = 0
	replace int2 = 1 if time >= 7
	
/********************************************************************
- We will generate 5 models
-- Model 1 - Linear splines with dummy
-- Model 2 - Linear splines with missing data & with dummy

Dummy variables are generated to estimat the "level" change at the knots
********************************************************************/

**************************************************************
// MODEL 1 - LINEAR SPLINES
**************************************************************
// MKSPLINE SETUP
mkspline knot1 3 knot2 7 knot3 = time
			
// MKSPLINE MODEL - LINEAR REGRESSION MODEL
xtset subjectid time

xtreg score knot1 knot2 knot3 int1 int2, re vce(cluster subjectid)
predict linear1 /* Generate the predicted scores */

// DIFFERENCE IN SLOPE BETWEEN time < 3 and time >= 3
lincom knot2 - knot1

// DIFFERENCE IN SLOPE BETWEEN time < 7 and time >= 7 
lincom knot3 - knot2

// MARGINS TO ESTIMATE CHANGES AT THE LEVELS
showcoding time knot1 knot2 knot3 int1 int2

margins, at(knot1 = 0 knot2 = 0 knot3 = 0 int1 = 0 int2 = 0) ///
		 at(knot1 = 3 knot2 = 0 knot3 = 0 int1 = 0 int2 = 0) ///
		 at(knot1 = 3 knot2 = 0 knot3 = 0 int1 = 1 int2 = 0) ///
		 at(knot1 = 7 knot2 = 4 knot3 = 0 int1 = 1 int2 = 0) ///
		 at(knot1 = 7 knot2 = 4 knot3 = 0 int1 = 1 int2 = 1) ///
		 at(knot1 = 12 knot2 = 9 knot3 = 5 int1 = 1 int2 = 1)

		 
sort time
graph twoway (scatter avg_score time) ///
			 (lfit linear1 time if shocks == 0, col("navy") range(1 3)) ///
			 (lfit linear1 time if shocks == 1, col("purple") range(3 7)) ///
			 (lfit linear1 time if shocks == 2, col("brown") range(7 12) ///
			  graphregion(color(white)) ///
			  ylab(, nogrid labsize(small)) ///
			  ytitle("Average score per student") ///
			  xtitle("Time (Quarters)") ///
			  xline(3 7, lpattern(dash) lcol("cranberry")) ///
			  xlab(1 3 7 12) ///
			  xscale(range(1 12) noextend) ///
			  legend(off))			  

	
	
**************************************************************	
// MODEL 2 - MISSING DATA ISSUE
**************************************************************
// SELECT DIRECTORY / LOAD DATA FROM GITHUB
clear all
import delimited "https://raw.githubusercontent.com/mbounthavong/Stata-tutorials/refs/heads/main/Data/linear_spline.csv"

// CREATE MISSING DATA
replace score = . if grade == 1 & time == 3 

// GENERATE AVERAGE SCORE
egen avg_score = mean(score), by(time)

// GENERATE DUMMY VARIABLES
gen int1 = 0
	replace int1 = 1 if time >= 3

gen int2 = 0
	replace int2 = 1 if time >= 7
	
// MKSPLINE SETUP
mkspline knot1 3 knot2 7 knot3 = time
			
// MKSPLINE MODEL - LINEAR REGRESSION MODEL
xtset subjectid time

xtreg score knot1 knot2 knot3 int1 int2, re vce(cluster subjectid)
predict linear2 /* Generate the predicted scores */


// MARGINS TO ESTIMATE CHANGES AT THE LEVELS
showcoding time knot1 knot2 knot3 int1 int2

margins, at(knot1 = 0 knot2 = 0 knot3 = 0 int1 = 0 int2 = 0) ///
		 at(knot1 = 3 knot2 = 0 knot3 = 0 int1 = 0 int2 = 0) ///
		 at(knot1 = 3 knot2 = 0 knot3 = 0 int1 = 1 int2 = 0) ///
		 at(knot1 = 7 knot2 = 4 knot3 = 0 int1 = 1 int2 = 0) ///
		 at(knot1 = 7 knot2 = 4 knot3 = 0 int1 = 1 int2 = 1) ///
		 at(knot1 = 12 knot2 = 9 knot3 = 5 int1 = 1 int2 = 1)

// PLOT
sort time
graph twoway (scatter avg_score time) ///
			 (lfit linear2 time if shocks == 0, col("navy") range(1 3)) ///
			 (lfit linear2 time if shocks == 1, col("purple") range(3 7)) ///
			 (lfit linear2 time if shocks == 2, col("brown") range(7 12) ///
			  graphregion(color(white)) ///
			  ylab(, nogrid labsize(small)) ///
			  ytitle("Average score per student") ///
			  xtitle("Time (Quarters)") ///
			  xline(3 7, lpattern(dash) lcol("cranberry")) ///
			  xlab(1 3 7 12) ///
			  xscale(range(1 12) noextend) ///
			  legend(off))
			  
			  
			  
			  
			  
			  
			  
			  