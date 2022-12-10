
	clear all
	set more off
	mat drop _all
	pause off
	version 16
	set seed 77282829
	
	** Setting the stage
	*ssc install schemepack, replace
	*set scheme white_tableau   // my favorite one
	set scheme black_tableau
	
	** Import Data
	import delimited "https://raw.githubusercontent.com/tidyverse/ggplot2/master/data-raw/mpg.csv", clear
	
	sort year
	
	tab year 
	tab manufacturer
	

	bysort year: egen avg_hwy_mlg_toyota = mean(hwy) if manufacturer == "toyota"
	bysort year: egen avg_hwy_mlg_honda = mean(hwy) if manufacturer == "honda"
	bysort year: egen avg_hwy_mlg_others = mean(hwy) if (manufacturer != "honda" & manufacturer != "toyota")
	
	#delimit ;
	
	twoway 
	bar avg_hwy_mlg_others year, barw(2) color(black) fcolor(white%0) lwidth(thin) lcolor(white%100) 
	||
	bar avg_hwy_mlg_toyota year, barw(1) color(green) fcolor(green%50) 
	||
	bar avg_hwy_mlg_honda year, barw(0.5) color(blue) fcolor(blue%100) ,
	scheme(black_tableau)
	title("{bf: Average Highway Milage by Manufacturer}", size(2) pos(12) box)
	subtitle("Honda and Toyota V/s other Manufacturer", size(1.5) pos(12))
	xlabel(1999(9)2008, labsize(2) nogrid)
	ylabel(, nogrid)
	legend(on stack row(1) title("") pos(11) size(vsmall) ring(0))
	legend(label(1 "Others") label(2 "Toyota") label(3 "Honda"))
	
	; 
	#delimit cr
	
	graph save "GraphA.gph", replace
	
	#delimit ;
	
	 
	graph bar avg_hwy_mlg_others avg_hwy_mlg_toyota avg_hwy_mlg_honda, ///
	over(year) blabel(total, position(outside) gap(2) format(%12.0f) orientation(vertical)) ///
	bar(1, color(black) fcolor(white%0) lwidth(thin) lcolor(white%100)) ///
	bar(2, color(green) fcolor(green%50)) ///
	bar(3, color(blue) fcolor(blue%100))
	ylabel(, nogrid)
	title("{bf: Average Highway Milage by Manufacturer}", size(2) pos(12) box)
	subtitle("Honda and Toyota V/s other Manufacturer", size(1.5) pos(12))
	legend(on stack row(1) title("") pos(11) size(vsmall) ring(0))
	legend(label(1 "Others") label(2 "Toyota") label(3 "Honda"))

	
	; 
	#delimit cr
	
	graph save "GraphB.gph", replace
	
	#delimit ;
	
	graph combine "GraphB.gph" "GraphA.gph" ,
				title("{bf: Bar graphs Two Ways}", color(black))
				subtitle(Two way bar V/s Graph bar, size(2) color(gray)) 
				graphregion(color(white))
	; 
	#delimit cr
	
	graph export "A+B.png", as(png) width(3840) replace
