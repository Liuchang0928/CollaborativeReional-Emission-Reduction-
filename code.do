
//莫兰指数测算（方法1）

use "C:\Users\liuch\Desktop\邻近矩阵.dta"

spatwmat using"C:\Users\liuch\Desktop\邻近矩阵.dta",name(w) standardize

import excel "C:\Users\liuch\Desktop\基准回归分析 -控制变量.xlsx", sheet("111") firstrow

foreach yr in 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 {
    preserve // 保存当前数据状态
    keep if 年份 == `yr'  // 使用反引号和单引号正确地引用局部宏yr

    // 显示当前处理的年份
    display "Analyzing data for year: `yr'"

    spatgsa SynergisticEmissionReductionI, weights(w) moran
    
    restore // 恢复数据到原始状态
}



// 画出2011年的莫兰散点图

moranplot SynergisticEmissionReductionI if 年份 ==2021, w(w) id( province)

keep if 年份 == 2011
spatgsa SynergisticEmissionReductionI, weights(w) moran
moranplot SynergisticEmissionReductionI, w(w)  id(province_code)
graph export "C:\Users\liuch\Desktop\moranplot_2011.png", as(png) replace
clear

// 重新载入数据
use "C:\Users\liuch\Desktop\816.dta", clear

// 画出2021年的莫兰散点图
keep if 年份 == 2021
spatgsa SynergisticEmissionReductionI, weights(w) moran
moranplot SynergisticEmissionReductionI, w(w)
graph export "C:\Users\liuch\Desktop\moranplot_2021.png", as(png) replace







//空间权重矩阵//
spatwmat using"C:\Users\liuch\Desktop\816.dta",name(w) standardize

mkmat _all, matrix(new_matrix_name)





//空间杜宾

//1.邻接矩阵，构建矩阵
use "C:\Users\liuch\Desktop\邻近矩阵.dta"

spatwmat using"C:\Users\liuch\Desktop\邻近矩阵.dta",name(w) standardize

use "C:\Users\liuch\Desktop\整体数据.dta"

xtset province 年份

  //1.1邻接矩阵，不带控制变量

xsmle SERI DEI ,fe model(sdm) wmat(w)  type(ind) nolog noeffects//最终版本

outreg2 using "C:\Users\liuch\Desktop\1.doc", replace

  //1.2邻接矩阵，加入控制变量

xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalReserves ThermalPower Universities CoalInvestment ForestCoverage PTransportation ,fe model(sdm) wmat(w)  type(ind) nolog noeffects//修正后的全字母（参考）

xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation ,fe model(sdm) wmat(w)  type(ind) nolog noeffects//最终版本

outreg2 using "C:\Users\liuch\Desktop\2.doc", replace

  //1.3模型结果分解

xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation ,fe model(sdm) wmat(w)  type(ind) nolog effects

outreg2 using "C:\Users\liuch\Desktop\模型分解.doc", replace


//2.经济矩阵，构建矩阵

use "C:\Users\liuch\Desktop\经济矩阵.dta"

spatwmat using"C:\Users\liuch\Desktop\经济矩阵.dta",name(w) standardize

use "C:\Users\liuch\Desktop\整体数据.dta"

xtset province 年份

  //2.1经济矩阵，不带控制变量

xsmle SERI DEI,fe model(sdm) wmat(w)  type(ind) nolog noeffects//最终版本

outreg2 using "C:\Users\liuch\Desktop\3.doc", replace

  //2.2经济矩阵，加入控制变量

xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation ,fe model(sdm) wmat(w)  type(ind) nolog noeffects//最终版本

outreg2 using "C:\Users\liuch\Desktop\4.doc", replace

 //2.3模型结果分解

xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation ,fe model(sdm) wmat(w)  type(ind) nolog effects

outreg2 using "C:\Users\liuch\Desktop\模型分解2.doc", replace




//稳健性检验


//更换解释变量

//邻接矩阵
use "C:\Users\liuch\Desktop\邻近矩阵.dta"

spatwmat using"C:\Users\liuch\Desktop\邻近矩阵.dta",name(w) standardize

use "C:\Users\liuch\Desktop\整体数据.dta"

xtset province 年份

xsmle SERI DEI2 TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation ,fe model(sdm) wmat(w)  type(both) nolog noeffects

outreg2 using "C:\Users\liuch\Desktop\1.doc", replace


//经济矩阵

use "C:\Users\liuch\Desktop\经济矩阵.dta"

spatwmat using"C:\Users\liuch\Desktop\经济矩阵.dta",name(w) standardize

use "C:\Users\liuch\Desktop\整体数据.dta"

xtset province 年份

xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation ,fe model(sdm) wmat(w)  type(ind) nolog noeffects

outreg2 using "C:\Users\liuch\Desktop\1.doc", replace

//工具变量(数据准备)

use "C:\Users\liuch\Desktop\邻近矩阵.dta"

spatwmat using"C:\Users\liuch\Desktop\邻近矩阵.dta",name(w) standardize

use "C:\Users\liuch\Desktop\整体数据.dta"

xtset province 年份


//2SLS回归


ivreg2 SERI (DEI = postoffice) ThermalPower PDensity NEISI CoalInvestment, robust
estimates store Model_2SLS
esttab Model_2SLS using "C:\\Users\\liuch\\Desktop\\6.rtf", replace


//异质性分析

use "C:\Users\liuch\Desktop\邻近矩阵.dta"

spatwmat using"C:\Users\liuch\Desktop\邻近矩阵.dta",name(w) standardize

use "C:\Users\liuch\Desktop\整体数据.dta"

xtset province 年份

xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation, fe model(sdm) wmat(w) durbin(DEI) type(ind) nolog noeffects if region == "东部"

by region: xsmle SERI DEI TIGR NEPO PCGDP NEISI PerRoad Patents PDensity IEnterprises CoalInvestment PTransportation, fe model(sdm) wmat(w) durbin(DEI) type(ind) nolog noeffects


