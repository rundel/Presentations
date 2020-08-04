Statistical Programming - Homework 1
-------------

Due by 11:59 pm on Friday, October 4th.


<br/>

![fizz buzz](fizzbuzz.png?raw=true)

<br/>

## Task 0 - Watch "Code Smells and Feels" by Jenny Bryan *(0 marks)*

At last year's UseR conference (2018), Jenny Bryan gave a keynote lecture titled "Code Smells and Feels", a video of this lecture is available on [youtube](https://www.youtube.com/watch?v=7oyiPBjLAWY) and a repo containing the slides and related materials is on [github](https://github.com/jennybc/code-smells-and-feels).

This talk is a wonderful introduction into what good R code should look like as well as the process of refactoring existing code to improve its overall quality. I strongly recommend that you take the time to watch the lecture in its entirety. At the very least her slides are worth skimming through.

<br/>

## Task 1 - Re-Implement FizzBuzz *(6 marks)*

For this homework you have been assigned to a group that includes 3-4 students from the class, these groups were constructed randomly and will change for each subsequent team assignment. Your initial repo master branch contains similar files to the hw1.

Your tasks for this assignment is to revise your original implementation(s) of `fizzbuzz` into a single clean / elegant / readable implementation. Your new implementation **must** make use of the additional material we have covered in Lecture 2 (i.e. you *must* use R's S3 object system in your solution). Additionally, I highly recommend adopting the relevant suggestions Jenny made in her talk to improve and streamline your implementation.

In other words, your `fizzbuzz` function must now be implemented as

```r
fizzbuzz = function(v) {
  UseMethod("fizzbuzz")
}
```

and you and your team should now implement the additional function(s) necessary to make this work.


<br/>

## Task 2 - FizzBuzz validation *(4 marks)*

In the previous assignment we provide some rudimentary test cases for both good and bad inputs to the `fizzbuzz` function. However, each of these test cases needs to be explictly reviewed to determine if the function is performing correctly for the given input.

For this task you will be improving these tests by reimplementing them to use the functionality of the package `testthat`. This is a powerful [unit testing](https://en.wikipedia.org/wiki/Unit_testing) package that is widely used throughout the R community for testing R packages. The package has extensive documentation that is available [here](https://testthat.r-lib.org/reference/index.html). The primary learning objective for this task is for you to learn how to use a new package solely relying on the available documentation. 

For our purposes we will focus solely on the expectation related functions from `testthat`. Your `hw1.Rmd` template already includes some scaffolding and example implementations. You should expand on these and at a minimum include all of the tests that were included originally in hw0. For full marks you should add additional (non-redundant) test cases that cover other possible good and bad inputs. Keep in mind that the goal is to have as much coverage as possible with as few tests as possible.

Note - I have included a special package called `chunktest` at the begining of the Rmd which does some knitr black magic to allow the inclusion of the testthat code for this task. This package is what allows knitr to recognize and correctly process the `testthat` chunks. If you are interested in how all of this works the code for the package is available on github: https://github.com/rundel/chunktest.


<br/>

## Submission and Grading

This homework is due by 11:59 pm on Friday, October 4th. You are to complete the assignment as a group and to keep everything (code, write ups, etc.) in your team's repository (commit early and often). Only the work commited to the repositories' **master** branch by the deadline will be marked.

The final product for this assignment should be a single Rmd document (`hw1.Rmd`) that contains all code and text for the tasks described above. This document should be clearly and cleanly formated and present all of your results. Style and formating does count for this assignment, so please take the time to make sure everything looks good and your text and code are properly formated. This document must be reproducible and I must be able to compile it with minimal intervention - documents that do not compile will be penalized. 

As with the hw0 we will not be enforcing any particular coding style, however it is important that the code your team produces is *readable* and *consistent* in its formating. There are several R style guides online, e.g. from [Google](https://google.github.io/styleguide/Rguide.xml) and from the [tidyverse team](https://style.tidyverse.org/) that are a good place to start. As a group you should decide on what conventions you will use and the entire team should conform to them as much as possible.

<br/>
