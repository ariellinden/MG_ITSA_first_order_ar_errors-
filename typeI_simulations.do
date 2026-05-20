*********************
***** Newey-West ****
*********************

*******************
* type I error
******************
*************************
*** autocorrelation *****
*************************
*** trend ***
forvalues ac = -0.9(0.3)0.9 {
	power multi_itsa, n(10(5)50) contcnt(12) ///
            tint(10) cint(10) tpre(0) cpre(0) ///
            tstep(0) cstep(0) tsd(1) csd(1) ///
            cpost(0) tpost(0) ///
            trho1(`ac') crho1(`ac') alpha(0.05) reps(2000) ///
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
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_trend_nw.dta"

*** level ***
forvalues ac = -0.9(0.3)0.9 {
	power multi_itsa, n(10(5)50) contcnt(12) ///
            tint(10) cint(10) tpre(0) cpre(0) ///
            tstep(0) cstep(0) tsd(1) csd(1) ///
            cpost(0) tpost(0) ///
            trho1(`ac') crho1(`ac') alpha(0.05) reps(2000) ///
			noi table perf level
			
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
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_level_nw.dta"


*********************
***** Newey-West ****
*********************

*******************
* type I error
******************
*************************
*** controls *****
*************************
*** trend ***
power multi_itsa, n(10(5)50) contcnt(4 8 12 16 20) ///
	tint(10) cint(10) tpre(0) cpre(0) ///
	tstep(0) cstep(0) tsd(1) csd(1) ///
	cpost(0) tpost(0) ///
	trho1(.20) crho1(.20) alpha(0.05) reps(2000) ///
	noi table perf 
			
	mat effect = nullmat(effect) \ r(pss_table)


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
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_trend_nw_controls.dta"

*** level ***
power multi_itsa, n(10(5)50) contcnt(4 8 12 16 20) ///
	tint(10) cint(10) tpre(0) cpre(0) ///
	tstep(0) cstep(0) tsd(1) csd(1) ///
	cpost(0) tpost(0) ///
	trho1(.20) crho1(.20) alpha(0.05) reps(1000) ///
	noi table perf level
			
	mat effect = nullmat(effect) \ r(pss_table)


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
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_level_nw_controls.dta"


********************************
***** Prais-Winsten ****
*******************************

*******************
* type I error
******************
*************************
*** autocorrelation *****
*************************
*** trend ***
forvalues ac = -0.9(0.3)0.9 {
	power multi_itsa, n(10(5)50) contcnt(12) ///
            tint(10) cint(10) tpre(0) cpre(0) ///
            tstep(0) cstep(0) tsd(1) csd(1) ///
            cpost(0) tpost(0) ///
            trho1(`ac') crho1(`ac') alpha(0.05) reps(2000) ///
			noi table perf praisk
			
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
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_trend_pw.dta", replace

*** level ***
forvalues ac = -0.9(0.3)0.9 {
	power multi_itsa, n(10(5)50) contcnt(12) ///
            tint(10) cint(10) tpre(0) cpre(0) ///
            tstep(0) cstep(0) tsd(1) csd(1) ///
            cpost(0) tpost(0) ///
            trho1(`ac') crho1(`ac') alpha(0.05) reps(1000) ///
			noi table perf praisk level
			
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
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_level_pw.dta", replace

*******************
* type I error
******************
*************************
*** controls *****
*************************
*** trend ***
power multi_itsa, n(10(5)50) contcnt(4 8 12 16 20) ///
	tint(10) cint(10) tpre(0) cpre(0) ///
	tstep(0) cstep(0) tsd(1) csd(1) ///
	cpost(0) tpost(0) ///
	trho1(.20) crho1(.20) alpha(0.05) reps(2000) ///
	noi table perf praisk
			
	mat effect = nullmat(effect) \ r(pss_table)


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
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_trend_pw_controls.dta"

*** level ***
power multi_itsa, n(10(5)50) contcnt(4 8 12 16 20) ///
	tint(10) cint(10) tpre(0) cpre(0) ///
	tstep(0) cstep(0) tsd(1) csd(1) ///
	cpost(0) tpost(0) ///
	trho1(.20) crho1(.20) alpha(0.05) reps(2000) ///
	noi table perf level praisk
			
	mat effect = nullmat(effect) \ r(pss_table)


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
	
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_level_pw_controls.dta"
