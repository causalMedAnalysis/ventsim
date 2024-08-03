{smcl}
{* *! version 0.1, 1 July 2024}{...}
{cmd:help for ventsim}{right:Geoffrey T. Wodtke}
{hline}

{title:Title}

{p2colset 5 18 18 2}{...}
{p2col : {cmd:ventsim} {hline 2}}analysis of interventional effects using simulation and general linear models{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmd:ventsim} {depvar} {ifin} [{it:{help weight:pweight}}] {cmd:,} 
{cmdab:dvar(}{it:{help varname:varname}}{cmd:)}
{cmdab:mvar(}{it:{help varname:varname}}{cmd:)}
{cmdab:lvar(}{it:{help varlist:varlist}}{cmd:)}
d(#) dstar(#) m(#) 
mreg(string) yreg(string) lreg(string) nsim(integer) 
[{cmdab:cvar(}{it:{help varlist:varlist}}{cmd:)} 
{opt nointer:action} {opt cxd} {opt cxm} {opt lxm} 
{opt reps(integer)} 
{cmdab:strata(}{it:{help varname:varname}}{cmd:)}
{cmdab:cluster(}{it:{help varname:varname}}{cmd:)}
{opt level(cilevel)} {opt seed(passthru)} {opt detail}]


{p2coldent:* {opt depvar}}specify the outcome variable.{p_end}

{p2coldent:* {opt dvar}{cmd:(}{it:varname}{cmd:)}}specify the treatment (exposure) variable.{p_end}

{p2coldent:* {opt mvar}{cmd:(}{it:varname}{cmd:)}}specify the mediator variable.

{p2coldent:* {opt lvar}{cmd:(}{it:varlist}{cmd:)}}specify the post-treatment covariates (i.e., exposure-induced 
confounders) to be included in the analysis, which may be continuous, binary (0/1), or counts.

{p2coldent:* {opt d}{cmd:(}{it:#}{cmd:)}}set the reference level of treatment.{p_end}

{p2coldent:* {opt dstar}{cmd:(}{it:#}{cmd:)}}set the alternative level of treatment.{p_end}

{p2coldent:* {opt m}{cmd:(}{it:#}{cmd:)}}set the level of the mediator at which the controlled direct effect 
is evaluated. If there is no treatment-mediator interaction, then the controlled direct effect
is the same at all levels of the mediator and thus an arbitary value can be chosen.{p_end}

{p2coldent:* {opt mreg}{cmd:(}{it:string}{cmd:)}}specify the form of regression model to be estimated for the mediator. 
Options are {opt reg:ress}, {opt log:it}, or {opt poi:sson}.{p_end}

{p2coldent:* {opt yreg}{cmd:(}{it:string}{cmd:)}}specify the form of regression model to be estimated for the outcome. 
Options are {opt reg:ress}, {opt log:it}, or {opt poi:sson}.{p_end}

{p2coldent:* {opt lreg}{cmd:(}{it:string}{cmd:)}}specify the form of the regression models to be estimated for the 
exposure-induced confounders. If there are multiple exposure-induced confounders, a list of models must be supplied.
The order of the models supplied in this list should correspond to the order of the confounders supplied in {opt lvar}{cmd:(}{it:varlist}{cmd:)}}. 
Options are {opt reg:ress}, {opt log:it}, or {opt poi:sson}.{p_end}

{title:Options}

{synopt:{opt nsim(integer)}}specify the number of simulated values generated for the potential outcomes (the default is 200). {p_end}

{synopt:{opt cvar}{cmd:(}{it:varlist}{cmd:)}}specify the baseline covariates to be included in the analysis. {p_end}

{synopt:{opt cat}{cmd:(}{it:varlist}{cmd:)}}specify which of the {cmd: cvars} and {cmd: lvars} should be handled as categorical variables. {p_end}

{synopt:{opt nointer:action}}specify that a treatment-mediator interaction should not be included in the outcome model. {p_end}

{synopt:{opt cxa}}specify that treatment-covariate interactions should be included in all models. {p_end}

{synopt:{opt cxm}}specify that mediator-covariate interactions should be included in the outcome model. {p_end}

{synopt:{opt lxm}}specify that mediator-posttreatment interactions should be included in the outcome model. {p_end}

{synopt:{opt reps(integer 200)}}specify the number of bootstrap replications (the default is 200). {p_end}

{synopt:{opt strata(varname)}}specify a variable that identifies resampling strata for the bootstrap. {p_end}

{synopt:{opt cluster(varname)}}specify a variable that identifies resampling clusters for the bootstrap. {p_end}

{synopt:{opt level(cilevel)}}specify the confidence level for constructing bootstrap confidence intervals (the default is 95%). {p_end}

{synopt:{opt seed(passthru)}}specify the seed for bootstrap resampling. {p_end}

{synopt:{opt detail}}print the fitted models for the mediator and outcome in addition to the effect estimates. {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}
* required option.
{p_end}
{marker weight}{...}
{p 4 6 2}{opt pweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}

{title:Description}

{pstd}{cmd:ventsim} estimates interventionl direct and indirect effects  using simulation and general linear models 
for the mediator, outcome, and any exposure-induced confounders. Models for each of the exposure-induced confounders
are estimated. Then, a model for the mediator conditional on treatment and baseline covariates (if specified) is estimated, 
followed by a model for the outcome conditional on treatment, the mediator, the baseline covariates, and the exposure-induced
confounders. These models may be linear, logistic, or poisson regressions. These models are then used to simulate potential 
outcomes and construct estimates of the interventional direct and indirect effect, the overall effect, and the controlled 
direct effect.

{pstd}{cmd:ventsim} provides estimates of overall, interventional direct, interventional indirect, and controlled direct effects.{p_end}


{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. use nlsy79.dta} {p_end}

{pstd} no interaction between treatment and mediator, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. ventsim std_cesd_age40, dvar(att22) mvar(faminc_adj_age3539) lvar(ever_unemp_age3539) cvar(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(10.5) mreg(regress) yreg(regress) lreg(logit) nointer nsim(200) reps(200)} {p_end}

{pstd} treatment-mediator interaction, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. ventsim std_cesd_age40, dvar(att22) mvar(faminc_adj_age3539) lvar(ever_unemp_age3539) cvar(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(10.5) mreg(regress) yreg(regress) lreg(logit) nsim(200) reps(200)} {p_end}

{pstd} treatment-mediator interaction, all two-way interactions, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. ventsim std_cesd_age40, dvar(att22) mvar(faminc_adj_age3539) lvar(ever_unemp_age3539) cvar(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(10.5) mreg(regress) yreg(regress) lreg(logit) cxd cxm lxm nsim(200) reps(200)} {p_end}

{pstd} treatment-mediator interaction, multiple exposure-induced confounders, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. ventsim std_cesd_age40, dvar(att22) mvar(faminc_adj_age3539) lvar(ever_unemp_age3539 cesd_94) cvar(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(10.5) mreg(regress) yreg(regress) lreg(logit regress) nsim(200) reps(200)} {p_end}


{title:Saved results}

{pstd}{cmd:ventsim} saves the following results in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}matrix containing the effect estimates{p_end}


{title:Author}

{pstd}Geoffrey T. Wodtke {break}
Department of Sociology{break}
University of Chicago{p_end}

{phang}Email: wodtke@uchicago.edu


{title:References}

{pstd}Wodtke GT, and Zhou X. Causal Mediation Analysis. In preparation. {p_end}

{title:Also see}

{psee}
Help: {manhelp regress R}, {manhelp logit R}, {manhelp poisson R}, {manhelp bootstrap R}
{p_end}
