# Frequently Asked Questions

Q: My `deploy()` and `upgrade()` functions are deploying and upgrading, but my tests are still failing. Why?

A: Make sure that your functions return the resultant proxy contract (of type `ethers.Contract`).