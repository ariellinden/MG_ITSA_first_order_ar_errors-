* append files and generate graphs *

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_trend_nw_controls.dta", clear
generate model = "NW"
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_trend_nw_controls.dta", replace

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_trend_pw_controls.dta", clear
generate model = "PW"
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_trend_pw_controls.dta", replace

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_trend_nw_controls.dta", clear
append using "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\type1_trend_pw_controls.dta"
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\combined_type1_trend_controls.dta"

*** graph it ***

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\combined_type1_trend_controls.dta", clear

set scheme stmono2

gen type1_pct = power * 100

// ---- PW panel ----
twoway ///
    (connected type1_pct period if model=="PW" & controls==4,  sort msize(small)) ///
    (connected type1_pct period if model=="PW" & controls==12, sort msize(small)) ///
    (connected type1_pct period if model=="PW" & controls==20, sort msize(small)) ///
    , ylabel(0(10)60, nogrid) ///
    xlabel(10(10)50, nogrid) ///
    yline(5, lcolor(black) lpattern(dash) lwidth(thin)) ///
    ytitle("Type I Error Rate (%)") ///
    xtitle("Periods") ///
    title("Prais-Winsten") ///
    legend(order(1 "4" 2 "12" 3 "20") ///
           title("Controls", size(vsmall) margin(b-2)) ///
           pos(3) ring(1) size(vsmall) cols(1) rowgap(0)) ///
    name(pw_type1_trend_controls, replace)

// ---- NW panel ----
twoway ///
    (connected type1_pct period if model=="NW" & controls==4,  sort msize(small)) ///
    (connected type1_pct period if model=="NW" & controls==12, sort msize(small)) ///
    (connected type1_pct period if model=="NW" & controls==20, sort msize(small)) ///
    , ylabel(0(10)60, nogrid) ///
    xlabel(10(10)50, nogrid) ///
    yline(5, lcolor(black) lpattern(dash) lwidth(thin)) ///
    ytitle("") ///
    xtitle("Periods") ///
    title("OLS-NW") ///
    legend(order(1 "4" 2 "12" 3 "20") ///
           title("Controls", size(vsmall) margin(b-2)) ///
           pos(3) ring(1) size(vsmall) cols(1) rowgap(0)) ///
    name(nw_type1_trend_controls, replace)

graph combine ///
    pw_type1_trend_controls nw_type1_trend_controls ///
    , cols(2) xsize(10) ysize(7)

graph export "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\combined_type1_trend_controls.png" ///
    , replace width(3000)