metric(::Triangular) = Symmetric([1.0 0.5; 0.5 1.0])

ismetricdiag(::Triangular) = false
