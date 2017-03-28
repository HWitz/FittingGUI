# FittingGUI
GUI for Fitting Models to measured Impedance Spectra with focus on Lithium Ion Batteries

This graphical interface for Matlab has been used at ISEA for 
the evaluation of impedance spectra and time domain characterization measurements for many years. 
It includes a comprehensive model database, which allows you to easily integrate 
your own impedance model structures. For the individual elements, both formulations 
in the frequency domain for the impedance fitting as well as implementations in the 
time domain are stored. The latter are required for the fitting of the time 
domain large signal behavior. The unique feature of this tool is the possibility 
to parameterize a physical Newman model separately for the anode and the cathode. 
Separation takes place using the DRT (distribution of relaxation times). 
The individual model elements, the physical model, the time domain implementations 
and the procedure for the DRT process fitting are described in detail in the dissertation
of Heiko Witzenhausen.

Overview
==========
A brief overview of how the FittingGUI looks like is presented below
[![Teaser](https://img.youtube.com/vi/918e_LqCn5g/0.jpg)](https://www.youtube.com/watch?v=918e_LqCn5g "Teaser FittingGUI")
![Overview](documentation/overview.png "Overview")
The FittingResult GUI allows to see an overview of the fitting results over several states (Temperature, SOC)
![FittingResults-GUI](documentation/FittingResults.png "FittingResults-GUI")

Featured Projects
=================
Parts of the framework are used in the following projects:
1. Toolbox Speichersysteme, Energy Storage Toolbox 
  * Förderkennzeichen: 64.65.69-EM-2011A

2. Offenes Batterie-Alterungs-Tool zur Lebensdauerprognose von Batteriepacks unter Berücksichtigung von Unsicherheiten und Streuung von Zellqualität,
  * Website: [openbat](https://openbat.de)
  * Förderkennzeichen: 0325905

License
=========
The ISEA-Framework is published under the MIT License.
For commercial use, a different license is available.
Further information can be requested at post@isea.rwth-aachen.de .

More information can be found [here](LICENSE.TXT).