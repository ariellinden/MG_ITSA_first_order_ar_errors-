***********************************************************************
****                     trend                                    *****
***********************************************************************

********************************
***** OLS with NW std errs ****
*******************************

set scheme stmono2
* pre-to-post trend change (25% 50% 100% increase); 10-50 time periods; 4-20 controls; 1 sd for white noise 
power multi_itsa, n(10(5)50) contcnt(4(4)20) tint(10) cint(10) tpre(1) cpre(1) tstep(0) cstep(0) tsd(1) csd(1) cpost(1) tpost(1.25 1.50 2) tacorr(.20) cacorr(.20) reps(2000) ///
	noi table perf	
	
	mat effect = r(pss_table)
	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_nw.dta", replace

***** produce graphs *****
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_nw.dta", replace

***** produce graphs *****

**** repeat this for each post-trend (25%, 50%, 100%) 

local tpost = 1.25
local title (A)


set scheme stmono2
levelsof controls, local(levels)

* detect var type
local vartype : type controls

local plots ""
local legendopts "title(Controls, size(medium))"
local i = 1
local m "O diamond S T X"   // marker symbols to cycle through

foreach l of local levels {
    local msym : word `i' of `m'
    if strpos("`vartype'","str") {
        * controls is string -> use quotes
        local plots `plots' (connected power period if controls=="`l'" & tpost==`tpost', sort msymbol(`msym') title("`title'"))
    }
    else {
        * controls is numeric -> no quotes
        local plots `plots' (connected power period if controls==`l' & tpost==`tpost', sort msymbol(`msym') title("`title'"))
    }

    local legendopts `legendopts' label(`i' "`l'")
    local ++i
}

twoway `plots', ///
    ytitle("Power (1-{&beta})") ylabel(.2(.2)1) ///
    xtitle("Periods") ///
    legend(`legendopts' size(medium))

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_nw_.25_graph.gph"	

*************************
*** autocorrelation *****
*************************
set scheme stmono2

forvalues ac = -0.9(0.3)0.9 {
	power multi_itsa, n(10(5)50) contcnt(12) ///
            tint(10) cint(10) tpre(1) cpre(1) ///
            tstep(0) cstep(0) tsd(1) csd(1) ///
            cpost(1) tpost(1.25 1.50 2) ///
            tacorr(`ac') cacorr(`ac') alpha(0.05) reps(2000) ///
			noi table perf
			
			mat effect = nullmat(effect) \ r(pss_table)
			
}		

	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_nw_ac.dta"


*** graph it ***

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_nw_ac.dta", replace

tempvar test
gen str4 `test' = string(tcorr, "%4.1f")

local tpost 2
local title (C)

set scheme stmono2

twoway ///
    (connected power period if `test' == "-0.9" & tpost == `tpost', sort) ///
    (connected power period if `test' == "-0.6" & tpost == `tpost', sort) ///
    (connected power period if `test' == "-0.3" & tpost == `tpost', sort) ///
    (connected power period if `test' ==  "0.0" & tpost == `tpost', sort) ///
    (connected power period if `test' ==  "0.3" & tpost == `tpost', sort) ///
    (connected power period if `test' ==  "0.6" & tpost == `tpost', sort) ///
    (connected power period if `test' ==  "0.9" & tpost == `tpost', sort), ///
    legend(order(1 "-0.9" 2 "-0.6" 3 "-0.3" 4 "0" 5 "0.3" 6 "0.6" 7 "0.9") ///
           title("Autocorr", size(medium))) ///
    xtitle("Period") ///
    ytitle("Power(1-{&beta})") ///
	ylabel(.2(.2)1) ///
	title("`title'")

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_ac_nw_.25_graph.gph"

********************
*** graph bias *****
********************

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_nw.dta", clear

local tpost 1.25
local title (A)

set scheme stmono2

twoway ///
    (connected bias period if controls == 4 & tpost == `tpost', sort) ///
    (connected bias period if controls == 8 & tpost == `tpost', sort) ///
    (connected bias period if controls == 12 & tpost == `tpost', sort) ///	
    (connected bias period if controls == 16 & tpost == `tpost', sort) ///
    (connected bias period if controls == 20 & tpost == `tpost', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("% Bias") ///
	ylabel(-10(2)10) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_bias_nw_.25_graph.gph"

************************
*** graph std errs *****
************************
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_nw.dta", clear

local tpost 1.25
local title (A)

set scheme stmono2

twoway ///
    (connected se period if controls == 4 & tpost == `tpost', sort) ///
    (connected se period if controls == 8 & tpost == `tpost', sort) ///
    (connected se period if controls == 12 & tpost == `tpost', sort) ///	
    (connected se period if controls == 16 & tpost == `tpost', sort) ///
    (connected se period if controls == 20 & tpost == `tpost', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("Empirical Std Err.") ///
	ylabel(0(.1).5) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_se_nw_.25_graph.gph"

************************
*** graph RMSE *****
************************
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_nw.dta", clear

local tpost 1.25
local title (A)

set scheme stmono2

twoway ///
    (connected rmse period if controls == 4 & tpost == `tpost', sort) ///
    (connected rmse period if controls == 8 & tpost == `tpost', sort) ///
    (connected rmse period if controls == 12 & tpost == `tpost', sort) ///	
    (connected rmse period if controls == 16 & tpost == `tpost', sort) ///
    (connected rmse period if controls == 20 & tpost == `tpost', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("RMSE") ///
	ylabel(0.90(.05)1.1) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_rmse_nw_.25_graph.gph"


****************************
*** graph 95% coverage *****
****************************
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_nw.dta", clear
local tpost 1.25
local title (A)

set scheme stmono2

twoway ///
    (connected coverage period if controls == 4 & tpost == `tpost', sort) ///
    (connected coverage period if controls == 8 & tpost == `tpost', sort) ///
    (connected coverage period if controls == 12 & tpost == `tpost', sort) ///	
    (connected coverage period if controls == 16 & tpost == `tpost', sort) ///
    (connected coverage period if controls == 20 & tpost == `tpost', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("95% Coverage") ///
	ylabel(0.60(.10)1) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_cover_nw_.25_graph.gph"


**************************
***** Prais-Winsten  *****
**************************
*****************
**** trend *****
****************
set scheme stmono2
* pre-to-post trend change (25% 50% 100% increase); 10-50 time periods; 4-20 controls; 1 sd for white noise 
power multi_itsa, n(10(5)50) contcnt(4(4)20) tint(10) cint(10) tpre(1) cpre(1) tstep(0) cstep(0) tsd(1) csd(1) cpost(1) tpost(1.25 1.50 2) tacorr(.20) cacorr(.20) reps(2000) ///
	noi table prais perf
	
	mat effect = r(pss_table)
	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_prais.dta", replace	


***** produce graphs *****

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_prais.dta", replace

local tpost = 1.25
local title (D)


set scheme stmono2
levelsof controls, local(levels)

* detect var type
local vartype : type controls

local plots ""
local legendopts "title(Controls, size(medium))"
local i = 1
local m "O diamond S T X"   // marker symbols to cycle through

foreach l of local levels {
    local msym : word `i' of `m'
    if strpos("`vartype'","str") {
        * controls is string -> use quotes
        local plots `plots' (connected power period if controls=="`l'" & tpost==`tpost', sort msymbol(`msym') title("`title'"))
    }
    else {
        * controls is numeric -> no quotes
        local plots `plots' (connected power period if controls==`l' & tpost==`tpost', sort msymbol(`msym') title("`title'"))
    }

    local legendopts `legendopts' label(`i' "`l'")
    local ++i
}

twoway `plots', ///
    ytitle("Power (1-{&beta})") ylabel(.2(.2)1) ///
    xtitle("Number of periods") ///
    legend(`legendopts' size(medium))

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_prais_.25_graph.gph"


*************************
*** autocorrelation *****
*************************
set scheme stmono2

forvalues ac = -0.9(0.3)0.9 {
	power multi_itsa, n(10(5)50) contcnt(12) ///
            tint(10) cint(10) tpre(1) cpre(1) ///
            tstep(0) cstep(0) tsd(1) csd(1) ///
            cpost(1) tpost(1.25 1.50 2) ///
            tacorr(`ac') cacorr(`ac') alpha(0.05) reps(2000) ///
			noi table prais perf
			
			mat effect = nullmat(effect) \ r(pss_table)
			
}		

	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_prais_ac.dta", replace


***********************
* graph autocorrelation 
***********************
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_prais_ac.dta", replace


tempvar test
gen str4 `test' = string(tcorr, "%4.1f")

local tpost 2
local title (F)
set scheme stmono2

twoway ///
    (connected power period if `test' == "-0.9" & tpost == `tpost', sort) ///
    (connected power period if `test' == "-0.6" & tpost == `tpost', sort) ///
    (connected power period if `test' == "-0.3" & tpost == `tpost', sort) ///
    (connected power period if `test' ==  "0.0" & tpost == `tpost', sort) ///
    (connected power period if `test' ==  "0.3" & tpost == `tpost', sort) ///
    (connected power period if `test' ==  "0.6" & tpost == `tpost', sort) ///
    (connected power period if `test' ==  "0.9" & tpost == `tpost', sort), ///
    legend(order(1 "-0.9" 2 "-0.6" 3 "-0.3" 4 "0" 5 "0.3" 6 "0.6" 7 "0.9") ///
           title("Autocorr", size(medium))) ///
    xtitle("Period") ///
    ytitle("Power(1-{&beta})") ///
	ylabel(.2(.2)1) ///
	title("`title'")

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_ac_prais_.25_graph.gph", replace

********************
*** graph bias *****
********************

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_prais.dta", clear

local tpost 1.25
local title (A)

set scheme stmono2

twoway ///
    (connected bias period if controls == 4 & tpost == `tpost', sort) ///
    (connected bias period if controls == 8 & tpost == `tpost', sort) ///
    (connected bias period if controls == 12 & tpost == `tpost', sort) ///	
    (connected bias period if controls == 16 & tpost == `tpost', sort) ///
    (connected bias period if controls == 20 & tpost == `tpost', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("% Bias") ///
	ylabel(-10(2)10) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_bias_prais_.25_graph.gph"


************************
*** graph std errs *****
************************
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_prais.dta", clear

local tpost 1.25
local title (A)

set scheme stmono2

twoway ///
    (connected se period if controls == 4 & tpost == `tpost', sort) ///
    (connected se period if controls == 8 & tpost == `tpost', sort) ///
    (connected se period if controls == 12 & tpost == `tpost', sort) ///	
    (connected se period if controls == 16 & tpost == `tpost', sort) ///
    (connected se period if controls == 20 & tpost == `tpost', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("Empirical Std Err.") ///
	ylabel(0(.1).5) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_se_prais_.25_graph.gph"

************************
*** graph RMSE *****
************************
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_prais.dta", clear

local tpost 1.25
local title (D)

set scheme stmono2

twoway ///
    (connected rmse period if controls == 4 & tpost == `tpost', sort) ///
    (connected rmse period if controls == 8 & tpost == `tpost', sort) ///
    (connected rmse period if controls == 12 & tpost == `tpost', sort) ///	
    (connected rmse period if controls == 16 & tpost == `tpost', sort) ///
    (connected rmse period if controls == 20 & tpost == `tpost', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("RMSE") ///
	ylabel(0.90(.05)1.1) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_rmse_prais_.25_graph.gph"


****************************
*** graph 95% coverage *****
****************************
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_prais.dta", clear
local tpost 1.25
local title (A)

set scheme stmono2

twoway ///
    (connected coverage period if controls == 4 & tpost == `tpost', sort) ///
    (connected coverage period if controls == 8 & tpost == `tpost', sort) ///
    (connected coverage period if controls == 12 & tpost == `tpost', sort) ///	
    (connected coverage period if controls == 16 & tpost == `tpost', sort) ///
    (connected coverage period if controls == 20 & tpost == `tpost', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("95% Coverage") ///
	ylabel(0.60(.10)1) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_cover_prais_.25_graph.gph"


*****************************
* combine NW and PRAIS graphs
*****************************
*********
* trend *
*********
* order these by tpost value
gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_nw_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_prais_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_nw_.50_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_prais_.50_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_nw_1.0_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_prais_1.0_graph.gph" ///	
	, col(2) altshrink 

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_ac_prais_.25_graph.gph", replace	
	

*****************
* autocorrelation
*****************

gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_ac_nw_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_ac_prais_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_ac_nw_.50_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_ac_prais_.50_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_ac_nw_1.0_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_ac_prais_1.0_graph.gph" ///	
	, col(2) altshrink 

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\combined_trend_ac_graph.gph", replace


*********
* bias *
*********
* order these by tpost value
gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_bias_nw_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_bias_prais_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_bias_nw_.50_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_bias_prais_.50_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_bias_nw_1.0_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_bias_prais_1.0_graph.gph" ///	
	, col(2) altshrink 

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\combined_trend_bias_graph.gph", replace

*********
* SE *
*********

gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_se_nw_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_se_prais_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_se_nw_.50_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_se_prais_.50_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_se_nw_1.0_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_se_prais_1.0_graph.gph" ///	
	, col(2) altshrink 

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\combined_trend_se_graph.gph", replace


*********
* RMSE *
*********

gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_rmse_nw_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_rmse_prais_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_rmse_nw_.50_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_rmse_prais_.50_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_rmse_nw_1.0_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_rmse_prais_1.0_graph.gph" ///	
	, col(2) altshrink 

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\combined_trend_rmse_graph.gph", replace


************
* Coverage *
************
gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_cover_nw_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_cover_prais_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_cover_nw_.50_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_cover_prais_.50_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_cover_nw_1.0_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\trend_cover_prais_1.0_graph.gph" ///	
	, col(2) altshrink 

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\combined_trend_cover_graph.gph", replace


***********************************************************************
*********                     level                               *****
***********************************************************************

********************************
***** OLS with NW std errs ****
*******************************

set scheme stmono2
* level change (20% 25% 30% increase); 10-50 time periods; 4-20 controls; 1 sd for white noise 
power multi_itsa, n(10(5)50) contcnt(4(4)20) tint(10) cint(10) tpre(0) cpre(0) tstep(2 2.5 3) cstep(0) tsd(1) csd(1) cpost(0) tpost(0) tacorr(.20) cacorr(.20) reps(2000) ///
	noi table level perf	
	
	mat effect = r(pss_table)
	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_nw.dta", replace


*** graph it ***
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_nw.dta", clear

local tstep 3
local title (C)

set scheme stmono2

twoway ///
    (connected power period if controls == 4 & tstep == `tstep', sort) ///
    (connected power period if controls == 8 & tstep == `tstep', sort) ///
    (connected power period if controls == 12 & tstep == `tstep', sort) ///	
    (connected power period if controls == 16 & tstep == `tstep', sort) ///
    (connected power period if controls == 20 & tstep == `tstep', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("Power (1-{&beta})") ///
	ylabel(0.2(.2)1) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_nw_.30_graph.gph"


*****************************
*** autocorrelation NW *****
*****************************
set scheme stmono2

forvalues ac = -0.9(0.3)0.9 {
	power multi_itsa, n(10(5)50) contcnt(12) ///
            tint(10) cint(10) tpre(1) cpre(1) ///
            tstep(2 2.5 3) cstep(0) tsd(1) csd(1) ///
            cpost(1) tpost(1) ///
            tacorr(`ac') cacorr(`ac') alpha(0.05) reps(2000) ///
			noi table level perf
			
			mat effect = nullmat(effect) \ r(pss_table)
			
}		

	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_nw_ac.dta", replace


* graph it

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_nw_ac.dta", replace

tempvar test
gen str4 `test' = string(tcorr, "%4.1f")

local tstep 3
local title (C)

set scheme stmono2

twoway ///
    (connected power period if `test' == "-0.9" & tstep == `tstep', sort) ///
    (connected power period if `test' == "-0.6" & tstep == `tstep', sort) ///
    (connected power period if `test' == "-0.3" & tstep == `tstep', sort) ///
    (connected power period if `test' ==  "0.0" & tstep == `tstep', sort) ///
    (connected power period if `test' ==  "0.3" & tstep == `tstep', sort) ///
    (connected power period if `test' ==  "0.6" & tstep == `tstep', sort) ///
    (connected power period if `test' ==  "0.9" & tstep == `tstep', sort), ///
    legend(order(1 "-0.9" 2 "-0.6" 3 "-0.3" 4 "0" 5 "0.3" 6 "0.6" 7 "0.9") ///
           title("Autocorr", size(medium))) ///
    xtitle("Period") ///
    ytitle("Power(1-{&beta})") ///
	ylabel(.2(.2)1) ///
	title("`title'")

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_ac_nw_.20_graph.gph"


********************
*** graph bias *****
********************

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_nw.dta", clear

local tstep 3
local title (C)

set scheme stmono2

twoway ///
    (connected bias period if controls == 4 & tstep == `tstep', sort) ///
    (connected bias period if controls == 8 & tstep == `tstep', sort) ///
    (connected bias period if controls == 12 & tstep == `tstep', sort) ///	
    (connected bias period if controls == 16 & tstep == `tstep', sort) ///
    (connected bias period if controls == 20 & tstep == `tstep', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("% Bias") ///
	ylabel(-10(2)10) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_bias_nw_.20_graph.gph"


************************
*** graph std errs *****
************************

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_nw.dta", clear

local tstep 3
local title (C)

set scheme stmono2

twoway ///
    (connected se period if controls == 4 & tstep == `tstep', sort) ///
    (connected se period if controls == 8 & tstep == `tstep', sort) ///
    (connected se period if controls == 12 & tstep == `tstep', sort) ///	
    (connected se period if controls == 16 & tstep == `tstep', sort) ///
    (connected se period if controls == 20 & tstep == `tstep', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("Empirical Std Err.") ///
	ylabel(0.5(.25)1.5) ///
	title("`title'")	

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_se_nw_.20_graph.gph"


************************
*** graph RMSE *****
************************

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_nw.dta", clear

local tstep 3
local title (C)

set scheme stmono2

twoway ///
    (connected rmse period if controls == 4 & tstep == `tstep', sort) ///
    (connected rmse period if controls == 8 & tstep == `tstep', sort) ///
    (connected rmse period if controls == 12 & tstep == `tstep', sort) ///	
    (connected rmse period if controls == 16 & tstep == `tstep', sort) ///
    (connected rmse period if controls == 20 & tstep == `tstep', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("RMSE") ///
	ylabel(0.90(.05)1.1) ///
	title("`title'")		

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_rmse_nw_.20_graph.gph"


****************************
*** graph 95% coverage *****
****************************

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_nw.dta", clear

local tstep 3
local title (C)

set scheme stmono2

twoway ///
    (connected coverage period if controls == 4 & tstep == `tstep', sort) ///
    (connected coverage period if controls == 8 & tstep == `tstep', sort) ///
    (connected coverage period if controls == 12 & tstep == `tstep', sort) ///	
    (connected coverage period if controls == 16 & tstep == `tstep', sort) ///
    (connected coverage period if controls == 20 & tstep == `tstep', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("95% Coverage") ///
	ylabel(0.60(.10)1) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_cover_nw_.20_graph.gph"





**************************
***** Prais-Winsten  *****
**************************

set scheme stmono2
* level change (20% 25% 30% increase); 10-50 time periods; 4-20 controls; 1 sd for white noise 
power multi_itsa, n(10(5)50) contcnt(4(4)20) tint(10) cint(10) tpre(0) cpre(0) tstep(2 2.5 3) cstep(0) tsd(1) csd(1) cpost(0) tpost(0) tacorr(.20) cacorr(.20) reps(2000) ///
	noi table level prais perf
	
	mat effect = r(pss_table)
	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_prais.dta", replace

*** graph it ***
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_prais.dta", clear

local tstep 2
local title (D)

set scheme stmono2

twoway ///
    (connected power period if controls == 4 & tstep == `tstep', sort) ///
    (connected power period if controls == 8 & tstep == `tstep', sort) ///
    (connected power period if controls == 12 & tstep == `tstep', sort) ///	
    (connected power period if controls == 16 & tstep == `tstep', sort) ///
    (connected power period if controls == 20 & tstep == `tstep', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("Power (1-{&beta})") ///
	ylabel(0.2(.2)1) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_prais_.30_graph.gph"


*******************************
*** autocorrelation prais *****
*******************************

set scheme stmono2

forvalues ac = -0.9(0.3)0.9 {
	power multi_itsa, n(10(5)50) contcnt(12) ///
            tint(10) cint(10) tpre(1) cpre(1) ///
            tstep(2 2.5 3) cstep(0) tsd(1) csd(1) ///
            cpost(1) tpost(1) ///
            tacorr(`ac') cacorr(`ac') alpha(0.05) reps(2000) ///
			noi table level prais perf
			
			mat effect = nullmat(effect) \ r(pss_table)
			
}		

	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_prais_ac.dta", replace


* graph it

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_prais_ac.dta", replace

tempvar test
gen str4 `test' = string(tcorr, "%4.1f")

local tstep 3
local title (F)

set scheme stmono2

twoway ///
    (connected power period if `test' == "-0.9" & tstep == `tstep', sort) ///
    (connected power period if `test' == "-0.6" & tstep == `tstep', sort) ///
    (connected power period if `test' == "-0.3" & tstep == `tstep', sort) ///
    (connected power period if `test' ==  "0.0" & tstep == `tstep', sort) ///
    (connected power period if `test' ==  "0.3" & tstep == `tstep', sort) ///
    (connected power period if `test' ==  "0.6" & tstep == `tstep', sort) ///
    (connected power period if `test' ==  "0.9" & tstep == `tstep', sort), ///
    legend(order(1 "-0.9" 2 "-0.6" 3 "-0.3" 4 "0" 5 "0.3" 6 "0.6" 7 "0.9") ///
           title("Autocorr", size(medium))) ///
    xtitle("Period") ///
    ytitle("Power(1-{&beta})") ///
	ylabel(.2(.2)1) ///
	title("`title'")

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_ac_prais_.20_graph.gph"

********************
*** graph bias *****
********************

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_prais.dta", clear

local tstep 3
local title (F)

set scheme stmono2

twoway ///
    (connected bias period if controls == 4 & tstep == `tstep', sort) ///
    (connected bias period if controls == 8 & tstep == `tstep', sort) ///
    (connected bias period if controls == 12 & tstep == `tstep', sort) ///	
    (connected bias period if controls == 16 & tstep == `tstep', sort) ///
    (connected bias period if controls == 20 & tstep == `tstep', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("% Bias") ///
	ylabel(-10(2)10) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_bias_prais_.30_graph.gph"


************************
*** graph std errs *****
************************

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_prais.dta", clear

local tstep 3
local title (F)

set scheme stmono2

twoway ///
    (connected se period if controls == 4 & tstep == `tstep', sort) ///
    (connected se period if controls == 8 & tstep == `tstep', sort) ///
    (connected se period if controls == 12 & tstep == `tstep', sort) ///	
    (connected se period if controls == 16 & tstep == `tstep', sort) ///
    (connected se period if controls == 20 & tstep == `tstep', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("Empirical Std Err.") ///
	ylabel(0.5(.25)1.5) ///
	title("`title'")	

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_se_prais_.30_graph.gph"


************************
*** graph RMSE *****
************************

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_prais.dta", clear

local tstep 3
local title (F)

set scheme stmono2

twoway ///
    (connected rmse period if controls == 4 & tstep == `tstep', sort) ///
    (connected rmse period if controls == 8 & tstep == `tstep', sort) ///
    (connected rmse period if controls == 12 & tstep == `tstep', sort) ///	
    (connected rmse period if controls == 16 & tstep == `tstep', sort) ///
    (connected rmse period if controls == 20 & tstep == `tstep', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("RMSE") ///
	ylabel(0.90(.05)1.1) ///
	title("`title'")		

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_rmse_prais_.30_graph.gph"


****************************
*** graph 95% coverage *****
****************************

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_prais.dta", clear

local tstep 3
local title (F)

set scheme stmono2

twoway ///
    (connected coverage period if controls == 4 & tstep == `tstep', sort) ///
    (connected coverage period if controls == 8 & tstep == `tstep', sort) ///
    (connected coverage period if controls == 12 & tstep == `tstep', sort) ///	
    (connected coverage period if controls == 16 & tstep == `tstep', sort) ///
    (connected coverage period if controls == 20 & tstep == `tstep', sort), ///	
    legend(order(1 "4" 2 "8" 3 "12" 4 "16" 5 "20") ///
	title("Controls", size(medium))) ///
    xtitle("Period") ///
    ytitle("95% Coverage") ///
	ylabel(0.60(.10)1) ///
	title("`title'")	
	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_cover_prais_.30_graph.gph"




*****************************
* combine NW and PRAIS graphs
*****************************
*********
* level *
*********
* order these by tpost value
gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_nw_.20_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_prais_.20_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_nw_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_prais_.25_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_nw_.30_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_prais_.30_graph.gph" ///	
	, col(2) altshrink 

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\combined_level_graph.gph", replace


*****************
* autocorrelation
*****************

gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_ac_nw_.20_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_ac_prais_.20_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_ac_nw_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_ac_prais_.25_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_ac_nw_.30_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_ac_prais_.30_graph.gph" ///	
	, col(2) altshrink 

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\combined_level_ac_graph.gph", replace


*********
* bias *
*********
* order these by tstep value
gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_bias_nw_.20_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_bias_prais_.20_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_bias_nw_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_bias_prais_.25_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_bias_nw_.30_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_bias_prais_.30_graph.gph" ///	
	, col(2) altshrink 

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\combined_level_bias_graph.gph", replace

*********
* SE *
*********

gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_se_nw_.20_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_se_prais_.20_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_se_nw_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_se_prais_.25_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_se_nw_.30_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_se_prais_.30_graph.gph" ///	
	, col(2) altshrink 

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\combined_level_se_graph.gph", replace


*********
* RMSE *
*********

gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_rmse_nw_.20_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_rmse_prais_.20_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_rmse_nw_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_rmse_prais_.25_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_rmse_nw_.30_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_rmse_prais_.30_graph.gph" ///	
	, col(2) altshrink 

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\combined_level_rmse_graph.gph", replace


************
* Coverage *
************
gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_cover_nw_.20_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_cover_prais_.20_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_cover_nw_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_cover_prais_.25_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_cover_nw_.30_graph.gph" ///	
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\level_cover_prais_.30_graph.gph" ///	
	, col(2) altshrink 

	
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\combined_level_cover_graph.gph", replace


**********************************************************************************************
******************************* sensitivity analyses *****************************************
**********************************************************************************************

******************************
* #1 different baseline trends
******************************

***** OLS with NW std errs ****
* pre-to-post trend change when the starting trend for tx is 5 and starting trend for controls is 1
power multi_itsa, n(10(5)50) contcnt(4(4)20) tint(10) cint(10) tpre(5) cpre(1) tstep(0) cstep(0) tsd(1) csd(1) cpost(1) tpost(5.25 5.50 6) tacorr(.20) cacorr(.20) reps(2000) ///
	noi alpha(0.05) perf
	
	mat effect = r(pss_table)
	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	gen model = "nw"
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens1_nw.dta", replace	

***** Prais-Winsten  *****
power multi_itsa, n(10(10)50) contcnt(4(4)20) tint(10) cint(10) tpre(5) cpre(1) tstep(0) cstep(0) tsd(1) csd(1) cpost(1) tpost(5.25 5.50 6) tacorr(.20) cacorr(.20) reps(2000) noi alpha(0.05) ///
	prais perf
	
	mat effect = r(pss_table)
	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	gen model = "prais"
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens1_prais.dta", replace		

**************************************
* combine data sets and generate graph
**************************************
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens1_nw.dta", replace
append using "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens1_prais.dta"
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens1_combine.dta", replace

******
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens1_combine.dta", replace

set scheme stmono2

local controls 12
local tpost 5.5

twoway ///
    (connected power period if model == "nw" & controls == `controls' & tpost == `tpost', sort) ///
    (connected power period if model == "prais" & controls == `controls' & tpost == `tpost', sort), ///
    legend(order(1 "OLS-NW" 2 "PW") ///
	title("Model", size(medium))) ///
    xtitle("Period") ///
    ytitle("Power(1-{&beta})") ///
	ylabel(.2(.2)1) 

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens1.gph", replace	


******************************	
* #2 different baseline levels
******************************

***** OLS with NW std errs ****
* pre-to-post trend change when the starting trend for tx is 5 and starting trend for controls is 1
power multi_itsa, n(10(10)50) contcnt(4(4)20) tint(10) cint(8) tpre(0) cpre(0) tstep(2) cstep(0) tsd(1) csd(1) cpost(0) tpost(0) tacorr(.20) cacorr(.20) reps(2000) noi alpha(0.05) ///
	level perf
	
	mat effect = r(pss_table)
	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	gen model = "nw"
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens2_nw.dta", replace		

***** Prais-Winsten  *****
power multi_itsa, n(10(10)50) contcnt(4(4)20) tint(10) cint(8) tpre(0) cpre(0) tstep(2) cstep(0) tsd(1) csd(1) cpost(0) tpost(0) tacorr(.20) cacorr(.20) reps(2000) noi alpha(0.05) ///
	level prais perf
	
	mat effect = r(pss_table)
	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	gen model = "prais"
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens2_prais.dta", replace	

**************************************
* combine data sets and generate graph
**************************************
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens2_nw.dta", replace
append using "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens2_prais.dta"
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens2_combine.dta", replace


use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens2_combine.dta", replace

set scheme stmono2

local controls 12

twoway ///
    (connected power period if model == "nw" & controls == `controls', sort) ///
    (connected power period if model == "prais" & controls == `controls', sort), ///
    legend(order(1 "OLS-NW" 2 "PW") ///
	title("Model", size(medium))) ///
    xtitle("Period") ///
    ytitle("Power(1-{&beta})") ///
	ylabel(.2(.2)1) 

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens2.gph", replace	

	
**********************************************************************************************************************************************	
* #3 change in level and trend (control's baseline level = 8; treatment baseline level = 10, treatment step = 30% treatment post-trend = 100%)
**********************************************************************************************************************************************

***** OLS with NW std errs ****
* pre-to-post trend change when the starting trend for tx is 5 and starting trend for controls is 1
power multi_itsa, n(10(10)50) contcnt(4(4)20) tint(10) cint(8) tpre(1) cpre(1) tstep(2) cstep(0) tsd(1) csd(1) cpost(1) tpost(2) tacorr(.20) cacorr(.20) reps(2000) ///
	noi alpha(0.05) perf
	
	mat effect = r(pss_table)
	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	gen model = "nw"
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens3_nw.dta", replace	
	

***** Prais-Winsten  *****
power multi_itsa, n(10(10)50) contcnt(4(4)20) tint(10) cint(8) tpre(1) cpre(1) tstep(2) cstep(0) tsd(1) csd(1) cpost(1) tpost(2) tacorr(.20) cacorr(.20) reps(2000) noi alpha(0.05) ///
	prais perf	
	
	mat effect = r(pss_table)
	svmat effect
	rename effect1 alpha
	rename effect2 power
	rename effect3 period
	rename effect4 controls
	rename effect5 trper
	rename effect6 tint
	rename effect7 tpre
	rename effect8 tpost
	rename effect9 tstep
	rename effect10 tcorr
	rename effect11 cint
	rename effect12 cpre
	rename effect13 cpost
	rename effect14 cstep
	rename effect15 ccorr
	rename effect16 reps
	rename effect17 bias
	rename effect18 rmse
	rename effect19 coverage
	rename effect20 se
	gen model = "prais"
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens3_prais.dta", replace	

**************************************
* combine data sets and generate graph
**************************************
use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens3_nw.dta", replace
append using "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens3_prais.dta"
save "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens3_combine.dta", replace

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens3_combine.dta", replace

set scheme stmono2

local controls 12

twoway ///
    (connected power period if model == "nw" & controls == `controls', sort) ///
    (connected power period if model == "prais" & controls == `controls' , sort), ///
    legend(order(1 "OLS-NW" 2 "PW") ///
	title("Model", size(medium))) ///
    xtitle("Period") ///
    ytitle("Power(1-{&beta})") ///
	ylabel(.2(.2)1) 

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\sens3.gph", replace	
		
	
***************************************
* single runs for Demo (figure 1 and 2)
***************************************

*********
* trend *
*********

* show DGP for trend (25%)
power_sim_multi_itsa, n(50) trp(25) contcnt(12) tint(10) cint(10) tpre(1) cpre(1) tstep(0) cstep(0) tsd(1) csd(1) cpost(1) tpost(1.25) tacorr(.20) cacorr(.20) alpha(0.05)
itsa y , treat(1) trperiod(25) fig(ylab(0(20)100) title("(A)") legend(off) note("") subtitle("")) replace posttrend
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_trend_.25_graph.gph"

* show DGP for trend (50%)
power_sim_multi_itsa, n(50) trp(25) contcnt(12) tint(10) cint(10) tpre(1) cpre(1) tstep(0) cstep(0) tsd(1) csd(1) cpost(1) tpost(1.50) tacorr(.20) cacorr(.20) alpha(0.05)
itsa y , treat(1) trperiod(25) fig(ylab(0(20)100) title("(B)") legend(off) note("") subtitle("")) replace posttrend
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_trend_.50_graph.gph"

* show DGP for trend (100%)
power_sim_multi_itsa, n(50) trp(25) contcnt(12) tint(10) cint(10) tpre(1) cpre(1) tstep(0) cstep(0) tsd(1) csd(1) cpost(1) tpost(2) tacorr(.20) cacorr(.20) alpha(0.05)
itsa y , treat(1) trperiod(25) fig(ylab(0(20)100) title("(C)") legend(off) note("") subtitle("")) replace posttrend
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_trend_1.0_graph.gph"

* combine graphs
gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_trend_.25_graph.gph" ///
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_trend_.50_graph.gph" /// 
	"C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_trend_1.0_graph.gph", row(1) altshrink 
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_trend_combined_graph.gph", replace

*********
* level *
*********
* show DGP for level (20%)
power_sim_multi_itsa, n(50) trp(25) contcnt(12) tint(10) cint(10) tpre(0) cpre(0) tstep(2) cstep(0) tsd(1) csd(1) cpost(0) tpost(0) tacorr(.20) cacorr(.20) alpha(0.05)
itsa y , treat(1) trperiod(25) fig(ylab(0(5)30) title("(A)") legend(off) note("") subtitle("")) replace posttrend
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_level_.20_graph.gph"

* show DGP for level (25%)
power_sim_multi_itsa, n(50) trp(25) contcnt(12) tint(10) cint(10) tpre(0) cpre(0) tstep(2.5) cstep(0) tsd(1) csd(1) cpost(0) tpost(0) tacorr(.20) cacorr(.20) alpha(0.05)
itsa y , treat(1) trperiod(25) fig(ylab(0(5)30) title("(B)") legend(off) note("") subtitle("")) replace posttrend
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_level_.25_graph.gph"

* show DGP for level (30%)
power_sim_multi_itsa, n(50) trp(25) contcnt(12) tint(10) cint(10) tpre(0) cpre(0) tstep(3) cstep(0) tsd(1) csd(1) cpost(0) tpost(0) tacorr(.20) cacorr(.20) alpha(0.05)
itsa y , treat(1) trperiod(25) fig(ylab(0(5)30) title("(C)") legend(off) note("") subtitle("")) replace posttrend
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_level_.30_graph.gph"

* combine graphs
gr combine "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_level_.20_graph.gph" ///
 "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_level_.25_graph.gph" ///
 "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_level_.30_graph.gph", row(1) altshrink 
graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\Demo_level_combined_graph.gph", replace

**********************
* graph type 1 errors
**********************
* note: type 1 error were computed using -power_sim_multi_itsa- in a loop as power_itsa cannot compute type 1 errors

*** type 1 error over time ***

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\type1error_time.dta", clear

set scheme stmono2

twoway ///
    (connected type1 period if model == "nw", sort) ///
    (connected type1 period if model == "prais", sort), ///
    legend(order(1 "OLS-NW" 2 "PW") ///
	title("Model", size(medium))) ///
    xtitle("Period") ///
    ytitle("Type I error rate") ///
	ylabel(0(.10).50) 

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\type1error_time.gph", replace	

*** type 1 error over levels of autocorrelation ***

use "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\type1error_ac_combined.dta", clear

set scheme stmono2

twoway ///
    (connected type1 ac if model == "nw", sort) ///
    (connected type1 ac if model == "prais", sort), ///
    legend(order(1 "OLS-NW" 2 "PW") ///
	title("Model", size(medium))) ///
    xtitle("Autocorrelation") ///
    ytitle("Type I error rate") ///
	ylabel(0(.10).60) ///
	xlabel(-.90(.30)0.90, format(%4.2f))

graph save "Graph" "C:\Users\Ariel\Desktop\ITSA_stuff\compare models\type1error_ac.gph"
	