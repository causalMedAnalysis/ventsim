*!TITLE: VENTSIM - analysis of interventional effects using a simulation estimator
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1
*!

program define ventsim, eclass

	version 15	

	syntax varlist(min=1 max=1 numeric) [if][in] [pweight], ///
		dvar(varname numeric) ///
		mvar(varname numeric) ///
		lvars(varlist numeric) ///
		d(real) ///
		dstar(real) ///
		m(real) ///
		mreg(string) ///
		yreg(string) ///
		lregs(string) ///
		[nsim(integer 200)] ///
		[cvars(varlist numeric)] ///
		[NOINTERaction] ///
		[cxd] ///
		[cxm] ///
		[lxm] ///
		[reps(integer 200)] ///
		[strata(varname numeric)] ///
		[cluster(varname numeric)] ///
		[level(cilevel)] ///
		[seed(passthru)] ///
		[saving(string)] ///
		[detail]
		
	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
		}
	
	if ("`detail'" != "") {		
		ventsimbs `varlist' [`weight' `exp'] if `touse' , ///
			dvar(`dvar') mvar(`mvar') lvars(`lvars') cvars(`cvars') ///
			d(`d') dstar(`dstar') m(`m') ///
			mreg(`mreg') yreg(`yreg') lregs(`lregs') /// 
			nsim(1) `nointeraction' `cxd' `cxm' `lxm'
		}
		
	if ("`saving'" != "") {
		bootstrap CDE=r(cde) IDE=r(ide) IIE=r(iie) OE=r(oe), force ///
			reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
			saving(`saving', replace) noheader notable: ///
			ventsimbs `varlist' if `touse' [`weight' `exp'], ///
			dvar(`dvar') mvar(`mvar') lvars(`lvars') cvars(`cvars') ///
			d(`d') dstar(`dstar') m(`m') ///
			mreg(`mreg') yreg(`yreg') lregs(`lregs') ///
			nsim(`nsim') `nointeraction' `cxd' `cxm'
			}

	if ("`saving'" == "") {
		bootstrap CDE=r(cde) IDE=r(ide) IIE=r(iie) OE=r(oe), force ///
			reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
			noheader notable: ///
			ventsimbs `varlist' if `touse' [`weight' `exp'], ///
			dvar(`dvar') mvar(`mvar') lvars(`lvars') cvars(`cvars') ///
			d(`d') dstar(`dstar') m(`m') ///
			mreg(`mreg') yreg(`yreg') lregs(`lregs') ///
			nsim(`nsim') `nointeraction' `cxd' `cxm'
			}

	estat bootstrap, p noheader
	
	di as txt "CDE: controlled direct effect at m=`m'"
	
end ventsim
