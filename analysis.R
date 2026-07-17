#Volatility Estimation
# Load required libraries
library(xts)
library(highfrequency)
library(data.table)
# Loading dataset
data <- fread("Final_Dataset.csv
")
asks <- as.numeric(data$askPrice)
bids <- as.numeric(data$bidPrice)
mids <- 0.5*bids + 0.5*asks
summary(data$price)
str(data$price)
data$price <- as.numeric(data$price)
data <- data[!is.na(data$price), ] # Keep rows where 'price' is not NA
pmin <- min(data$price, na.rm = TRUE) # Minimum value of price
pmax <- max(data$price, na.rm = TRUE) # Maximum value of price
plot(as.numeric(data$price),col=
"red"
, type=
"l"
, ylab=
"Trade price"
,
xlab=
"Trade #"
, main=
"Trade price"
, ylim=c(pmin-0.1,pmax+0.1))
lines(mids, type=
"l"
, col=
"blue")
plot(as.numeric(data$size),col=
"red"
, type=
"l"
,
ylab=
"Trade size"
,
xlab=
"Trade #"
, main=
"Trade volume"
, ylim=c(0,100000))
prices<- as.numeric(data$price)
# Realized Variance Function
realizedVar <- function(q){rCov(diff(prices, lag=q, differences=1))/q}
# compute the signature plot RV(lag)
rv_data <- NULL
for(q in 1:500){
rv_data <- c(rv_data, sqrt(realizedVar(q))) # Took square root for volatility
}
plot(rv_data, type =
"l"
, main=
"Signature plot (Volatility)"
,
xlab=
"Lag (q)"
, ylab=
"Realized Volatility
")
n.trades <- dim(data)[1]
q5min <- n.trades*5/1440 # for Bitcoin's 24/7 trading
rv5 = realizedVar(q5min)
sqrt(rv5)
annualized_volatility <- sqrt(252) * sqrt(rv5) / mean(prices)
cat("Annualized Volatility (%):
"
, annualized_volatility * 100,
"\n")
# Roll Model Volatility using log prices
dp <- diff(log(prices))
# compute the covariance of the price changes, for the Roll model analysis
covdp <- acf(dp, lag.max=10,
type=
"covariance"
, plot=TRUE,main=
"Autocovariance of price changes")
gamma0 <- covdp$acf[1] # Lag 0
gamma1 <- covdp$acf[2] # Lag 1
# Roll model variance and volatility
sig2u = gamma0 + 2*gamma1
rvRoll <- sig2u*n.trades
sigRoll <- sqrt(sig2u*n.trades)
rvRoll <- sig2u * n_trades # Variance
sigRoll <- sqrt(rvRoll) # Volatility)
annualized_roll_volatility <- sqrt(252) * sigRoll / mean(prices)
# Plotting realized volatility and Roll model estimates
rv_data <- sapply(1:500, function(q) sqrt(sum(diff(prices, lag=q)^2) / length(diff(prices, lag=q))))
plot(rv_data, type =
"l"
, main =
xlab =
"Lag (q)"
, ylab =
"Signature Plot with Roll Model Volatility
"
"Realized Volatility
"
, ylim = c(0, max(rv_data)))
,
abline(h = sqrt(sig2u), col =
abline(h = rvRoll, col =
"blue"
, lty = 2, lwd = 2) # Roll model volatility
"red"
, lty = 2, lwd = 2) # Roll model realized variance
cat("Roll Model Variance (sig2u):
"
, sig2u,
cat("Roll Model Realized Variance:
"
, rvRoll,
"\n")
"\n")
cat("Roll Model Annualized Volatility (%):
"
, annualized_roll_volatility * 100,
"\n")
#Liquidity Analysis.
data <- data %>% arrange(index)
data$trade_indicator <- ifelse(data$price > lag(data$price), 1,
ifelse(data$price < lag(data$price),
-1, NA))
data$trade_indicator <- tidyr::fill(data, trade_indicator, .direction =
$trade_indicator
head(data[, c("timestamp"
,
"price"
,
"trade_indicator")])
data <- data %>% filter(!is.na(trade_indicator))
head(data)
trade_indicator_counts <- table(data$trade_indicator, useNA =
print(trade_indicator_counts)
data$midpoint_price <- (data$bidPrice + data$askPrice) / 2
data$quoted_spread <- data$askPrice - data$bidPrice
data$effective_spread <- 2 * data$trade_indicator * (data$price -
data$midpoint_price)
"down")
"ifany
")
delay <- 5data$midpoint_delayed <- dplyr::lead(data$midpoint_price, n = delay)
data$realized_spread <- 2 * data$trade_indicator * (data$price -
data$midpoint_delayed)
data$index <- 1:nrow(data)
ggplot(data, aes(x = index, y = quoted_spread)) +
geom_line(color =
"blue"
, size = 0.5) +
labs(
title =
x =
y =
"Quoted Spread Over Trade Index
"
,
"Trade Index
"
"Quoted Spread"
,
) +
theme_minimal() + # Clean theme
theme(
plot.title = element_text(hjust = 0.5, size = 16),
axis.title = element_text(size = 14),
axis.text = element_text(size = 12)
)
ggplot(data, aes(x = index, y = effective_spread)) +
geom_line(color =
"green"
, size = 0.8) +
labs(
title =
x =
y =
"Effective Spread Over Trade Index
"
,
"Trade Index
"
"Effective Spread"
,
) +
theme_minimal() +
theme(
plot.title = element_text(hjust = 0.5, size = 16),
axis.title = element_text(size = 14),
axis.text = element_text(size = 12)
)
ggplot(data, aes(x = index, y = realized_spread)) +
geom_line(color =
"red"
, size = 0.8) +
labs(
title =
x =
y =
"Realized Spread Over Trade Index
"
,
"Trade Index
"
"Realized Spread"
,
) +
theme_minimal() +
theme(
plot.title = element_text(hjust = 0.5, size = 16),
axis.title = element_text(size = 14),
axis.text = element_text(size = 12)
)
data$returns <- c(NA, diff(log(data$price)))data$rolling_vol <- rollapply(data$returns,
width = 20,
FUN = function(x) sd(x, na.rm = TRUE) * sqrt(20),
fill = NA)
data$is_high_vol <- data$rolling_vol > (mean(data$rolling_vol, na.rm = TRUE) +
sd(data$rolling_vol, na.rm = TRUE))
data$trade_indicator <- ifelse(data$price > lag(data$price), 1,
ifelse(data$price < lag(data$price),
-1, NA))
data$trade_indicator <- tidyr::fill(data, trade_indicator, .direction =
"down")$trade_indicator
data$midpoint_price <- (data$bidPrice + data$askPrice) / 2
data$quoted_spread <- data$askPrice - data$bidPrice
data$effective_spread <- 2 * data$trade_indicator * (data$price - data$midpoint_price)
delay <- 5
data$midpoint_delayed <- lead(data$midpoint_price, n = delay)
data$realized_spread <- 2 * data$trade_indicator * (data$price - data$midpoint_delayed)
spread_stats <- data %>%
group_by(is_high_vol) %>%
summarise(
avg_quoted_spread = mean(quoted_spread, na.rm = TRUE),
avg_effective_spread = mean(effective_spread, na.rm = TRUE),
avg_realized_spread = mean(realized_spread, na.rm = TRUE),
n_trades = n()
)
print("Spread Statistics during High vs Normal Volatility Periods:
")
print(spread_stats)
ggplot(data, aes(x = index)) +
geom_line(aes(y = quoted_spread)) +
geom_point(data = subset(data, is_high_vol),
aes(y = quoted_spread),
color =
"red"
,
size = 1) +
labs(title =
"Quoted Spread during High Volatility Periods"
,
x =
"Trade Index
"
,
y =
"Quoted Spread") +
theme_minimal()
ggplot(data, aes(x = index)) +
geom_line(aes(y = effective_spread)) +
geom_point(data = subset(data, is_high_vol),aes(y = effective_spread),
color =
"red"
,
size = 1) +
labs(title =
x =
"Trade Index
"
,
y =
"Effective Spread") +
theme_minimal()
"Effective Spread during High Volatility Periods"
,
ggplot(data, aes(x = index)) +
geom_line(aes(y = realized_spread)) +
geom_point(data = subset(data, is_high_vol),
aes(y = realized_spread),
color =
"red"
,
size = 1) +
labs(title =
"Realized Spread during High Volatility Periods"
,
x =
"Trade Index
"
,
y =
"Realized Spread") +
theme_minimal()
# 6. Optional: Box plots to compare spread distributions
spread_data_long <- data %>%
select(is_high_vol, quoted_spread, effective_spread, realized_spread) %>%
tidyr::gather(key =
"spread_type"
, value =
"spread"
,
-is_high_vol)
ggplot(spread_data_long, aes(x = spread_type, y = spread, fill = is_high_vol)) +
geom_boxplot() +
labs(title =
"Spread Distributions by Volatility Regime"
,
x =
"Spread Type"
,
y =
"Spread Value"
,
fill =
"High Volatility
") +
theme_minimal()