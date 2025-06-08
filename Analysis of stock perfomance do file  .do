use "/Users/kenatuitoek/Desktop/Applied Stats/BBY.dta"                      
browse 

* declare the data set time-series data 
tsset date 

*generates a new variable equal to the log of the price for the stock
generate ly=ln(y)

*generates a new variable equal to the log of the price for the S&P
generate lsap=ln(sap)

*takes the first difference of the log of the price for the stock
generate dly=d.ly

*takes the first difference of the log of the price for the S&P
generate dlsap=d.lsap

summarize
centile lsap, centile(10,50,90) 
centile dly , centile(10,50,90) 
centile dlsap, centile(10,50,90)
centile ly, centile(10,50,90) 

summarize dly 
summarize dlsap 

tabstat dlsap, s(count mean semean range skewness kurtosis iqr)

tabstat dly, s(count mean semean range skewness kurtosis iqr)

* plotting box plot - ly and lsap 
graph box ly
graph box lsap 
graph box dly 
graph box dlsap 

* find count of variable 
tab language
tab dlsap, s(fre) 
* timeseries graph for adjusted close price 
tsline ly

* timeseries graph for adjusted close price - sap 
tsline lsap

* timeseries on difference 
tsline d.ly 
tsline d.lsap
tsline dly, title(BBY Weekly Returns) tline(2016w27) 
tsline dlsap, title(S&P500 Weekly Returns) tline(2016w27)

* generate lag operator on adjusted close
gen lag_BBY = L.ly 

* generate return stock return 
gen ret_ly = d.ly/L.ly

* timeseries graph for strock return 
tsline ret_ly

* regression analysis 
regress dly dlsap 


* identifying outliers and extreme values 
summarize dly, detail

* using scalars to define outlier/ extreme value boundaries 
scalar q1 = r(p25)
scalar q3 = r(p75)
scalar iqr = q3-q1
scalar il = iqr*1.5 
scalar iu = iqr*3

* list observations that lie as positive and negative outliers , positive and negative extremes , respectively 
list if dly>q3+il & dly<q3+iu
list if dly<q1-il & dly>q1-iu
list if dly>q3+iu & dly<.
list if dly<q1-iu

* kernel density plot and P-P Plot 
kdensity dly
pnorm dly 

* sktest - if normal assumptions of skewness and kurtosis are satisfied + sensitivity to the extreme value 
sktest dly 
sktest dly if dly > -0.0000

* swilk test 
swilk dly 
swilk dly if dly > -0.0000


 bayes
 
 * summary stats for earlier observations and 2nd half of observations 
 summarize dly if timedum == 0 
 summarize dly if timedum == 1 
 tabstat dly, by(timedum) s(n mean sd min max)
 
 * oneway/ anova technique ... though not normally distributed 
 oneway dlsap dly, tabulate 
 
tabstat dly, by(timedum == 0) s(n mean sd min max p50)

* conducting a non parametric test - Mann-Whitney U test 
ranksum dly, by(timedum)
* median test 
median dly, by(timedum) exact 

* testing if BBY is aggressive or not - compared to critical value 5%
display (1.124342-1)/.1852687
display invttail(249,0.05)

*test of unitary effect of S&P500 on BBY returns 
test dlsap=1 

