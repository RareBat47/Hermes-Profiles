# Working with Seams (Michael Feathers Doctrine)

A seam is a place where you can alter behavior in a program without editing that place directly.

## The Seam Protocol
1. **Identify the Seam:** Find where the dependency enters (function parameter, interface implementation, dependency injection).
2. **Characterization Tests:** Write a test that documents existing behavior before changing a single line of logic.
3. **Surgical Interception:** Implement the new behavior through the seam.
4. **Zero Collateral Damage:** Verify that existing tests continue to pass without unintended side effects.
