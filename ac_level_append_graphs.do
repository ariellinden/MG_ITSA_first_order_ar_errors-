* append files and generate graphs *
use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\level_nw_ac.dta", clear
generate model = "NW"
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\level_nw_ac.dta", replace

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\level_prais_ac.dta", clear
generate model = "PW"
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\level_prais_ac.dta", replace

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\level_nw_ac.dta", clear
append using "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\level_prais_ac.dta"
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\combined_ac_level.dta", replace


**** graphs ****
use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\combined_ac_level.dta", clear

set scheme stmono2

*gen str4 tcorr_str = string(tcorr, "%4.1f")
gen coverage_pct = coverage * 100

foreach metric in /*power*/ coverage /*bias se rmse*/ {

    if "`metric'" == "power"    local ytitle "Power (1-{&beta})"
    if "`metric'" == "coverage" local ytitle "95% Coverage"
    if "`metric'" == "bias"     local ytitle "% Bias"
    if "`metric'" == "se"       local ytitle "Empirical Std Err."
    if "`metric'" == "rmse"     local ytitle "RMSE"

    if "`metric'" == "power"    local ylabel "ylabel(0(.2)1, nogrid)"
    if "`metric'" == "power"    local xlabel "xlabel(10(10)50, nogrid)"
    if "`metric'" == "coverage" local ylabel "ylabel(0(20)100, nogrid)"
    if "`metric'" == "coverage" local xlabel "xlabel(10(10)50, nogrid)"
    if "`metric'" == "bias"     local ylabel "ylabel(-10(2)10, nogrid)"
    if "`metric'" == "bias"     local xlabel "xlabel(10(10)50, nogrid)"
    if "`metric'" == "se"       local ylabel "ylabel(0.5(0.25)1.5, nogrid)"
    if "`metric'" == "se"       local xlabel "xlabel(10(10)50, nogrid)"
    if "`metric'" == "rmse"     local ylabel "ylabel(0(0.5)2.5, nogrid)"
    if "`metric'" == "rmse"     local xlabel "xlabel(10(10)50, nogrid)"

    if "`metric'" == "bias"     local yref "yline(0, lcolor(black) lpattern(dash) lwidth(thin))"
    if "`metric'" == "coverage" local yref "yline(95, lcolor(black) lpattern(dash) lwidth(thin))"
    if "`metric'" != "bias" & "`metric'" != "coverage" local yref ""

    if "`metric'" == "coverage" local plotvar "coverage_pct"
    else                        local plotvar "`metric'"

    foreach effect_val in 2 2.5 3 {

        if `effect_val' == 2    local note_txt "Level effect = 20%"
        if `effect_val' == 2.5  local note_txt "Level effect = 25%"
        if `effect_val' == 3    local note_txt "Level effect = 30%"

        if `effect_val' == 2 {
            local pw_title `"title("Prais-Winsten")"'
            local nw_title `"title("OLS-NW")"'
        }
        else {
            local pw_title ""
            local nw_title ""
        }

        local suf = subinstr("`effect_val'", ".", "_", .)

        // ---- PW panel ----
        twoway ///
            (connected `plotvar' period if model=="PW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="-0.9", sort msize(small)) ///
            (connected `plotvar' period if model=="PW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="-0.6", sort msize(small)) ///
            (connected `plotvar' period if model=="PW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="-0.3", sort msize(small)) ///
            (connected `plotvar' period if model=="PW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="0.0",  sort msize(small)) ///
            (connected `plotvar' period if model=="PW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="0.3",  sort msize(small)) ///
            (connected `plotvar' period if model=="PW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="0.6",  sort msize(small)) ///
            (connected `plotvar' period if model=="PW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="0.9",  sort msize(small)) ///
            , `yref' ///
            `ylabel' ///
            `xlabel' ///
            ytitle("`ytitle'") ///
            xtitle("Periods") ///
            `pw_title' ///
            note("`note_txt'") ///
            legend(order(1 "{&rho}=-0.9" 2 "{&rho}=-0.6" 3 "{&rho}=-0.3" ///
                         4 "{&rho}=0" 5 "{&rho}=0.3" 6 "{&rho}=0.6" 7 "{&rho}=0.9") ///
                   title("Autocorr", size(vsmall) margin(b-2)) ///
                   pos(3) ring(1) size(vsmall) cols(1) rowgap(0)) ///
            name(pw_`metric'_t`suf', replace)

        // ---- NW panel ----
        twoway ///
            (connected `plotvar' period if model=="NW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="-0.9", sort msize(small)) ///
            (connected `plotvar' period if model=="NW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="-0.6", sort msize(small)) ///
            (connected `plotvar' period if model=="NW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="-0.3", sort msize(small)) ///
            (connected `plotvar' period if model=="NW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="0.0",  sort msize(small)) ///
            (connected `plotvar' period if model=="NW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="0.3",  sort msize(small)) ///
            (connected `plotvar' period if model=="NW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="0.6",  sort msize(small)) ///
            (connected `plotvar' period if model=="NW" & abs(tstep-`effect_val')<0.001 & tcorr_str=="0.9",  sort msize(small)) ///
            , `yref' ///
            `ylabel' ///
            `xlabel' ///
            ytitle("") ///
            xtitle("Periods") ///
            `nw_title' ///
            note("`note_txt'") ///
            legend(order(1 "{&rho}=-0.9" 2 "{&rho}=-0.6" 3 "{&rho}=-0.3" ///
                         4 "{&rho}=0" 5 "{&rho}=0.3" 6 "{&rho}=0.6" 7 "{&rho}=0.9") ///
                   title("Autocorr", size(vsmall) margin(b-2)) ///
                   pos(3) ring(1) size(vsmall) cols(1) rowgap(0)) ///
            name(nw_`metric'_t`suf', replace)
    }

    graph combine ///
        pw_`metric'_t2   nw_`metric'_t2   ///
        pw_`metric'_t2_5 nw_`metric'_t2_5 ///
        pw_`metric'_t3   nw_`metric'_t3   ///
        , cols(2) xsize(10) ysize(14)

    graph export "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\combined_level_ac_`metric'.png" ///
        , replace width(3000)
}