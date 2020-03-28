Covid19PredictionStudies
=============

<img src="https://img.shields.io/badge/Study%20Status-Started-blue.svg" alt="Study Status: Started">

- Analytics use case(s): **Patient-Level Prediction**
- Study type: **Clinical Application**
- Tags: **-**
- Study lead: **Jenna Reps, Ross Williams, Peter Rijnbeek**
- Study lead forums tag: **[jreps](https://forums.ohdsi.org/u/jreps), [RossW](https://forums.ohdsi.org/u/RossW), [Rijnbeek](https://forums.ohdsi.org/u/Rijnbeek)**
- Study start date: **Mar 26, 2020**
- Study end date: **-**
- Protocol: **-**
- Publications: **-**
- Results explorer: **-**

This study repo will include all the prediction model development and validation packages from the covid-19 OHDSI study-a-thon


The Corona Virus Disease 2019 (COVID-19), which started in late 2019 as an epidemic in Wuhan, Hubei Province, China, has been classified as a pandemic and a public health emergency of international concern by the World Health Organisation (WHO) in January 2020.

The OHDSI community has initiated a study-athon to attempt to provide evidence to healthcare providers, governments and patients to best aid in the understanding and treatment of the pandemic. 


This specific repository contains the work of the Patient-Level Prediction group in aiding this effort.

There are 4 packages contained here:

Package 1: <todo link> Protocol 1: <todo link>
The objective of this study is to inform the triage and early management of patients with diagnosed or suspected COVID-19, by developing and validating a patient-level prediction model to identify adult patients at risk of hospitalization after presenting with flu or flu-like symptoms at a general practitioner (GP), outpatient (OP) or emergency room (ER) visit.  

Package 2: <todo link>
The objective of this study is to identify the most high risk patients amongst those who have been admitted to hospital with pneumonia and COVID-19.  

Package 3: <todo link>
This package contains an existing model that was identffied as a candidate for validation in the COVID-19 setting.

Package 4: <todo link>
This package contains the software used in the development of a simple model to answer the two prediction questions. This was done so as to increase the usability of the models in practice by reducing the featur set, whilst being provided with a benchmark to measure against.
















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


