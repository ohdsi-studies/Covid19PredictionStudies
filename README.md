Covid19PredictionStudies
=============

<img src="https://img.shields.io/badge/Study%20Status-Started-blue.svg" alt="Study Status: Started">

- Analytics use case(s): **Patient-Level Prediction**
- Study type: **Clinical Application**
- Tags: **-**
- Study lead: **Jenna Reps, Ross Williams, Peter Rijnbeek**
- Study lead forums tag: **[jreps](https://forums.ohdsi.org/u/jreps), [Rijnbeek](https://forums.ohdsi.org/u/Rijnbeek)**
- Study start date: **Mar 26, 2020**
- Study end date: **-**
- Protocol: **-**
- Publications: **-**
- Results explorer: **-**

This study repo will include all the prediction model development and validation packages from the covid-19 OHDSI study-a-thon


Instructions for particpation
============
To run these studies you need the following software installed:

- [Required] R (version 3.3.0 or higher). 
- [Required] Java (Java can be downloaded from http://www.java.com)
- [optional] Python installation may be required for some of the machine learning algorithms. We advise to
install Python 3.7 using Anaconda (https://www.continuum.io/downloads).

You need to install the latest version of the PatientLevelPrediction R package (version 3.0.15):

```r
install.packages('devtools')
devtools::install_github('ohdsi/PatientLevelPrediction')
```


