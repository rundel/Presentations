## **UseR 2020** - `livecode`: broadcast your code from R

## Abstract

In this talk I will discuss `livecode`, a new R package for broadcasting code for live coding demonstrations. This package implements a lightweight asynchronous webserver (via `httpuv` and `later`) to dynamically publish the content of a source file (i.e. `.R` or `.Rmd`) from R as it is edited live. The goal of this package is to encourage an audience to more actively engage with the code produced during a live coding session by removing the need to type along with the presenter. 

In the talk I will provide a live demonstration of this functionality and explain its pedagogical implications for teaching programming. I will also discuss some of the technical implementation details, particularly in regard to the implications for scalability and accessibility of these tools. Finally, I will discuss recent improvements for broadcasting messages and timers to users as well as future plans for enabling two-way communication for the purpose of implementing quizzes / polls.
