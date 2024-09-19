{smcl}
{* *! version 0.1, 1 July 2024}{...}
{cmd:help for ventsim}{right:Geoffrey T. Wodtke}
{hline}

{title:Title}

{p2colset 5 18 18 2}{...}
{p2col : {cmd:ventsim} {hline 2}}analysis of interventional direct and indirect effects using simulation and general linear models{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmd:ventsim} {depvar} {ifin} [{it:{help weight:pweight}}]{cmd:,} 
{opt dvar(varname)}
{opt mvar(varname)}
{opt lvars(varlist)}
{opt d(#)} 
{opt dstar(#)} 
{opt m(#)} 
{opt mreg(string)} 
{opt yreg(string)} 
{opt lregs(string)} 
{opt nsim(integer)} 
{opt cvars(varlist)}
{opt nointer:action} 
{opt cxd} 
{opt cxm} 
{opt lxm} 
{opt detail}
[{it:{help bootstrap##options:bootstrap_options}}]


{p2coldent:* {opt depvar}}specify the outcome variable.{p_end}

{p2coldent:* {opt dvar(varname)}}specify the treatment (exposure) variable.{p_end}

{p2coldent:* {opt mvar(varname)}}specify the mediator variable.

{p2coldent:* {opt lvars(varlist)}}specify the post-treatment covariates (i.e., exposure-induced confounders) to be included in the analysis, which may be continuous, binary (0/1), or counts.

{p2coldent:* {opt d(#)}}set the reference level of treatment.{p_end}

{p2coldent:* {opt dstar(#)}}set the alternative level of treatment.{p_end}

{p2coldent:* {opt m(#)}}set the level of the mediator at which the controlled direct effect is evaluated.{p_end}

{p2coldent:* {opt mreg(string)}}specify the form of regression model to be estimated for the mediator. Options are {opt regress}, {opt logit}, or {opt poisson}.{p_end}

{p2coldent:* {opt yreg(string)}}specify the form of regression model to be estimated for the outcome. Options are {opt regress}, {opt logit}, or {opt poisson}.{p_end}

{p2coldent:* {opt lregs(string)}}specify the form of the regression models to be estimated for the exposure-induced confounders. If there are multiple exposure-induced confounders, a list of models must be supplied.
The order of the models supplied in this list should correspond to the order of the confounders supplied in {opt lvar(varlist)}. Options are {opt regress}, {opt logit}, or {opt poisson}.{p_end}

{title:Options}

{synopt:{opt nsim(integer)}}specify the number of simulated values generated for the potential outcomes (the default is 200). {p_end}

{synopt:{opt cvars(varlist)}}specify the baseline covariates to be included in the analysis. {p_end}

{synopt:{opt nointer:action}}specify that a treatment-mediator interaction should not be included in the outcome model. {p_end}

{synopt:{opt cxd}}specify that all two-way treatment-covariate interactions should be included in all models. {p_end}

{synopt:{opt cxm}}specify that all two-way mediator-covariate interactions should be included in the outcome model. {p_end}

{synopt:{opt lxm}}specify that all two-way mediator-posttreatment covariate interactions should be included in the outcome model. {p_end}

{synopt:{opt detail}}print the fitted models for the exposure-induced confounders, mediator, and outcome. {p_end}

{synopt:{it:{help bootstrap##options:bootstrap_options}}}all {help bootstrap} options are available. {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}
* required option.
{p_end}
{marker weight}{...}
{p 4 6 2}{opt pweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}

{title:Description}

{pstd}{cmd:ventsim} estimates interventionl direct and indirect effects using simulation and general linear models 
for the mediator, outcome, and any exposure-induced confounders. It computes inferential statistics using the nonparametric
bootstrap. 

{pstd}Models for each of the exposure-induced confounders, conditional on the exposure and baseline covariates (if specified), are estimated. 
Then, a model for the mediator conditional on treatment and baseline covariates is estimated, followed by a model for the outcome 
conditional on treatment, the mediator, the baseline covariates, and the exposure-induced confounders. These models may be linear, 
logistic, or poisson regressions. The fitted models are then used to simulate potential outcomes and construct estimates of the 
interventional direct and indirect effect, the overall effect, and the controlled direct effect.

{pstd}If using {help pweights} from a complex sample design that require rescaling to produce valid boostrap estimates, be sure to appropriately 
specify the strata(), cluster(), and size() options from the {help bootstrap} command so that Nc-1 clusters are sampled from each stratum 
with replacement, where Nc denotes the number of clusters per stratum. Failing to properly adjust the bootstrap procedure to account
for a complex sample design and its associated sampling weights could lead to invalid inferential statistics. {p_end}

{title:Examples}

{pstd}Setup{p_end}

{phang2}{cmd:. use nlsy79.dta} {p_end}

{pstd} no interaction between treatment and mediator, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. ventsim std_cesd_age40, dvar(att22) mvar(faminc_adj_age3539) lvars(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(10.5) mreg(regress) yreg(regress) lregs(logit) nointer} {p_end}

{pstd} treatment-mediator interaction, percentile bootstrap CIs with default settings, 2000 Monte Carlo draws: {p_end}
 
{phang2}{cmd:. ventsim std_cesd_age40, dvar(att22) mvar(faminc_adj_age3539) lvars(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(10.5) mreg(regress) yreg(regress) lregs(logit) nsim(2000)} {p_end}

{pstd} treatment-mediator interaction, all two-way interactions, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. ventsim std_cesd_age40, dvar(att22) mvar(faminc_adj_age3539) lvars(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(10.5) mreg(regress) yreg(regress) lregs(logit) cxd cxm lxm} {p_end}

{pstd} treatment-mediator interaction, multiple exposure-induced confounders, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. ventsim std_cesd_age40, dvar(att22) mvar(faminc_adj_age3539) lvars(ever_unemp_age3539 cesd_94)} 
			{cmd: cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(10.5) mreg(regress) yreg(regress) lregs(logit regress)} {p_end}


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
