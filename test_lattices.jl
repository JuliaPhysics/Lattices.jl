include("Lattices.jl")

# TODO: just playground testing right now
# need more concrete testing

# RUBY
ρ = 1.
a = 4*ρ / sqrt(3)

a1 = [a, 0.]
a2 = [a*0.5, a*sqrt(3)*0.5]

r1 = [0., 0.]
r2 = 0.75 * a2
r3 = 0.25 * (a1 + a2)
r4 = 0.5 * a1
r5 = 0.25*a1 + 0.75*a2
r6 = 0.5*a1 + 0.25*a2
r = [r1, r2, r3, r4, r5, r6]

n1 = 3
n2 = 3

PBC = (false, false)

ruby1 = Custom(a1, a2, n1, n2, r, PBC)
ruby2 = Ruby(ρ, n1, n2, PBC)



dij1 = distance_matrix(ruby1)
dij2 = distance_matrix(ruby2)

@show dij1 == dij2

@show dij1[4][52]

a = 1.
a2 = [2., 1.]
n1 = 2
n2 = 3
PBC = (false, true)

rectangle = Rectangle(a, a2, n1, n2, PBC)
asd = distance_matrix(rectangle)

# garbage lattice

#a = 4.12346
#
## x, y
#a1 = (a, 0.0)
#a2 = (0.234*a, 2.1235*a)
#
#r1 = (0., 0.)
#r2 = 0.4 .* a1
#r3 = 0.62 .* a2 .+ 0.71 .* a1
#
#r = [r1, r2, r3]
#@show typeof(r)
#
#nX = 10
#nY = 13

#garbage = Custom(a1, a2, nX, nY, r)
