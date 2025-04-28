using Overseer
using GeometryTypes

@component struct Spatial
    position::Point3{Float64}
    velocity::Vec3{Float64}
end

@component struct Spring
    center::Point3{Float64}
    spring_constant::Float64
end

@component struct Rotation
    omega::Float64
    center::Point3{Float64}
    axis::Vec3{Float64}
end


struct Oscillator <: System end
Overseer.requested_components(::Oscillator) = (Spatial, Spring)

function Overseer.update(::Oscillator, m::AbstractLedger)
    for e in @entities_in(m, Spatial && Spring)
        new_v = e.velocity - (e.position - e.center) * e.spring_constant
        e[Spatial] = Spatial(e.position, new_v)
    end
end

struct Rotator <: System end
Overseer.requested_components(::Rotator) = (Spatial, Rotation)

function Overseer.update(::Rotator, m::AbstractLedger)
    dt = 0.01
    for e in @entities_in(m, Rotation && Spatial)
        n = e.axis
        r = -e.center + e.position
        theta = e.omega * dt
        nnd = n * dot(n, r)
        e[Spatial] = Spatial(Point3f0(e.center + nnd + (r - nnd) * cos(theta) + cross(r, n) * sin(theta)), e.velocity)
    end
end

struct Mover <: System end

Overseer.requested_components(::Mover) = (Spatial,)

function Overseer.update(::Mover, m::AbstractLedger)
    dt = 0.01
    spat = m[Spatial]
    for e in @entities_in(spat)
        e_spat = spat[e]
        spat[e] = Spatial(e_spat.position + e_spat.velocity * dt, e_spat.velocity)
    end
end




stage = Stage(:simulation, [Oscillator(), Rotator(), Mover()])
m = Ledger(stage) #this creates the Overseer with the system stage, and also makes sure all requested components are added.

e1 = Entity(m,
    Spatial(Point3(1.0, 1.0, 1.0), Vec3(0.0, 0.0, 0.0)),
    Spring(Point3(0.0, 0.0, 0.0), 0.01))

e2 = Entity(m,
    Spatial(Point3(-1.0, 0.0, 0.0), Vec3(0.0, 0.0, 0.0)),
    Rotation(1.0, Point3(0.0, 0.0, 0.0), Vec3(1.0, 1.0, 1.0)))

e3 = Entity(m,
    Spatial(Point3(0.0, 0.0, -1.0), Vec3(0.0, 0.0, 0.0)),
    Rotation(1.0, Point3(0.0, 0.0, 0.0), Vec3(1.0, 1.0, 1.0)),
    Spring(Point3(0.0, 0.0, 0.0), 0.01))
e4 = Entity(m,
    Spatial(Point3(0.0, 0.0, 0.0), Vec3(1.0, 0.0, 0.0)))



@edit  Overseer.update(m)
m[e1] #this groups all the componentdata that is associated with e1 
m[e2]
m[e3]
m[e4]
m[Spring][e3] #accesses Spring data for entity e3