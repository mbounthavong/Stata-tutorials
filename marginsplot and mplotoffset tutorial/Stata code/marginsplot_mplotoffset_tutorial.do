********************************************************************************
** Title: 			Stata - marginsplot & mplotoffset commands for plotting average marginal effects
** Programmer: 		Mark Bounthavong
** Date:			30 January 2025
** Updated:			NA
** Updated: 		NA
********************************************************************************

// LOAD DATA
clear all
import delimited "https://raw.githubusercontent.com/mbounthavong/Stata-tutorials/refs/heads/main/Data/meps22.csv"

// DESCRIBE DATA
describe

// VISUALIZE VARIABLES
tab race, m 
tab povcat, m 

// NEW RACE VARIABLE
codebook race, tab(1000) /* Provides the full label in a tabulate format */

gen race1 = .
	replace race1 = 0 if race == "1 WHITE - NO OTHER RACE REPORTED"
	replace race1 = 1 if race == "2 BLACK - NO OTHER RACE REPORTED"
	replace race1 = 2 if race == "3 AMER INDIAN/ALASKA NATIVE - NO OTHER RACE"
	replace race1 = 3 if race == "4 ASIAN/NATV HAWAIIAN/PACFC ISL-NO OTH"
	replace race1 = 4 if race == "6 MULTIPLE RACES REPORTED"

label define race_lbl 0 "White" 1 "Black" 2 "AI/AN" 3 "Asian" 4 "Mulitple"
label values race1 race_lbl
tab race1, m 

// NEW POVERTY VARIABLE
codebook povcat, tab(1000)  /* Provides the full label in a tabulate format */

gen poverty = .
	replace poverty = 0 if povcat == "1 POOR/NEGATIVE"
	replace poverty = 1 if povcat == "2 NEAR POOR"
	replace poverty = 2 if povcat == "3 LOW INCOME"
	replace poverty = 3 if povcat == "4 MIDDLE INCOME"
	replace poverty = 4 if povcat == "5 HIGH INCOME"
	
label define poverty_lbl 0 "Poor" 1 "Near Poor" 2 "Low-income" 3 "Middle-income" 4 "High-income"
label values poverty poverty_lbl
tab poverty, m 


// REGRESSION MODEL
glm totexp c.age i.poverty c.age#i.poverty i.race1, family("Gaussian") link("identity") vce(robust)


// MARGINS - AME
margins, dydx(poverty) at(age = (25 35 45 55 65))

marginsplot

margins r.poverty, at(age = (25 35 45 55 65))

marginsplot, by(age)

marginsplot

// ADD OFFSET
mplotoffset, offset(1.5)

mplotoffset, offset(1.5) ///
			 plotopts(msymbol(square) msize(large) mcol("navy") dcol("none")) ///
			 ciopts(lcol("navy")) ///
			 recast(dot) ///
			 yline(0, lcol("cranberry")) ///
			 xtitle("Age (Years)") ///
			 xlab( , nogrid) ///
			 ytitle("Avg Difference in Total Healthcare Expenditures ($)") ylab(, nogrid) ///
			 title("")		

mplotoffset, offset(1.5) ///
			 plot1opts(msymbol(square) msize(large) mcol("navy") dcol("none")) ///
			 plot2opts(msymbol(square) msize(large) mcol("green") dcol("none")) ///
			 plot3opts(msymbol(square) msize(large) mcol("cranberry") dcol("none")) ///
			 plot4opts(msymbol(square) msize(large) mcol("orange") dcol("none")) ///
			 ci1opts(lcol("navy")) ///
			 ci2opts(lcol("green")) ///
			 ci3opts(lcol("cranberry")) ///
			 ci4opts(lcol("orange")) ///
			 recast(dot) ///
			 yline(0, lcol("cranberry")) ///
			 xtitle("Age (Years)") xlab(, nogrid) ///
			 ytitle("Avg Difference in Total Healthcare Expenditures ($)") ylab(, nogrid) ///
			 title("") ///
			 legend(order(1 "Near Poor v. Poor" 2 "Low-income v. Poor" 3 "Middle-income v. Poor" 4 "High-income v. Poor"))
			 
mplotoffset, offset(1.5) ///
			 plot1opts(msymbol(square) msize(large) mcol("navy") dcol("none")) ///
			 plot2opts(msymbol(square) msize(large) mcol("green") dcol("none")) ///
			 plot3opts(msymbol(square) msize(large) mcol("cranberry") dcol("none")) ///
			 plot4opts(msymbol(square) msize(large) mcol("orange") dcol("none")) ///
			 ci1opts(lcol("navy")) ///
			 ci2opts(lcol("green")) ///
			 ci3opts(lcol("cranberry")) ///
			 ci4opts(lcol("orange")) ///
			 recast(dot) ///
			 yline(0, lcol("cranberry")) ///
			 xtitle("Age (Years)") xlab(, nogrid) ///
			 ytitle("Avg Difference in Total Healthcare Expenditures ($)") ylab(, nogrid) ///
			 title("") ///
			 legend(order(5 "Near Poor v. Poor" 6 "Low-income v. Poor" 7 "Middle-income v. Poor" 8 "High-income v. Poor"))
			 
	 
		