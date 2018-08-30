%% Simulating CLT

%% ---------------------------------------------------------------
%% This script is aimed at simulatiing the central-limit theorem
%% I will try my best to explain the process step by step
%% If you have any great idea or question, please contact me 
%% as soon as possible!
%% E-mail: 16zfdeng5@stu.edu.cn
%% ---------------------------------------------------------------



%% Remove all the variables created before

clear all;


%% n -> ¡ÆXi, the number of i; 
%% sample_size -> Note that in CLT, we treat ¡ÆXi/n as a unit(a single variable), which is 
%%                the average of those i.i.d Xi. Here sample_size is the experiment times 
%%                we want to simulate about ¡ÆXi/n. Just like the n of Bernoulli's random 
%%                variable~(n, p).
%% nbins -> For histogramming. We will see later.

n = 5000; sample_size = 20000; nbins = 500;


%% Here, we use a clever way to simulate our variable ¡ÆXi/n for 10,000
%% times: we use the matlib function unifrnd() to get 300 * 10,000 independent 
%% identically distributed variables(exactly, each of them is a specified
%% real number). We can treat each sum of each column(containing 300 numbers) as a
%% single experiment on the random variable, namely ¡ÆXi(not ¡ÆXi/n). 
%% Note: Here. each Xi is a uniformly distributed random variable on [-0.5, 0.5]

R=unifrnd(-0.5,0.5,[n, sample_size]);


%% Here we sum each column using sum(R, 1). We can get a 1 * 10,000 vector, 
%% each of which is the sum result of each column, namely ¡ÆXi.
%% After summing, we standardize the random variable as following:
%% (¡ÆXi / n - ¦Ì) / (sqrt(n) * ¦Ò)
%% Tips: E[¡ÆXi / n] == ¦Ì, Var(¡ÆXi / n) == ¦Ò^2 / n
%% And it is very clear that the expectation of uniformly distributed random 
%% variable on [-0.5, 0.5] is 0; the varience of it is (1 / 12), and the n
%% here is 300. Note that (sqrt(n) * ¦Ò) == 5

Average = sum(R, 1) / (sqrt(n) * sqrt(1 / 12.0));

%% Calculate the interval while ploting the histogram

interval = (max(Average) - min(Average)) / nbins;


%% You can use the command "doc hist" in matlib command line window to get 
%% more information about hist()

[Yi, X] = hist(Average, nbins);


%% This is a very important step!!!
%% In gereral, we are transforming Y from frequency form to probability
%% density form here, namely, P{¡ÆXi / n ¡Ê a paticular section}
%%
%%
%% Why? Why don't we just calculate P{¡ÆXi / n = i}? 
%% This simple stupid question brothered me for a few hours... :(
%% Here is the reason ---
%%
%% 1. ¡ÆXi / n is a "continuous random varible", technically speaking. 
%%    P{¡ÆXi / n = any paticular real number} == 0. (Properties of integration) 
%% 2. For the reason "..." mentioned above, the only thing we can do if we 
%%    want to measure the mass function of ¡ÆXi / n, is to define the dx so
%%    that f(x)dx makes sense.
%%
%%
%% And the key to obtain the equation below(or, to calculate 
%% P{¡ÆXi / n ¡Ê a paticular section(or interval)}) is that we can calculate
%% the area of each bar and compare each of them to the total area ---
%%
%% the area of a paticular bar: Y(i) * interval; 
%% the area of all of the bars: ¡ÆY(i) * interval == sample_size * (max(Average) - min(Average))
%%
%% Thus, P{¡ÆXi / n ¡Ê a paticular section} == 
%% Y(i) * interval / (sample_size *  interval == Y(i) / sample_size
%%
%%
%% It that enough? But wait... The equation is Y / (sample_size * interval)
%% Why do we need the divisor "interval"?
%% This simple question again brother me for almost half of the day :(
%% Just consider the meaning of the probability density function:
%% By integral, ¡Òf(x)dx == 1, for all probability density function.
%% Which means that the area that the curve covers between itself and the
%% x-axis(I am just talking about the one dimension situation) is always 
%% equal to 1. Note that if we just make Y(i) equal to Y(i) / sample_size,
%% we are just insuring the sum of the height of each bar equal to 1, not
%% the sum of the area of each bar equals to 1, (You can try to plot the histogram
%% without the divisor "interval")which does not accord with the definition
%% of probability density function. So here, note that the total area of all
%% the bars equal to interval * ¡ÆY(i), while Y(i) is fixed. We have to make
%% sure that (interval * ?) == 1. By doing ? = Y(i) / sample_size * (1 / interval)
%% should be enough. ¡Æ? == 1 / interval, thus, interval * ? == 1.

Y = Yi / (sample_size * interval);


%% Plotting the histogram and compare it with the Gaussian distribution

t = -3.5:0.05:3.5;
Z = 1 / sqrt(2 * pi) * exp(-(t.^2) / 2);
hold on;
bar(X, Y, 0.5);
plot(t, Z, 'r');


%% Something more to say
%% The histogram may not perfectly fix the Gaussian distribution,
%% but the key is to compare the area they cover in each small interval.
%% Area is the key, not the height of these curve or bar.