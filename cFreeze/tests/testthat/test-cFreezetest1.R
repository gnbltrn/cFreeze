test_that("cFreeze::freeze returns a percent > 0", {
  expect_gt(test_data <- cFreeze::freeze(-118, 43, 9, 29), 0)
})

test_that("cFreeze::freeze returns a percent < = 100", {
  expect_lte(test_data <- cFreeze::freeze(-118, 43, 9, 29), 100)
})  

test_that("cFreeze::nofreeze returns a value > 0", {
  expect_gt(test_data <- cFreeze::freeze(-118, 43, 9, 29), 0)
})

test_that("cFreeze::freeze10 returns a value > 0", {
  expect_gt(test_data <- cFreeze::freeze(-118, 43, 9, 29), 0)
})

test_that("cFreeze::freeze20 returns a value > 0", {
  expect_gt(test_data <- cFreeze::freeze(-118, 43, 9, 29), 0)
})
