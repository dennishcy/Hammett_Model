# Hammett Model
**1. Introduction**
Hammett values are based on the Hammett equation and are originally derived by comparing the pKa’s of benzoic acids substituted with various groups on the benzene ring to the pKa of the parent benzoic acid.  Hammett values are now tabulated in order to quantify the substituent effect of these groups and are now used widely in physical organic chemistry as a mechanistic tool.  Depending on the position of substitution, values are divided into two categories: m (meta) and p (para).  For more details, see: https://en.wikipedia.org/wiki/Hammett_equation

**2. Aim**
The goal of this project is to develop a model for predicting Hammett values.  By devising appropriate features to capture the substituent effect, including inductive and resonance effect, various regression models are tested for the data set.

**3. Data Source**
The data used in this project is extracted from a classic review on Hammett studies: Hansch, C.; Leo, A.; Taft, R. W. A Survey of Hammett Substituent Constants and Resonance and Field Parameters. *Chem. Rev.* **1991**, 91, 165-195, doi: 10.1021/cr00002a004.

**4. Data Selection**
In the original review, there are totally 530 entries of data (Table I).  460 entries were left and subjected for analysis after the data with the following characters are excluded:
+ substituents containing net charges
+ substituents containing carborane 
+ substituents containing transition metals



**5. Features**
In order to capture both the inductive and resonance effect, the following features are devised: 
+ **lp2p**: whether a lone pair of 2p orbital exists on the first immediate atom attached to the benzene ring
+ **lp3p**: whether a lone pair of 3p orbital exists on the first immediate atom attached to the benzene ring
+ **pi_conj**: whether the benzene ring is conjugated to another pi-system
+ **en1**: sum of Pauling electronegativity of atoms 1 bond away from the benzene ring
+ **en2**: sum of Pauling electronegativity of atoms 2 bonds away from the benzene ring
+ **en3**: sum of Pauling electronegativity of atoms 3 bonds away from the benzene ring
+ **en4**: sum of Pauling electronegativity of atoms 4 bonds away from the benzene ring
+ **en5**: sum of Pauling electronegativity of atoms 5 bonds away from the benzene ring

Note: **lp2p**, **lp3p**, and **pi_conj** are categorical variables where 0 denotes no and 1 denotes yes.  For **en1-5**, if the atoms are connected through multiple bonds, then their electronegativity are calculated multiple times.  For example, for a carbon connected through a double bond, its electronegativity will be counted twice (2.55x2=5.10).  Similarly, in a ring system, the atoms are counted multiple times every time encountered in bonding path.

**6. Models**
The following models were tested in this project:
+ Linear regression (lm)
+ k-nearest neighbors (knn)
+ Random forest (rf)
+ Support vector machine (svm)
