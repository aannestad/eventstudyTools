# eventstudySuite
Interactive data exploration and stock price predictions based on news and company events

This was build for enabling my master's thesis in Economic Analysis at the Norwegian School of Economics (NHH). Given stock price data and a database of news and events, it has a range of features for empirical inference of how stock prices react to new fundamental information. The examples below is based on the most recent 20,000 events related to the 35 largest companies on the Oslo Stock Exchange. 

<!---[First equation](https://latex.codecogs.com/gif.latex?\dpi{400}\alpha&space;+&space;\frac{2\beta}{\gamma})--->

<!---[Second equation](http://latex.codecogs.com/gif.latex?%5Cfrac%7Ba%7D%7Bb%7D)--->

<!---[Third equation](https://latex.codecogs.com/svg.latex?\sum_{i=1}^{n}sqrt(3sin(i)))--->

<!---[Third equation](https://latex.codecogs.com/gif.latex?\dpi{200}\sum_{i=1}^{n}\sqrt(3sin(i)))--->

<!---[alt1](https://wikimedia.org/api/rest_v1/media/math/render/svg/583cca32cbdd337bcc4b07c5748fb2ba2c1184c8)--->

## Highlight 1: Event windows
Automatic generation of **event windows**. As an example, here is the interesting event of *DIVIDEND PAYMENTS*, indicating the profitable strategy of buying ahead of dividend payouts:

![](Screenshots/eventwindow.png)
The **event windows** can easily be tailored and explored interactively to pursuit any news or events of interest, finding possible market inefficiencies ranging from effects stemming from insider trading to naturally occuring trading oppurtunities.

<!---[](Screenshots/eventperiod.png)--->

## Highlight 2: Aggregation of event statistics
It can for example reveal how, on average, each type of event impact stock prices *that* day (by abnormal return (AR)): 

![](Screenshots/eventstudy.png)

## How abnormal return (AR) is calculated

First, due to **volatility clustering**, seen in grey in the figure below (for the company YARA), adjustment is done by using generalized autoregressive conditional heteroskedasticity [(GARCH)](https://en.wikipedia.org/wiki/Autoregressive_conditional_heteroskedasticity):

![](Screenshots/yaraAR.png)

Then, a dynamic **market model** handling varying time-dependency (solving the limitations of static OLS based [CAPM](https://en.wikipedia.org/wiki/Capital_asset_pricing_model), using a [Kalman filter], inspired by the work of [Mergner and Bulla] (https://www.tandfonline.com/doi/full/10.1080/13518470802173396), for examples models the (quite varying) market **beta** of company YARA as seen below:

![](Screenshots/yaraKFGARCH.png)

![](Screenshots/discrstats.png)







