# eventstudySuite
Interactive data exploration and stock price predictions based on news and company events

## Test equation
![First equation](https://latex.codecogs.com/gif.latex?\dpi{400}\alpha&space;+&space;\frac{2\beta}{\gamma})

![Second equation](http://latex.codecogs.com/gif.latex?%5Cfrac%7Ba%7D%7Bb%7D)

![Third equation](https://latex.codecogs.com/svg.latex?\sum_{i=1}^{n}sqrt(3sin(i)))

![Third equation](https://latex.codecogs.com/gif.latex?\dpi{200}\sum_{i=1}^{n}\sqrt(3sin(i)))

![alt text](https://user-images.githubusercontent.com/44523247/87425885-b3e8a000-c5de-11ea-80d3-b59ef10f5c52.png)

![alt1](https://wikimedia.org/api/rest_v1/media/math/render/svg/583cca32cbdd337bcc4b07c5748fb2ba2c1184c8)

If an autoregressive moving average model (ARMA) model is assumed for the error variance, the model is a generalized autoregressive conditional heteroskedasticity (GARCH) model.[2]

In that case, the GARCH (p, q) model (where p is the order of the GARCH terms {\displaystyle ~\sigma ^{2}}~\sigma ^{2} and q is the order of the ARCH terms {\displaystyle ~\epsilon ^{2}}~\epsilon ^{2} ), following the notation of the original paper, is given by

{\displaystyle y_{t}=x'_{t}b+\epsilon _{t}}{\displaystyle y_{t}=x'_{t}b+\epsilon _{t}}

{\displaystyle \epsilon _{t}|\psi _{t-1}\sim {\mathcal {N}}(0,\sigma _{t}^{2})}{\displaystyle \epsilon _{t}|\psi _{t-1}\sim {\mathcal {N}}(0,\sigma _{t}^{2})}

{\displaystyle \sigma _{t}^{2}=\omega +\alpha _{1}\epsilon _{t-1}^{2}+\cdots +\alpha _{q}\epsilon _{t-q}^{2}+\beta _{1}\sigma _{t-1}^{2}+\cdots +\beta _{p}\sigma _{t-p}^{2}=\omega +\sum _{i=1}^{q}\alpha _{i}\epsilon _{t-i}^{2}+\sum _{i=1}^{p}\beta _{i}\sigma _{t-i}^{2}}{\displaystyle \sigma _{t}^{2}=\omega +\alpha _{1}\epsilon _{t-1}^{2}+\cdots +\alpha _{q}\epsilon _{t-q}^{2}+\beta _{1}\sigma _{t-1}^{2}+\cdots +\beta _{p}\sigma _{t-p}^{2}=\omega +\sum _{i=1}^{q}\alpha _{i}\epsilon _{t-i}^{2}+\sum _{i=1}^{p}\beta _{i}\sigma _{t-i}^{2}}

Generally, when testing for heteroskedasticity in econometric models, the best test is the White test. However, when dealing with time series data, this means to test for ARCH and GARCH errors.

Exponentially weighted moving average (EWMA) is an alternative model in a separate class of exponential smoothing models. As an alternative to GARCH modelling it has some attractive properties such as a greater weight upon more recent observations, but also drawbacks such as an arbitrary decay factor that introduces subjectivity into the estimation.
