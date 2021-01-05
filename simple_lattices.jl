abstract type SimpleLattice end

# TODO: make more intuitive
# currently, triangle vs rectangle doesn't change anything 

struct Triangle <: SimpleLattice
    a1::Array{Float64,1} 
    a2::Array{Float64,1} 
    n1::Int
    n2::Int
    PBC::Tuple{Bool, Bool}
end

function Triangle(a::Float64, a2::Array{Float64, 1}, n1::Int, n2::Int, PBC::Tuple{Bool, Bool})
    a1 = [a, 0.]
    return Triangle(a1, a2, n1, n2, PBC)
end


struct Rectangle <: SimpleLattice
    a1::Array{Float64,1} 
    a2::Array{Float64,1} 
    n1::Int
    n2::Int
    PBC::Tuple{Bool, Bool}
end

function Rectangle(a::Float64, a2::Array{Float64, 1}, n1::Int, n2::Int, PBC::Tuple{Bool, Bool})
    a1 = [a, 0.]
    return Rectangle(a1, a2, n1, n2, PBC)
end

function distance_matrix(lattice::SimpleLattice)
    a1 = lattice.a1
    a2 = lattice.a2
    n1 = lattice.n1
    n2 = lattice.n2
    PBC1, PBC2 = lattice.PBC

    a2_length = sqrt(a2[1]^2 + a2[2]^2) # length of a2 vector
    θ = acos(a2[1] / a2_length) # a2 angle from horizontal
    
    # total number of sites
    N = n1*n2
    dij = [zeros(Float64, N) for _ in 1:N]

    # (xpi, ypi) are lattice index coordinates
    # need to keep track of these for PBC enforcement
    # subtract one from xpi and ypi to center everything at (0,0)
    for i in 1:(N-1)
        xp1 = rem(i, n1) > 0 ? rem(i, n1) - 1 : n1 - 1
        yp1 = rem(i, n1) > 0 ? div(i, n1) : div(i, n1) - 1

        x1 = xp1*a1[1] + yp1*a2_length*cos(θ)
        y1 = yp1*a2_length*sin(θ)

        for j in (i+1):N
            xp2 = rem(j, n1) > 0 ? rem(j, n1) - 1 : n1 - 1
            yp2 = rem(j, n1) > 0 ? div(j, n1) : div(j, n1) - 1

            x2 = xp2*a1[1] + yp2*a2_length*cos(θ)
            y2 = yp2*a2_length*sin(θ)

            # check x and y directions to enforce PBCs
            if PBC1 & PBC2
                # calculate minimum distance
                
                # non-periodic
                d_np = sqrt( (y1 - y2)^2 + (x1 - x2)^2 )

                # periodic in x only
                x2 -= a1[1]*n1*cos(θ)
                d_px = sqrt( (y1 - y2)^2 + (x1 - x2)^2 )

                # periodic in x and y
                # x2 has already been taken care of
                y2 -= a2_length*n2*sin(θ)
                d_pxy = sqrt( (y1 - y2)^2 + (x1 - x2)^2 )

                # periodic in y only
                # undo the x2 periodicity
                x2 += a1[1]*n1*cos(θ) 
                d_py = sqrt( (y1 - y2)^2 + (x1 - x2)^2 )

                d = min(d_py, d_px, d_pxy, d_np)

            elseif PBC1 & !PBC2
                if abs(x1 - x2) > 0.5*n1*a1[1]
                    x2 -= a1[1]*n1*cos(θ)
                end

                d = sqrt( (y1 - y2)^2 + (x1 - x2)^2 )
            
            elseif PBC2 & !PBC1
                yi = x1*cos(θ) + y1*sin(θ)
                yj = x2*cos(θ) + y2*sin(θ)
                
                if abs(yi - yj) > 0.5*n2*a2_length
                    x2 -= a2_length*n2*cos(θ)
                    y2 -= a2_length*n2*sin(θ)
                end

                d = sqrt( (y1 - y2)^2 + (x1 - x2)^2 )
            
            else # no PBCs anywhere
                d = sqrt( (y1 - y2)^2 + (x1 - x2)^2 )
            
            end

            dij[i][j] = d
        end
    end

    return dij 
end
