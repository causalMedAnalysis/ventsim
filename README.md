# ventsim: A Stata Module to Estimate Interventional Direct and Indirect Effects Using Simulation and General Linear Models

`ventsim` is a Stata module designed to estimate interventional direct and indirect effects using simulation and general linear models. This approach is designed for analyses that include exposure-induced confounders.

## Syntax

```stata
ventsim depvar, dvar(varname) mvar(varname) lvars(varlist) d(#) dstar(#) m(#) mreg(string) yreg(string) lregs(string) nsim(integer) [options]
```

### Required Arguments

- `depvar`: Specifies the outcome variable.
- `dvar(varname)`: Specifies the treatment (exposure) variable.
- `mvar(varname)`: Specifies the mediator variable.
- `lvars(varlist)`: Specifies the post-treatment covariates (exposure-induced confounders).
- `d(#)`: Reference level of treatment.
- `dstar(#)`: Alternative level of treatment.
- `m(#)`: Level of the mediator at which the controlled direct effect is evaluated.

### Models

- `mreg(string)`: Specifies the regression model for the mediator. 
- `yreg(string)`: Specifies the regression model for the outcome.
- `lregs(string)`: Specifies the regression models for the exposure-induced confounders.

Options include `regress`, `logit`, or `poisson`.

### Options

- `cvars(varlist)`: Specifies the baseline covariates to be included in the analysis.
- `nointer`: Specifies whether treatment-mediator interactions should be included in the outcome model.
- `cxd`: Includes treatment-covariate interactions in all models.
- `cxm`: Includes mediator-covariate interactions in the outcome model.
- `lxm`: Includes mediator-posttreatment interactions in the outcome model.
- `detail`: Prints the fitted models for mediator, outcome, and exposure-induced confounders.
- `bootstrap_options`: All `bootstrap` options are available.
  
## Description

`ventsim` fits several models to construct effect estimates:
1. A model for each exposure-induced confounder conditional on treatment and the baseline covariates.
2. A model for the mediator conditional on treatment and the baseline covariates.
3. A model for the outcome conditional on treatment, the mediator, baseline covariates, and exposure-induced confounders.

These models are used to simulate potential outcomes, which are in turn used to estimate the overall, interventional direct, interventional indirect, and controlled direct effects. `ventsim` computes inferential statistics using the nonparametric bootstrap.

`ventsim` allows pweights, but it does not internally rescale them for use with the bootstrap. If using weights from a complex sample design that require rescaling to produce valid boostrap estimates, the user must be sure to appropriately specify the `strata`, `cluster`, and `size` options from the `bootstrap` command so that Nc-1 clusters are sampled within from each stratum, where Nc denotes the number of clusters per stratum. Failure to properly adjust the bootstrap sampling to account for a complex sample design that requires `pweights` could lead to invalid inferential statistics.

## Examples

```stata
// Load data
use nlsy79.dta

// Default settings, single binary exposure-induced confounder
ventsim std_cesd_age40, dvar(att22) mvar(faminc_adj_age3539) lvars(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(10.5) mreg(regress) yreg(regress) lregs(logit)

// Single binary exposure-induced confounder, include all interactions
ventsim std_cesd_age40, dvar(att22) mvar(faminc_adj_age3539) lvars(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(10.5) mreg(regress) yreg(regress) lregs(logit) cxd cxm lxm

// Multiple exposure-induced confounders (the first modeled with logit and second with regress)
ventsim std_cesd_age40, dvar(att22) mvar(faminc_adj_age3539) lvars(ever_unemp_age3539 cesd_92) cvar(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(10.5) mreg(regress) yreg(regress) lregs(logit regress)
```

## Saved Results

`ventsim` saves the following results in `e()`:

- **Matrices**:
  - `e(b)`: Matrix containing the effect estimates.

## Author

Geoffrey T. Wodtke  
Department of Sociology  
University of Chicago

Email: [wodtke@uchicago.edu](mailto:wodtke@uchicago.edu)

## References

- Wodtke GT, and Zhou X. Causal Mediation Analysis. In preparation.

## Also See

- Help: [regress](#), [logit](#), [poisson](#), [bootstrap](#)
