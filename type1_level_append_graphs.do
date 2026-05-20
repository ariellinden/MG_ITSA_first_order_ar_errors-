* append files and generate graphs *
use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_level_nw.dta", clear
generate model = "NW"
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_level_nw.dta", replace

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_level_pw.dta", clear
generate model = "PW"
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_level_pw.dta", replace


use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_level_nw.dta", clear
append using "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_level_pw.dta"
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\combined_type1_level.dta"

*** graph it ***

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\combined_type1_level.dta", clear

set scheme stmono2

gen str4 tcorr_str = string(tcorr, "%4.1f")
gen type1_pct = power * 100

// ---- PW panel ----
twoway ///
    (connected type1_pct period if model=="PW" & tcorr_str=="-0.9", sort msize(small)) ///
    (connected type1_pct period if model=="PW" & tcorr_str=="-0.6", sort msize(small)) ///
    (connected type1_pct period if model=="PW" & tcorr_str=="-0.3", sort msize(small)) ///
    (connected type1_pct period if model=="PW" & tcorr_str=="0.0",  sort msize(small)) ///
    (connected type1_pct period if model=="PW" & tcorr_str=="0.3",  sort msize(small)) ///
    (connected type1_pct period if model=="PW" & tcorr_str=="0.6",  sort msize(small)) ///
    (connected type1_pct period if model=="PW" & tcorr_str=="0.9",  sort msize(small)) ///
    , ylabel(0(10)60, nogrid) ///
    xlabel(10(10)50, nogrid) ///
    yline(5, lcolor(black) lpattern(dash) lwidth(thin)) ///
    ytitle("Type I Error Rate (%)") ///
    xtitle("Periods") ///
    title("Prais-Winsten") ///
    legend(order(1 "{&rho}=-0.9" 2 "{&rho}=-0.6" 3 "{&rho}=-0.3" ///
                 4 "{&rho}=0" 5 "{&rho}=0.3" 6 "{&rho}=0.6" 7 "{&rho}=0.9") ///
           title("Autocorr", size(vsmall) margin(b-2)) ///
           pos(3) ring(1) size(vsmall) cols(1) rowgap(0)) ///
    name(pw_type1_level, replace)

// ---- NW panel ----
twoway ///
    (connected type1_pct period if model=="NW" & tcorr_str=="-0.9", sort msize(small)) ///
    (connected type1_pct period if model=="NW" & tcorr_str=="-0.6", sort msize(small)) ///
    (connected type1_pct period if model=="NW" & tcorr_str=="-0.3", sort msize(small)) ///
    (connected type1_pct period if model=="NW" & tcorr_str=="0.0",  sort msize(small)) ///
    (connected type1_pct period if model=="NW" & tcorr_str=="0.3",  sort msize(small)) ///
    (connected type1_pct period if model=="NW" & tcorr_str=="0.6",  sort msize(small)) ///
    (connected type1_pct period if model=="NW" & tcorr_str=="0.9",  sort msize(small)) ///
    , ylabel(0(10)60, nogrid) ///
    xlabel(10(10)50, nogrid) ///
    yline(5, lcolor(black) lpattern(dash) lwidth(thin)) ///
    ytitle("") ///
    xtitle("Periods") ///
    title("OLS-NW") ///
    legend(order(1 "{&rho}=-0.9" 2 "{&rho}=-0.6" 3 "{&rho}=-0.3" ///
                 4 "{&rho}=0" 5 "{&rho}=0.3" 6 "{&rho}=0.6" 7 "{&rho}=0.9") ///
           title("Autocorr", size(vsmall) margin(b-2)) ///
           pos(3) ring(1) size(vsmall) cols(1) rowgap(0)) ///
    name(nw_type1_level, replace)

graph combine ///
    pw_type1_level nw_type1_level ///
    , cols(2) xsize(10) ysize(7)

graph export "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\combined_type1_level.png" ///
    , replace width(3000)