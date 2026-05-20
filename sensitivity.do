// ================================================================
// SENSITIVITY ANALYSIS 1
// Trend effect only, different baseline trends
// tpost = 5.25, 5.5, 6; controls = 4, 8, 12, 16, 20
// ================================================================

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\sens1_combine.dta", clear

set scheme stmono2

gen coverage_pct = coverage * 100

foreach metric in power coverage {

    if "`metric'" == "power"    local ytitle "Power (1-{&beta})"
    if "`metric'" == "coverage" local ytitle "95% Coverage"

    if "`metric'" == "power"    local ylabel "ylabel(0(.2)1, nogrid)"
    if "`metric'" == "coverage" local ylabel "ylabel(0(20)100, nogrid)"

    if "`metric'" == "coverage" local yref "yline(95, lcolor(black) lpattern(dash) lwidth(thin))"
    else                        local yref ""

    if "`metric'" == "coverage" local plotvar "coverage_pct"
    else                        local plotvar "`metric'"

    foreach effect_val in 5.25 5.5 6 {

        if `effect_val' == 5.25 local note_txt "Trend effect = 25%"
        if `effect_val' == 5.5  local note_txt "Trend effect = 50%"
        if `effect_val' == 6    local note_txt "Trend effect = 100%"

        if `effect_val' == 5.25 {
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
            (connected `plotvar' period if model=="prais" & abs(tpost-`effect_val')<0.001 & controls==4,  sort msize(small)) ///
            (connected `plotvar' period if model=="prais" & abs(tpost-`effect_val')<0.001 & controls==12, sort msize(small)) ///
            (connected `plotvar' period if model=="prais" & abs(tpost-`effect_val')<0.001 & controls==20, sort msize(small)) ///
            , `yref' ///
            `ylabel' ///
            xlabel(10(10)50, nogrid) ///
            ytitle("`ytitle'") ///
            xtitle("Periods") ///
            `pw_title' ///
            note("`note_txt'") ///
            legend(order(1 "4" 2 "12" 3 "20") ///
                   title("Controls", size(vsmall) margin(b-2)) ///
                   pos(3) ring(1) size(vsmall) cols(1) rowgap(0)) ///
            name(pw_`metric'_s1_t`suf', replace)

        // ---- NW panel ----
        twoway ///
            (connected `plotvar' period if model=="nw" & abs(tpost-`effect_val')<0.001 & controls==4,  sort msize(small)) ///
            (connected `plotvar' period if model=="nw" & abs(tpost-`effect_val')<0.001 & controls==12, sort msize(small)) ///
            (connected `plotvar' period if model=="nw" & abs(tpost-`effect_val')<0.001 & controls==20, sort msize(small)) ///
            , `yref' ///
            `ylabel' ///
            xlabel(10(10)50, nogrid) ///
            ytitle("") ///
            xtitle("Periods") ///
            `nw_title' ///
            note("`note_txt'") ///
            legend(order(1 "4" 2 "12" 3 "20") ///
                   title("Controls", size(vsmall) margin(b-2)) ///
                   pos(3) ring(1) size(vsmall) cols(1) rowgap(0)) ///
            name(nw_`metric'_s1_t`suf', replace)
    }

    graph combine ///
        pw_`metric'_s1_t5_25 nw_`metric'_s1_t5_25 ///
        pw_`metric'_s1_t5_5  nw_`metric'_s1_t5_5  ///
        pw_`metric'_s1_t6    nw_`metric'_s1_t6    ///
        , cols(2) xsize(10) ysize(14)

    graph export "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\sens1_`metric'.png" ///
        , replace width(3000)
}

// ================================================================
// SENSITIVITY ANALYSIS 2
// Level effect only, different baseline levels
// tstep=2, tpost=0, controls = 4, 8, 12, 16, 20
// Single effect size — one row
// ================================================================

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\sens2_combine.dta", clear

set scheme stmono2

gen coverage_pct = coverage * 100

foreach metric in power coverage {

    if "`metric'" == "power"    local ytitle "Power (1-{&beta})"
    if "`metric'" == "coverage" local ytitle "95% Coverage"

    if "`metric'" == "power"    local ylabel "ylabel(0(.2)1, nogrid)"
    if "`metric'" == "coverage" local ylabel "ylabel(0(20)100, nogrid)"

    if "`metric'" == "coverage" local yref "yline(95, lcolor(black) lpattern(dash) lwidth(thin))"
    else                        local yref ""

    if "`metric'" == "coverage" local plotvar "coverage_pct"
    else                        local plotvar "`metric'"

    // ---- PW panel ----
    twoway ///
        (connected `plotvar' period if model=="prais" & controls==4,  sort msize(small)) ///
        (connected `plotvar' period if model=="prais" & controls==12, sort msize(small)) ///
        (connected `plotvar' period if model=="prais" & controls==20, sort msize(small)) ///
        , `yref' ///
        `ylabel' ///
        xlabel(10(10)50, nogrid) ///
        ytitle("`ytitle'") ///
        xtitle("Periods") ///
        title("Prais-Winsten") ///
        legend(order(1 "4" 2 "12" 3 "20") ///
               title("Controls", size(vsmall) margin(b-2)) ///
               pos(3) ring(1) size(vsmall) cols(1) rowgap(0)) ///
        name(pw_`metric'_s2, replace)

    // ---- NW panel ----
    twoway ///
        (connected `plotvar' period if model=="nw" & controls==4,  sort msize(small)) ///
        (connected `plotvar' period if model=="nw" & controls==12, sort msize(small)) ///
        (connected `plotvar' period if model=="nw" & controls==20, sort msize(small)) ///
        , `yref' ///
        `ylabel' ///
        xlabel(10(10)50, nogrid) ///
        ytitle("") ///
        xtitle("Periods") ///
        title("OLS-NW") ///
        legend(order(1 "4" 2 "12" 3 "20") ///
               title("Controls", size(vsmall) margin(b-2)) ///
               pos(3) ring(1) size(vsmall) cols(1) rowgap(0)) ///
        name(nw_`metric'_s2, replace)

    graph combine ///
        pw_`metric'_s2 nw_`metric'_s2 ///
        , cols(2) xsize(10) ysize(7)

    graph export "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\sens2_`metric'.png" ///
        , replace width(3000)
}

// ================================================================
// SENSITIVITY ANALYSIS 3
// Combined level and trend effect
// tstep=2, tpost=2, controls = 4, 8, 12, 16, 20
// Single effect size — one row
// ================================================================

use "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\sens3_combine.dta", clear

set scheme stmono2

gen coverage_pct = coverage * 100

foreach metric in power coverage {

    if "`metric'" == "power"    local ytitle "Power (1-{&beta})"
    if "`metric'" == "coverage" local ytitle "95% Coverage"

    if "`metric'" == "power"    local ylabel "ylabel(0(.2)1, nogrid)"
    if "`metric'" == "coverage" local ylabel "ylabel(0(20)100, nogrid)"

    if "`metric'" == "coverage" local yref "yline(95, lcolor(black) lpattern(dash) lwidth(thin))"
    else                        local yref ""

    if "`metric'" == "coverage" local plotvar "coverage_pct"
    else                        local plotvar "`metric'"

    // ---- PW panel ----
    twoway ///
        (connected `plotvar' period if model=="prais" & controls==4,  sort msize(small)) ///
        (connected `plotvar' period if model=="prais" & controls==12, sort msize(small)) ///
        (connected `plotvar' period if model=="prais" & controls==20, sort msize(small)) ///
        , `yref' ///
        `ylabel' ///
        xlabel(10(10)50, nogrid) ///
        ytitle("`ytitle'") ///
        xtitle("Periods") ///
        title("Prais-Winsten") ///
        legend(order(1 "4" 2 "12" 3 "20") ///
               title("Controls", size(vsmall) margin(b-2)) ///
               pos(3) ring(1) size(vsmall) cols(1) rowgap(0)) ///
        name(pw_`metric'_s3, replace)

    // ---- NW panel ----
    twoway ///
        (connected `plotvar' period if model=="nw" & controls==4,  sort msize(small)) ///
        (connected `plotvar' period if model=="nw" & controls==12, sort msize(small)) ///
        (connected `plotvar' period if model=="nw" & controls==20, sort msize(small)) ///
        , `yref' ///
        `ylabel' ///
        xlabel(10(10)50, nogrid) ///
        ytitle("") ///
        xtitle("Periods") ///
        title("OLS-NW") ///
        legend(order(1 "4" 2 "12" 3 "20") ///
               title("Controls", size(vsmall) margin(b-2)) ///
               pos(3) ring(1) size(vsmall) cols(1) rowgap(0)) ///
        name(nw_`metric'_s3, replace)

    graph combine ///
        pw_`metric'_s3 nw_`metric'_s3 ///
        , cols(2) xsize(10) ysize(7)

    graph export "C:\Users\Ariel\Desktop\ITSA_stuff\Compare NW and PRAIS\AR(1) Revisions\sens3_`metric'.png" ///
        , replace width(3000)
}