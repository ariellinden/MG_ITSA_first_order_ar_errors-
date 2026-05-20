* append files and generate graphs *

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\trend_nw.dta", clear
generate model = "NW"
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\trend_nw.dta", replace

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\trend_prais.dta", replace
generate model = "PW"
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\trend_prais.dta", replace

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\trend_nw.dta", clear
append using "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\trend_prais.dta"
save "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\combined_trend.dta"


*** graph it ***
use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\combined_trend.dta", clear

set scheme stmono2

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
    if "`metric'" == "bias"     local ylabel "ylabel(-12(4)12, nogrid)"
    if "`metric'" == "bias"     local xlabel "xlabel(10(10)50, nogrid)"
    if "`metric'" == "se"       local ylabel "ylabel(0(0.1)0.6, nogrid)"
    if "`metric'" == "se"       local xlabel "xlabel(10(10)50, nogrid)"
    if "`metric'" == "rmse"     local ylabel "ylabel(0.9(0.05)1.10, nogrid)"
    if "`metric'" == "rmse"     local xlabel "xlabel(10(10)50, nogrid)"

    if "`metric'" == "bias"     local yref "yline(0, lcolor(black) lpattern(dash) lwidth(thin))"
    if "`metric'" == "coverage" local yref "yline(95, lcolor(black) lpattern(dash) lwidth(thin))"
    if "`metric'" != "bias" & "`metric'" != "coverage" local yref ""

    // Set the plot variable — use coverage_pct for coverage, otherwise use metric name
    if "`metric'" == "coverage" local plotvar "coverage_pct"
    else                        local plotvar "`metric'"

    foreach effect_val in 1.25 1.5 2 {

        if `effect_val' == 1.25  local note_txt "Trend effect = 25%"
        if `effect_val' == 1.5   local note_txt "Trend effect = 50%"
        if `effect_val' == 2     local note_txt "Trend effect = 100%"

        if `effect_val' == 1.25 {
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
            (connected `plotvar' period if model=="PW" & abs(tpost-`effect_val')<0.001 & controls==4,  sort msize(small)) ///
            (connected `plotvar' period if model=="PW" & abs(tpost-`effect_val')<0.001 & controls==12, sort msize(small)) ///
            (connected `plotvar' period if model=="PW" & abs(tpost-`effect_val')<0.001 & controls==20, sort msize(small)) ///
            , `yref' ///
            `ylabel' ///
            `xlabel' ///
            ytitle("`ytitle'") ///
            xtitle("Periods") ///
            `pw_title' ///
            note("`note_txt'") ///
            legend(order(1 "4" 2 "12" 3 "20") ///
                   title("Controls", size(vsmall) margin(b-2)) ///
                   pos(3) ring(1) size(vsmall) cols(1) rowgap(0) linegap(0)) ///
            name(pw_`metric'_t`suf', replace)

        // ---- NW panel ----
        twoway ///
            (connected `plotvar' period if model=="NW" & abs(tpost-`effect_val')<0.001 & controls==4,  sort msize(small)) ///
            (connected `plotvar' period if model=="NW" & abs(tpost-`effect_val')<0.001 & controls==12, sort msize(small)) ///
            (connected `plotvar' period if model=="NW" & abs(tpost-`effect_val')<0.001 & controls==20, sort msize(small)) ///
            , `yref' ///
            `ylabel' ///
            `xlabel' ///
            ytitle("") ///
            xtitle("Periods") ///
            `nw_title' ///
            note("`note_txt'") ///
            legend(order(1 "4" 2 "12" 3 "20") ///
                   title("Controls", size(vsmall) margin(b-2)) ///
                   pos(3) ring(1) size(vsmall) cols(1) rowgap(0) linegap(0)) ///
            name(nw_`metric'_t`suf', replace)
    }

    graph combine ///
        pw_`metric'_t1_25 nw_`metric'_t1_25 ///
        pw_`metric'_t1_5  nw_`metric'_t1_5  ///
        pw_`metric'_t2    nw_`metric'_t2    ///
        , cols(2) xsize(10) ysize(14)

    graph export "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\combined_trend_`metric'.png" ///
        , replace width(3000)
}