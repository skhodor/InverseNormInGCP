# Calculating the Inverse Normal Using BigQuery SQL

**Introduction**<br>
GCP's BigQuery SQL has many powerful built-in functions, but in many cases, the user might find themselves needing to use a function that is not present.

The cumulative distribution function (CDF) of a normal distribution function is not present in GCP, but can be built by understanding the probability distribution equation for a normal distribution. This is:

$f(x) = \frac{1}{\sqrt{2\pi\sigma^2} }*exp(-\frac{(x-\mu)^2}{2\sigma^2})$

where $`\mu`$ and  $`\sigma`$ are the mean and standard deviation of the distribution, respectively.  The CDF is then found by integrating this function from $`-\infty`$ to a value $`x`$, which gives:

$$F(x) = \int_{-\infty}^{x} \frac{1}{\sqrt{2\pi\sigma^2} }*exp(-\frac{(x'-\mu)^2}{2\sigma^2})  dx' = \frac{1}{2} \left[ 1 + \text{erf} \left( \frac{x - \mu}{\sigma \sqrt{2}} \right) \right]$$

where $`erf(...)`$ represents the error function, defined as:

$$\text{erf}(z) = \frac{2}{\sqrt{\pi}} \int_0^z e^{-t^2} \, dt$$

**Example:**<br>
If $`\mu = 70`$ and  $`\sigma = 4.5`$, the CDF of the normal distribution at $`x = 75.76`$ will be $`F(75.76) = 0.9`$.
This solution can be found using a calculator. 

In Microsoft Excel, this can be found by using the built-in function
=NORMDIST(75.76, 70, 4.5, FALSE) $`\approx`$ 0.9

To generate the normal distribution CDF in BQ, there are a few resources online which provide a basis of how this can be done: [following](https://stackoverflow.com/questions/50817194/generate-normally-distributed-series-using-bigquery).

**Generating the Inverse Normal Distribution in BQ SQL**<br>
So what about the inverse normal distribution? How could we get this in BQ?

Using the example mentioned above, imagine we had $`F = 0.9`$, $`\mu = 70`$, and  $`\sigma = 4.5`$, but we wanted to solve for $`x`$ using BQ SQL? From the above example, we already know that the solution will $`x = 75.76`$, but we wish to generalize this to solve for any $`x`$ given any permutation of values of $`F`$, $`\mu`$, and  $`\sigma`$.

To do this, we first need solve the equation expressing $`F(x)`$ above for $`x`$. This gives us

$$x = \mu + \sigma \sqrt{2} \, \text{erf}^{-1} \left( 2F(x) - 1 \right)$$

Since the inverse error function is not built-in BigQuery, we can use the MacLaurin Series of the inverse error function to approximate the function. This is:

$$\text{erf}^{-1}(z) = \sum_{n=0}^{\infty} \frac{\sqrt{\pi}}{2} \frac{c_n}{2n+1} z^{2n+1}$$ 

where $`c_n`$ satisfies the recursion relation:

$$c_n = \sum_{k=0}^{n-1} \frac{c_k c_{n-1-k}}{(k+1)(2k+1)}$$ 

with the initial condition $`c_0$ = \frac{\sqrt{\pi}}{2}`$.

**Code**
In the provided code, I use the above relationship to obtain the inverse normal distribution given any $`F`$, $`\mu`$, and  $`\sigma`$. 

I use the first four terms of the following recursion where n = 0, 1, 2, 3 $$\frac{\sqrt{\pi}}{2} \frac{c_n}{2n+1}$$ These are $1$, $1$, $\frac{5}{3}$, and $\frac{127}{90}$. These are provided in an array within the code.

To get more exact answers for the inverse normal distribution, one can consider calculating/adding more of the coefficents within the recursion to the array. Further, one can consider using the Taylor Series expanded at a value close to $2F-1$ to get accuracy to more decimal places.

When using running the attached BigQuery SQL code using the above considered example of $`F = 0.9`$, $`\mu = 70`$, and  $`\sigma = 4.5`$, we are able to obtain an approximate value of $`x = 75.76`$ in BigQuery as shown below.



![Image](https://github.com/users/skhodor/projects/1/assets/77984394/b436387b-fbf4-490a-9314-39cc760a2185)
