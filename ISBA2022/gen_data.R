# lm data
set.seed(1234)

n = 11
m = 6
b = 2
x = seq(0, 1, length.out = n)
y = m*x + b + rnorm(n)

d = data.frame(x = x, y = round(y,4))

write.csv(d, "data/lm.csv", row.names = FALSE)


