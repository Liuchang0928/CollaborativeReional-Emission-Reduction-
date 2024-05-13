use "C:\Users\liuch\Desktop\邻近矩阵.dta"
spatwmat using"C:\Users\liuch\Desktop\邻近矩阵.dta",name(w) standardize
import excel "C:\Users\liuch\Desktop\基准回归分析 -控制变量.xlsx", sheet("111") firstrow
foreach yr in 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 {
    preserve 
    keep if 年份 == `yr' 
    display "Analyzing data for year: `yr'"
    spatgsa SynergisticEmissionReductionI, weights(w) moran
    restore 
}
moranplot SynergisticEmissionReductionI if 年份 ==2021, w(w) id( province)
keep if 年份 == 2011
spatgsa SynergisticEmissionReductionI, weights(w) moran
moranplot SynergisticEmissionReductionI, w(w)  id(province_code)
graph export "C:\Users\liuch\Desktop\moranplot_2011.png", as(png) replace
clear
use "C:\Users\liuch\Desktop\816.dta", clear
keep if 年份 == 2021
spatgsa SynergisticEmissionReductionI, weights(w) moran
moranplot SynergisticEmissionReductionI, w(w)
graph export "C:\Users\liuch\Desktop\moranplot_2021.png", as(png) replace
spatwmat using"C:\Users\liuch\Desktop\816.dta",name(w) standardize
mkmat _all, matrix(new_matrix_name)
use "C:\Users\liuch\Desktop\邻近矩阵.dta"
spatwmat using"C:\Users\liuch\Desktop\邻近矩阵.dta",name(w) standardize
use "C:\Users\liuch\Desktop\整体数据.dta"
xtset province 年份
xsmle SERI DEI ,fe model(sdm) wmat(w)  type(ind) nolog noeffects//最终版本
outreg2 using "C:\Users\liuch\Desktop\1.doc", replace
xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalReserves ThermalPower Universities CoalInvestment ForestCoverage PTransportation ,fe model(sdm) wmat(w)  type(ind) nolog noeffects//修正后的全字母（参考）
xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation ,fe model(sdm) wmat(w)  type(ind) nolog noeffects//最终版本
outreg2 using "C:\Users\liuch\Desktop\2.doc", replace
xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation ,fe model(sdm) wmat(w)  type(ind) nolog effects
outreg2 using "C:\Users\liuch\Desktop\模型分解.doc", replace
use "C:\Users\liuch\Desktop\经济矩阵.dta"
spatwmat using"C:\Users\liuch\Desktop\经济矩阵.dta",name(w) standardize
use "C:\Users\liuch\Desktop\整体数据.dta"
xtset province 年份
xsmle SERI DEI,fe model(sdm) wmat(w)  type(ind) nolog noeffects//最终版本
outreg2 using "C:\Users\liuch\Desktop\3.doc", replace
xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation ,fe model(sdm) wmat(w)  type(ind) nolog noeffects//最终版本
outreg2 using "C:\Users\liuch\Desktop\4.doc", replace
xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation ,fe model(sdm) wmat(w)  type(ind) nolog effects
outreg2 using "C:\Users\liuch\Desktop\模型分解2.doc", replace
use "C:\Users\liuch\Desktop\邻近矩阵.dta"
spatwmat using"C:\Users\liuch\Desktop\邻近矩阵.dta",name(w) standardize
use "C:\Users\liuch\Desktop\整体数据.dta"
xtset province 年份
xsmle SERI DEI2 TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation ,fe model(sdm) wmat(w)  type(both) nolog noeffects
outreg2 using "C:\Users\liuch\Desktop\1.doc", replace
use "C:\Users\liuch\Desktop\经济矩阵.dta"
spatwmat using"C:\Users\liuch\Desktop\经济矩阵.dta",name(w) standardize
use "C:\Users\liuch\Desktop\整体数据.dta"
xtset province 年份
xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation ,fe model(sdm) wmat(w)  type(ind) nolog noeffects
outreg2 using "C:\Users\liuch\Desktop\1.doc", replace
use "C:\Users\liuch\Desktop\邻近矩阵.dta"
spatwmat using"C:\Users\liuch\Desktop\邻近矩阵.dta",name(w) standardize
use "C:\Users\liuch\Desktop\整体数据.dta"
xtset province 年份
ivreg2 SERI (DEI = postoffice) ThermalPower PDensity NEISI CoalInvestment, robust
estimates store Model_2SLS
esttab Model_2SLS using "C:\\Users\\liuch\\Desktop\\6.rtf", replace
use "C:\Users\liuch\Desktop\邻近矩阵.dta"
spatwmat using"C:\Users\liuch\Desktop\邻近矩阵.dta",name(w) standardize
use "C:\Users\liuch\Desktop\整体数据.dta"
xtset province 年份
xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation, fe model(sdm) wmat(w) durbin(DEI) type(ind) nolog noeffects if region == "东部"
by region: xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation, fe model(sdm) wmat(w) durbin(DEI) type(ind) nolog noeffects
