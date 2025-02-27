using LinearAlgebra


a = [1 2 3
    2 3 5]

### CR Decomposition Column&&Row independent
a == [1 2;2 3]*[1 0 1;0 1 1]

### LU Decomposition -> solve Ax=b by Lc = b && Ux = c
lu(a)

### QR Decomposition -> orthogonalize A and keep C(A) == C(Q) 
### Gram-Schmidt procedural
b,c = qr(a)
b'*b ≈ I
c

### QΛQᵀ Decomposition
### All **Symmetric matrices S ** must have real eigenvalues and orthogonal eigenvectors.
d = [1 2 3;2 5 6;3 6 9] ### Symmetric PositiveDeﬁnite Matrix
f,g = eigen(d)
d ≈ g*diagm(f)*g'

# this is the spectrum theorem 
# it is broken down into a combination of rank1 projection matrices  P = qqᵀ.

### SVD Decomposition -> Every Matrix UΣVᵀ
svd(d)
# V as an orthonormal basis of Rⁿ (eigenvectorsof AᵀA)
# U as an orthonormal basis of Rᵐ (eigenvectorsof AAᵀ)
# UUᵀ = Iₘ  &&  VVᵀ = Iₙ

